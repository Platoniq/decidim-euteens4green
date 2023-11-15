# frozen_string_literal: true

require "rails_helper"

module Decidim
  module Proposals
    describe ProposalVotesController, type: :controller do
      routes { Decidim::Proposals::Engine.routes }

      let(:component) { create(:proposal_component, :with_votes_enabled) }
      let(:proposal) { create(:proposal, :participant_author, component: component) }
      let(:user) { create(:user, :confirmed, organization: component.organization) }

      let(:params) do
        {
          proposal_id: proposal.id,
          component_id: component.id
        }
      end

      before do
        request.env["decidim.current_organization"] = component.organization
        request.env["decidim.current_participatory_space"] = component.participatory_space
        request.env["decidim.current_component"] = component
        sign_in user
      end

      shared_context "with proposal author" do
        let(:user) { proposal.authors.first }
      end

      describe "POST create" do
        it "allows voting" do
          expect { post :create, format: :js, params: params }.to change(ProposalVote, :count).by(1)
          expect(ProposalVote.last.author).to eq(user)
          expect(ProposalVote.last.proposal).to eq(proposal)
        end

        context "when the user is the proposal author" do
          include_context "with proposal author"

          it "doesn't allow voting" do
            expect { post :create, format: :js, params: params }.not_to change(ProposalVote, :count)
          end
        end
      end

      describe "DELETE destroy" do
        before do
          create(:proposal_vote, proposal: proposal, author: user)
        end

        it "allows voting" do
          expect { delete :destroy, format: :js, params: params }.to change(ProposalVote, :count).by(-1)
          expect(ProposalVote.count).to eq(0)
        end

        context "when the user is the proposal author" do
          include_context "with proposal author"

          it "doesn't allow voting" do
            expect { delete :destroy, format: :js, params: params }.not_to change(ProposalVote, :count)
          end
        end
      end
    end
  end
end
