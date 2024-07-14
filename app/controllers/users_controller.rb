class UsersController < ApplicationController

   skip_before_action :authenticate_request, only: [:create]

    def create
      user = User.new(user_params)
      if user.save
        token = generate_token(user)
        render json: { token: token }, status: :created
      else
        render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
      end
    end
  
    private
  
    def generate_token(user)
      payload = { user_id: user.id }
      JWT.encode(payload, Rails.application.credentials.jwt_secret, 'HS256')
    end
  
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
  end