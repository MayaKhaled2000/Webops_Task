require 'rails_helper'

describe 'Comments API', type: :request do

  let(:user) { FactoryBot.create(:user ,name: "Test User",email:"testuser@example.com",password: "password",password_confirmation:"password") }
  let(:user2) { FactoryBot.create(:user ,name: "Test User2",email:"testuser2@example.com",password: "password",password_confirmation:"password") }
  let(:tag1) { FactoryBot.create(:tag, name: "tag1") }
  let(:tag2) { FactoryBot.create(:tag, name: "tag2") }
  let(:post_instance) { FactoryBot.create(:post, title: "test", body: "test", author: user, tags: [tag1]) }
  let(:comment_instance) { FactoryBot.create(:comment,body:"test",user: user,post: post_instance) }


  before do
    post '/login', params: { email: user.email, password: user.password }
    token = JSON.parse(response.body)['token']
    @headers = { 'Authorization' => "Bearer #{token}" }
    post '/login', params: { email: user2.email, password: user2.password }
    token2 = JSON.parse(response.body)['token']
    @headers2 = { 'Authorization' => "Bearer #{token2}" }
  end

  describe 'POST /posts/:post_id/comments' do
    it 'creates a comment' do
      expect{
        post "/posts/#{post_instance.id}/comments", params: { comment: { body: "Test"} }, headers: @headers
    }.to change {Comment.count}.from(0).to(1)
      expect(response).to have_http_status(:created)
      json_response = JSON.parse(response.body)
      puts "Test 14 result is: #{json_response}"
    end

    it 'creates a comment' do
      expect{
        post "/posts/#{post_instance.id}/comments", params: { comment: { body: "Test"} }, headers: @headers2
    }.to change {Comment.count}.from(0).to(1)
      expect(response).to have_http_status(:created)
      json_response = JSON.parse(response.body)
      puts "Test 15 result is: #{json_response}"
    end

  end


    it 'Update a comment' do
          put "/posts/#{post_instance.id}/comments/#{comment_instance.id}", params:{comment: { body: "comment updated"} } ,headers: @headers
          expect(response).to have_http_status(:ok) 
          json_response = JSON.parse(response.body)
          puts "Test 16 result is: #{json_response}"        
    end

    it 'Unauthorized update a comment' do
      put "/posts/#{post_instance.id}/comments/#{comment_instance.id}", params:{comment: { body: "comment updated"} } ,headers: @headers2
      expect(response).to have_http_status(:unauthorized) 
      json_response = JSON.parse(response.body)
      puts "Test 17 result is: #{json_response}"        
    end


    it 'Delete a comment' do

          delete "/posts/#{post_instance.id}/comments/#{comment_instance.id}", headers: @headers 
          expect(response).to have_http_status(:no_content) 
          puts "Test 18 result is: Post deleted"
    end

    it 'Unauthorized delete a comment' do

      delete "/posts/#{post_instance.id}/comments/#{comment_instance.id}", headers: @headers2 
      expect(response).to have_http_status(:unauthorized) 
      json_response = JSON.parse(response.body)
      puts "Test 19 result is: #{json_response}"
    end
end
    