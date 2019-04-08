module Flexite
  module WithPath
    extend ActiveSupport::Concern

    included do
      before_save :assign_path

      serialize :path
    end

    private

    def assign_path
      self.path = (parent.present? ? parent.path << name : [name])
    end
  end
end
