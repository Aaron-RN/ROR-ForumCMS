# frozen_string_literal: true

class ForumsController < ApplicationController
  before_action :set_forum, only: %i[show update destroy]

  def index
    per_page = params[:forum][:per_page]
    page = params[:forum][:page]
    all_forums = []
    Forum.all.each do |forum|
      new_forum = forum.attributes
      new_forum['posts'] = forum.subforum_posts(nil, per_page, page)
      new_forum['subforums'] = return_subforums(forum, per_page, page)
      all_forums.push new_forum
    end

    json_response(forums: all_forums)
  end

  def show
    per_page = params[:forum][:per_page]
    page = params[:forum][:page]
    selected_forum = @forum.attributes
    new_forum['posts'] = forum.subforum_posts(nil, per_page, page)
    selected_forum['subforums'] = return_subforums(@forum, per_page, page)

    json_response(forum: selected_forum)
  end

  def create
    forum = Forum.create!(forum_params)
    json_response(forum: forum)
  end

  def update
    # update = Forum.update(@forum.id, forum_params)
    if @forum.update(forum_params)
      json_response(forum: @forum)
    else
      json_response(errors: @forum.errors.full_messages)
    end
  end

  def destroy
    @forum.destroy
    json_response('Forum destroyed')
  end

  private

  def set_forum
    @forum = Forum.find(params[:id])
  end

  def return_subforums(forum, per_page, page)
    all_subforums = []
    forum.subforums.each do |subforum|
      new_subforum = { subforum: subforum,
                       posts: forum.subforum_posts(subforum, per_page, page) }
      all_subforums.push(new_subforum)
    end

    all_subforums
  end

  def forum_params
    params.require(:forum)
          .permit(:name, [subforums: []], :admin_only, :admin_view_only)
  end
end
