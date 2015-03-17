class Partition

	def initialize()
		
		@partition = { 
		'01' => ' DOS 12-bit FAT',
		'04' => ' DOS 16-bit FAT (up to 32M)',
		'05' => ' Extended DOS 3.3+ extended partition',
		'06' => ' DOS 3.31+ Large File System (16-bit FAT, over 32M)',
		'07' => ' WindowsNT NTFS',
		'08' => ' AIX bootable partition, SplitDrive',
		'09' => ' AIX AIX data partition',
		'0B' => ' Windows95 with 32-bit FAT',
		'0C' => ' Windows95 with 32-bit FAT (using LBA-mode INT 13 extensions)',
		'17' => ' NTFS hidden NTFS partition',
		'1B' => ' Windows hidden Windows95 FAT32 partition',
		'1E' => ' Windows hidden LBA VFAT partition',
		'3C' => ' PowerQuest PartitionMagic recovery partition',
		'66' => ' Novell partition',
		'69' => ' Novell NSS Volume',
		'81' => ' Linux',
		'82' => ' Linux/Swap Linux Swap partition',
		'83' => ' Linux native file system (ext2fs/xiafs)',
		'86' => ' FAT16 FAT16 volume/stripe set (Windows NT)',
		'87' => ' HPFS HPFS Fault-Tolerant mirrored partition or NTFS NTFS volume/stripe set',
		'A5' => ' FreeBSD, BSD/386',
		'A6' => ' OpenBSD',
		'A9' => ' NetBSD (http://www.netbsd.org/)',
		'C7' => ' corrupted NTFS volume/stripe set',
		'EB' => ' BeOS BFS (BFS1)',
		}		
	end

	def get_partition_type(detail)
		key = detail[12..13].upcase
		if(!@partition[key])
			@partition[key] = ''
		end 
		'('+key+')'+@partition[key]
	end


	def get_partition_address(detail)
		hex = convert_to_little_endian_address(detail)
		address = hex.to_i(16)
	end

	def get_partition_size(detail)
		hex = convert_to_little_endian_size(detail)
		size = hex.to_i(16)
	end

	def convert_to_little_endian_address(arg)
    return arg[33..34]+arg[30..31]+arg[27..28]+arg[24..25]
  end

  def convert_to_little_endian_size(arg)
    return arg[45..46]+arg[42..43]+arg[39..40]+arg[36..37]
  end
end