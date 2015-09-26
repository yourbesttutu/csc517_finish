class Book < ActiveRecord::Base
  validates :isbn, :presence => true, numericality: true, uniqueness: true
  validates :title, :presence => true
  validates :author, :presence => true
  validates :description, :presence => true
  #validates :status, :presence => true

  def self.search(search)
    if(search.upcase=='AVAILABLE')
      where( "status like ? ","1" )
    else
      where( "isbn like ? OR title like? OR author like? OR description like?", "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%" )
    end
  end


  def self.searchu(searchu)
    User.find_by_email(searchu)
  end
end
