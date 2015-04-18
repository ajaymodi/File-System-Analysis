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
      params = {:calculation => nil, :partition_start_offset => nil, :byte_address => nil,
      :sector_size => nil, :logical_address => nil, :logical_known_address => nil, 
      :physical_address => nil, :physical_known_address => nil, :cluster_address => nil,
      :cluster_known_address => nil, :cluster_size => nil, :reserved_sectors => nil,
      :fat_tables => nil, :fat_length => nil}   

      parser = OptionParser.new 
      parser.banner = "Usage: address4forensics [options]"
      answer = -1
      parser.on("-L", "--logical", "Calculate the logical address",
        "from either the cluster address or the physical address.",
        "Either -c or -p must be given.") { params[:calculation] = "calculate_logical_address" }
      parser.on("-P" '--physical', 'Calculate the physical ','
        address from either the cluster address or the logical address. ','
        Either -c or -l must be given.') { params[:calculation] = "calculate_physical_address"  }
      parser.on("-C", '--cluster', 'Calculate the cluster address ','
        from either the logical address or the physical address. ','
        Either -l or -p must be given.') { params[:calculation] = "calculate_cluster_address"  }
      parser.on("-b", "--partition-start offset", Integer , 'This specifies the ','
        physical address (sector number) of the start of the partition, and ','
        defaults to 0 for ease in working with images of a single partition. ','
        The offset vaulue will always translate into logical address 0.') do |offset|
        params[:partition_start_offset] = offset.to_i
      end
      parser.on("-B", "--byte-address", Integer ,'Instead of returning ','
        sector values for the conversion, this returns the byte address of ','
        the calculated value, which is the number of sectors multiplied by ','
        the number of bytes per sector.') { params[:byte_address]   = true }
      parser.on("-s", "--sector-size bytes", Integer, 'When the -B option is used, ','
        this allows for a specification of bytes per sector other than the ','
        default 512. Has no affect on output without -B.') do |bytes|
        params[:sector_size]   = bytes.to_i 
      end
      parser.on("-l", "--logical-known address", Integer, 'This specifies the ','
        known logical address for calculating either a cluster address or a ','
        physical address. When used with the -L option, this simply ','
        returns the value given for address.') do |address|
        params[:logical_address]   = address.to_i 
        params[:logical_known_address]   = true
      end
      parser.on("-p", "--physical-known address", Integer, 'This specifies the ','
        known physical address for calculating either a cluster address or a ','
        logical address. When used with the -P option, this simply ','
        returns the value given for address.') do |address|
        params[:physical_address]   = address.to_i
        params[:physical_known_address]   = true
      end
      parser.on("-c", "--cluster-known address", Integer, 'This specifies the ','
        known cluster address for calculating either a logical address or a ','
        physical address. When used with the -C option, this simply ','
        returns the value given for address. Note that options -k, ','
        -r, -t, and -f must be provided with this option.') do |address|
        params[:cluster_address]   = address.to_i
        params[:cluster_known_address]   = true
      end
      parser.on("-k", "--cluster-size sectors", Integer, 'This specifies the ','
        number of sector per cluster.') do |sectors|
        params[:cluster_size]   = sectors.to_i
      end
      parser.on("-r", "--reserved sectors", Integer, 'This specifies the ','
        number of reserved sectors in the partition.') do |sectors|
        params[:reserved_sectors]   = sectors.to_i 
      end
      parser.on("-t", "--fat_tables tables", Integer, 'This specifies the ','
        number of FAT tables, which is usually 2.') do |tables|
        params[:fat_tables]   = tables.to_i
      end
      parser.on("-f", "--fat_length sectors", Integer, 'This specifies the ','
        length of each FAT table in sectors.') do |sectors|
        params[:fat_length]   = sectors.to_i
      end
      parser.on("-x", "--help", "Displays help") do
        puts parser
        exit 1
      end
      begin
        parser.parse!(argv)
      rescue OptionParser::ParseError
        puts  "Not a valid format. Use mac_conversion -x for more help"
        exit 1
      end 
      
      [params, parser]
    end
  end
end