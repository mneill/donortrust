class Project < ActiveRecord::Base
  after_save :create_project_history
  after_save :save_project_history  
  
  belongs_to :project_status
  belongs_to :program
  belongs_to :partner
  has_many :project_histories#, :dependent => :destroy
  has_many :milestones#, :dependent => :destroy
  belongs_to :urban_centre
  belongs_to :contact
  #has_and_belongs_to_many :millennium_development_goals
  validates_presence_of :program
  
  def create_project_history
    if Project.exists?(self.id)
      @create_project_history_ph = ProjectHistory.new_audit(Project.find(self.id))
    end
  end

  def save_project_history
    if (@create_project_history_ph)
      @create_project_history_ph.save
      @create_project_history_ph = nil
    end
  end
  
  def destroy
    result = false
    if milestones.count > 0
#      errors.add_to_base( "Can not destroy a #{self.class.to_s} that has Milestones" )
      raise( "Can not destroy a #{self.class.to_s} that has Milestones" )
    else
      result = super
    end
    return result
  end

  def milestones_count
    return milestones.count
  end

  def get_percent_raised
    result = 0
    if !( total_cost == nil or dollars_raised == nil )
      result = (dollars_raised * 100 / total_cost) if total_cost > 0
    end
    return result
  end

  def get_number_of_milestones_by_status(status)
    milestones = self.milestones.find(:all, :conditions => "milestone_status_id = " + status.to_s )    
    return milestones.size unless milestones == nil 
  end
  
  # hpd should not really need this. self.milestones should be the same thing
  def get_milestones
    return self.milestones.find(:all, :conditions => "project_id = " + self.id.to_s)
  end
  
  def days_remaining
    result = nil
    result = end_date - Date.today if end_date != nil #number of seconds in a day
    return result
  end
  
  def village
    self.urban_centre
  end
  
  def percent_raised
    return dollars_raised * 100 / total_cost
  end  

  def self.is_a_project?(object)
    return object.class.to_s == "Project"
  end
  
  def self.total_projects
    return self.find(:all).size    
  end
  
  def self.completed_projects
    return self.find(:all, :conditions => "project_status_id => 1")     
  end
  
  def self.get_project(project_id)
    return self.find(project_id)   
  end
  
  def self.projects_nearing_end(days_until_end)
    @projects = Project.find(:all) 
    @projects_near_end = Array.new
    for aProject in @projects
      if aProject.end_date != nil
        if (aProject.end_date - Date.today) <= days_until_end  
          @projects_near_end << aProject
        end
      end
    end
    return @projects_near_end
  end
  
  def self.total_percent_raised
    return self.total_money_raised * 100 / self.total_costs
  end 
  
  def self.total_money_raised
    return self.sum(:dollars_raised)
  end
  
  def self.total_costs
    return self.sum(:total_cost)
  end
  
  def self.total_money_spent
    return self.sum(:dollars_spent)
  end
  
#  def self.get_md_goals
#    return self.project_md_goals.find(:all)
#  end
end
