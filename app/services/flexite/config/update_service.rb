module Flexite
  class Config
    class UpdateService < ActionService
      def call
        return failure if @form.invalid?

        @record = Config.joins("LEFT JOIN #{Entry.table_name} ON #{Entry.table_name}.parent_id = #{Config.table_name}.id AND #{Entry.table_name}.parent_type = '#{Config.model_name}'")
          .select("#{Config.table_name}.*, #{Entry.table_name}.id AS entry_id")
          .where(id: @form.id).first
        @prev_parent = @record.config_id
        @record.update_attributes(@form.attributes)
        success
      end

      protected

      def failure
        Result.new(success: false, endpoint: { action: :edit, status: 400 })
      end

      def success
        Result.new(flash: { type: :success, message: 'Config was updated!' }, data: @record, parent_changed: parent_changed?)
      end

      def parent_changed?
        @prev_parent != @record.config_id
      end
    end
  end
end
