# Formal Verification of AXI

```sh
make qverify IP=fifo/dma/xbar
```

Steps:

1. ZIPCPU FIFO
2. ZIPCPU AXI FIFO
3. ZIPCPU Crossbar
4. Other Crossbars?


# ToDo:

- Write
  - W same order as AW
  - W packet should have `aw_len+1` beats, and last
  - In each beat, wstrb should match for narrow bursts. can deassert all wires
  - B same order as W
- Read
  - Per ID, R same order as AR
  - R packet should have `ar_len+1` beats and last