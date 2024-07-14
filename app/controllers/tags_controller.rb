class TagsController < ApplicationController
    before_action :set_tag, only: [:show, :update, :destroy]
    before_action :set_post, only: [:update_post_tags]
    before_action :authorize_user, only: [:update, :destroy ,:update_post_tags]

  
    def index
      @tags = Tag.all
      render json: @tags
    end
  
    def show
      render json: @tag
    end
  
    def create
      @tag = Tag.new(tag_params)
  
      if @tag.save
        render json: @tag, status: :created
      else
        render json: { errors: @tag.errors.full_messages }, status: :unprocessable_entity
      end
    end
  
    def update
      if @tag.update(tag_params)
        render json: @tag
      else
        render json: { errors: @tag.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def update_post_tags
      @post.tags = Tag.where(id: params[:tag_ids])
      if @post.save
        render json: @post.tags, status: :ok
      else
        render json: { errors: @post.errors.full_messages }, status: :unprocessable_entity
      end
    end
  
    def destroy
      @tag.destroy
    end
  
    private
  
    def set_tag
      @tag = Tag.find(params[:id])
    end
  
    def tag_params
      params.require(:tag).permit(:name)
    end
  
    def set_post
      @post = Post.find(params[:post_id])
    end
    def authorize_user
      render json: { errors: 'Unauthorized' }, status: :unauthorized unless @post.author == current_user
    end
  end