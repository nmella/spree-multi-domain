module Spree
  module Api
    module TaxonomyHelper
      def get_taxonomies
        # Override method as dont need store specific
        # @taxonomies ||= current_store.present? ? Spree::Taxonomy.by_store(current_store) : Spree::Taxonomy
        @taxonomies ||= Spree::Taxonomy
        @taxonomies = @taxonomies.includes(root: :children)
        @taxonomies
      end
    end
  end
end
