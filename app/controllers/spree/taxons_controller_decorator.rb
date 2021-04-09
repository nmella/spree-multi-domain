module Spree
  module TaxonsControllerDecorator
    def show
      @taxon = Spree::Taxon.friendly.find(params[:id])

      # Override method as dont need store specific
      # @taxon = Spree::Taxon.find_by_store_id_and_permalink!(current_store.id, params[:id])
      return unless @taxon

      @searcher = build_searcher(params.merge(taxon: @taxon.id))
      @products = @searcher.retrieve_products
      @vendor_filters, @brand_filters, @filterable_properties, @price_filters, @available_option_types = @searcher.retrieve_filters

      @taxonomies = get_taxonomies
    end
  end
end

::Spree::TaxonsController.prepend(Spree::TaxonsControllerDecorator)
