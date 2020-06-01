# frozen_string_literal: true

class Affiliation < ApplicationRecord
  belongs_to :organisation
  belongs_to :user
end
