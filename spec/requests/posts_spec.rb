require 'rails_helper'

describe 'Posts API', type: :request do

    let(:user) { FactoryBot.create(:user ,name: "Test User",email:"testuser@example.com",password: "password",password_confirmation:"password") }
    let(:user2) { FactoryBot.create(:user ,name: "Test User 2",email:"testuser2@example.com",password: "password",password_confirmation:"password") }
    let(:tag1) { FactoryBot.create(:tag, name: "tag1") }
    let(:tag2) { FactoryBot.create(:tag, name: "tag2") }
    let(:post_instance) { FactoryBot.create(:post, title: "test", body: "test", author: user, tags: [tag1]) }

    before do
        post '/login', params: { email: user.email, password: user.password }
        token = JSON.parse(response.body)['token']
        @headers = { 'Authorization' => "Bearer #{token}" }
        post '/login', params: { email: user2.email, password: user2.password }
        token2 = JSON.parse(response.body)['token']
        @headers2 = { 'Authorization' => "Bearer #{token2}" }
      end
    

      it 'creates a new post' do
        post '/posts', params: { post: {title:"test",body:"test"},tags: ["tag1", "tag2", "tag3"] }, headers: @headers
        expect(response).to have_http_status(:created)
        json_response = JSON.parse(response.body)
        puts "Test 7 result is: #{json_response}"
      end

      it 'creates a new post without authentication' do
        post '/posts', params: { post: {title:"test",body:"test"},tags: ["tag1", "tag2", "tag3"] }, headers: []
        expect(response).to have_http_status(:unauthorized)
        json_response = JSON.parse(response.body)
        puts "Test 8 result is: #{json_response}"

      end

      it 'creates a post without tag' do
        post '/posts', params: { post: {title:"test",body:"test"} }, headers: @headers
        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        puts "Test 9 result is: #{json_response}"

      end


      it 'updates a post and its tags' do
        put "/posts/#{post_instance.id}", params: { post: { title: "updated test", body: "updated test" }, tags: ["tag2"] }, headers: @headers
        expect(response).to have_http_status(:ok)
        post_instance.reload
        expect(post_instance.title).to eq("updated test")
        expect(post_instance.body).to eq("updated test")
        expect(post_instance.tags.map(&:name)).to include("tag2")
        json_response = JSON.parse(response.body)
        puts "Test 10 result is: #{json_response}"
      end

      it 'Unauthorized user updates a post and its tags' do
        put "/posts/#{post_instance.id}", params: { post: { title: "updated test", body: "updated test" }, tags: ["tag2"] }, headers: @headers2
        expect(response).to have_http_status(:unauthorized)
        json_response = JSON.parse(response.body)
        puts "Test 11 result is: #{json_response}"
      end


    describe 'DELETE /posts/:id' do
        it 'deletes the post' do
          delete "/posts/#{post_instance.id}", headers: @headers
          expect(response).to have_http_status(:no_content)
          puts "Test 12 result is: Post Deleted"
        end

        it 'Unauthorized user deletes the post' do
          delete "/posts/#{post_instance.id}", headers: @headers2
          expect(response).to have_http_status(:unauthorized)
          json_response = JSON.parse(response.body)
          puts "Test 13 result is: #{json_response}"
        end
      end
      

      it 'enqueues a deletion job after creation' do
        Sidekiq::Testing.fake! do
          post = Post.create(title: 'Test Title', body: 'Test Body', author: user, tags: [tag1])
          expect(DeletePostWorkerJob).to have_enqueued_sidekiq_job(post.id).in(24.hours)
        end
      end
end

    