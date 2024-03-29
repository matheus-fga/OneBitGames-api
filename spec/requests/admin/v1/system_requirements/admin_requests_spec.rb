require 'rails_helper'

RSpec.describe "Admin::V1::SystemRequirements as :admin", type: :request do
  let(:user) { create(:user) }

  context "GET /system_requirements" do
    let(:url) { "/admin/v1/system_requirements" }
    let!(:system_requirements) { create_list(:system_requirement, 5) }

    it "returns all system requirements" do
      get url, headers: auth_header(user)
      expect(body_json['system_requirements']).to contain_exactly *system_requirements.as_json(
        only: %i(id name operational_system storage processor memory video_board)
      )
    end

    it "returns success status" do
      get url, headers: auth_header(user)
      expect(response).to have_http_status(:ok)
    end
  end

  context "POST /system_requirements" do
    let(:url) { "/admin/v1/system_requirements" }

    context "with valid params" do
      let(:system_requirement_params) { { system_requirement: attributes_for(:system_requirement) }.to_json }

      it "adds a new SystemRequirement" do
        expect do
          post url, headers: auth_header(user), params: system_requirement_params
        end.to change(SystemRequirement, :count).by(1)
      end

      it "returns last added SystemRequirement" do
        post url, headers: auth_header(user), params: system_requirement_params
        expected_system_requirement = SystemRequirement.last.as_json(
          only: %i(id name operational_system storage processor memory video_board)
        )
        expect(body_json['system_requirement']).to eq(expected_system_requirement)
      end

      it "returns success status" do
        post url, headers: auth_header(user), params: system_requirement_params
        expect(response).to have_http_status(:ok)
      end
    end

    context "with invalid params" do
      let(:invalid_system_requirement_params) do
        { system_requirement: attributes_for(:system_requirement, name: nil) }.to_json
      end

      it "does not add a new SystemRequirement" do
        expect do
          post url, headers: auth_header(user), params: invalid_system_requirement_params
        end.to_not change(SystemRequirement, :count)
      end

      it "returns error message" do
        post url, headers: auth_header(user), params: invalid_system_requirement_params
        expect(body_json['errors']['fields']).to have_key('name')
      end

      it "returns unprocessable_entity status" do
        post url, headers: auth_header(user), params: invalid_system_requirement_params
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  context "PATCH /system_requirements/:id" do
    let(:system_requirement) { create(:system_requirement) }
    let(:url) { "/admin/v1/system_requirements/#{system_requirement.id}" }

    context "with valid params" do
      let(:new_name) { 'My New System Requirement' }
      let(:system_requirement_params) do 
        { system_requirement: attributes_for(:system_requirement, name: new_name) }.to_json
      end

      it "should updates the system requirement" do
        patch url, headers: auth_header(user), params: system_requirement_params
        system_requirement.reload
        expect(system_requirement.name).to eq new_name
      end

      it "should return the updated system requirement" do
        patch url, headers: auth_header(user), params: system_requirement_params
        system_requirement.reload
        expected_system_requirement = system_requirement.as_json(
          only: %i(id name operational_system storage processor memory video_board)
        )
        expect(body_json['system_requirement']).to eq expected_system_requirement
      end

      it "should return success status" do
        patch url, headers: auth_header(user), params: system_requirement_params
        expect(response).to have_http_status(:ok)
      end
    end

    context "with invalid params" do
      let(:invalid_system_requirement_params) do
        { system_requirement: attributes_for(:system_requirement, name: nil) }.to_json
      end

      it "should not updates the system requirement" do
        old_name = system_requirement.name
        patch url, headers: auth_header(user), params: invalid_system_requirement_params
        system_requirement.reload
        expect(system_requirement.name).to eq old_name
      end

      it "should return an error message" do
        patch url, headers: auth_header(user), params: invalid_system_requirement_params
        expect(body_json['errors']['fields']).to have_key('name')
      end

      it "should return unprocessable_entity status" do
        patch url, headers: auth_header(user), params: invalid_system_requirement_params
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
  
  context "DELETE /system_requirements/:id" do
    let!(:system_requirement) { create(:system_requirement) }
    let(:url) { "/admin/v1/system_requirements/#{system_requirement.id}" }

    context "without games associated" do
      it "should remove the system requirement" do
        expect do
          delete url, headers: auth_header(user)
        end.to change(SystemRequirement, :count).by(-1)
      end
  
      it "should not return any body content" do
        delete url, headers: auth_header(user)
        expect(body_json).to_not be_present
      end
  
      it "should return success status" do
        delete url, headers: auth_header(user)
        expect(response).to have_http_status(:no_content)
      end
    end

    context "with games associated" do
      before(:each) do
        create_list(:game, 3, system_requirement: system_requirement)
      end

      it "should not remove the system requirement" do
        expect do  
          delete url, headers: auth_header(user)
        end.to_not change(SystemRequirement, :count)
      end

      it "should return an error" do
        delete url, headers: auth_header(user)
        expect(body_json['errors']['fields']).to have_key('base')
      end
    end
  end
end