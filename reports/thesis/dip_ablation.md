# DiP Plain vs Gated Ablation

| Variant | DC Area | DC Dyn mW | DC Leak mW | Notes |
| --- | ---: | ---: | ---: | --- |
| plain | 34153.043464 | 2.090200 | 0.003057 | no clock gating |
| gated | 17367.671666 | 0.962882 | 0.009444 | selected profile `gated_ultra_mbw8` |

- Selected gated profile: `gated_ultra_mbw8`
- Selected profile power/area: `0.962882` mW / `17367.671666` um^2
- Innovus clock gates: `15`
- Innovus post-route gate sim: `268/268` `PASS`
- Innovus slack: `2.038` ns
