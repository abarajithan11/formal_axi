package pkg_axi_fvip;

  //___________ ENUMS (AXI4) ___________ 

  // Table A3-3: Burst type encoding
  typedef enum logic [1:0] {
    BURST_FIXED = 2'b00,
    BURST_INCR  = 2'b01,
    BURST_WRAP  = 2'b10
    // 2'b11 reserved
  } burst_e;

  // Table A3-4: Response encoding
  typedef enum logic [1:0] {
    RESP_OKAY   = 2'b00,
    RESP_EXOKAY = 2'b01,
    RESP_SLVERR = 2'b10,
    RESP_DECERR = 2'b11
  } resp_e;

  // AXI4 uses 1-bit AxLOCK (A7.4)
  typedef enum logic {
    LOCK_NORMAL    = 1'b0,
    LOCK_EXCLUSIVE = 1'b1
  } lock_e;

  // Table A4-5: Memory type encoding (unique values only)
  // Note: different allocate hints share the same encoding;
  // only one name per unique 4-bit value is listed here.
  typedef enum logic [3:0] {
    CACHE_DEV_NON_BUF     = 4'b0000,  // Device Non-bufferable
    CACHE_DEV_BUF         = 4'b0001,  // Device Bufferable
    CACHE_NORM_NON_CACHE  = 4'b0010,  // Normal Non-cacheable Non-bufferable
    CACHE_NORM_BUF        = 4'b0011,  // Normal Non-cacheable Bufferable
    CACHE_WT_NO_ALLOC     = 4'b0110,  // Write-through No-allocate (also Read-allocate)
    CACHE_WB_NO_ALLOC     = 4'b0111,  // Write-back No-allocate (also Read-allocate)
    CACHE_WT_WR_ALLOC     = 4'b1010,  // Write-through Write-allocate (also No-allocate on AR)
    CACHE_WB_WR_ALLOC     = 4'b1011,  // Write-back Write-allocate (also No-allocate on AR)
    CACHE_WT_RW_ALLOC     = 4'b1110,  // Write-through Read-and-Write-allocate
    CACHE_WB_RW_ALLOC     = 4'b1111   // Write-back Read-and-Write-allocate
  } cache_e;

  //___________ RESET ___________

  property low_after(rstn, valid);
    disable iff (0)
    !rstn |=> !valid;
  endproperty

  property not_with_rise(rstn, valid);
    disable iff (0)
    $rose(rstn) |-> !valid;
  endproperty

  //___________ UNKNOWN VALUES ___________

  property not_unknown(signal);
    !$isunknown(signal);
  endproperty

  property not_unknown_when(when_cond, signal);
    when_cond |-> !$isunknown(signal);
  endproperty

  //___________ HANDSHAKES ___________

  property stable_next_when(when_cond, signal);
    when_cond |=> $stable(signal);
  endproperty

  property valid_before_ready(valid, ready);
    valid && !ready;
  endproperty

  //___________ BURST ___________

  // Burst size must not exceed data bus width (A3.4.1, Burst size)
  property burst_size_max(valid, size, int DATA_W);
    valid |-> (1 << size) <= (DATA_W / 8);
  endproperty

  // AxBURST must not be reserved encoding 2'b11 (Table A3-3)
  property burst_not_reserved(valid, burst);
    valid |-> burst != 2'b11;
  endproperty

  // FIXED burst: length 1-16 transfers (A3.4.1, Burst length)
  property fixed_len(valid, burst, len);
    valid && burst == BURST_FIXED |-> len <= 8'd15;
  endproperty

  // WRAP burst: length must be 2, 4, 8, or 16 (A3.4.1, Burst type)
  property wrap_len(valid, burst, len);
    valid && burst == BURST_WRAP |-> len inside {8'd1, 8'd3, 8'd7, 8'd15};
  endproperty

  // Burst must not cross 4KB address boundary (A3.4.1)
  let aligned_addr(addr, size) = (addr >> size) << size;
  let total_bytes(len, size)   = (len + 1) << size;
  let end_byte(addr, len, size) = aligned_addr(addr, size) + total_bytes(len, size) - 1;

  property no_4kb_cross(valid, burst, addr, len, size);
    valid && burst == BURST_INCR |->
      (addr >> 12) == (end_byte(addr, len, size) >> 12);
  endproperty

  // WRAP start address must be aligned to transfer size (A3.4.1)
  property wrap_addr_aligned(valid, burst, addr, size);
    valid && burst == BURST_WRAP |-> addr == aligned_addr(addr, size);
  endproperty

  //___________ LOCK ___________

  // Exclusive burst length must not exceed 16 transfers (A7.2.4)
  property excl_len(valid, lock, len);
    valid && lock |-> len <= 8'd15;
  endproperty

  // Total bytes in exclusive must be power of 2 (A7.2.4)
  property excl_bytes_pow2(valid, lock, len, size);
    valid && lock |-> $onehot(total_bytes(len, size));
  endproperty

  // Max bytes in exclusive burst is 128 (A7.2.4)
  property excl_max_bytes(valid, lock, len, size);
    valid && lock |-> total_bytes(len, size) <= 128;
  endproperty

  // Exclusive address must be aligned to total transaction bytes (A7.2.4)
  property excl_addr_aligned(valid, lock, addr, len, size);
    valid && lock |-> (addr & (total_bytes(len, size) - 1)) == '0;
  endproperty

  // Exclusive AxCACHE[3:2] must be 0b00 (A7.2.4)
  property excl_cache(valid, lock, cache);
    valid && lock |-> cache[3:2] == 2'b00;
  endproperty

  //___________ CACHE ___________

  // When AxCACHE[1] (Modifiable) is 0, AxCACHE[3:2] must be 0
  // This is the ONLY reserved AxCACHE constraint (Table A4-5, A4.2)
  property cache_non_mod(valid, cache);
    valid && !cache[1] |-> cache[3:2] == 2'b00;
  endproperty


endpackage