Task    2.    Acquisition,    Authentication,    and    Analysis     

For  this    project,    it    is    assumed    that    the    work    of    acquiring    a    digital    copy    of    a    hard    drive    has    already    been    performed.    The    following    requirements    should    be    accomplished    in    your    code:    a    single    package    is    preferred.    A    sample    raw    image    and    corresponding    information    are    available    at    Blackboard.    

Requirement  a)    First,    you    are    to    write    a    program    that    can    take    as    input    the    path    to    a    RAW    image    and    

open    it    as    read-­‐only    for    the    requirements    (b)    and    (c).    

Requirement  b)    Before    opening    the    RAW    image,    your    program    should    first    calculate    MD5    and    SHA1    checksums    for    the    image.        Both    checksums    should    be    stored    as    MD5-­‐image-­‐name.txt    and    SHA1-­‐image-­‐ name.txt.  For    example,    the    name    of    RAW    image    is    Sparky    then    your    authentication    module    needs    to    generate    MD5-­‐Sparky.txt    and    SHA1-­‐Sparky.txt    before    opening    the    RAW    image.        

Requirement  c)    The    next    tasks    your    program    must    be    able    to    accomplish    are:    

1.   Locate  and    extract    the    partition    tables    from    the    master    boot    record    (MBR)    

a.    Your  program    MUST    generate    the    partition    type    including    hex    value    and    corresponding    

type,    start    sector    address,    and    size    of    each    partition    in    decimal    as    follows:    

(07) NTFS, 0002056320, 0000208845

2.    For  FAT16/32    partition,    read    each    partition’s    volume    boot    record    (VBR)    and    retrieve    the    

geometric  data    of    the    file    system.    Your    code    MUST    generate    the    following    layout    information:    

a.    The  layout    should    include:        

Reserved area:  Start sector: 0  Ending sector: 6  Size:  7 sectors

Sectors per cluster:  32 sectors

FAT area:  Start sector: 7 Ending sector:  598

# of FATs: 2

The size of each FAT: 249 sectors

The first sector of cluster 2: 12234 sectors