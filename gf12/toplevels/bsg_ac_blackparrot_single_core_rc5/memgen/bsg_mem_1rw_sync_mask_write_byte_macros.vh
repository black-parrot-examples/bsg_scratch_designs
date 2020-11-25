
`define BSG_MEM_HARD_1RW_SYNC_MASK_WRITE_BYTE_MACROS \
  `bsg_mem_1rw_sync_mask_write_byte_macro(512,64,2) else \
  `bsg_mem_1rw_sync_mask_write_byte_banked_macro(1024,512,8,2) else
