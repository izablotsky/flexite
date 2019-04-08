module Flexite
  class Config::CopyService
    def initialize(id)
      @config = Config.includes(Config.includes_hash, :entry).find(id)
    end

    def call
      copy
      rename
      save
    end

    private

    def copy
      @copy ||= @config.deep_clone include: [Config.includes_hash, :entry],
                                   skip_missing_associations: true,
                                   use_dictionary: true
    end

    def rename
      copy.name = "#{@config.name}_copy"
    end

    def save
      begin
        skip_callback
        ActiveRecord::Base.transaction do
          ActiveRecord::Base.no_touching do
            copy.save
          end
        end
      ensure
        set_callback
      end
    end

    def skip_callback
      Config.skip_callback(:save, :after, :save_history)
      Entry.skip_callback(:save, :after, :save_history)
    end

    def set_callback
      Config.set_callback(:save, :after, :save_history)
      Entry.set_callback(:save, :after, :save_history)
    end
  end
end
