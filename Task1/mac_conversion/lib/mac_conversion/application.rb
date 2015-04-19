#require "debugger"

module MacConversion

  class Application
    def initialize(argv)
      @params = parse_options(argv)
      @calculation = MacConversion::Calculation.new(@params)
    end

    #Specifies root folder for the project
    def self.root(path = nil)
      @_root ||= File.expand_path(File.dirname(__FILE__))
      path ? File.join(@_root, path.to_s) : @_root
    end

    #Specifies the environment
    def self.env
      @_env ||= ENV['RACK_ENV'] || 'development'
    end

    # Initialize the application
    def self.initialize!
    end

    #Validates the arguments passed for option parser and calculates interchangable address based on description in readme file.
    def run
      args = nil
      if @params[:conversion] == nil 
        puts "Not a valid format. Use mac_conversion -x for more help "
        exit 1
      elsif @params[:hex_value] == nil and @params[:filename] == nil 
        puts  "Not a valid format. Use mac_conversion -x for more help"
        exit 1
      end

      if @params[:filename]
        args = @calculation.read_file
      else
        args = @params[:hex_value]
      end

      if(args.length==6 and args[0..1]=="0x")
        args = @calculation.convert_to_little_endian(args)
      else 
        puts  "Not a valid format. Use mac_conversion -x for more help"
        exit 1
      end

      if not @calculation.check_valid_hex(args)
        puts "Enter Valid hex numbers."
        exit 1
      elsif @params[:conversion]== "convert_time"
        result = @calculation.convert_time(args)
      elsif @params[:conversion]== "convert_date"
        result = @calculation.convert_date(args)
      end
      puts result
    end

    #Parses the input given by user
    def parse_options(argv)
      params = {:filename => nil, :hex_value => nil, :conversion => nil}   
      parser = OptionParser.new 
      parser.banner = "Usage: mac_conversion [options]"
      time = nil
      parser.on("-T", "--time", "Use time conversion module. Either -f or -h must be given.") { params[:conversion] = "convert_time" }
      parser.on("-D", "--date", "Use date conversion module. Either -f or -h must be given.") { params[:conversion] = "convert_date"  }
      parser.on("-f","--filename filepath", "This specifies the path to a filename that includes a hex value of time or date.","Note that the hex value should follow this notation: 0x1234.","For the multiple hex values in either a file or a command line input,","we consider only one hex value so the recursive mode for a MAC conversion is optional.") do |filepath|
        params[:filename] = filepath
      end
      parser.on("-h", "--hex_value hex_value", "This specifies the hex value for converting to either date or time value.","Note that the hex value should follow this notation: 0x1234.","For the multiple hex values in either a file or a command line input,","we consider only one hex value so the recursive mode for a MAC conversion is optional.") do |hex_value|
        params[:hex_value] = hex_value
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
      params
    end
  end
end
