class UsersController < ApplicationController
    before_action :get_app, only: [:index, :show, :edit, :update, :destroy]
    skip_before_action :get_app, only: [:welcome, :welcome_create_lead]
    before_action :set_user, only:[:show, :edit, :update, :destroy]

    before_action :require_login, only: [:index, :show]
   
  
    #admins are able to see a list of users that belong to the app 
    #all non-admins get redirected to home
    def index 
        if current_user.admin == true 
            @users = @app.users
        else 
            redirect_to "/"
        end
    end

    def welcome 
        @user = User.new
        render layout: 'welcome'
    end

    def welcome_create_lead
        @user = User.new(user_params)
        render layout: false
    end

    def show 
        @user = User.find_by(id: params[:id])
    end
        

    def new 
        @user = User.new
    end

    def create 
        @user = User.new(user_params)
        @app = @user.build_app 
        if @user.save 
            session[:user_id] = @user.id
            session[:app_id] = @user.app.id
            redirect_to controller: "contacts", action: 'index', app_id: @user.app.id
        else 
            render :new
        end

    end

    def edit 
        @user = User.find_by(id: params[:id])
    end

    def update 
        @user = User.find_by(id: params[:id])
        @user.update(user_params)
        redirect_to controller: "contacts", action: 'index', app_id: @user.app.id
    end


    def destroy
        @user = User.find(params[:id]).destroy
        redirect_to "/"
    end

    private 

    def get_app
        @app =  App.find(params[:app_id])
    end

    def set_user 
        @user = @app.users.find(params[:id])
    end
    
    def user_params 
        params.require(:user).permit(:username, :email, :password, :app_id)
    end

  

end
