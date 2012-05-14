class JoiningObserver < ActiveRecord::Observer
  observe 'Mapping::OrganizationSection', 'Mapping::ActivationOrganization'

  def after_create(record)
    baby, parent = get_baby_and_parent(record)

    if baby and parent
      add_memberships baby, parent
    end
  end

  # def after_destroy(record)
  #   baby, parent = get_baby_and_parent(record)
  # 
  #   return unless Organization === baby
  # 
  #   case parent
  #     when Activation
  #       remove_memberships(baby, parent) do |user|
  #       end
  #     when Section
  #       remove_memberships(baby, parent) do |user| 
  #       end
  #   end
  # end

  private
  def get_baby_and_parent(record)
    case record
      when Mapping::OrganizationSection    then [record.organization, record.section]
      when Mapping::ActivationOrganization then [record.organization, record.activation]
    end
  end

  def add_memberships(baby, parent)
    baby.memberships.select(:user_id).find_each(batch_size: 1000) do |membership|
      parent.memberships.where(user_id: membership.user_id).first_or_create()
    end
  end
  
  # def remove_memberships(baby, parent)
  #   baby.users.find_each(batch_size: 1000) do |user|
  #     if !block_given? or yield(user)
  #       parent.memberships.where(user_id: user.id).delete_all
  #     end
  #   end
  # end
end
