class History < ActiveRecord::Base

  def self.searchid(search)
    where( "userid like ?", "%#{search}%" )
  end

end
