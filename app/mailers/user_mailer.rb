class UserMailer < ApplicationMailer
  def verification_email(user)
    @user = user
    @url = verify_user_url(@user)
    mail(to: @user.email, subject: 'Your Verification PIN')
  end
end
