require 'rails_helper'

RSpec.describe "Admin::V1::SystemRequirements as :client", type: :request do
  let(:user) { create(:user, profile: :client) }

  context "GET /categories" do
    let(:url ) { "/admin/v1/system_requirements" }

    before(:each) { get url, headers: auth_header(user) }

    include_examples "forbidden access"
  end

  context "POST /categories" do
    let(:url ) { "/admin/v1/system_requirements" }

    before(:each) { post url, headers: auth_header(user) }

    include_examples "forbidden access"
  end

  context "PATCH /categories/:id" do
    let(:system_requirement) { create(:system_requirement) }
    let(:url) { "/admin/v1/system_requirements/#{system_requirement.id}" }

    before(:each) { patch url, headers: auth_header(user) }

    include_examples "forbidden access"
  end

  context "DELETE /categories/:id" do
    let(:system_requirement) { create(:system_requirement) }
    let(:url) { "/admin/v1/system_requirements/#{system_requirement.id}" }

    before(:each) { delete url, headers: auth_header(user) }

    include_examples "forbidden access"
  end
end 