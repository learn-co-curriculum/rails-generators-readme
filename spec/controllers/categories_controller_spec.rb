require 'rails_helper'

RSpec.describe CategoriesController, type: :controller do

  describe "GET #show" do
    it "returns http success" do
      category = Category.create(name: 'category')

      get :show, id: category.id

      expect(response).to have_http_status(:success)
    end
  end

end
