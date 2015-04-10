# encoding: utf-8
class DashboardController < ApplicationController
  before_action :authenticate_user!

  def default_url_options(options={})
    { route: current_account ? current_account.subdomain : nil }
  end

end