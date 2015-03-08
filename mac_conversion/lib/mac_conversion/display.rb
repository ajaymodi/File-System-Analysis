module Address4Forensics
  class Display
    def initialize(params)
      @params   = params
    end

    def convert_time
      return address
    end

    def convert_date
    end

    def read_file
      File.open(@params[:filename], "r") do |f|
        l=""
        f.each_line do |line|
          l = line.strip
          break
        end
        if(l.split[0].length==6)
          return l.split[0]
        else
          return nil
        end   
      end
    end

    def convert_to_little_endian(arg)
      arg[2] = temp[4] 
      arg[3] = temp[5]
      arg[4] = temp[2]
      arg[5] = temp[3]
      return arg
    end

    def check_valid_hex(arg)
      return !arg[/\H/]
    end

  end
end
