class CodeMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.code_mailer.send_code.subject
  #
  def send_code(user) #metodo que retorna el codigo de seguridad 
    @code = user.current_otp

    mail to: user.email
  end

  def send_change_password(user)
    token = user.send(:set_reset_password_token)
    
    @reset_password_url = 'http://localhost:3000'+ Rails.application.routes.url_helpers.edit_user_password_path(reset_password_token: token)
    
    mail to: user.email
  end

end
