class OpenidController < ApplicationController
  
  skip_before_filter :verify_authenticity_token
  
  def create
    session[:location] = params[:user][:location] if params[:user]
    authenticate_with_open_id(nil, :optional => [:nickname, :postcode]) do |result, openid_identity, registration|
      if result.successful?
        user = User.find_or_create_by_openid(openid_identity,
                                             registration,
                                             {:location => session[:location]})
        if user.save
          session[:user_id] = user.id
          redirect_to purchases_path
        else
          flash[:warning] = 'Please enter your location so we can find stores near you.'
          redirect_to new_user_path(:user => { 
            :openid_identity => openid_identity 
          })
        end 
      else
        flash[:warning] = result.message
        redirect_to new_session_path
      end 
    end 
  end
end
