# AXI4 ROM WOM

---

AXI4 compatible high-performance ROM and WOM.
For when you need some garbage data source/sink for performance analysis.

### Features

- AXI4 write burst transfers
- supports back-to-back transfers without wait cycles
- always acknowledges write transfers with `BRESP` after `WLAST`

- AXI4 read burst transfers
- correct amount of beats in burst transfer with correct `RLAST` assertion
- read data 8 LSB contain burst beat number, all other MSB are 0



