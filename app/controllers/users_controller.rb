class UsersController < ApplicationController
    def create
        user = User.create(user_params)
        if user.valid? 
        session[:user_id] = user.id
        render json: user, status: :created
        else
        render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
        end
    end

    def show 
        if session[:user_id]
            user =User.find(session[:user_id])
            render json:{
                id: user.id,
                username: user.username,
                image_url: user.image_url,
                bio: user.bio
            }, status: :ok
            else
                 render json: { error: "Unauthorized Activity" }, status: :unauthorized
        end
    end


  private
  def user_params
    params.permit(:username, :image_url, :bio, :password, :password_confirmation)
  end
end
