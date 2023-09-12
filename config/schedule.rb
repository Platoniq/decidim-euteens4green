# frozen_string_literal: true

every "0 8 1 * *" do
  rake "extract_users_info:extract_users_info"
end
