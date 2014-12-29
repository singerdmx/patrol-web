class AlertMailer < ActionMailer::Base
  default from: "alert-no-reply@managebrite.com"

  def alert_email(user)
    @user = user
    mail(to: @user.email, subject: 'Sample Email')
  end
end
