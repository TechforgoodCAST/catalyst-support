# frozen_string_literal: true

class TicketsController < ApplicationController
  def index
    @tickets = Ticket.includes(:organisation, :user).all
  end
end
