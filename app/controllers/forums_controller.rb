# frozen_string_literal: true

class ForumsController < ApplicationController
  before_action :set_forum, only: %i[show update destroy]

  def index
    all_forums = []
    Forum.all.each do |forum|
      new_forum = forum.attributes
      new_forum['posts'] = forum.subforum_posts(nil)
      new_forum['subforums'] = return_subforums(forum)
      all_forums.push new_forum
    end

    json_response(forums: all_forums)
  end

  def show
    selected_forum = @forum.attributes
    selected_forum['posts'] = @forum.subforum_posts(nil)
    selected_forum['subforums'] = return_subforums(@forum)

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

  def return_subforums(forum)
    all_subforums = []
    forum.subforums.each do |subforum|
      new_subforum = { subforum: subforum,
                       posts: forum.subforum_posts(subforum) }
      all_subforums.push(new_subforum)
    end

    all_subforums
  end

  def forum_params
    params.require(:forum)
          .permit(:name, [subforums: []], :admin_only, :admin_view_only)
  end
end
