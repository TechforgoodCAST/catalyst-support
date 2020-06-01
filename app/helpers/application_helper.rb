# frozen_string_literal: true

module ApplicationHelper
  def active_nav?(controller: nil, action: nil)
    if action
      controller_name == controller && action_name == action ? ' underline' : nil
    else
      controller_name == controller ? ' underline' : nil
    end
  end
end
