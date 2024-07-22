require 'rails_helper'

describe 'Users API', type: :request do
    describe 'Valid Sign up' do
        it 'Register a new valid user' do
            expect{
            post '/signup', params: {user:{
             name: "rspec t1",
             email: "rspect1@gmail.com",
             password: "rspect1",
             password_confirmation: "rspect1",
             image: fixture_file_upload(Rails.root.join('spec', 'fixtures', 'files', 'test_image.png'), 'image/png')
            }} 
        }.to change {User.count}.from(0).to(1)
            expect(response).to have_http_status(:created) 
            user = User.find_by(email: "rspect1@gmail.com")
            expect(user.image).to be_attached
            json_response = JSON.parse(response.body)
            expect(json_response).to have_key('token')
            puts "Test 1 result is: #{json_response}"     
        end

    end
    
    describe "Invalid Signup" do
        it 'Register a new user with mismatch passwords' do
            post '/signup', params: {user:{
             name: "rspec t1",
             email: "rspect1@gmail.com",
             password: "rspect1",
             password_confirmation: "rspect2"
            }} 
            expect(response).to have_http_status(:unprocessable_entity) 
            json_response = JSON.parse(response.body)
            puts "Test 2 result is: #{json_response}"
            
        end
        it 'Register a new user with already existing email' do
            user= FactoryBot.create(:user ,name: "Test User",email:"testuser@example.com",password: "password",password_confirmation:"password")
            post '/signup', params: {user:{
             name: "rspec t1",
             email: user.email,
             password: "rspect1",
             password_confirmation: "rspect1"
            }} 
            expect(response).to have_http_status(:unprocessable_entity) 
            json_response = JSON.parse(response.body)
            puts "Test 3 result is: #{json_response}"
            
        end
    end


    describe 'Login' do
        let(:user) { FactoryBot.create(:user ,name: "Test User",email:"testuser@example.com",password: "password",password_confirmation:"password",image: fixture_file_upload(Rails.root.join('spec', 'fixtures', 'files', 'test_image.png'), 'image/png')
        ) }
        it 'Successful login and session creation' do
          post '/login', params: { email: user.email, password: user.password }
          expect(response).to have_http_status(:created)
          json_response = JSON.parse(response.body)
          expect(json_response).to have_key('token')
          puts "Test 4 result is: #{json_response}"
        end

        it 'Invalid Email' do
            post '/login', params: { email: "invalid@example.com", password: user.password }
            expect(response).to have_http_status(:unauthorized)
            json_response = JSON.parse(response.body)
            puts "Test 5 result is: #{json_response}"
          end

          it 'Invalid Password' do
            post '/login', params: { email: user.email, password: "invalidPass" }
            expect(response).to have_http_status(:unauthorized)
            json_response = JSON.parse(response.body)
            puts "Test 6 result is: #{json_response}"
          end
      end
end