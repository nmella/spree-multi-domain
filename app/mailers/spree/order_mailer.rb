module Spree
  class OrderMailer < BaseMailer
    def confirm_email(order, resend = false)
      @order = order.respond_to?(:id) ? order : Spree::Order.find(order)
      subject = (resend ? "[#{Spree.t(:resend).upcase}] " : '')
      subject += "#{@order.store.name} #{Spree.t('order_mailer.confirm_email.subject')} ##{@order.number}"
      mail_params = { to: @order.email, subject: subject }
      mail_params[:from] = if @order.store.present? && @order.store.mail_from_address.present?
                             @order.store.mail_from_address
                           else
                             Spree::Store.default.mail_from_address
                           end
      mail(mail_params)
    end

    def cancel_email(order, resend = false)
      @order = order.respond_to?(:id) ? order : Spree::Order.find(order)
      subject = (resend ? "[#{Spree.t(:resend).upcase}] " : '')
      subject += "#{@order.store.name} #{Spree.t('order_mailer.cancel_email.subject')} ##{@order.number}"
      mail_params = { to: @order.email, subject: subject }
      mail_params[:from] = if @order.store.present? && @order.store.mail_from_address.present?
                             @order.store.mail_from_address
                           else
                             Spree::Store.default.mail_from_address
                           end
      mail(mail_params)
    end

    def store_owner_notification_email(order)
      @order = order.respond_to?(:id) ? order : Spree::Order.find(order)
      current_store = @order.store
      subject = Spree.t('order_mailer.store_owner_notification_email.subject', store_name: current_store.name)
      mail(to: current_store.new_order_notifications_email, from: from_address, subject: subject, store_url: current_store.url)
    end
  end
end
