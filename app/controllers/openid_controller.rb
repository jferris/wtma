class OpenidController < ApplicationController
  def create
    authenticate_with_open_id do |result, openid_identity, registration|
      if result.successful?
        user = User.find_or_create_by_openid(openid_identity, registration)
        if user.save
          session[:user_id] = user.id
          redirect_to new_purchase_path
        else
          redirect_to new_session_path
        end 
      else
        flash[:warning] = result.message
        redirect_to new_session_path
      end 
    end 
  end
end
