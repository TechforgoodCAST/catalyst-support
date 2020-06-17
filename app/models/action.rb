# frozen_string_literal: true

class Action < ApplicationRecord
  belongs_to :potential_action
  belongs_to :organisation
end
