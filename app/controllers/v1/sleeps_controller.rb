class V1::SleepsController < ApplicationController
  before_action :find_user, only: [:index, :friends_record]
  def index
    sleeps = @user.sleeps.order(created_at: :desc)
    render json: sleeps
  end

  def create
    user = User.find(sleep_params[:user_id])
    sleep = user.sleeps.new(sleep_params)
    if sleep.save
      render json: { sleep: "You had clocked in successfully with duration #{sleep.duration.strftime("%H:%M:%S")}" } , status: :created
    else
      render json: { errors: sleep.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def friends_record
    friends = @user.followees
    sleeps = Sleep.where(user_id: friends).where(created_at: 1.week.ago..Time.current).order(duration: :asc)
    render json: sleeps
  end

  private
  def find_user
    @user = User.find(params[:user_id])
  end

  def sleep_params
    params.require(:sleep).permit(:asleep_at, :woke_up_at, :user_id)
  end
end
