require 'rails_helper'

describe 'Tags API', type: :request do
  let(:user) { FactoryBot.create(:user ,name: "Test User",email:"testuser@example.com",password: "password",password_confirmation:"password") }
  let(:user2) { FactoryBot.create(:user ,name: "Test User2",email:"testuser2@example.com",password: "password",password_confirmation:"password") }
  let(:tag1) { FactoryBot.create(:tag, name: "tag1") }
  let(:tag2) { FactoryBot.create(:tag, name: "tag2") }
  let(:tag3) { FactoryBot.create(:tag, name: "tag3") }
  let(:post_instance) { FactoryBot.create(:post, title: "test", body: "test", author: user, tags: [tag1]) }

  before do
    post '/login', params: { email: user.email, password: user.password }
    token = JSON.parse(response.body)['token']
    @headers = { 'Authorization' => "Bearer #{token}" }
    post '/login', params: { email: user2.email, password: user2.password }
    token2 = JSON.parse(response.body)['token']
    @headers2 = { 'Authorization' => "Bearer #{token2}" }
  end

  it 'updates the tags of a post' do
    patch "/posts/#{post_instance.id}/tags/update_post_tags", params: { tag_ids: [tag3.id] }, headers: @headers
    expect(response).to have_http_status(:ok)
    json_response = JSON.parse(response.body)
    puts "Test 20 result is: #{json_response}"
  end


  it 'Unauthorized updates the tags of a post' do
    patch "/posts/#{post_instance.id}/tags/update_post_tags", params: { tag_ids: [tag1.id] }, headers: @headers2
    expect(response).to have_http_status(:unauthorized)
    json_response = JSON.parse(response.body)
    puts "Test 21 result is: #{json_response}"
  end

end
