class ChargesController < ApplicationController
  def new
  end

  def create
    # Amount in cents
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

    current_user.role = 'premium'
    current_user.save!
    redirect_to edit_user_registration_path

  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to new_charge_path
  end

  def destroy
    customer = Stripe::Customer.retrieve(current_user.stripe_id)
    if customer.delete
      flash[:notice] = "\"#{current_user.email}\" was downgraded to standard successfully."
      current_user.role = 'standard'
      current_user.save!

      wikis = current_user.wikis
      wikis.each do |wiki|
        if wiki.private
          wiki.private = false
          wiki.save!
        end
      end

      redirect_to new_charge_path
    else
      flash.now[:alert] = "There was an error downgrading the user."
      redirect_to new_charge_path
    end
  end

end
