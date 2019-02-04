module Flexite
  class Entry < ActiveRecord::Base
    include WithHistory

    attr_accessor :locked

    attr_accessible :value, :to_delete
    history_attributes :value, :updated_by

    belongs_to :parent, polymorphic: true, touch: true
    has_many :histories, as: :entity, dependent: :destroy

    scope :order_by_value, -> { order(:value) }

    before_save :check_value, :cast_value

    delegate :locked, to: :parent, allow_nil: true

    def self.form(attributes = {})
      Form.new(attributes)
    end

    def self.service(type)
      "entry_#{type}".to_sym
    end

    def attributes
      super.tap do |hash|
        hash[:locked] = locked
      end
    end

    alias form_attributes attributes

    def t_node
      Hash.new.tap do |node|
        node['value'] = self[:value]
        node['type']  = I18n.t("models.#{self.class.name.demodulize.underscore}")
        node['class'] = self.class.name
      end
    end

    def dig(level)
      send(level)
    end

    private

    def cast_value
      self[:value] = self[:value].to_s
    end

    def check_value
    end
  end
end
