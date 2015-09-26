class SessionsController < ApplicationController
  # before_action :require_login, only: [:create]

  # GET /users/login
  # if alread logged in, just redirect to user's user_path
  # if not logged in, create a session
  def new
    if(User.find_by_email("you@you")==nil)
      u=User.new
      u.name='you'
      u.email='you@you'
      u.password='bb'
      u.permission=0
      u.save
    end
    if logged_in?
      redirect_to user_path(current_user)
    end
  end

  # POST /users/login
  # create a new session if login successfully
  def create
    puts "\n ==> User Name: " + params[:session][:email] + "\n ==> Password: " + params[:session][:password] + "\n\n"
    
    @user = User.find_by_email(params[:session][:email].downcase)
    if @user || @user.authenticate(params[:session][:email].downcase, params[:session][:password].downcase)
      # Sign the user in and redirect to the user's show page.
      log_in(@user);
      redirect_to :controller => 'users', :action => 'show', :id => session[:id]
      
    else
      # Create an error message and re-render the signin form.
      flash[:notice] = "Invalid email or password"
      redirect_to login_path
    end
  end

  def password

  end

  def password_change
    @user = current_user
    if @user.password == params[:session][:password_old]
      @user.update({:password => params[:session][:password]})
      redirect_to users_path, notice: 'Password changed successfully'
    else
      flash.now[:danger] = 'Incorrect password. Please try again'
      render 'password'
    end
  end

  def destroy
    log_out
    # redirect_to login_path
  end
    
end
