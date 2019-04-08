module Flexite
  class HistoryPresenter < SimpleDelegator
    def initialize(object, template)
      @object = object
      super(template)

      history.history_attributes.each do |attribute|
        define_singleton_method(attribute.name) do
           return attribute.value unless boolean?(attribute.name)

           cast(attribute.value)
        end
      end
    end

    def path
      history.entity.path.join(' -> ')
    end

    private

    def cast(value)
      !value.to_i.zero?
    end

    def history
      @object
    end

    def boolean?(field)
      history.entity.is_a?(Flexite::BoolEntry) && field =~ /value/
    end
  end
end
