require 'rails_helper'

RSpec.describe "Admin::V1::Coupons as :admin", type: :request do
  let(:user) { create(:user) }

  context "GET /coupons" do
    let(:url) { "/admin/v1/coupons" }
    let!(:coupons) { create_list(:coupon, 5) }

    it "should return all coupons" do
      get url, headers: auth_header(user)
      expect(body_json['coupons']).to contain_exactly *coupons.as_json(
        only: %i(id name code status discount_value max_use due_date)
      )
    end

    it "should return success status" do
      get url, headers: auth_header(user)
      expect(response).to have_http_status(:ok)
    end
  end

  context "POST /coupons" do
    let(:url) { "/admin/v1/coupons" }

    context "with valid params" do
      let(:coupon_params) { { coupon: attributes_for(:coupon) }.to_json }

      it "should add a new coupon" do
        expect do
          post url, headers: auth_header(user), params: coupon_params
        end.to change(Coupon, :count).by(1)
      end

      it "should return last added coupon" do
        post url, headers: auth_header(user), params: coupon_params
        expected_coupon = Coupon.last.as_json(
          only: %i(id name code status discount_value max_use due_date)
        )
        expect(body_json['coupon']).to eq expected_coupon
      end

      it "should return success status" do
        post url, headers: auth_header(user), params: coupon_params
        expect(response).to have_http_status(:ok)
      end
    end

    context "with invalid params" do
      let(:invalid_coupon_params) do
        { coupon: attributes_for(:coupon, name: nil) }.to_json
      end

      it "should not add a new coupon" do
        expect do
          post url, headers: auth_header(user), params: invalid_coupon_params
        end.to_not change(Coupon, :count)
      end

      it "should return error message" do
        post url, headers: auth_header(user), params: invalid_coupon_params
        expect(body_json['errors']['fields']).to have_key('name')
      end

      it "should return unprocessable_entity status" do
        post url, headers: auth_header(user), params: invalid_coupon_params
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
