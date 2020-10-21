class Recipe < ApplicationRecord
  belongs_to :user
  
  has_many :comments, :dependent => :delete_all
  has_many :ingredients, :dependent => :delete_all
  has_many :dietary_restrictions, :dependent => :delete_all
  has_many :users, through: :comments

  validates_presence_of :name, :steps, :description

  accepts_nested_attributes_for :ingredients, reject_if: proc {|ing| ing['name'].blank? || ing['count'].blank? || ing['measurement'].blank? }
  accepts_nested_attributes_for :dietary_restrictions, reject_if: proc {|diet| diet['name'].blank? }

  scope :search, -> (query) { where("LOWER(name) LIKE ?", "%#{query.downcase}%") }


  def overall_rating
    rating_sum = 0
    self.comments.each do |comment|
      rating_sum += comment.rating
    end 
    mean_rating = (rating_sum/self.comments.count) unless self.comments.count == 0
    if self.comments.count == 0 
      "No Reviews Yet"
    else 
     "#{mean_rating} Stars"
    end
  end 

end
