class User < ApplicationRecord
    has_secure_password
    belongs_to :app
    
    has_many :contacts
    
    has_many :visitors
   
    has_many :pages 

    def self.from_omniauth(response)
        @user = User.find_or_create_by(uid: response[:uid], provider: response[:provider]) do |u|
            u.username = response[:info][:name]
            u.email = response[:info][:email]
            u.password = SecureRandom.hex(15)
            u.app = u.build_app
        end
        ahoy.authenticate(@user)
    end


    private

    #create an instance of an app and associate with the user
    # def set_create_app
    #     @app = App.create
    #     self.app = @app 
    # end

    def user_params
        params.require(:user).permit(:username, :password, :email, :uid, :provider)
    end
end
