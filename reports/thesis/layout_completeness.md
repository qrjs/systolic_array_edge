# Layout Completeness

该表回答版图是否完整、是否有 IO、VDD/VSS 如何存在。当前四个数据流都是 block-level hard macro 交付：GDS/DEF 存在，顶层 signal pin 合法放置，VDD/VSS 在 DEF SPECIALNETS 中；但不是 full-chip pad-ring 版图。

## Block-Level Completeness

| Arch | Block Layout | IO Pad Ring | Top Pins | Pads | VDD/VSS | Specialnets | Components | Die um | Core um | Route | Innovus Conn/DRC | Antenna/Data Issues |
| --- | --- | --- | --- | ---: | --- | ---: | ---: | ---: | ---: | --- | --- | ---: |
| WS | PASS | NO | 653/653 legal | 0 | PASS VDD=YES VSS=YES | 2 | 34044 | 213.920 x 212.800 | 197.680 x 196.800 | 18678 nets / 55382 terms | 0v/0w / 0drc | 1 |
| OS | PASS | NO | 654/654 legal | 0 | PASS VDD=YES VSS=YES | 2 | 33053 | 208.880 x 208.000 | 192.640 x 192.000 | 18323 nets / 53741 terms | 0v/0w / 0drc | 0 |
| IS | PASS | NO | 653/653 legal | 0 | PASS VDD=YES VSS=YES | 2 | 33145 | 214.200 x 212.800 | 197.960 x 196.800 | 18727 nets / 55628 terms | 0v/0w / 0drc | 3 |
| DIP | PASS | NO | 650/650 legal | 0 | PASS VDD=YES VSS=YES | 2 | 25751 | 194.180 x 193.600 | 177.940 x 177.600 | 15301 nets / 53169 terms | 0v/0w / 0drc | 5 |

## Tapeout IO Interpretation

| Arch | Status | GDS | DEF | Notes |
| --- | --- | --- | --- | --- |
| WS | BLOCK_ONLY_NO_PAD_RING | PRESENT bytes=16869376 | PRESENT | block-level hard macro; no IO pad ring/ESD/seal ring; VDD/VSS DEF SPECIALNETS present; strict Calibre DRC/LVS tracked separately |
| OS | BLOCK_ONLY_NO_PAD_RING | PRESENT bytes=16633856 | PRESENT | block-level hard macro; no IO pad ring/ESD/seal ring; VDD/VSS DEF SPECIALNETS present; strict Calibre DRC/LVS tracked separately |
| IS | BLOCK_ONLY_NO_PAD_RING | PRESENT bytes=17385472 | PRESENT | block-level hard macro; no IO pad ring/ESD/seal ring; VDD/VSS DEF SPECIALNETS present; strict Calibre DRC/LVS tracked separately |
| DIP | BLOCK_ONLY_NO_PAD_RING | PRESENT bytes=18403328 | PRESENT | block-level hard macro; no IO pad ring/ESD/seal ring; VDD/VSS DEF SPECIALNETS present; strict Calibre DRC/LVS tracked separately |

结论：这些版图已经达到论文中四个数据流在同一后端约束下做 block-level PPA/版图对比的要求；但因为 `IO Pad Ring=NO`，它们还不是可直接封装流片的 full-chip 版图。严格流片前还需要补 IO pad/ESD/power pad/可能的 seal ring，并继续收敛 Calibre DRC/LVS。
