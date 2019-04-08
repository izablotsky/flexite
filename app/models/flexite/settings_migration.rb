module Flexite
  class SettingsMigration < ActiveRecord::Base
    attr_accessible :version
  end
end
