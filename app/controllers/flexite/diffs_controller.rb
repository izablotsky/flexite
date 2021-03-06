require_dependency 'flexite/application_controller'

module Flexite
  class DiffsController < ApplicationController
    def check
      render json: ServiceFactory.instance.get("#{Flexite.config.diff_approach}_check_diff".to_sym,
                                               params[:tree], params[:token], params[:stage], params[:checksum]).call
    end

    def apply
      render json: ServiceFactory.instance.get(:apply_diff, params[:token], params[:stage], params[:checksum]).call
    end

    def push
      result = ServiceFactory.instance.get(:push_diff, params[:stage], params[:url]).call

      if result.flash.present?
        service_flash(result)
      end

      service_response(result)
    end

    def save_diff
      ServiceFactory.instance.get(:save_diff, params[:stage], params[:response]).call
    end

    def show
      result = ServiceFactory.instance.get("#{Flexite.config.diff_approach}_show_diff".to_sym, params[:stage], params[:url]).call

      if result.succeed?
        @data = result.data
        @stage = params[:stage]
        @url = params[:url]
      end

      if result.flash.present?
        service_flash(result)
      end

      service_response(result)
    end
  end
end
