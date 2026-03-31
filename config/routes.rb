Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get 'service-worker' => 'rails/pwa#service_worker', as: :pwa_service_worker
  get 'manifest' => 'rails/pwa#manifest', as: :pwa_manifest

  # Defines the root path route ("/")
  # root "posts#index"

  # Devise という認証ライブラリによって、ユーザー認証（サインアップ、ログイン、ログアウト、パスワードリセットなど）に必要な一連のルーティングを一括で定義
  devise_for :users

  # パスが何も指定されていないURLにアクセスがあった場合、ArticlesController の index アクションを実行するように定義。これがアプリケーションの トップページ になる
  root to: 'articles#index'

  # articlesというリソース（多数のデータが存在する集合）に対して、7つのルーティング（index, show, new, create, edit, update, destroy）を全て生成
  # このブロック内に記述されたルーティングは、articles リソースに紐づいたルーティングとして生成される
  resources :articles do
    resources :comments, only: [:new, :create]

    resource :like, only: [:create, :destroy]
  end

  resource :profile, only: [:show, :edit, :update]
  resources :favorites, only: [:index]
end
