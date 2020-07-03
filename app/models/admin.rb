# frozen_string_literal: true

class Admin < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, 
         :omniauthable, omniauth_providers: [:google_oauth2]

  has_many :affiliations, as: :individual
  has_many :organisations, through: :affiliations, dependent: :destroy

  validates :password, password_strength: { use_dictionary: true }

  def self.from_omniauth(access_token)
      data = access_token.info
      admin = Admin.where(email: data['email']).first

      # Uncomment the section below if you want users to be created if they don't exist
      unless admin
        admin = Admin.create(
          first_name: data['first_name'],
          last_name: data['last_name'],
          email: data['email'],
          password: Devise.friendly_token[0,20]
        )
      end
      admin
  end
end
