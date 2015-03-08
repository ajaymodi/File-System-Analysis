require "debugger"


module MacConversion

  class Application
    def initialize(argv)
      @params = parse_options(argv)
      @display = MacConversion::Display.new(@params)
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
      args = nil
      if @params[:filename]
        args = @display.read_file
      else
        args = @params[:hex_value]
      end

      args = @display.convert_to_little_endian(args)

      if @params[:conversion].empty? 
        puts "You are missing parameters."
      elsif @display.check_valid_hex(args)
        puts "Enter Valid hex numbers."
      elsif @params[:conversion]== "convert_time"
        result = @display.convert_time(args)
      elsif @params[:conversion]== "convert_date"
        result = @display.convert_date(args)
      end
      puts format(result)
    end

    def parse_options(argv)
      params = {}
      parser = OptionParser.new 
      time = nil
      parser.on("-T") { params[:conversion] = "convert_time" }
      parser.on("-D") { params[:conversion] = "convert_date"  }

      parser.on("-f","--filename filepath", "summary_of_command") do |filepath|
        params[:filename] = filepath
      end
      parser.on("-h", "--hex_value hex_value", "summary_of_command") do |hex_value|
        params[:hex_value] = hex_value
      end
      parser.parse(argv)
      params
    end
  end
end
