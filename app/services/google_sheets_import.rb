# frozen_string_literal: true

class GoogleSheetsImport
  def initialize
    @session = GoogleDrive::Session.from_service_account_key(
      StringIO.new(ENV['GOOGLE_APIS_SERVICE_ACCOUNT_KEY'])
    )
  end

  def create_tickets!(config, row_start: 2)
    config = JSON.parse(config, object_class: OpenStruct)

    worksheet = @session.spreadsheet_by_key(config.sheet.file_id)
                        .worksheet_by_sheet_id(config.sheet.worksheet_id)

    (row_start..worksheet.num_rows).each do |row|
      user = User.find_or_initialize_by(
        email: worksheet[row, config.user.email].strip.downcase
      )

      unless user.persisted?
        user.password = SecureRandom.urlsafe_base64
        user.save!
      end

      org = Organisation.find_or_create_by!(
        name: worksheet[row, config.organisation.name]
      )
      org.update!(users: [user])

      ticket = Ticket.find_or_initialize_by(
        user: user,
        organisation: org,
        created_at: DateTime.strptime(
          worksheet[row, config.ticket.timestamp], '%d/%m/%Y %H:%M:%S'
        )
      )

      ticket.body = {}
      config.ticket.to_h.each { |k, v| ticket.body[k] = worksheet[row, v] }
      ticket.save!
    end
  end
end
