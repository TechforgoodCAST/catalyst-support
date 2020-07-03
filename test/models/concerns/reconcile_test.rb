# frozen_string_literal: true

require 'test_helper'

class ReconcileTest < ActiveSupport::TestCase
  setup do
    @lookup = CharityDomainLookup.create!(
      regno: 'GB-CHC-123', name: 'Charity', email_domain: 'website.org', web_domain: 'website.org'
    )
    @org = Organisation.create!(name: 'Charity', org_ids: ['GB-CHC-123'])
    @subject = Class.new.extend(Reconcile)
  end

  def assert_build_for_review(org)
    assert(org.is_a?(Organisation))
    refute(org.persisted?)
    assert(org.for_review)
  end
  
  def assert_build_no_match(org, name = nil, org_ids = [])
    assert(org.is_a?(Organisation))
    refute(org.persisted?)
    assert(org.for_review)
    assert_equal(org_ids, org.org_ids)
    assert_equal([], org.potential_org_ids)
    assert_equal(name, org.name)
  end

  def assert_build_single_match(org, org_ids)
    assert(org.is_a?(Organisation))
    refute(org.persisted?)
    refute(org.for_review)
    assert_equal(org_ids, org.org_ids)
    assert_equal([], org.potential_org_ids)
  end

  def assert_build_multiple_match(org, potential_org_ids)
    assert(org.is_a?(Organisation))
    refute(org.persisted?)
    assert(org.for_review)
    assert_equal([], org.org_ids)
    assert_equal(potential_org_ids, org.potential_org_ids)
  end

  test 'org_id not provided returns new org' do
    org = @subject.new_or_reconcile(org_id_or_regno: '')

    assert_build_no_match(org)
  end

  test 'domain_or_email not provided returns new org' do
    org = @subject.new_or_reconcile(domain_or_email: '')

    assert_build_no_match(org)
  end

  test 'common domain_or_email returns new org' do
    org = @subject.new_or_reconcile(domain_or_email: 'gmail.com')

    assert_build_no_match(org)
  end

  test 'name not provided returns new org' do
    org = @subject.new_or_reconcile(name: '')

    assert_build_no_match(org)
  end

  test 'org_id takes precedence over domain_or_email' do
    org = @subject.new_or_reconcile(org_id_or_regno: 'GB-CHC-123', domain_or_email: 'notfound.org')

    assert_equal(@org, org)
  end

  test 'org_id takes precedence over name' do
    org = @subject.new_or_reconcile(org_id_or_regno: 'GB-CHC-123', name: 'Wrong name!')

    assert_equal(@org, org)
  end

  test 'domain_or_email takes precedence over name' do
    org = @subject.new_or_reconcile(domain_or_email: 'website.org', name: 'Wrong Name!')

    assert_equal(@org, org)
  end

  ## no existing orgs + no lookup

  test 'no existing org and no lookup using org_id' \
       'builds new org for_review with no potential_org_ids' do
    org = @subject.new_or_reconcile(org_id_or_regno: 'UNKNOWN_ID')

    assert_build_no_match(org, nil, ['GB-CHC-UNKNOWN_ID'])
  end

  test 'no existing org and no lookup using domain_or_email' \
       'builds new org for_review with no potential_org_ids' do
    org = @subject.new_or_reconcile(domain_or_email: 'notfound.org')

    assert_build_no_match(org)
  end

  test 'no existing org and no lookup using name' \
       'builds new org for_review with no potential_org_ids' do
    org = @subject.new_or_reconcile(name: 'Wrong Name!')

    assert_build_no_match(org, 'Wrong Name!')
  end

  ## no existing orgs + single lookup

  test 'no existing org and one lookup using org_id' \
       'creates new org not needing review and org_ids set' do
    @org.destroy
    org = @subject.new_or_reconcile(org_id_or_regno: 'GB-CHC-123')

    assert_build_single_match(org, ['GB-CHC-123'])
  end

  test 'no existing org and one lookup using domain_or_email' \
       'creates new org not needing review and org_ids set' do
    @org.destroy
    org = @subject.new_or_reconcile(domain_or_email: 'website.org')

    assert_build_single_match(org, ['GB-CHC-123'])
  end

  test 'no existing org and one lookup using name' \
       'creates new org not needing review and org_ids set' do
    @org.destroy
    org = @subject.new_or_reconcile(name: 'Charity')

    assert_build_single_match(org, ['GB-CHC-123'])
  end

  ## no existing orgs + multiple lookup

  test 'no existing orgs and multiple lookup using org_id' \
       'builds new org for_review' do
    @org.destroy
    @lookup.dup.save!
    org = @subject.new_or_reconcile(org_id_or_regno: 'GB-CHC-123')

    assert_build_for_review(org)
  end

  test 'no existing orgs and multiple lookup using domain_or_email' \
       'builds new org for_review with multiple potential_org_ids' do
    @org.destroy
    @lookup.dup.update!(regno: 'GB-SC-SC123')
    org = @subject.new_or_reconcile(domain_or_email: 'website.org')

    assert_build_multiple_match(org, %w[GB-CHC-123 GB-SC-SC123])
  end

  test 'no existing orgs and multiple lookup using name' \
       'builds new org for_review with multiple potential_org_ids' do
    @org.destroy
    @lookup.dup.update!(regno: 'GB-SC-SC123')
    org = @subject.new_or_reconcile(name: 'Charity')

    assert_build_multiple_match(org, %w[GB-CHC-123 GB-SC-SC123])
  end

  ## one existing org + no lookup

  test 'one existing org and no lookup using org_id ' \
       'finds existing org using org_ids' do
    @lookup.destroy
    org = @subject.new_or_reconcile(org_id_or_regno: 'GB-CHC-123')

    assert_equal(@org, org)
  end

  test 'one existing org and no lookup using domain_or_email ' \
       'builds new org for_review with no potential_org_ids' do
    @lookup.destroy
    org = @subject.new_or_reconcile(domain_or_email: 'website.org')

    assert_build_no_match(org)
  end

  test 'one existing org and no lookup using name ' \
       'builds new org for_review with no potential_org_ids' do
    @lookup.destroy
    org = @subject.new_or_reconcile(name: 'Charity')

    assert_equal(@org, org)
  end

  ## one existing org + single lookup

  test 'one existing org and one lookup using org_id ' \
       'finds existing org using org_ids' do
    org = @subject.new_or_reconcile(org_id_or_regno: 'GB-CHC-123')

    assert_equal(@org, org)
  end

  test 'one existing org and one lookup using domain_or_email ' \
       'finds existing org using org_ids' do
    org = @subject.new_or_reconcile(domain_or_email: 'website.org')

    assert_equal(@org, org)
  end

  test 'one existing org and one lookup using name ' \
       'finds existing org using org_ids' do
    org = @subject.new_or_reconcile(name: 'Charity')

    assert_equal(@org, org)
  end

  ## one existing orgs + multiple lookup

  test 'one existing org and multiple lookup using org_id ' \
       'finds existing org using org_ids' do
    @lookup.dup.save!
    org = @subject.new_or_reconcile(org_id_or_regno: 'GB-CHC-123')

    assert_equal(@org, org)
  end

  test 'one existing org and multiple lookup domain_or_email ' \
       'builds new org for_review with multiple potential_org_ids' do
    @lookup.dup.update!(regno: 'GB-SC-SC123')
    org = @subject.new_or_reconcile(domain_or_email: 'website.org')

    assert_build_multiple_match(org, %w[GB-CHC-123 GB-SC-SC123])
  end

  test 'one existing org and multiple lookup using name ' \
       'matches existing org' do
    @lookup.dup.update!(regno: 'GB-SC-SC123')
    org = @subject.new_or_reconcile(name: 'Charity')

    assert_equal(@org, org)
  end

  ## multiple existing orgs + no lookup

  test 'multiple existing orgs and no lookup using org_id ' \
       'builds new org for_review with multiple potential_org_ids' do
    @lookup.destroy
    @org.dup.update!(name: 'Duplicate Charity')
    org = @subject.new_or_reconcile(org_id_or_regno: 'GB-CHC-123')

    assert_build_for_review(org)
  end

  test 'multiple existing orgs and no lookup using domain_or_email ' \
       'builds new org for_review with no potential_org_ids' do
    @lookup.destroy
    @org.dup.save!
    org = @subject.new_or_reconcile(domain_or_email: 'website.org')

    assert_build_no_match(org)
  end

  ## multiple existing orgs + single lookup

  test 'multiple existing orgs and one lookup using org_id ' \
       'builds new org for_review with multiple potential_org_ids' do
    @org.dup.save!
    org = @subject.new_or_reconcile(org_id_or_regno: 'GB-CHC-123')

    assert_build_for_review(org)
  end

  test 'multiple existing orgs and one lookup using domain_or_email ' \
       'builds new org for_review' do
    @org.dup.save!
    org = @subject.new_or_reconcile(domain_or_email: 'website.org')

    assert_build_for_review(org)
  end

  ## multiple existing orgs + multiple lookup

  test 'multiple existing orgs and multiple lookup using org_id ' \
       'builds new org for_review' do
    @lookup.dup.save!
    @org.dup.save!
    org = @subject.new_or_reconcile(org_id_or_regno: 'GB-CHC-123')

    assert_build_for_review(org)
  end

  test 'multiple existing orgs and multiple lookup using domain_or_email ' \
       'builds new org for_review with multiple potential_org_ids' do
    @lookup.dup.update!(regno: 'GB-SC-SC123')
    @org.dup.save!
    org = @subject.new_or_reconcile(domain_or_email: 'website.org')

    assert_build_multiple_match(org, %w[GB-CHC-123 GB-SC-SC123])
  end
end
