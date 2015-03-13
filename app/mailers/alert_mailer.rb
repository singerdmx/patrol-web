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

    recipients = contacts.map {|c| Contact.find(c).email} if contacts
    recipients ||= []
    users.each do |u|
      recipients << User.find(u).email
    end

    mail(to: recipients,
         from: "alert-no-reply@managebrite.com",
         subject: '巡检结果异常通知')
  end
end
