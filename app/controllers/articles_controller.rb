class ArticlesController < ApplicationController

  # show アクションが実行される直前に、プライベートメソッドの set_article を実行
  before_action :set_article, only: [:show]
  # new, create, edit, update, destroy のアクションが実行される直前に、ユーザーの認証（ログインしているか）を確認
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]

  # 全てのリソース (Article.all) を取得し、@articles に格納します。一覧表示（/articles）のためのデータ準備
  def index
    @articles = Article.all
  end

  # before_action :set_article で取得された @article を利用して、その記事に紐づくコメントを @article.comments で取得し、@comments に格納します。詳細表示（/articles/:id）のためのデータ準備
  def show
    @comments = @article.comments
  end

  # 新規記事作成フォーム（/articles/new）を表示するために、current_user.articles.build を使って、ユーザーに紐づいた新しい記事オブジェクト @article を作成
  def new
    @article = current_user.articles.build
  end

  # フォームからのデータ (article_params) を受け取り、current_user.articles.build で記事オブジェクトを作成し、データベースに保存する
  def create
    @article = current_user.articles.build(article_params)
    # 保存に成功したら、記事の詳細ページへリダイレクトし、成功メッセージを表示
    if @article.save
      redirect_to article_path(@article), notice: '保存できたよ'
      # 保存に失敗したら、失敗メッセージを flash.now で設定し、再度 new テンプレートをレンダリングして、入力エラーをユーザーに示す
    else
      flash.now[:error] = '保存に失敗しました'
      render :new, status: :unprocessable_entity
    end
  end

  # 編集フォーム（/articles/:id/edit）を表示するために、current_user.articles.find(params[:id]) で、ログインユーザーが所有する対象記事を取得
  def edit
    @article = current_user.articles.find(params[:id])
  end

  # edit と同様にログインユーザーが所有する記事を取得し、フォームからのデータ (article_params) で @article.update を実行し、データベースを更新
  def update
    @article = current_user.articles.find(params[:id])
    # 処理は create と類似
    if @article.update(article_params)
      redirect_to article_path(@article), notice: '更新できました'
      # 処理は create と類似
    else
      flash.now[:error] = '更新できませんでした'
      render :edit, status: :unprocessable_entity
    end
  end

  # current_user.articles.find(params[:id]) でログインユーザーが所有する記事を取得し、destroy! でデータベースから削除
  def destroy
    article = current_user.articles.find(params[:id])
    article.destroy!
    # 削除後、アプリケーションのトップページ（root_path）へリダイレクトし、成功メッセージを表示します。status: :see_other は、削除後のリダイレクトであることを示す適切なHTTPステータスコード
    redirect_to root_path, status: :see_other, notice: '削除に成功しました'
  end

  private
  # ストロングパラメーター (Strong Parameters) と呼ばれるセキュリティ機能
  # フォームから送られてきたデータ (params) のうち、article キーに属する :title, :content, :eyecatch の3つだけを、データベース操作（create や update）に使用することを許可しています。これにより、悪意のあるデータ（ユーザーが勝手に変更できないはずのデータなど）の混入を防ぐ
  def article_params
    params.require(:article).permit(:title, :content, :eyecatch)
  end

  # URLから渡された :id を使って該当する記事をデータベースから取得し、インスタンス変数 @article に格納
  def set_article
    @article = Article.find(params[:id])
  end
end
