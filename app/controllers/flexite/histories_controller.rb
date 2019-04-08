require_dependency 'flexite/application_controller'

module Flexite
  class HistoriesController < ApplicationController
    def index
      @histories = History
        .includes(:history_attributes)
        .where(entity_id: params[:entity_id], entity_type: params[:entity_type].camelize)
    end

    def restore
      History.includes(:history_attributes).find(params[:history_id]).restore
      flash[:success] = 'Entity was restored from history'
    end

    def recent_changes
      @histories = History.all.group_by(&:entity_type)
      @entries   = @histories[Flexite::Entry.model_name]
      @configs   = @histories[Flexite::Config.model_name]
    end
  end
end
