# == Schema Information
#
# Table name: articles
#
#  id         :bigint           not null, primary key
#  title      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_articles_on_user_id  (user_id)
#
class Article < ApplicationRecord
  # Active Storageを利用した関連付けです。記事にアイキャッチ画像（ファイル）を1つ添付できることを示します。
  has_one_attached :eyecatch
  has_rich_text :content

  # 必須（空でないこと）
  validates :title, presence: true
  # 2文字以上100文字以下であること
  validates :title, length: { minimum: 2, maximum: 100 }
  # **@で始まらない**こと
  validates :title, format: { with: /\A(?!\@)/ }

  # 必須（空でないこと）
  validates :content, presence: true
  # 10文字以上であること
  validates :content, length: { minimum: 10 }
  # 一意であること（他のどの記事とも本文が重複しないこと）
  validates :content, uniqueness: true

  # validateを使って、privateセクションで定義されたカスタムメソッドを検証として実行します。
  validate :validate_title_and_content_length

  # 1つの記事は複数のコメントを持つことができます。dependent: :destroyにより、記事が削除されたとき、関連するすべてのコメントも自動的に削除されます。
  has_many :comments, dependent: :destroy
  # 1つの記事は複数のいいね（Like）を持つことができます。これも記事削除時に、関連するすべてのいいねが自動的に削除されます。
  has_many :likes, dependent: :destroy
  # この記事は1人のユーザーに属しています（ユーザーが記事を作成した）。
  belongs_to :user

  # 記事の作成日時（self.created_at）を、現在設定されているロケール（ここでは日本語I18n）のデフォルトフォーマットで整形して返します。
  def display_created_at
    I18n.l(self.created_at, format: :default)
  end

  # 関連付けられたuser（記事の作成者）のdisplay_nameメソッドを呼び出し、作成者の表示名を取得して返します。
  def author_name
    user.display_name
  end

  # 関連付けられたlikesの数をカウントし、記事に付いているいいねの総数を返します。
  def like_count
    likes.count
  end

  private
  # タイトルと本文を合わせた文字数が100文字を超えていることを検証します。
  def validate_title_and_content_length
    char_count = self.title.length + self.content.length
    # 100文字以下の場合、contentフィールドにエラーメッセージ「100文字以上で!」を追加し、保存を中止します。
    errors.add(:content, '100文字以上で!') unless char_count > 100
  end
end
