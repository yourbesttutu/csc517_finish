class User < ActiveRecord::Base
  validates :name, :presence => true
  validates :email, :presence => true
  validates :password, :presence => true
  validates :permission, :presence => true
  
  def authenticate(email, password)
    if user = User.find_by_email(email)
      if user.password == password
        #if user.password == ''
        return user
      end
    end
    return nil
  end

end
