# frozen_string_literal: true

class User < ApplicationRecord
  has_many :affiliations, as: :individual
  has_many :organisations, through: :affiliations, dependent: :destroy
end
