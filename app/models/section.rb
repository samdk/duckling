class Section < Group
  belongs_to :groupable, polymorphic: true
end
