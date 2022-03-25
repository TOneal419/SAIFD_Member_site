class UsermailerMailer < ApplicationMailer
    
   
   def welcome_email(user)
      @user = user
      @url  = 'git//www.gmail.com'
      mail(to: @user.email, subject: 'Welcome to My Awesome Site')
   end
end
