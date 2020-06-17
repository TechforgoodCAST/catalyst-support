# frozen_string_literal: true

module Reconcile
  def new_or_reconcile(org_id: nil, domain_or_email: nil, name: nil)
    @org_id = org_id
    @domain_or_email = domain_or_email
    @name = name

    by_org_id(@org_id) || by_domain_or_email(@domain_or_email) || by_name(@name)
  end

  private

  def by_org_id(org_id = nil)
    return nil if org_id.blank?

    org_id_lookup_regnos = CharityDomainLookup.where(regno: org_id).pluck(:regno)

    existing_orgs = query_existing_orgs(org_id_lookup_regnos.empty? ? [org_id] : org_id_lookup_regnos)

    return existing_orgs.first if existing_orgs.size == 1

    build_or_find(existing_orgs, org_id_lookup_regnos, @domain_or_email) do |domain_or_email|
      by_domain_or_email(domain_or_email)
    end
  end

  def by_domain_or_email(domain_or_email = nil)
    return nil if domain_or_email.blank?

    domain = domain_or_email.split('@').last.strip

    return nil if CharityDomainLookup::GENERIC_DOMAINS.include?(domain)

    domain_lookup_regnos = CharityDomainLookup.where('email_domain = ? OR web_domain = ?', domain, domain).pluck(:regno)

    existing_orgs = query_existing_orgs(domain_lookup_regnos)

    return build_review_org(potential_org_ids: domain_lookup_regnos) if domain_lookup_regnos.size > 1

    build_or_find(existing_orgs, domain_lookup_regnos, @name) do |name|
      by_name(name)
    end
  end

  def by_name(name = nil)
    return build_review_org if name.blank?

    slug_lookup_regnos = CharityDomainLookup.where(slug: name&.parameterize).pluck(:regno)

    existing_orgs = query_existing_orgs(slug_lookup_regnos)

    build_or_find(existing_orgs, slug_lookup_regnos) do
      substr_lookup_regnos = CharityDomainLookup.where('slug LIKE ?', "%#{name.parameterize}%").pluck(:regno)
      build_review_org(potential_org_ids: substr_lookup_regnos)
    end
  end

  def query_existing_orgs(ids)
    Organisation.where('org_ids @> any(array[?]::jsonb[])', ids.map(&:to_json))
  end

  def build_review_org(args = {})
    Organisation.new({ for_review: true }.merge(args))
  end

  def build_or_find(existing_org_query, lookup_org_ids, *args, &_block)
    if existing_org_query.size > 1
      # TODO: avoid identical duplicate review orgs
      build_review_org(potential_org_ids: existing_org_query.pluck(:org_ids).flatten)
    elsif existing_org_query.size == 1
      existing_org_query.first
    elsif lookup_org_ids.size == 1
      Organisation.new(org_ids: lookup_org_ids)
    elsif lookup_org_ids.size > 1
      build_review_org(potential_org_ids: lookup_org_ids)
    else
      yield(*args)
    end
  end
end
