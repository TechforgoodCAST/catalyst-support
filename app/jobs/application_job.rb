# frozen_string_literal: true

class ApplicationJob < ActiveJob::Base
  # Automatically retry jobs that encountered a deadlock
  # retry_on ActiveRecord::Deadlocked

  # Most jobs are safe to ignore if the underlying records are no longer available
  # discard_on ActiveJob::DeserializationError

  def build_action(action_name, org, timestamp)
    Action.find_or_initialize_by(
      potential_action: PotentialAction.find_by(name: action_name),
      organisation: org,
      start_time: timestamp,
      end_time: timestamp
    )
  end

  def create_affiliation(org, email)
    return if org.new_record? || email.blank?

    user = User.find_or_create_by!(email: email.strip.downcase)
    Affiliation.find_or_create_by!(organisation: org, individual: user)
  end
end
