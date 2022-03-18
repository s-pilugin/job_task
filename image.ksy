meta:
  id: image
  file-extension: img
  endian: le
  bit-endian: le
  
seq:
  - id: mbr
    type: mbr
  - id: reserved
    size: mbr.reserved_space
  - id: fats
    size: mbr.fats_size
    type: fat
    repeat: expr
    repeat-expr: mbr.number_of_fats
  - id: root_dir
    type: root_directory
    size: mbr.root_dir_size
  - id: data
    size: mbr.cluster_size
    repeat: eos
    
types:
  mbr:
    seq:
      - id: jmp_boot
        size: 3
      - id: oem_name
        size: 8
        type: str
        encoding: ASCII
      - id: bytes_per_sector
        type: u2
      - id: sectors_per_cluster
        type: u1
      - id: number_of_reserved_sectors
        type: u2
      - id: number_of_fats
        type: u1
      - id: max_num_of_root_dir_entries
        type: u2
      - id: total_sector_count_16
        type: u2
      - id: media_code
        type: u1
      - id: sectors_per_fat
        type: u2
      - id: sector_per_track
        type: u2
      - id: number_of_heads
        type: u2
      - id: number_of_hidden_sectors
        type: u4
      - id: total_sector_count_32
        type: u4
      - id: driver_num
        type: u1
      - id: reserved1
        type: u1
      - id: boot_signature
        type: u1
      - id: volume_id
        type: u4
      - id: volume_label
        size: 11
        type: str
        encoding: ASCII
      - id: filesystem_type
        size: 8
        type: str
        encoding: ASCII
      - id: boot_code
        size: 448
      - id: end_signature
        size: 2
        
    instances:
      reserved_space:
        value: (number_of_reserved_sectors - 1) * bytes_per_sector
      fats_size:
        value: sectors_per_fat * bytes_per_sector
      cluster_size:
        value: sectors_per_cluster * bytes_per_sector
        
      root_dir_size:
        value: 32 * max_num_of_root_dir_entries
        
  fat:
    seq:
      - id: next_cluster
        type: b12
        repeat: eos
        
  root_directory:
    seq:
      - id: records
        type: root_directory_entry
        repeat: expr
        repeat-expr: _root.mbr.max_num_of_root_dir_entries
        
  root_directory_entry:
    seq:
      - id: file_name
        size: 11
        type: str
        encoding: ASCII
      - id: attribute
        type: u1
      - id: reserved
        size: 10
      - id: time
        type: u2
      - id: date
        type: u2
      - id: start_cluster
        type: u2
      - id: file_size
        type: u4
        
