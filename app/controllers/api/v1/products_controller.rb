# frozen_string_literal: true

class Api::V1::ProductsController < ApplicationController
  include Pagy::Backend

  devise_group :shop_and_user, contains: %i[shop user]

  # devise group
  before_action :authenticate_shop_and_user!, only: %i[index show]
  before_action :authenticate_shop!, only: %i[create update destroy]
  before_action :set_product, only: %i[show update destroy]
  before_action :authorize_shop, only: %i[create update destroy]

  # GET /api/v1/products
  # GET /api/v1/products.json
  def index
    @meta, @products = pagy(policy_scope(Product))
  end

  # GET /api/v1/products/1
  # GET /api/v1/products/1.json
  def show
  end

  # POST /api/v1/products
  # POST /api/v1/products.json
  def create
    @product = current_shop.products.new(product_params)

    render_model_errors(@post) unless @post.save
  end

  # PATCH/PUT /api/v1/products/1
  # PATCH/PUT /api/v1/products/1.json
  def update
    if @product.update(product_params)
      render_success(I18n.t('updated', resource: 'Product'))
    else
      render_model_errors(@product)
    end
  end

  # DELETE /api/v1/products/1
  # DELETE /api/v1/products/1.json
  def destroy
    @product.destroy!
  end

  private

  def authorize_shop
    authorize @product
  end

  def set_product
    @product = Product.find_by(id: params[:id])

    raise_if_blank(@product, 'Product')
  end

  def product_params
    params.require(:product).permit(:name, :description, :price, :cover, images: [])
  end
end
