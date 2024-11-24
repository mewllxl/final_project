Rails.application.routes.draw do
  resources :posts do
    resources :comments, only: [:create, :destroy]
    member do
      get :like
    end
  end

  # เส้นทางสำหรับการเข้าสู่ระบบและออกจากระบบ
  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"

  # เส้นทางสำหรับการสร้างและจัดการผู้ใช้
  resources :users, only: [:new, :create]

  # หน้าหลักของเว็บไซต์
  root "posts#index"
end
