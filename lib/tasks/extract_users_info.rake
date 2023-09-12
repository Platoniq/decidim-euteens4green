# frozen_string_literal: true

require "csv"

namespace :extract_users_info do
  desc "Extract users info into a csv and then send it by email"
  task extract_users_info: [:environment] do
    # create csv with datetime on name and headers
    csv_name = "extract_users_info_#{Time.zone.now.strftime("%Y%m%d")}.csv"
    headers = %w(id email comments_created comments_created_this_month meetings_created meetings_created_this_month posts_created posts_created_this_month)

    csv_string = CSV.generate(headers: headers, write_headers: true) do |csv|
      Decidim::User.find_each do |user|
        comments_created = Decidim::Comments::Comment.where(author: user).count
        comments_created_last_month = Decidim::Comments::Comment.where(author: user, created_at: Time.zone.now.last_month).count
        meetings_created = Decidim::Meetings::Meeting.where(author: user).count
        meetings_created_last_month = Decidim::Meetings::Meeting.where(author: user, created_at: Time.zone.now.last_month).count
        posts_created = Decidim::Blogs::Post.where(author: user).count
        posts_created_last_month = Decidim::Blogs::Post.where(author: user, created_at: Time.zone.now.last_month).count

        csv << [user.id, user.email, comments_created, comments_created_last_month, meetings_created, meetings_created_last_month, posts_created, posts_created_last_month]
      end
    end

    mail = ActionMailer::Base.mail(from: Rails.application.secrets.extract_users_info[:from_email],
                                   to: Rails.application.secrets.extract_users_info[:to_email],
                                   subject: t("eut4g.extract_users_info.mail.subject"),
                                   body: t("eut4g.extract_users_info.mail.body"))

    mail.attachments[csv_name] = csv_string
    mail.deliver_now
  end
end
