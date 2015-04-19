module MacConversion
  class Calculation
    def initialize(params)
      @params   = params
    end

    #Converts hex into proper time 
    def convert_time(arg)
      arg = convert_to_binary(arg)
      hour = arg[0..4].to_i(2)
      minute = arg[5..10].to_i(2)
      second = arg[11..15].to_i(2)*2
      return time_format(hour,minute,second)
    end

    #Converts hex into proper date
    def convert_date(arg)
      arg = convert_to_binary(arg)
      year = arg[0..6].to_i(2)
      month = arg[7..10].to_i(2)
      date = arg[11..15].to_i(2)
      return date_format(year,month,date)
    end

    #Converts time into HH:MM:SS format
    def time_format(hour,minute,second)
      time = ""
      if(hour>12)
        time = "Time: "+(hour-12).to_s+":"+minute.to_s+":"+second.to_s+" PM"
      else
        time = "Time: "+(hour).to_s+":"+minute.to_s+":"+second.to_s+" AM"
      end
      return time
    end

    #Converts date into Month Date, Year format
    def date_format(year,month,date)
      year = year+1980
      result = ""
      result = (Date.new(year,month,date)).strftime('%b %d, %Y')
      return "Date: "+result
    end

    #Converts given hex argument to binary
    def convert_to_binary(arg)
      return arg.hex.to_s(2).rjust(arg.size*4, '0')
    end

    #Read file for the given hex input
    def read_file
      if(File.exist?(@params[:filename]))
        l=""
        File.open(@params[:filename], "r") do |f|
          l = f.readline.strip[0..5]   
        end
        return l
      else
        puts "File does not exists"
        exit 1
      end
    end

    #Convert given hex to Little Endian format 
    def convert_to_little_endian(arg)
      return arg[4..5]+arg[2..3]
    end

    #Checks whether provided input contains valid hex or not.
    def check_valid_hex(arg)
      return !arg[/\H/]
    end

  end
end
