module Address4Forensics
  class Calculation
    def initialize(params)
      @params   = params
    end

    #Calculates the logical address value given either a physical address or cluster address.
    def calculate_logical_address
      address = 0
      if(@params[:cluster_known_address]  == true)
        address = convert_cluster_to_physical_address
      elsif @params[:physical_address]
        address = @params[:physical_address]
      end
      address = subtract_partition_offset(address)
      if(@params[:logical_address])
        address = @params[:logical_address]
      end
      return address
    end

    #Converts a cluster address to a physical address.
    def convert_cluster_to_physical_address
        adrs = 0
        no_of_fat = @params[:fat_tables]
        sectors_in_fat = @params[:fat_length]
        reserved_sectors = @params[:reserved_sectors]
        sectors_per_cluster =  @params[:cluster_size]
        default_cluster_number = 2
        cluster_known_address = @params[:cluster_address]
        adrs = add_partition_offset(adrs)+(cluster_known_address-default_cluster_number)*sectors_per_cluster+reserved_sectors+(no_of_fat*sectors_in_fat) 
    end

    #Calculates the physical address value given either a logical address or cluster address.
    def calculate_physical_address
      address = 0
      if(@params[:cluster_known_address]  == true)
        address = convert_cluster_to_physical_address
      elsif @params[:logical_address]
        address = @params[:logical_address]
        address = add_partition_offset(address)
      else
        address = @params[:physical_address]
      end
      return address
    end

    #Adds partition offset to convert logical to physical address
    def add_partition_offset adr
      if @params[:partition_start_offset]
        offset = @params[:partition_start_offset]
        return adr+offset
      else
        return adr
      end
    end

    #Subtracts partition offset to convert physical to logical address
    def subtract_partition_offset adr
      if @params[:partition_start_offset]
        offset = @params[:partition_start_offset]
        return adr-offset
      else
        return adr
      end
    end
    
    #Calculates the cluster address value given either a physical address or logical address.
    def calculate_cluster_address
      address = 0
      if(@params[:logical_known_address]  == true)
        address = convert_logical_to_cluster_address @params[:logical_address]
      elsif(@params[:physical_known_address]  == true)
        address = subtract_partition_offset(@params[:physical_address])
        address = convert_logical_to_cluster_address address
      else
        address = @params[:cluster_address]
      end
      return address
    end

    #Converts a logical address to a cluster address.
    def convert_logical_to_cluster_address adrs
      # puts @params
      # adrs = @params[:logical_address]
      no_of_fat = @params[:fat_tables]
      sectors_in_fat = @params[:fat_length]
      reserved_sectors = @params[:reserved_sectors]
      sectors_per_cluster = @params[:cluster_size]
      default_cluster_number = 2
      cluster_no = ((adrs - reserved_sectors - (no_of_fat*sectors_in_fat))/sectors_per_cluster)+default_cluster_number
    end
  end
end
