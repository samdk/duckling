module Mapping
  class OrganizationSection < ActiveRecord::Base
    self.table_name = 'organizations_sections'
    belongs_to :organization
    belongs_to :section
    
    def interested_emails
      organization.users | section.users
    end
  end
  
  class ActivationOrganization < ActiveRecord::Base
    self.table_name = 'activations_organizations'
    belongs_to :activation
    belongs_to :organization   
    
    def interested_emails
      # a_sql = '(memberships.container_type = "Activation"   AND memberships.container_id = ?)'
      # o_sql = '(memberships.container_type = "Organization" AND memberships.container_id = ?)'
      # User.joins(:memberships)
      #     .where("#{a_sql} OR #{o_sql}", activation_id, organization_id)
      #     .select('distinct(users.id), users.*')
      activation.users | organization.users
    end 
  end
  
  class SectionUpdate < ActiveRecord::Base
    self.table_name = 'sections_updates'
    belongs_to :section
    belongs_to :update
    
    def interested_emails
      (section.interested_emails + update.interested_emails).uniq
    end
  end
end