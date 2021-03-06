class UsersController < ApplicationController
  def home
  end

  def create
    @u = User.new(new_user)
    if @u.save
      session[:user_id] = @u.id
      redirect_to "/auctions"
    else
      flash[:errors] = @u.errors.full_messages
      redirect_to :back
    end
  end

  def subscribe
    @subscribe = Subscribe.new(:email => params[:email] )
    if @subscribe.save
      UserMailer.signup_confirmation(@subscribe).deliver_now
      redirect_to "/"
    else 
      redirect_to :back
    end
  end

  def new
  end

  def edit
    @user = User.find(session[:user_id])
    if @user.address_id != nil
      @address = Address.find(@user.address_id)
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update(update_user)
      redirect_to :back
    else
      flash[:errors] = @user.errors.full_messages
      redirect_to :back
    end
  end

  def destroy
  end
  private
    def new_user
      params.require(:user).permit(:first_name, :last_name, :email, :password)
    end

    def update_user
      params.require(:user).permit(:first_name, :last_name, :email, :company, :phone_number)
    end
end
