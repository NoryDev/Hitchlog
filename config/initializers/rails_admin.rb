RailsAdmin.config do |config| 
  config.authenticate_with { redirect_to root_path unless user_signed_in? and current_user.admin? }
end
