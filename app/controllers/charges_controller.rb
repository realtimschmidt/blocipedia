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

    Stripe::Subscription.create(
      :customer => customer.id,
      :plan     => "premium"
    )

    current_user.set_attribute(:role, 'premium')

  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to new_charge_path
  end

  def downgrade
    subscription = Stripe::Subscription.retrieve("sub_49ty4767H20z6a")
    subscription.plan = "standard"
    subscription.save
  end
end
