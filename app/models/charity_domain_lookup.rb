# frozen_string_literal: true

class CharityDomainLookup < ApplicationRecord
  GENERIC_DOMAINS = [
    'gmail.com',
    'hotmail.com',
    'btinternet.com',
    'hotmail.co.uk',
    'yahoo.co.uk',
    'outlook.com',
    'aol.com',
    'btconnect.com',
    'yahoo.com',
    'googlemail.com',
    'ntlworld.com',
    'talktalk.net',
    'sky.com',
    'live.co.uk',
    'ntlworld.com',
    'tiscali.co.uk',
    'icloud.com',
    'btopenworld.com',
    'blueyonder.co.uk',
    'virginmedia.com',
    'nhs.net',
    'me.com',
    'msn.com',
    'talk21.com',
    'aol.co.uk',
    'mail.com',
    'live.com',
    'virgin.net',
    'ymail.com',
    'mac.com',
    'waitrose.com',
    'gmail.co.uk'
  ].freeze

  before_validation :set_slug

  def self.lookup_domain(domain)
    return nil if GENERIC_DOMAINS.include? domain

    @domains = self.where(email_domain: domain).or(self.where(web_domain: domain))

    return nil if @domains.count == 0
    @domains.first.regno
  end

  def set_slug
    self[:slug] = name.parameterize
  end
end
