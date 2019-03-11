module Flexite
  class ArrEntry < Entry
    def value
      entries.select(%i[id value type]).map(&:value)
    end

    def entry=(entry)
      entries << entry
    end

    def form_attributes
      attributes.merge(entries: form_entries)
    end

    def self.form(attributes = {})
      Entry::ArrayForm.new(attributes)
    end

    def self.service(type)
      "arr_entry_#{type}".to_sym
    end

    def t_node
      node = super.except('value')
      node['entries'] = entries&.map(&:t_node)
      node
    end

    def dig(level)
      return super if level.to_sym != :entries

      send(level).order_by_value
    end

    private

    def form_entries
      entries.select(%i[id value type updated_at])
    end

    def cast_value
      # value should be blank
    end
  end
end
