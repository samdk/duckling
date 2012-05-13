class InvitationsController < AuthorizedController
  
  before_filter :set_target
  
  respond_to :json
  respond_to :html, except: [:search]
  
  skip_login only: [:search]
  
  def search
    hash = Hash.new {|hsh, key| hsh[key] = []}
    hash['Users'] = current_user.acquaintance_ids.map {|aid| [aid, @target.users.exists?(aid)] }    
    case @target
      when Activation
        hash['Organizations'] = current_user.organization_ids.map {|oid| [oid, @target.organizations.exists?(oid)] }
        hash['Groups']        = current_user.potential_group_ids.map {|gid| [gid, true] }
      when Section
        hash['Organizations'] = current_user.organization_ids.map {|oid| [oid, @target.organizations.exists?(oid)] }
        hash['Groups']        = current_user.potential_group_ids.map {|gid| [gid, @target.groups.exists?(gid)] }
    end
    
    respond_to do |format|
      format.json { render json: hash }
    end
  end
  
  def create
    params[:sources].each do |source|
      if source[:class_name] == 'Email'
        if current_user.can? read: @target
          Email.invite(source[:email], @target)
        end
      else
        source_object = objectize source[:class_name], source[:id]
        current_user.try_to_associate @target, source_object
      end
    end
  end
  
  private
  def set_target
    @target = objectize(params[:target_class], params[:target_id])
  end
  
  def objectize(klass_name, id)
    klass_name.constantize.find(id.to_i)
  rescue NameError
    raise ActiveRecord::RecordNotFound
  end
end