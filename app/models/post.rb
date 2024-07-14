class Post < ApplicationRecord
  belongs_to :author, class_name: 'User', foreign_key: 'user_id'
  has_and_belongs_to_many :tags
  has_many :comments, dependent: :destroy

  validates :title, presence: true
  validates :body, presence: true
  validate :must_have_at_least_one_tag

  after_create :schedule_deletion

  private

  def must_have_at_least_one_tag
    errors.add(:tags, 'must have at least one tag') if tags.empty?
  end

  def schedule_deletion
    DeletePostWorkerJob.perform_in(24.hours, id)
  end
end
