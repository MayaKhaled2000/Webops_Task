# spec/workers/delete_post_worker_job_spec.rb
require 'rails_helper'

RSpec.describe DeletePostWorkerJob, type: :worker do
  let(:user) { FactoryBot.create(:user) }
  let(:tag) { FactoryBot.create(:tag) }
  let!(:post) { FactoryBot.create(:post, title: 'Test Title', body: 'Test Body', author: user, tags: [tag]) }

  it 'deletes the post' do
    Sidekiq::Testing.inline! do
      expect {
        DeletePostWorkerJob.perform_async(post.id)
        DeletePostWorkerJob.drain
      }.to change { Post.count }.by(-1)
      puts "Test 22 result is: successful deletion scheduled"
    end
  end
end
