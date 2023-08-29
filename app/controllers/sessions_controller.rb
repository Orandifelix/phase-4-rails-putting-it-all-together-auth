class SessionsController < ApplicationController
    def create 
        user = User.find_by(username: params[:username])
        if user&.authenticate(params[:password])
            session[:user_id] = user.id
            render json: {
                id: user.id,
                username: user.username,
                image_url: user.image_url,
                bio: user.bio
            }, status: :created
            else
                render json: { errors: ['Invalid username or password'] }, status: :unauthorized
                
        end
    end

    def destroy
        if session[:user_id]
            session[:user_id] = nil
            head :no_content
        else
             render json: { errors: ['You are not logged in'] }, status: :unauthorized
        end
    end
end
