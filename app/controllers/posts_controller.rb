class PostsController < ApplicationController
  before_action :require_login, only: [:like, :create, :update, :destroy] # ทำให้ต้องล็อกอินสำหรับการกระทำบางอย่าง
  before_action :set_post, only: [:show, :edit, :update, :destroy, :like]
  before_action :authorize_post, only: %i[edit update destroy]

  def index
    # ค้นหาจากคำที่พิมพ์ในฟอร์ม
    if params[:search].present?
      @posts = Post.where('title LIKE ? OR content LIKE ?', "%#{params[:search]}%", "%#{params[:search]}%")
    else
      @posts = Post.all
    end
  end

  def new
    if current_user.nil?
      redirect_to login_path, alert: "You must log in to create a post."
    else
      @post = current_user.posts.build
    end
  end
  

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      redirect_to posts_path, notice: "Post created successfully!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @post.update(post_params)
      redirect_to posts_path, notice: "Post updated successfully!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @post.destroy
    redirect_to posts_url, notice: "Post was successfully deleted."
  end

  def show
    @comments = @post.comments
  end

  def like
    if current_user
      if current_user.liked?(@post)
        # ถ้าไลค์แล้ว ลบไลค์ออก
        @post.likes.find_by(user_id: current_user.id).destroy
        liked = false
      else
        # ถ้ายังไม่ไลค์ เพิ่มไลค์
        @post.likes.create(user_id: current_user.id)
        liked = true
      end
      @post.reload # รีเฟรชข้อมูลโพสต์
      
      # แสดงผลเป็น HTML และ render partial ที่ต้องการอัปเดต
      respond_to do |format|
        format.html { redirect_to @post } # รีไดเรกต์ไปยังโพสต์
        format.js   # ทำการใช้ JavaScript (ตอบกลับแบบ .js.erb) เพื่ออัปเดตข้อมูลบนหน้า
      end
    else
      redirect_to login_path, alert: "You must log in to like posts."
    end
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def authorize_post
    redirect_to posts_path, alert: "Not authorized to perform this action" unless @post.user == current_user
  end

  def post_params
    params.require(:post).permit(:title, :content)
  end

  def require_login
    redirect_to login_path, alert: "You must log in to access this page" unless logged_in?
  end
end
