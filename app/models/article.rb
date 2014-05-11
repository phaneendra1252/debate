class Article < ActiveRecord::Base

  has_many :comments, :dependent => :destroy
  belongs_to :user

  validates_presence_of :name, :content

end
