module Flexite
  class Diff < ActiveRecord::Base
    serialize :hash_changes
    serialize :path
  end
end
