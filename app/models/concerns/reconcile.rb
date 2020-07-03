# frozen_string_literal: true

module Reconcile
  def new_or_existing_org(org_id: nil, name: nil)
    for_review = false

    if org_id
      existing_orgs = Organisation.where('org_ids @> ?', '["' + org_id + '"]')

      return existing_orgs.first if existing_orgs.size == 1

      for_review = true if existing_orgs.size > 1
    end

    if name
      if (existing_org_by_name = Organisation.find_by(slug: name&.parameterize)) then return existing_org_by_name end
    else
      # If we're missing the org name, try to get it from the CharityDomainLookup
      lookup_orgs = chc_by_org_id(org_id)
      name = lookup_orgs.first.name if lookup_orgs.!empty?
      for_review = true if lookup_orgs.size > 1
    end

    return Organisation.new(
      name: name,
      org_ids: [org_id].select(&:present?),
      for_review: for_review || org_id.nil? || name.nil?
    )
  end

  def convert_regno_to_org_id(org_id_or_regno)
    return nil if org_id_or_regno.blank?

    # Already an org id
    return org_id_or_regno if org_id_or_regno.starts_with?('GB-')

    return 'GB-SC-' + org_id_or_regno if org_id_or_regno.starts_with?('SC')
    return 'GB-NIC-' + /NIC(\d+)/.match('org_id_or_regno').first if org_id_or_regno.starts_with?('NIC')
    return 'GB-CHC-' + org_id_or_regno
  end

  def new_or_reconcile(org_id_or_regno: nil, domain_or_email: nil, name: nil)
    @domain_or_email = domain_or_email
    @name = name.presence ? name : nil
    @slug = name&.parameterize

    # Convert charity number to org ID (if necessary)
    @org_id = convert_regno_to_org_id(org_id_or_regno)

    # If we have org ID use that
    return new_or_existing_org(org_id: @org_id, name: @name) if @org_id.present?

    # Search lookup by domain or failing that name
    chcs = chc_by_domain_or_email(@domain_or_email) || chc_by_name(@name)

    return new_or_existing_org(name: @name) if chcs.blank?

    return new_or_existing_org(org_id: chcs.first.regno, name: @name) if chcs.size == 1

    # Try to narrow by name
    filtered = chcs.select { |chc| chc.slug == @slug }
    chcs = filtered.empty? ? chcs : filtered

    return new_or_existing_org(org_id: chcs.first.regno, name: @name) if chcs.size == 1

    # Do we already have an org with that name?
    if (existing_org_by_name = Organisation.find_by(slug: @slug)) then return existing_org_by_name end

    # Create new org with multiple potential IDs
    return build_review_org(name: @name, potential_org_ids: chcs.pluck(:regno))
  end

  private

  def chc_by_org_id(org_id = nil)
    return CharityDomainLookup.where(regno: org_id)
  end

  def chc_by_domain_or_email(domain_or_email = nil)
    return nil if domain_or_email.blank?

    domain = domain_or_email.split('@').last.strip

    return CharityDomainLookup.lookup_domain(domain)
  end

  def chc_by_name(name = nil)
    return nil if name.blank?

    return CharityDomainLookup.where(slug: name&.parameterize)
  end

  def build_review_org(args = {})
    Organisation.new({ for_review: true }.merge(args))
  end
end
