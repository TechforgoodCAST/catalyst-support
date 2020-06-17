# frozen_string_literal: true

class GoogleSheetsImport
  def initialize
    @session = GoogleDrive::Session.from_service_account_key(
      StringIO.new(ENV['GOOGLE_APIS_SERVICE_ACCOUNT_KEY'])
    )
  end

  def extract(config, row_start: 2)
    config = JSON.parse(config, object_class: OpenStruct)

    worksheet = @session.spreadsheet_by_key(config.file_id)
                        .worksheet_by_sheet_id(config.sheet_id)

    ret = []

    (row_start..worksheet.num_rows).each do |row|
      next if worksheet[row, 1].blank?

      ret_row = {}
      config.fields.to_h.each { |k, v| ret_row[k] = worksheet[row, v] }
      ret << ret_row
    end

    ret
  end
end
