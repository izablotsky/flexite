module Flexite
  class Config < ActiveRecord::Base
    include WithHistory
    include WithPath

    attr_accessible :name, :selectable, :config_id, :description, :locked, :to_delete, :updated_by
    history_attributes :name, :name_was, :config_id, :description, :description_was, :updated_by, :updated_at

    delegate :value, to: :entry, allow_nil: true
    belongs_to :config, touch: true
    alias parent config
    alias :parent= :config=

    has_one :entry, as: :parent, dependent: :destroy
    has_many :configs, dependent: :destroy, order: "UPPER(name)"
    has_many :histories, as: :entity, dependent: :destroy

    scope :not_selectable, -> { select([:id, :name]).where(selectable: false) }
    scope :roots, -> { where(config_id: nil) }
    scope :order_by_name, -> { order("UPPER(#{table_name}.name)") }
    scope :all_configs, -> { includes(includes_hash) }

    before_create :set_description
    before_create :assign_depth

    def tv_node
      {
        id:           id,
        editHref:     Engine.routes.url_helpers.edit_config_path(self),
        selfHref:     Engine.routes.url_helpers.config_path(self),
        newHref:      Engine.routes.url_helpers.new_config_config_path(self),
        copyHref:     Engine.routes.url_helpers.copy_config_path(self),
        text:         name,
        dataHref:     selectable ? entry_href : configs_href,
        path:         path,
        nodes:        nodes,
        selectable:   true,
        ajaxOnSelect: selectable
      }
    end

    def nodes_count
      self[:nodes_count].to_i
    end

    def entry_id
      self[:entry_id]
    end

    def nodes
      return if selectable

      configs&.map(&:tv_node)
    end

    def self.t_nodes
      roots.includes(includes_hash, :entry).order_by_name.where(locked: false).map(&:t_node)
    end

    def t_node
      {}.tap do |node|
        node['name']        = name
        node['description'] = description
        node['class']       = self.class.name
        node['configs']     = configs&.map(&:t_node)
        node['entry']       = entry&.t_node
      end
    end

    def dig(level)
      if level.to_sym == :configs
        return send(level).where(locked: false).order_by_name
      end

      send(level)
    end

    def self.includes_hash
      tree_depth = Flexite::Config.maximum(:depth)
      tree_depth.times.inject(:configs) { |h| { configs: [h, :entry] } }
    end

    private

    def assign_depth
      self.depth = (config.present? ? config.depth + 1 : 0)
    end

    def set_description
      return if description.present?

      self.description = name
    end

    def entry_href
      if entry.present?
        Engine.routes.url_helpers.edit_entry_path(entry, format: :js)
      else
        Engine.routes.url_helpers.select_type_entries_path(self, format: :js)
      end
    end

    def configs_href
      Engine.routes.url_helpers.config_configs_path(self, format: :json)
    end
  end
end
