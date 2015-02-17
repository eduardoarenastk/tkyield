class RegistrationsController < Devise::RegistrationsController
  add_breadcrumb "Dashboard", :root_path , :only => %w(edit update)
  private
 
  def sign_up_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
  end
 
  def account_update_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :current_password)
  end
end