class AddIndices < ActiveRecord::Migration
  
  INDICES = [[:deployments, :activation_id  ],
             [:deployments, :deployed_id    ],
             [:users,       :cookie_token   ],
             [:memberships, :organization_id],
             [:memberships, :user_id        ],
             [:users,       :last_name      ]]
  
  def self.up
    INDICES.each {|table, field| add_index table, field }
  end

  def self.down
    INDICES.each {|table, field| remove_index table, field }
  end
end
