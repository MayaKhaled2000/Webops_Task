class CommentsController < ApplicationController
  before_action :set_comment, only: [:update, :destroy]
  before_action :authorize_user, only: [:update, :destroy]
  before_action :set_post, only: [:update, :destroy ,:create]


  def create
    
    @comment= Comment.new(comment_params.merge(user:current_user , post:@post))
    if @comment.save
      render json: @comment, status: :created
    else
      render json: { errors: @comment.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @comment.update(comment_params)
      render json: @comment
    else
      render json: { errors: @comment.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @comment.destroy
  end

  private

  def set_comment
    @comment = Comment.find(params[:id])
  end
  
  def set_post
    @post = Post.find(params[:post_id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end

  def authorize_user
    render json: { errors: 'Unauthorized' }, status: :unauthorized unless @comment.user == current_user
  end
end