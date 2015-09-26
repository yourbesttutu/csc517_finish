class BooksController < ApplicationController
  before_action :set_book, only: [:show, :edit, :update, :destroy]
  before_action :require_login
  # include SessionsHelper
  
  # GET /books
  # GET /books.json
  def index
      @books = Book.all
      if params[:search]
        @books = Book.search(params[:search])
      end
  end

  # GET /books/1
  # GET /books/1.json
  def show
  end

  # GET /books/new
  def new
    @curr_user = current_user()
    if (@curr_user.permission == 2)
      redirect_to books_url, notice: "Sorry, you don't have permission"
    else
      puts "permission is 2"
    end
    @book = Book.new
  end

  # GET /books/1/edit
  def edit
  end

  # POST /books
  # POST /books.json
  def create
    @book = Book.new(book_params)
    respond_to do |format|
      if @book.save
        format.html { redirect_to @book, notice: 'Book was successfully created.' }
        format.json { render :show, status: :created, location: @book }
      else
        format.html { render :new }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
    #end
  end

  # PATCH/PUT /books/1
  # PATCH/PUT /books/1.json
  def update
    respond_to do |format|
      if @book.update(book_params)
        format.html { redirect_to @book, notice: 'Book was successfully updated.' }
        format.json { render :show, status: :ok, location: @book }
      else
        format.html { render :edit }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /books/1
  # DELETE /books/1.json
  def destroy
    @histories = History.find_by_sql(" SELECT *
                                    FROM histories
                                    WHERE bookid = '#{@book.id}' ")
    @ture=0

    @histories.each do |history|
      if (history.returntime == '-1')
        @ture=1
        redirect_to books_url notice: 'The Book is still checked out'
      end
    end

    if (@ture == 0)
      @histories.each do |history|
        history.destroy
      end

      @book.destroy
      respond_to do |format|
        format.html { redirect_to books_url, notice: 'Book was successfully destroyed.' }
        format.json { head :no_content }
      end
    end
  end

  # Return the Book
  def return
    @book = Book.find(params[:id])
    @history = History.find(params[:hid])
    t = Time.now

    # UPDATE Book and History
    @book.status = '1'
    @history.returntime = t

    # SAVE TO DATABASE
    @book.save
    @history.save
    redirect_to :back, notice: 'Book is successfully returned.'
  end

  # Check out the Book
  def checkout
    @book = Book.find(params[:id])
    @history = History.new()
    t = Time.now

    # UPDATE BOOK and HISTORY
    @book.status = '0'
    @history.userid = params[:uid]
    @history.bookid = params[:id]
    @history.checkouttime = t
    @history.returntime = -1

    # SAVE TO DATABASE
    @book.save
    @history.save
    # puts "checkout success !"
    redirect_to :back, notice: 'Book is successfully checked out.'
  end


  def searchu
    @otheruser = Book.searchu(params[:searchu].to_s)
    @book = Book.find(params[:bid])
    if @otheruser
      if params[:searchu] and @otheruser.permission < 2
        redirect_to :back, notice: 'Can`t check out for Admin'
      else
        @history = History.new()
        t = Time.now
        @book.status = '0'
        @history.userid = @otheruser.id
        @history.bookid = params[:bid]
        @history.checkouttime = t
        @history.returntime = -1
        @book.save
        @history.save
        redirect_to :back, notice: 'Check out successfully'
      end
    else
      redirect_to :back, notice: 'Can`t find this user'
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_book
      @book = Book.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def book_params
      params.require(:book).permit(:isbn, :title, :author, :description, :status)
    end
end
