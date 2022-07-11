class UsersOtpController < ApplicationController
    before_action :authenticate_user!, except: [:home]

    ###activar o desactivar reseteo de auth de 2 pasos

    def enable
        current_user.otp_secret = User.generate_otp_secret
        current_user.otp_required_for_login = true #columna que indica si el usuario activo la auth2p
        current_user.save!
        redirect_back fallback_location: root_path, alert: "Autentificacion de 2 pasos activada"

    end

    def disable 
        current_user.otp_secret = User.generate_otp_secret
        current_user.otp_required_for_login = false #columna que indica si el usuario activo la auth2p
        current_user.save!
        redirect_back fallback_location: root_path, alert: "Autentificacion de 2 pasos desactivada"

    end

    ####activar o desactivar reseteo de contraseña

    def enable_reset_password
        current_user.passwordreset = true
        current_user.save!
        CodeMailer.send_change_password(current_user).deliver_now
        redirect_back fallback_location: root_path, alert: "Reseteo de contraseña activado"
    end

    def disable_reset_password
        current_user.passwordreset = false
        current_user.save!
        redirect_back fallback_location: root_path, alert: "Reseteo de contraseña desactivado"
    end


end