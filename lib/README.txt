# How to setup Technology Libraries

1. **Logical Synthesis Library (.db)**:
   - Copy your `.db` files (e.g., `saed32hvt_tt1p05v25c.db`) to:
     `./db/`
   
   - If you don't have one, the script is currently configured to use the Synopsys example library (`lsi_lsc15.db`).

2. **Physical Design Library** (for ICC2):
   - **NDM Format**: If you use ICC2, place `.ndm` directories here.
   - **Milkyway Format**: If you use old ICC, place Milkyway libraries here.
   - Copy them to:
     `./ndm/`

3. **Technology File**:
   - Place `.tf` (Tech File) and `.tluplus` (RC extraction models) in this directory or a `tech` subdirectory.
