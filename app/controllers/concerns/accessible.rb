# frozen_string_literal: true

# For devise user sign out conflict 
module Accessible
  extend ActiveSupport::Concern
  included do
    before_action :check_user
  end

  protected

  def check_user
    if current_user
      flash.clear
      # if you have rails_admin. You can redirect anywhere really
      redirect_to(authenticated_root_path) && return
    elsif current_company
      flash.clear
      # The authenticated root path can be defined in your routes.rb in: devise_scope :user do...
      redirect_to(companies_dashboards_index_path) && return
    end
  end
end
