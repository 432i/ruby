class Client < ApplicationRecord
    has_many :users

    def timeout
        
        
        puts timeoutminutes
        timeoutminutes
    end
end
