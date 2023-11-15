# frozen_string_literal: true

Rails.application.config.to_prepare do
  Decidim::Proposals::ApplicationHelper.include(Decidim::Proposals::ApplicationHelperOverride)
  Decidim::Proposals::Permissions.include(Decidim::Proposals::PermissionsOverride)
end
