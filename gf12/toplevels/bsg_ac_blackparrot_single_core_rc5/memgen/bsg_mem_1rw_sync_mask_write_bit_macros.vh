
`define BSG_MEM_HARD_1RW_SYNC_MASK_WRITE_BIT_MACROS \
  `bsg_mem_1rw_sync_mask_write_bit_macro(64,7,4) else \
  `bsg_mem_1rw_sync_mask_write_bit_macro(64,15,4) else \
  `bsg_mem_1rw_sync_mask_write_bit_macro(64,124,2) else \
  `bsg_mem_1rw_sync_mask_write_bit_macro(128,15,4) else \
  `bsg_mem_1rw_sync_mask_write_bit_macro(128,116,2) else \
  `bsg_mem_1rw_sync_mask_write_bit_banked_macro(64,248,2,1) else \
  `bsg_mem_1rw_sync_mask_write_bit_banked_macro(128,232,2,1) else
