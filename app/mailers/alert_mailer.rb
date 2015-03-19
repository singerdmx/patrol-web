require 'set'

class AlertMailer < ActionMailer::Base
  default from: "alert-no-reply@managebrite.com"

  def alert_email(contacts, users, content)
    @hasMedia = false
    @content = content
    @content.each do |row|
      unless row[0].nil? && row[1].nil?
        @hasMedia = true
        break
      end
    end

    recipients = Set.new(contacts.map {|c| Contact.find(c).email})
    users.each do |u|
      recipients.add(User.find(u).email)
    end

    mail(to: recipients.to_a,
         from: "alert-no-reply@managebrite.com",
         subject: '巡检结果异常通知')
  end
end
