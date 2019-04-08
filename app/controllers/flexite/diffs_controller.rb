require_dependency 'flexite/application_controller'

module Flexite
  class DiffsController < ApplicationController
    def apply
      result = ServiceFactory.instance.get(:apply_diff, params[:ids]).call
      service_flash(result) if result.flash.present?
      service_response(result)
    end

    def show
      @result = ServiceFactory.instance.get(:show_diff, params[:stage]).call
    end
  end
end
