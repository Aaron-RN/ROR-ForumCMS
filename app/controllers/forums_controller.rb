# frozen_string_literal: true

class ForumsController < ApplicationController
  before_action :set_forum, only: %i[update destroy]
  before_action :set_page_params, only: %i[index show]

  def index
    all_forums = []
    Forum.all.each do |forum|
      new_forum = forum.attributes
      new_forum['posts'] = forum.subforum_posts(nil, @per_page, @page)
      new_forum['subforums'] = return_subforums(forum, @per_page, @page)
      all_forums.push new_forum
    end

    json_response(results: { forums: all_forums, pinned_posts: Post.pins,
                             per_page: @per_page, page: @page })
  end

  def index_all
    json_response(forums: Forum.all)
  end

  def show
    forum = Forum.find_by(name: params[:forum])
    selected_forum = forum.attributes
    if params[:subforum].present?
      subforum = params[:subforum]
      selected_forum['posts'] = []
      new_subforum = { subforum: subforum,
                       posts: forum.subforum_posts(subforum, @per_page, @page) }
      selected_forum['subforums'] = new_subforum
    else
      selected_forum['posts'] = forum.subforum_posts(nil, @per_page, @page)
      selected_forum['subforums'] = return_subforums(forum, @per_page, @page)
    end

    json_response(results: { forum: selected_forum,
                             per_page: @per_page, page: @page })
  end

  def create
    Forum.create!(forum_params)
    json_response(forums: Forum.all)
  end

  def update
    # update = Forum.update(@forum.id, forum_params)
    if @forum.update(forum_params)
      json_response(forums: Forum.all)
    else
      json_response(errors: @forum.errors.full_messages)
    end
  end

  def destroy
    @forum.destroy
    json_response('Forum destroyed successfully')
  end

  private

  def set_forum
    @forum = Forum.find(params[:id])
  end

  def set_page_params
    @per_page = params[:per_page].present? ? params[:per_page].to_i : 5
    @page = params[:page].present? ? params[:page].to_i : 1
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
          .permit(:name, [subforums: []], :admin_only, :admin_only_view)
  end
end
