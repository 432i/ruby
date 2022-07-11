class User < ApplicationRecord
  devise :two_factor_authenticatable,
         :otp_secret_encryption_key => ENV['SECRETO_ENCRIPTADO'] #asignar esta variable de entorno de forma segura (32 bytes)

  belongs_to :client

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  #VERIFICAR QUE DATABASE AUTENTICABLE N OESTE Y ESTE TWO FACTOR AUTENTICABLE
  devise :registerable,
         :recoverable, :rememberable, :validatable, :timeoutable

  
  def timeout
    
    timeoutminutes or client.try(:timeout)
  end

  def timeout_in
    
    (timeout or 15).minutes
    #intenta primero el valor de timeout del usuario y luego del cliente
  end
end

