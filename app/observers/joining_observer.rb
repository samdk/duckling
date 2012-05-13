class JoiningObserver < ActiveRecord::Observer
  observe :deployment, 'Section::Mapping'

  def after_create(record)
    baby, parent = get_baby_and_parent(record)

    if valid_relationship? baby, parent
      add_memberships baby, parent
    end
  end

  def after_destroy(record)
    baby, parent = get_baby_and_parent(record)

    case [baby.class, parent.class]
      when [Organization, Activation]
        remove_memberships(baby, parent) do |user|
          
        end
      when [Organization, Section]    then TODO
      when [Group,        Section]    then TODO
    end
  end

  private
  def get_baby_and_parent(record)
    case record
      when Deployment       then [record.deployed,  record.activation]
      when Section::Mapping then [record.subentity, record.section]
    end
  end
  
  VALID_RELATIONS = [[Organization, Activation], [Organization, Section], [Group, Section]]

  def valid_relationship?(baby, parent)
    VALID_RELATIONS.include?([baby, parent])
  end
  
  def add_memberships(baby, parent)
    baby.memberships.select(:user_id).find_each(batch_size: 1000) do |uid|
      parent.memberships.create(user_id: uid)
    end
  end
  
  def remove_memberships(baby, parent)
    baby.users.find_each(batch_size: 1000) do |user|
      if !block_given? or yield(user)
        parent.memberships.where(user_id: user.id).delete_all
      end
    end
  end
end
