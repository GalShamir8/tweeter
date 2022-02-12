class UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update destroy following followers ]
  before_action :set_following, only: %i[ show following followers ]
  before_action :set_followers, only: %i[ show followers following ]
  before_action :set_is_follow, only: %i[ show followers following ]
  before_action :searched_users, only: %i[ search ]

  Q_GET_ALL_FOLLOWERS = 'follow = ?'
  Q_GET_ALL_FOLLOWING = 'user_id = ?'

  # GET /users or /users.json
  def index
    @users = User.all
  end

  # GET /users/1 or /users/1.json
  def show
    @followers_count = @followers.length() || 0
    @following_count = @following.length() || 0
  end

  # GET /users/search
  def search
  end

  # GET /users/followers
  def followers
    @users = []
    if !@followers.blank?
      @followers.each do |follower|
        user_id = follower.user_id
        user = User.find(user_id)
        if !user.blank?
          @users.append(user)
        end
      end
    end
  end

  # GET /users/following
  def following
    @users = []
    if !@following.blank?
      @following.each do |follower|
        user_id = follower.follow
        user = User.find(user_id)
        if !user.blank?
          @users.append(user)
        end
      end
    end
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users or /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to user_url(@user), notice: "User was successfully created." }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to user_url(@user), notice: "User was successfully updated." }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url, notice: "User was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    def set_following
      @following = Follower.where(Q_GET_ALL_FOLLOWING, @user.id)
    end

    def set_followers
      @followers = Follower.where(Q_GET_ALL_FOLLOWERS, @user.id)
    end

    def set_is_follow
      if @followers.length() || 0 > 0
        current_user_following = @followers.where("user_id = ?", current_user.id)
        @is_follow = !current_user_following.blank?
        if @is_follow
          @follow_row_index = current_user_following.first.id
        end
      else
        @is_follow = false
      end
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:email, :password)
    end

    def searched_users
      @users = User.where("username LIKE ?", "%#{params[:q]}%")
    end
end
