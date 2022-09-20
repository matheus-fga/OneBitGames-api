require 'rails_helper'

RSpec.describe "Admin::V1::Users as :admin", type: :request do
  let!(:logged_user) { create(:user) }

  context "GET /users" do
    let(:url) { "/admin/v1/users" }
    let!(:users) { create_list(:user, 5) }

    it "should return all users" do
      get url, headers: auth_header(logged_user)
      users.push(logged_user)
      expect(body_json['users']).to contain_exactly *users.as_json(
        only: %i(id name email profile)
      )
    end

    it "should return success status" do
      get url, headers: auth_header(logged_user)
      expect(response).to have_http_status(:ok)
    end
  end

  context "POST /users" do
    let(:url) { "/admin/v1/users" }

    context "with valid params" do
      let(:user_params) { { user: attributes_for(:user) }.to_json }

      it "should add a new user" do
        expect do
          post url, headers: auth_header(logged_user), params: user_params
        end.to change(User, :count).by(1)
      end

      it "should return last added user" do
        post url, headers: auth_header(logged_user), params: user_params
        expected_user = User.last.as_json(
          only: %i(id name email profile)
        )
        expect(body_json['user']).to eq expected_user
      end

      it "should return success status" do
        post url, headers: auth_header(logged_user), params: user_params
        expect(response).to have_http_status(:ok)
      end
    end

    context "with invalid params" do
      let(:invalid_user_params) do
        { user: attributes_for(:user, name: nil) }.to_json
      end

      it "should not add a new user" do
        expect do
          post url, headers: auth_header(logged_user), params: invalid_user_params
        end.to_not change(User, :count)
      end

      it "should return error message" do
        post url, headers: auth_header(logged_user), params: invalid_user_params
        expect(body_json['errors']['fields']).to have_key('name')
      end

      it "should return unprocessable_entity status" do
        post url, headers: auth_header(logged_user), params: invalid_user_params
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  context "PATCH /users/:id" do
    let(:user) { create(:user) }
    let(:url) { "/admin/v1/users/#{user.id}" }

    context "with valid params" do
      let(:new_name) { 'My New name' }
      let(:user_params) do 
        { user: { name: new_name } }.to_json
      end

      it "should update the user" do
        patch url, headers: auth_header(logged_user), params: user_params
        user.reload
        expect(user.name).to eq new_name
      end

      it "should return the updated user" do
        patch url, headers: auth_header(logged_user), params: user_params
        user.reload
        expected_user = user.as_json(
          only: %i(id name email profile)
        )
        expect(body_json['user']).to eq expected_user
      end

      it "should return success status" do
        patch url, headers: auth_header(logged_user), params: user_params
        expect(response).to have_http_status(:ok)
      end
    end

    context "with invalid params" do
      let(:invalid_user_params) do
        { user: attributes_for(:user, name: nil) }.to_json
      end

      it "should not updates the user" do
        old_name = user.name
        patch url, headers: auth_header(logged_user), params: invalid_user_params
        user.reload
        expect(user.name).to eq old_name
      end

      it "should return an error message" do
        patch url, headers: auth_header(logged_user), params: invalid_user_params
        expect(body_json['errors']['fields']).to have_key('name')
      end

      it "should return unprocessable_entity status" do
        patch url, headers: auth_header(logged_user), params: invalid_user_params
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  context "DELETE /users/:id" do
    let!(:user) { create(:user) }
    let(:url) { "/admin/v1/users/#{user.id}" }

    it "should remove the user" do
      expect do
        delete url, headers: auth_header(logged_user)
      end.to change(User, :count).by(-1)
    end

    it "should not return any body content" do
      delete url, headers: auth_header(logged_user)
      expect(body_json).to_not be_present
    end

    it "should return success status" do
      delete url, headers: auth_header(logged_user)
      expect(response).to have_http_status(:no_content)
    end
    
  end
end