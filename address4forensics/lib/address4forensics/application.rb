require "debugger"


module Address4Forensics

  class Application
    def initialize(argv)
      @params = parse_options(argv)
      @calculation = Address4Forensics::Calculation.new(@params)
    end

    def self.root(path = nil)
      @_root ||= File.expand_path(File.dirname(__FILE__))
      path ? File.join(@_root, path.to_s) : @_root
    end

    def self.env
      @_env ||= ENV['RACK_ENV'] || 'development'
    end

    # Initialize the application
    def self.initialize!
    end

    # Bundler.require(:default, Address4Forensics::Application.env)

    def run
      if @params[:calculation].empty?
        puts "You are missing parameters."
      elsif @params[:calculation]== "calculate_logical_address"
        answer_in_sectors = @calculation.calculate_logical_address
      elsif @params[:calculation]== "calculate_physical_address"
        answer_in_sectors = @calculation.calculate_physical_address
      elsif @params[:calculation]== "calculate_cluster_address"
        answer_in_sectors = @calculation.calculate_cluster_address
      end
      if(@params[:byte_address])
        if(params[:sector_size])
          answer = answer_in_sectors * params[:sector_size]
        else
          answer = answer_in_sectors * 512
        end
      else
        answer = answer_in_sectors
      end
      puts answer
    end

    
    def parse_options(argv)
      params = {}
      parser = OptionParser.new 
      answer = -1
      parser.on("-L") { params[:calculation] = "calculate_logical_address" }
      parser.on("-P") { params[:calculation] = "calculate_physical_address"  }
      parser.on("-C") { params[:calculation] = "calculate_cluster_address"  }
      parser.on("-b", "--partition-start offset", "summary_of_command") do |offset|
        params[:partition_start_offset] = offset.to_i
      end
      parser.on("-B", "--byte-address", "summary_of_command") { params[:byte_address]   = true }
      parser.on("-s", "--sector-size bytes", "summary_of_command") do |bytes|
        params[:sector_size]   = bytes.to_i 
      end
      parser.on("-l", "--logical-known address", "summary_of_command") do |address|
        params[:logical_address]   = address.to_i 
        params[:logical_known_address]   = true
      end
      parser.on("-p", "--physical-known address", "summary_of_command") do |address|
        params[:physical_address]   = address.to_i
        params[:physical_known_address]   = true
      end
      parser.on("-c", "--cluster-known address", "summary_of_command") do |address|
        params[:cluster_address]   = address.to_i
        params[:cluster_known_address]   = true
      end
      parser.on("-k", "--cluster-size sectors", "summary_of_command") do |sectors|
        params[:cluster_size]   = sectors.to_i
      end
      parser.on("-r", "--reserved sectors", "summary_of_command") do |sectors|
        params[:reserved_sectors]   = sectors.to_i 
      end
      parser.on("-t", "--fat_tables tables", "summary_of_command") do |tables|
        params[:fat_tables]   = tables.to_i
      end
      parser.on("-f", "--fat_length sectors", "summary_of_command") do |sectors|
        params[:fat_length]   = sectors.to_i
      end
      parser.parse(argv)
      params
    end
  end
end
