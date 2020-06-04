# frozen_string_literal: true

class Organisation < ApplicationRecord
  has_many :affiliations
  has_many :admins, through: :affiliations, source: :individual, source_type: 'Admin', dependent: :destroy
  has_many :users, through: :affiliations, source: :individual, source_type: 'User', dependent: :destroy
  has_many :tickets
end
