module Address4Forensics
  class Display
    def initialize(params)
      @params   = params
      @answer   = -1
    end

    
    def run
      if @params[:calculation].empty?
        puts "You are missing parameters."
      elsif @params[:calculation]== :calculate_logical_address
        answer_in_sectors = calculate_logical_address
      elsif @params[:calculation]== :calculate_physical_address
        answer_in_sectors = calculate_physical_address
      elsif @params[:calculation]== :calculate_cluster_address
        answer_in_sectors = calculate_cluster_address
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
      return answer
    end


    private

    # attr_reader :line_numbering_style, :squeeze_extra_newlines, :line_number

    def calculate_logical_address
      address = 0
      if(@params[:cluster_known_address]  == true)
        address = convert_cluster_to_physical_address
      else
        address = @params[:physical_address]
      end

      if @params[:partition_start_offset]
        address = subtract_partition_offset(address)
      end
      return address
    end

    def convert_cluster_to_physical_address
        adrs = 0
        no_of_fat = params[:fat_tables]
        sectors_in_fat = params[:fat_length]
        reserved_sectors = params[:reserved_sectors]
        sectors_per_cluster =  params[:cluster_size]
        default_cluster_number = 2
        cluster_known_address = @params[:cluster_address]
        adrs = add_partition_offset(adrs)+(cluster_known_address-default_cluster_number)*sectors_per_cluster+reserved_sectors
        +(no_of_fat*sectors_in_fat) 
    end

    def calculate_physical_address
      address = 0
      if(@params[:cluster_known_address]  == true)
        address = convert_cluster_to_physical_address
      else
        address = @params[:logical_address]
        if @params[:partition_start_offset]
          address = add_partition_offset(address)
        end
      end
      return address
    end

    def add_partition_offset adr
      offset = @params[:partition_start_offset]
      return adr+offset
    end

    def subtract_partition_offset adr
      offset = @params[:partition_start_offset]
      return adr-offset
    end
    
    def calculate_cluster_address
      address = 0
      if(@params[:logical_known_address]  == true)
        address = convert_logical_to_cluster_address
      elsif(@params[:physical_known_address]  == true)
        address = subtract_partition_offset(params[:physical_address])
        address = convert_logical_to_cluster_address
      else
        
      end
      return address
    end

    def convert_logical_to_cluster_address
      adrs = params[:logical_address]
      no_of_fat = 2  # params[:fat_tables]
      sectors_in_fat = 16 # params[:fat_length]
      reserved_sectors = 6 #params[:reserved_sectors]
      sectors_per_cluster = 4 # params[:cluster_size]
      default_cluster_number = 2
      adrs = adrs - reserved_sectors - (no_of_fat*sectors_in_fat)
      adrs = adrs/sectors_per_cluster
      cluster_no = (adrs+default_cluster_number)
    end
  end
end
