# frozen_string_literal: true

require "rake"

Rails.application.load_tasks

class ExtractUsersInfoWorker
  include Sidekiq::Worker

  def perform(*_args)
    Rake::Task["extract_users_info:extract_users_info"].invoke
  end
end
