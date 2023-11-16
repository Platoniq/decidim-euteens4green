# frozen_string_literal: true

module Decidim
  module Proposals
    module PermissionsOverride
      extend ActiveSupport::Concern

      included do
        def can_vote_proposal?
          is_allowed = proposal &&
                       !proposal.authored_by?(user) &&
                       authorized?(:vote, resource: proposal) &&
                       voting_enabled? &&
                       remaining_votes.positive?

          toggle_allow(is_allowed)
        end

        def can_unvote_proposal?
          is_allowed = proposal &&
                       !proposal.authored_by?(user) &&
                       authorized?(:vote, resource: proposal) &&
                       voting_enabled?

          toggle_allow(is_allowed)
        end
      end
    end
  end
end
