# frozen_string_literal: true

class Organisation < ApplicationRecord
  has_many :affiliations
  has_many :users, through: :affiliations, dependent: :destroy
  has_many :tickets
end
