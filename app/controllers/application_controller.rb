class ApplicationController < ActionController::API
  before_action :authenticate_request
  JWT_SECRET = 'mysecret1'
  ALGORITHM_TYPE = 'HS256'
  # rescue_from ActiveRecord::RecordNotDestroyed , with: :notdestroyed

  private

  def authenticate_request
    header = request.headers['Authorization']
    token = header&.split(' ')&.last

    begin
      decoded_token = JWT.decode(token, JWT_SECRET, true, algorithm: ALGORITHM_TYPE)
      user_id = decoded_token[0]['user_id']
      @current_user = User.find(user_id)
    rescue JWT::DecodeError, ActiveRecord::RecordNotFound => e
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end

  def current_user
    @current_user
  end

  # def notdestroyed(e)
  #   render: json {errors: e.record.errors} , status: unprocessable_entity
  # end

end