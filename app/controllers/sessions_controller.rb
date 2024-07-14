class SessionsController < ApplicationController
    skip_before_action :authenticate_request, only: [:create]
    JWT_SECRET = 'mysecret1'
    ALGORITHM_TYPE = 'HS256'
  
    def create
      user = User.find_by(email: params[:email])
      if user&.authenticate(params[:password])
        token = generate_token(user)
        render json: { token: token }, status: :created
      else
        render json: { error: 'Invalid email or password' }, status: :unauthorized
      end
    end
  
    private
  
    def generate_token(user)
      payload = { user_id: user.id }
      JWT.encode(payload, JWT_SECRET, ALGORITHM_TYPE)
    end
  end