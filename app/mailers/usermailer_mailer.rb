
# User Mailer Entity
class UsermailerMailer < ApplicationMailer
  def welcome_email(user)
    @user = user
    @url = 'www.heroku.com'
    mail(to: @user.email, subject: '[SAIFD Member Site] Welcome to the SAIFD Member Site')
  end

  def announce_all(user, announcement)
    @user = user
    @announcement = announcement
    @url = 'www.heroku.com'
    mail(to: @user.email, subject: '[SAIFD Member Site] ' << @announcement.title)
  end
end
