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

end
