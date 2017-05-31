class ChargesController < ApplicationController
  def new
    @stripe_btn_data = {
      key: "#{ Rails.configuration.stripe[:publishable_key] }",
      description: "Blocipedia Membership - #{current_user.email}",
      amount: @amount
    }
  end

  def create
    @amount = 1500

    customer = Stripe::Customer.create(
      :email => params[:stripeEmail],
      :source  => params[:stripeToken]
    )

    charge = Stripe::Charge.create(
      :customer    => customer.id,
      :amount      => @amount,
      :description => 'Rails Stripe customer',
      :currency    => 'usd'
    )

    flash[:success] = "Thanks for upgrading, #{current_user.email}!"
    current_user.update_attribute(:role, 'premium')
    redirect_to edit_user_registration_path

#    Stripe::Subscription.create(
#      :customer => customer.id,
#      :plan => "premium",
#    )

#    current_user.set_attribute(:role, 'premium')

    rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to new_charge_path
  end
end
