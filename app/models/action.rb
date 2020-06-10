# frozen_string_literal: true

class Action < ApplicationRecord
  belongs_to :potential_action
  belongs_to :organisation

  def get_string
    base_string = potential_action.format

    details&.each do |key, val|
      base_string = base_string.sub('{{' + key + '}}', val)
    end

    base_string
  end
end
