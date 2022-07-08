class User < ApplicationRecord
  belongs_to :client

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :timeoutable

  
  def timeout
    
    timeoutminutes or client.try(:timeout)
  end

  def timeout_in
    
    (timeout or 15).minutes
    #intenta primero el valor de timeout del usuario y luego del cliente
  end
end
