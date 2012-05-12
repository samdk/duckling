class OrganizationsController < AuthorizedController
  respond_to :html
  respond_to :json, :xml, except: [:new, :edit]

  before_filter :set_organization, only: [:edit, :update, :destroy, :invite, :revoke]

  def index
    respond_with(@organizations = current_user.organizations)
  end

  def show
    @organization = Organization.find(params[:id])
    if !current_user.can?(read: @organization)
      unauthorized! 'organization.private'
    end
    
    respond_with @organization
  end

  def new
    @organization = Organization.new
  end

  def edit ; end

  def create
    @organization = Organization.new(params[:organization])

    @organization.users << current_user
    if @organization.authorize_with(current_user).save
      notice 'organization.created'
      # TODO: Do we need other associations?
      respond_with @organization
    else
      respond_with @organization, location: new_organization_path
    end
  end

  def update
    if @organization.update_attributes(params[:organization])
      notice 'organization.updated'
      respond_with @organization
    else
      respond_with @organization, location: edit_organization_path
    end
    
  end

  def destroy
    @organization.destroy
    destroyed_redirect_to organizations_url
  end
  
  def invite
    email = Email.find_or_create_by_email(params[:email])
    
    if user = email.user
      @organization.users << user
    else
      @organization.invited_emails << email
    end 
  end
  
  def revoke
    if params[:email]
      email = Email.where(email: params[:email])
      @organization.invitiations.where(email_id: email.id).clear
    elsif params[:user_id]
      @organization.users.where(user_id: params[:user_id]).clear
    end
  end

  private
  def set_organization
    @organization = current_user.organizations.find(params[:id])
    @organization.authorize_with(current_user)
  end
end
