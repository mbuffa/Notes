module Notes
  class Configuration
    attr_reader :conf_dir, :data_dir

    def initialize
      @home = File.expand_path '~'
      @conf_dir = File.join(@home, '.config', 'notes')
      @data_dir = File.join(@home, '.local', 'share', 'notes')

      if File.exists?(@conf_dir)
        if File.directory?(@conf_dir) == false
          raise "#{@conf_dir} already exists and is not a directory, aborting."
        end

        if File.executable?(@conf_dir) == false
          raise "#{@conf_dir} already exists and is not executable, aborting."
        end
      else
        Dir.mkdir(@conf_dir)
      end

      if File.exists?(@data_dir)
        if File.directory?(@data_dir) == false
          raise "#{@data_dir} already exists and is not a directory, aborting."
        end

        if File.executable?(@data_dir) == false
          raise "#{@data_dir} already exists and is not executable, aborting."
        end
      else
        Dir.mkdir(@data_dir)
      end
    end
  end
end
