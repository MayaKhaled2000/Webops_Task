class PostsController < ApplicationController
    before_action :set_post, only: [:show, :update, :destroy]
    before_action :authorize_user, only: [:update, :destroy]
  
    def index
      @posts = Post.all
      render json: @posts
    end
  
    def show
      render json: @post
    end
  
    def create
      
      # binding.irb
      # @tags = Tag.create(post_params[:tags])
      # @post = Post.new(post_params.merge(author: current_user))
      @post = current_user.posts.build(post_params)
    
      tag_names = params[:tags] || []
      tags = tag_names.map { |name| Tag.find_or_create_by(name: name) }
      @post.tags = tags
  
      if @post.save
        render json: @post, status: :created
      else
        render json: { errors: @post.errors.full_messages }, status: :unprocessable_entity
      end
    end
  
    def update
      tag_names = params[:tags] || []
      tags = tag_names.map { |name| Tag.find_or_create_by(name: name) }
      @post.tags = tags
      if @post.update(post_params)
        render json: @post
      else
        render json: { errors: @post.errors.full_messages }, status: :unprocessable_entity
      end
    end
  
    def destroy
      @post.destroy
    end
    
    private
  
    def set_post
      @post = Post.find(params[:id])
    end
  
    def post_params
      params.require(:post).permit(:title,:body)
    end

  
    def authorize_user
      render json: { errors: 'Unauthorized' }, status: :unauthorized unless @post.author == current_user
    end
  end