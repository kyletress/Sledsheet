class Run < ActiveRecord::Base
  belongs_to :entry
  
  validates :entry_id, presence: true
  
  acts_as_list :scope => :entry
  default_scope -> { order('position ASC')}

end
