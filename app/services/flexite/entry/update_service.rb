require_dependency 'flexite/action_service'

module Flexite
  class Entry::UpdateService < ActionService
    def call
      return failure if @form.invalid?

      record            = @form.type.constantize.find(@form.id)
      record.value      = @form.value
      record.updated_by = @params[:user]&.user_id
      record.save if record.changed?

      success
    end

    protected

    def failure
      save_errors
      Result.new(success: false, endpoint: { action: :edit, status: 400 })
    end

    def success
      Result.new(flash: { type: :success, message: 'Entry was updated!' })
    end
  end
end
