# frozen_string_literal: true

require "rails_helper"

describe "Support Proposal", type: :system, slow: true do
  include_context "with a component"
  let(:manifest_name) { "proposals" }

  let(:component) do
    create(:proposal_component,
           :with_votes_enabled,
           manifest: manifest,
           participatory_space: participatory_process)
  end
  let!(:proposal) { create :proposal, :participant_author, :published, component: component }

  before do
    login_as user, scope: :user
    user.confirm
    visit_component
    click_link translated(proposal.title)
  end

  context "when visiting by the author" do
    let(:user) { proposal.authors.first }

    it "doesn't show the vote proposal button" do
      expect(page).to have_no_button("Support")
    end
  end

  context "when visiting by other user" do
    let(:user) { create :user, :confirmed, organization: organization }

    it "shows the vote proposal button" do
      expect(page).to have_button("Support")
    end
  end
end
