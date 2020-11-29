# frozen_string_literal: true

class PostsController < ApplicationController
  before_action :set_post, only: %i[show update destroy lock_post pin_post]

  def show
    json_response({ post: post_json(@post), comments: @post.comments })
  end

  def create
    user = User.find(params[:post][:user_id])
    return if suspended(user.can_post_date)

    post = user.posts.build(post_params)
    if post.save
      json_response(post: post_json(post))
    else
      json_response(errors: post.errors.full_messages)
    end
  end

  def update
    if @post.update(post_params)
      json_response(post: post_json(@post))
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
      json_response(post: post_json(@post))
    else
      json_response(errors: @post.errors.full_messages)
    end
  end

  def pin_post
    if @post.update(is_pinned: !@post.is_pinned)
      json_response(post: post_json(@post))
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
  
  def post_json(post)
    new_post = post.attributes
    new_post['author'] = post.author.username
    new_post['forum'] = post.forum.name
    new_post
  end

  def suspended(date)
    if date > DateTime.now
      json_response(errors: ['Your posting communications are still suspended'])
      return true
    end

    false
  end
end
