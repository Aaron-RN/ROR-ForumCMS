class ForumsController < ApplicationController
  before_action :set_forum, only: %i[show edit]

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
  end

  def edit
  end

  def destroy
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
end
