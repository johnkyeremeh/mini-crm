class ContactsController < ApplicationController
    before_action :get_app, only: [:index, :new, :show, :edit, :update, :destroy, :identify]
    before_action :set_contacts, only:[:show, :edit, :update, :destroy, :identify]
    before_action :require_login, only: [:index, :new, :create, :show, :edit, :update, :destroy]
    
   
    #list of all contacts
    def index
        if params[:app_id]
            @contacts = @app.contacts
        else 
            @contacts = Contact.all 
        end
    end

    #create a new contact
    def new 
        @contact = Contact.new
    end

    def create 
        @app = App.find(params[:app_id])
        @contact = Contact.new(contact_params)

        if @contact.save 
            redirect_to controller: "contacts", action: 'index'
        else 
            render :new
        end

    end

    #show contact information
    def show 
        @contact = Contact.find(params[:id])
    end


    def edit 
        @contact = Contact.find_by(id: params[:id])
    end

    def update 
        @contact = Contact.find_by(id: params[:id])
        @contact.update(contact_params)
        redirect_to app_contacts_path(@contact.app)

    end

    def destroy
        @contact = contact.find(params[:id]).destroy
        redirect_to "/"
    end


    def contact_created_from_page

        @app = App.find(params[:app_id])
        @contact = Contact.new(contact_params)
        @page = Page.find(params[:page_id])
    
        @contact.app = @app 
        @contact.name = ""
        @contact.visitor_token = current_visit.visitor_token
        @contact.visitor_id = current_visit.id

        @contact.save 
    
        redirect_to app_page_path(@app, @page)

    end

    #identify if contact has any visitor activity 
    def identify 
        @contacts = Contact.all 
        Visitor.all.select do |visitor|
            if @contact.visitor_id == visitor.id
                @identity = Identity.new(visitor_id: visitor.id, contact_id: @contact.visitor_id)
                
                @identity.identity_confirmed = true 
                @identity.save 
                flash[:message] = "Contact Identified"
                redirect_to controller: "contacts", action: 'index', app_id: @contact.app.id
            else
                flash[:message] = "Contact Activity not found"
                render :index
            end
        end
    end
 


    


    private

    def get_app
        @app =  App.find(params[:app_id])
    end

    def set_contacts 
        @contact = @app.contacts.find(params[:id])
    end

   
    def contact_params 
        params.require(:contact).permit(:name, :spent, :age, :email, :gender, :first_seen,  :last_visit, :region, :city, :country_code, :app_id, :visitor_id, :visitor_token, :page_id)
    end

end
