# frozen_string_literal: true

class AddOrgIdsToOrganisation < ActiveRecord::Migration[6.0]
  def change
    add_column :organisations, :for_review, :boolean, default: false
    add_column :organisations, :org_ids, :jsonb, default: []
    add_column :organisations, :potential_org_ids, :jsonb, default: []
    add_column :organisations, :alternate_names, :jsonb, default: []
    add_column :charity_domain_lookups, :slug, :string, index: true
  end
end
