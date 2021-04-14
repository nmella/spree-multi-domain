module Spree
  module Admin
    module ProductsControllerDecorator
      def self.prepended(base)
        base.before_action :find_stores, only: [:update]
      end

      private

      def find_stores
        params[:product][:store_ids] = params[:product][:store_ids].reject(&:empty?) if params[:product][:store_ids].present?
      end
    end
  end
end

::Spree::Admin::ProductsController.prepend(Spree::Admin::ProductsControllerDecorator)
