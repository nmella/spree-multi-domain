module Spree
  module HomeControllerDecorator
    def index
      # @searcher = build_searcher(params)
      # @products = @searcher.retrieve_products
      # @taxonomies = get_taxonomies
      super # Fix for home page performance
    end

    def subscription
      list_key = request.format.html? ? params[:list_key] : current_store&.lists&.default&.take&.key

      if list_key && params[:email]
        api_response = Sendy::Client.new.subscribe(list_key, params[:email])
        @response, @message = api_response ? [:success, Spree.t(:successfully_subscribed, scope: :list)] : [:error, Spree.t(:something_went_wrong, scope: :list)]
      else
        @response = :error
        @message = Spree.t(:email_or_list_id_not_exists, scope: :list)
      end

      respond_to do |format|
        format.html do
          flash[@response] = @message
          redirect_to account_path
        end

        format.js
      end
    end

    def unsubscription
      if params[:list_key] && params[:email]
        api_response = Sendy::Client.new.unsubcribe(params[:list_key], params[:email])
        response, message = api_response ? [:success, Spree.t(:successfully_unsubscribed, scope: :list)] : [:error, Spree.t(:something_went_wrong, scope: :list)]
      else
        response = :error
        message = Spree.t(:email_or_list_id_not_exists, scope: :list)
      end

      flash[response] = message
      redirect_to account_path
    end

    def subcription_status
      list_key = Spree::List.find_by(id: params[:id]).key
      email = spree_current_user.email

      if list_key && email
        response = Sendy::Client.new.subscription_status(list_key, email)
        data = [response, params[:id]]
        respond_to do |format|
          format.json { render json: data.to_json }
        end
      else
        flash[:error] = Spree.t(:email_or_list_id_not_exists, scope: :list)
      end
    end
  end
end

::Spree::HomeController.prepend(Spree::HomeControllerDecorator)
