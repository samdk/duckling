class OrganizationsController < ApplicationController

  respond_to :html
  respond_to :json, :xml, except: [:new, :edit]

  before_filter :set_organization, only: [:edit, :update, :destroy]

  def index
    respond_with(@organizations = current_user.organizations)
  end

  def show    
    @organization = Organization.find(params[:id])
    if !current_user.can_see_organization?(@organization)
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

    if @organization.save
      notice 'organization.created'
      # TODO: associate to stuff
    end
    
    respond_with @organization
  end

  def update
    if @organization.update_attributes(params[:organization])
      notice 'organization.updated'
    end
    
    respond_with @organization
  end

  def destroy
    @organization.destroy
    destroyed_redirect_to organizations_url
  end
  
  private
  def set_organization
    @organization = current_user.administrated_organizations.find(params[:id])
  end
end
