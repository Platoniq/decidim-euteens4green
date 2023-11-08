# frozen_string_literal: true

module Decidim
  module Proposals
    module ApplicationHelperOverride
      extend ActiveSupport::Concern

      included do
        def safe_content_admin?
          true
        end
      end
    end
  end
end
