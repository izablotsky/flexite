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
          if changes.try(:[], 'class') == 'Flexite::Config'
            html << display_configs(changes)
          elsif changes.try(:[], 'class') == 'Flexite::ArrEntry'
            html << display_entries(changes['entries'])
          end
        end.html_safe
      end
    end

    private

    def display_configs(changes, indent = 0)
      content_tag(:div, style: "margin: #{10 * indent}px 0 0 #{10*indent}px;") do
        ''.tap do |html|
          html << content_tag(:div) do
            concat(label_tag('Node name:'))
            concat(changes['name'])
          end.html_safe

          html << content_tag(:div) do
            concat(label_tag('Node description:'))
            concat(changes['description'])
          end.html_safe

          html << content_tag(:div) do
            if changes['entry'].present?
              concat(label_tag('Value:'))
              concat(display_entry(changes['entry']))
            elsif changes['configs'].present?
              changes['configs'].map do |config|
                display_configs(config, indent.next)
              end.join.html_safe
            end
          end.html_safe
        end.html_safe
      end
    end

    def display_entry(entry)
      entry.try(:[], 'value')
    end

    def display_entries(entries)
      entries.map { |e| e.to_h['value'] }.join(', ')
    end
  end
end
