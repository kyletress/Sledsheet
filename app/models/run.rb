class Run < ActiveRecord::Base
  before_save :calculate_intermediates
  belongs_to :entry

  validates :entry_id, presence: true
  validates :status, presence: true

  enum status: [:ok, :dns, :dnf, :dsq]

  acts_as_list :scope => :entry
  default_scope -> { order('position ASC')}

  # a test for calculating intermediates at the db level
  def self.first_int
    select("runs.*, (split2 - start) as int")
  end

  def difference_from(run)
    values = []
    values << (self.start - run.start unless self.start.nil? or run.start.nil?)
    values << (self.split2 - run.split2 unless self.split2.nil? or run.split2.nil?)
    values << (self.split3 - run.split3 unless self.split3.nil? or run.split3.nil?)
    values << (self.split4 - run.split4 unless self.split4.nil? or run.split4.nil?)
    values << (self.split5 - run.split5 unless self.split5.nil? or run.split5.nil?)
    values << (self.finish - run.finish unless self.finish.nil? or run.finish.nil?)
    values
  end

  private

    def calculate_intermediates
      self.int1 = split2 - start unless split2.nil? or start.nil?
      self.int2 = split3 - split2 unless split3.nil? or split2.nil?
      self.int3 = split4 - split3 unless split4.nil? or split3.nil?
      self.int4 = split5 - split4 unless split5.nil? or split4.nil?
      self.int5 = finish - split5 unless finish.nil? or split5.nil?
    end

end
