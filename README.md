# Catalyst Support

## Importing data

```ruby
GoogleSheetImport.new.import!(ENV['MY_CONFIG_JSON_STRING'])
```

Below is the structure of the config JSON the `#import!` method expects - remember to convert the JSON to a string. The integers - i.e. `"user_email": 2` - indicate the column number from the sheet to import. In the example below column 2 contains the email addresses of users you'd like to import.

```json
{
  "file_id": "11NZ5o5TqSvvLtM...",
  "sheet_id": "13477...",
  "timestamp": 1,
  "user_email": 2,
  "organisation_name": 3,
  "custom": {
    "custom_column_1": 4,
    "custom_column_2": 5
  }
}
```
