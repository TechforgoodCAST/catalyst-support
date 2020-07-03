class Admins::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
      @admin = Admin.from_omniauth(request.env['omniauth.auth'])

      if @admin.present? && @admin.persisted?
        flash[:notice] = I18n.t 'devise.omniauth_callbacks.success', kind: 'Google'
        sign_in_and_redirect @admin, event: :authentication
      else
        flash[:alert] = "You don't have an account"
        redirect_to root_path
      end
  end
end