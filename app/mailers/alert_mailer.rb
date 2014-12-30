class AlertMailer < ActionMailer::Base
  default from: "alert-no-reply@managebrite.com"

  def alert_email(contacts, users, report)
    recipients = contacts.map {|c| Contact.find(c).email}
    users.each do |u|
      recipients << User.find(u).email
    end

    mail(to: recipients,
         from: "alert-no-reply@managebrite.com",
         subject: '巡检结果异常通知')
  end
end
