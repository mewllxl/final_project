class CommentsController < ApplicationController
  before_action :require_login
  #before_action :set_post
  #before_action :set_comment, only: [:destroy]
  before_action :set_post, only: [:create, :destroy]
  before_action :set_comment, only: [:destroy]

  def create
    @comment = @post.comments.build(comment_params)
    @comment.user = current_user
    if @comment.save
      redirect_to post_path(@post), notice: "Comment added!"
    else
      redirect_to post_path(@post), alert: "Comment can't be empty"
    end
  end

  def destroy
    if @comment.destroy
      flash[:notice] = 'Comment was successfully deleted.'
    else
      flash[:alert] = 'Unable to delete comment.'
    end
    redirect_to post_path(@post)
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end

  def set_comment
    @comment = @post.comments.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:content)
  end

  def require_login
    redirect_to login_path, alert: "You must log in to comment" unless logged_in?
  end
end
