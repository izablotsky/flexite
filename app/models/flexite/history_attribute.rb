module Flexite
  class HistoryAttribute < ActiveRecord::Base
    attr_accessible :name, :value, :updated_by
    belongs_to :history
  end
end
