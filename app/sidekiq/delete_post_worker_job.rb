class DeletePostWorkerJob
  include Sidekiq::Job
  def perform(post_id)
    post = Post.find_by(id: post_id)
    return unless post

    if post.created_at < 24.hours.ago
      post.destroy
    else
      # Schedule the worker again after the remaining time
      DeletePostWorkerJob.perform_in(24.hours, post.id)
    end
  end
end
