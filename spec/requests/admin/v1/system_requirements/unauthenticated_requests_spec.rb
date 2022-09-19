require 'rails_helper'

RSpec.describe "Admin::V1::SystemRequirements without authentication", type: :request do

  context "GET /categories" do
    let(:url ) { "/admin/v1/system_requirements" }

    before(:each) { get url }

    include_examples "unauthenticated access"
  end

  context "POST /categories" do
    let(:url ) { "/admin/v1/system_requirements" }

    before(:each) { post url }

    include_examples "unauthenticated access"
  end

  context "PATCH /categories/:id" do
    let(:system_requirement) { create(:system_requirement) }
    let(:url) { "/admin/v1/system_requirements/#{system_requirement.id}" }

    before(:each) { patch url }

    include_examples "unauthenticated access"
  end

  context "DELETE /categories/:id" do
    let(:system_requirement) { create(:system_requirement) }
    let(:url) { "/admin/v1/system_requirements/#{system_requirement.id}" }

    before(:each) { delete url }

    include_examples "unauthenticated access"
  end
end 