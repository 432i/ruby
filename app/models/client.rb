class Client < ApplicationRecord
    has_many :users

    def timeout
        timeoutminutes
    end
end
