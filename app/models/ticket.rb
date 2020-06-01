# frozen_string_literal: true

class Ticket < ApplicationRecord
  belongs_to :organisation, optional: true
  belongs_to :user
end
