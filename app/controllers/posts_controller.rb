# frozen_string_literal: true

class PostsController < ApplicationController
  before_action :set_post, only: %i[show update destroy lock_post pin_post]

  def show
    json_response(post: @post)
  end

  def create
    user = User.find(params[:post][:user_id])
    post = user.posts.build(post_params)
    if post.save
      json_response(post: post)
    else
      json_response(errors: post.errors.full_messages)
    end
  end

  def update
    if @post.update(post_params)
      json_response(post: @post)
    else
      json_response(errors: @post.errors.full_messages)
    end
  end

  def destroy
    @post.destroy
    json_response('Post destroyed')
  end

  def lock_post
    if @post.update(is_locked: !@post.is_locked)
      json_response(post: @post)
    else
      json_response(errors: @post.errors.full_messages)
    end
  end

  def pin_post
    if @post.update(is_pinned: !@post.is_pinned)
      json_response(post: @post)
    else
      json_response(errors: @post.errors.full_messages)
    end
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :body, :subforum, :is_pinned,
                                 :is_locked, :forum_id)
  end
end
