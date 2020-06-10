# frozen_string_literal: true

class GoogleSheetsImport
  def initialize
    @session = GoogleDrive::Session.from_service_account_key(
      StringIO.new(ENV['GOOGLE_APIS_SERVICE_ACCOUNT_KEY'])
    )
  end

  def import!(config, row_start: 2)
    config = JSON.parse(config, object_class: OpenStruct)

    worksheet = @session.spreadsheet_by_key(config.file_id)
                        .worksheet_by_sheet_id(config.sheet_id)

    (row_start..worksheet.num_rows).each do |row|
      user = User.find_or_initialize_by(
        email: worksheet[row, config.user_email].strip.downcase
      )

      unless user.persisted?
        user.password = SecureRandom.urlsafe_base64
        user.save!
      end

      org = Organisation.find_or_create_by!(
        name: worksheet[row, config.organisation_name]
      )
      org.update!(users: [user])

      ticket = Ticket.find_or_initialize_by(
        user: user,
        organisation: org,
        created_at: DateTime.strptime(
          worksheet[row, config.timestamp], '%d/%m/%Y %H:%M:%S'
        )
      )

      ticket.body = {}
      config.custom.to_h.each { |k, v| ticket.body[k] = worksheet[row, v] }
      ticket.save!
    end
  end

  def extract(config, row_start: 2)
    config = JSON.parse(config, object_class: OpenStruct)

    worksheet = @session.spreadsheet_by_key(config.file_id)
                        .worksheet_by_sheet_id(config.sheet_id)

    ret = []

    (row_start..worksheet.num_rows).each do |row|
      unless worksheet[row, 1].empty?
        ret_row = {}
        config.fields.to_h.each { |k, v| ret_row[k] = worksheet[row, v] }
        ret << ret_row
      end
    end

    ret
  end
end
