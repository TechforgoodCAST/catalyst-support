# frozen_string_literal: true

class Admin < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :affiliations, as: :individual
  has_many :organisations, through: :affiliations, dependent: :destroy

  validates :password, password_strength: { use_dictionary: true }
end
