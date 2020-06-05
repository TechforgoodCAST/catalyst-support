# Catalyst Support

## Getting started

These instructions will get a copy of the project up and running on your local machine for development and testing purposes.

### Prerequisites

[Ruby v2.7.1](https://www.ruby-lang.org), [Bundler](https://bundler.io/), [PostgreSQL](https://www.postgresql.org/), [NodeJS](https://nodejs.org/) and [Yarn](https://yarnpkg.com/).

### Install the app

1. `git clone https://github.com/TechforgoodCAST/catalyst-support.git`
2. `cd catalyst-support`
3. `bundle install`
4. `yarn install`

### Configure your editor

To ensure consistency in code style configure your editor to work with [Solargraph](https://github.com/castwide/solargraph#using-solargraph) to benefit from intellisense and linting against the [Ruby Style Guide](https://rubystyle.guide) via [Rubocop](https://github.com/rubocop-hq/rubocop) (which Solargraph includes by default).

### Importing data

```ruby
GoogleSheetsImport.new.import!(ENV['MY_CONFIG_JSON_STRING'])
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
