class OrganizationsController < ApplicationController

  respond_to :html
  respond_to :json, :xml, except: [:new, :edit]

  def index
    respond_with(@organizations = current_user.organizations)
  end

  def show    
    if current_model.blank? or !current_user.can_see_organization?(current_model)
      unauthorized! 'organization.private'
    end
  end

  def new
    @organization = Organization.new
  end

  def edit
    @organization = current_model
  end

  def create
  end

  def update
    @organization = current_model
    
    unless current_user.managed_organizations.include?(@organization)
      unauthorized! 'organization.update_others'
    end
    
    if @organization.update_attributes(params[:organization])
      notice 'organization.updated'
    end
    
    respond_with(@organization)
  end

  def destroy
    unless current_user.administrated_organizations.include?(current_model)
      unauthorized! 'organization.delete_others'
    end
      
    current_model.destroy
    destroyed_redirect_to organizations_url
  end
end
