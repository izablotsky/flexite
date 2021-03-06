require_dependency 'flexite/base_factory'

module Flexite
  class ServiceFactory < BaseFactory
    def initialize
      @store = {
        arr_entry_update: 'Entry::ArrayUpdateService',
        entry_update: 'Entry::UpdateService',
        config_create: 'Config::CreateService',
        entry_create: 'Entry::CreateService',
        arr_entry_create:  'Entry::ArrayCreateService',
        entry_destroy: 'Entry::DestroyService',
        arr_entry_destroy: 'Entry::DestroyService',
        destroy_array_entry: 'Entry::DestroyArrayEntryService',
        update_config: 'Config::UpdateService',
        sync_check_diff: 'Diff::SyncCheckService',
        async_check_diff: 'Diff::AsyncCheckService',
        sync_show_diff: 'Diff::SyncShowService',
        async_show_diff: 'Diff::AsyncShowService',
        apply_diff: 'Diff::ApplyService',
        push_diff: 'Diff::PushService'
      }
    end
  end
end
