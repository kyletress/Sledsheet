class Run < ActiveRecord::Base
  before_save :calculate_intermediates
  belongs_to :entry
  
  validates :entry_id, presence: true
  
  acts_as_list :scope => :entry
  default_scope -> { order('position ASC')}
  
  private
  
    def calculate_intermediates
      self.int1 = split2 - start unless split2.nil? or start.nil?
      self.int2 = split3 - split2 unless split3.nil? or split2.nil?
      self.int3 = split4 - split3 unless split4.nil? or split3.nil?
      self.int4 = split5 - split4 unless split5.nil? or split4.nil?
      self.int5 = finish - split5 unless finish.nil? or split5.nil?
    end

end
