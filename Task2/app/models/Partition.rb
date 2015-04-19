class Partition

	#Initialize the partition type of the partition table based on given HEX value 
	def initialize()
		
		@partition = { 
		'01' => ' DOS 12-bit FAT',
		'04' => ' DOS 16-bit FAT for partitions smaller than 32 MB',
		'05' => ' Extended partition',
		'06' => ' DOS 16-bit FAT for partitions larger than 32 MB',
		'07' => ' NTFS',
		'08' => ' AIX bootable partition, SplitDrive',
		'09' => ' AIX data partition',
		'0B' => ' DOS 32-bit FAT',
		'0C' => ' DOS 32-bit FAT for interrupt 13 support',
		'17' => ' Hidden NTFS partition (XP and earlier)',
		'1B' => ' Hidden FAT32 partition',
		'1E' => ' Hidden VFAT partition',
		'3C' => ' Partition Magic recovery partition',
		'66' => ' Novell partition',
		'67' => ' Novell partition',
		'68' => ' Novell partition',
		'69' => ' Novell partition',
		'81' => ' Linux',
		'82' => ' Linux swap partition (can also be associated with Solaris partitions)',
		'83' => ' Linux native file system (Ext2, Ext3, Reiser, xiafs)',
		'86' => ' FAT16 volume/stripe set (Windows NT)',
		'87' => ' High Performace File System (HPFS) Fault-Tolerant mirrored partition or NTFS NTFS volume/stripe set',
		'A5' => ' FreeBSD, BSD/386',
		'A6' => ' OpenBSD',
		'A9' => ' NetBSD',
		'C7' => ' Typical of a corrupted NTFS volume/stripe set',
		'EB' => ' BeOS BFS (BFS1)',
		}		
	end

	# gets Partition Type detail from the given Hex 
	def get_partition_type(detail)
		key = detail[12..13].upcase
		if(!@partition[key])
			@partition[key] = ''
		end 
		'('+key+')'+@partition[key]
	end

	# gets Reserved Area detail from the given Hex
	def get_reserved_area(detail)
		hex = convert_to_little_endian(detail[42..47])
		ra = hex.to_i(16)
	end

	# gets Sectors per cluster detail from the given Hex
	def get_sectors_per_cluster(detail)
		spc = detail[39..40].to_i(16)
	end

	# gets Number of FAT detail from the given Hex
	def get_number_of_fat(detail)
		spc = detail[48..49].to_i(16)
	end

	# gets Size of FAT detail from the given Hex
	def get_size_of_fat(detail,file_system)
		size = 0
		if(file_system=="06")
			hex = convert_to_little_endian(detail[66..70])
			size = hex.to_i(16)	
		else
			hex = convert_to_little_endian(detail[108..118])
			size = hex.to_i(16)
		end	
		return size
	end

	# gets Root Directory detail from the given Hex
	def get_root_directory(detail)
		hex = convert_to_little_endian(detail[51..55])
		size = hex.to_i(16)*32/512
	end

	# gets Partition Addrss detail from the given Hex
	def get_partition_address(detail)
		hex = convert_to_little_endian(detail[24..34])
		address = hex.to_i(16)
	end

	# gets Partition Size detail from the given Hex
	def get_partition_size(detail)
		hex = convert_to_little_endian(detail[36..46])
		size = hex.to_i(16)
	end

	# Converts to little Endian from the given Hex
	def convert_to_little_endian(arg)
		arg = arg.gsub(/\s+/, "")  unless arg.nil?
		if(arg.length==8)
			return arg.scan(/(..)(..)(..)(..)/).map(&:reverse).join
		else
			return arg.scan(/(..)(..)/).map(&:reverse).join
		end
  end
end