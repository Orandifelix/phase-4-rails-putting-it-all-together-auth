class RecipesController < ApplicationController
  rescue_from ActiveRecord::RecordInvalid, with: :handle_unprocessable_entity

  def index
    if session[:user_id]
      recipes = Recipe.all.includes(:user)
      render json: recipes, include: { user: { only: [:username, :id, :image_url, :bio] } },
             only: [:id, :title, :instructions, :minutes_to_complete], status: :ok
    else
      render json: { errors: ["Unauthorized"] }, status: :unauthorized
    end
  end

  def create
    if session[:user_id]
      recipe = Recipe.create!(recipe_params)
      render json: recipe, include: { user: { only: [:username, :id, :image_url, :bio] } },
             status: :created
    else
      render json: { errors: ["Unauthorized"] }, status: :unauthorized
    end
  end

  private

  def recipe_params
    params.permit(:title, :instructions, :minutes_to_complete).merge(user_id: session[:user_id])
  end

  def handle_unprocessable_entity
    render json: { errors: ['Unprocessable entity'] }, status: :unprocessable_entity
    
  end
end


