class AlertMailer < ActionMailer::Base
  default from: "alert-no-reply@managebrite.com"

  def alert_email(contacts, users, content)
    @noImage = false
    @content = content
    @content.each do |row|
      unless row[11].nil?
        @noImage = true
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
