module Flexite
  class DiffPresenter < SimpleDelegator
    def initialize(object, template)
      @object = object
      super(template)
    end

    def path
      tree = Config.roots
      path = @object.path.each_with_object([]) do |value, result|
        next if tree.nil?

        if value.is_a?(Integer) && tree[value].present?
          result << tree[value]['name']
        end
        tree = tree.dig(value)
      end.join(' -> ')
      content_tag(:div, class: 'raw') { path }
    end

    def changes
      send("#{@object.change_type}_changes", @object.hash_changes)
    end

    private

    define_method('~_changes') do |changes|
      content_tag(:div) do
        concat(content_tag(:div, class: 'raw my-2') do
                 concat(label_tag('Current value:'))
                 concat(changes.first)
               end)
        concat(content_tag(:div, class: 'raw my-2') do
                 concat(label_tag('New value:'))
                 concat(changes.last)
               end)
      end
    end

    %w[- +].each do |symbol|
      define_method("#{symbol}_changes") do |changes|
        changes = changes.first
        ''.tap do |html|
          if changes&.class == 'Flexite::Config'
            html << display_configs(changes)
          elsif changes.try(:[], 'class') == 'Flexite::ArrEntry'
            html << display_entries(changes['entries'])
          end
        end
      end
    end

    private

    def display_configs(changes)
      concat content_tag(:div, class: 'row my-2') do
        concat label_tag('Node name:')
        concat changes[:name]
      end
      concat content_tag(:div, class: 'row my-2') do
        concat label_tag('Node description:')
        concat changes[:description]
      end
      if changes.respond_to(:[], 'entry')
        concat display_entry(changes['entry'])
      else
        concat display_configs(changes['configs'])
      end
    end

    def display_entry(entry)
      entry['value']
    end

    def present_array_entry(entries)
      entries.map { |entry| entry['value'] }
    end

    def display_entries(entries)
      entries.map { |e| e.to_h['value'] }.join(', ')
    end

    def present_base_entry(entry)
      content_tag(:div) do
        concat(content_tag(:div, class: 'raw') do
          concat(label_tag('Node name:'))
          concat(entry['name'])
        end)
        concat(content_tag(:div, class: 'raw') do
          concat(label_tag('Node description:'))
          concat(entry['description'])
        end)
        concat(content_tag(:div, class: 'raw') do
          concat(label_tag('Value:'))
          concat(entry['entry']['value'])
        end)
      end
    end
  end
end
