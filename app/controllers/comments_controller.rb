# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :set_post, only: %i[show create update destroy]
  before_action :set_comment, only: %i[show update destroy]

  def show
    json_response(comment: @comment)
  end

  def create
    user = User.find(params[:comment][:user_id])
    return if suspended(user.can_comment_date)

    comment = @post.comments.build(comment_params)
    if comment.save
      json_response({ comment: comment,
                      comments: Post.author_comments_json(@post.comments) })
    else
      json_response(errors: comment.errors.full_messages)
    end
  end

  def update
    if @comment.update(comment_params)
      json_response({ comment: @comment,
                      comments: Post.author_comments_json(@post.comments) })
    else
      json_response(errors: @comment.errors.full_messages)
    end
  end

  def destroy
    @comment.destroy
    json_response({ message: 'Comment deleted',
                    comments: Post.author_comments_json(@post.comments) })
  end

  private

  def set_post
    @post = Post.find(params[:comment][:post_id])
  end

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:body, :comment_id, :user_id)
  end

  def suspended(date)
    if date > DateTime.now
      json_response(errors: ['Your commenting communications
                              are still suspended'])
      return true
    end

    false
  end
end
