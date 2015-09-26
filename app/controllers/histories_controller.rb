class HistoriesController < ApplicationController

  include SessionsHelper
  before_action :set_history, only: [:edit, :update, :destroy]
  before_action :require_login
  # before_action :require_login

  # GET /histories
  # GET /histories.json
  def index

    
    if current_user.permission == 2
      puts current_id
      @histories = History.find_by_sql("SELECT * FROM histories WHERE userid ='#{current_id}' ")
      # if !@histories
      #   puts " ==> History.find is nil"
      # elsif
      #   puts " ==> History.find is not nil"
      # end
    else
      @histories = History.find_by_sql("select * from histories")
      len = History.count_by_sql("select count(*) from histories")
      puts "result size is : " + len.to_s
      
      # if !@histories
      #   puts " ==> History.all is nil"
      # elsif
      #   puts " ==> History.all is not nil"
      #   @histories.each do |h|
      #     puts " ==> History is looping!"
      #   end
      
      # end

    end
  end

  # GET /histories/1
  # GET /histories/1.json
  def show
    @histories = History.find_by_sql("SELECT * FROM histories WHERE userid ='#{params[:id]}' ")
  end

  # GET /histories/new
  def new
    @history = History.new
  end

  # GET /histories/1/edit
  def edit
  end

  # POST /histories
  # POST /histories.json
  def create
    @history = History.new(history_params)

    respond_to do |format|
      if @history.save
        format.html { redirect_to @history, notice: 'History was successfully created.' }
        format.json { render :show, status: :created, location: @history }
      else
        format.html { render :new }
        format.json { render json: @history.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /histories/1
  # PATCH/PUT /histories/1.json
  def update
    respond_to do |format|
      if @history.update(history_params)
        format.html { redirect_to @history, notice: 'History was successfully updated.' }
        format.json { render :show, status: :ok, location: @history }
      else
        format.html { render :edit }
        format.json { render json: @history.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /histories/1
  # DELETE /histories/1.json
  def destroy
    @history.destroy
    respond_to do |format|
      format.html { redirect_to histories_url, notice: 'History was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_history
      @history = History.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def history_params
      params.require(:history).permit(:userid, :bookid, :checkouttime, :returntime)
    end
  # def require_login
  #   unless logged_in?
  #     redirect_to login_url, notice: 'login first plz'# halts request cycle
  #   end
  # end
end
