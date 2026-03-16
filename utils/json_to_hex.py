#!/usr/bin/env python3
import json
import sys
from pathlib import Path

def convert_to_hex(arch):
    json_path = Path(f"test_vectors_{arch}_100.json")
    if not json_path.exists():
        print(f"Error: {json_path} not found")
        return

    with open(json_path, 'r') as f:
        tests = json.load(f)

    # Output paths
    in_hex = Path(f"{arch}_inputs.hex")
    wt_hex = Path(f"{arch}_weights.hex")
    exp_hex = Path(f"{arch}_expected.hex")

    with open(in_hex, 'w') as fin, open(wt_hex, 'w') as fwt, open(exp_hex, 'w') as fexp:
        print(f"Converting {len(tests)} tests for {arch}...")
        
        for test_idx, test in enumerate(tests):
            # Input Matrix (4x4) -> Flattened 16 lines
            # WS/IS: 16 inputs. OS: 16 inputs?
            # Check data: "input" is list of lists
            inputs = test['input'] # 4x4
            weights = test['weight'] # 4x4
            expected = test['expected'] # 4x4

            # Flatten and write
            # Inputs
            for row in inputs:
                for val in row:
                    fin.write(f"{val & 0xFFFF:04x}\n")
            
            # Weights
            # Note: WS loads weights differently (B matrix).
            # The JSON generator stores them as standard matrices.
            # Verilog TB logic usually loads them linearly.
            for row in weights:
                for val in row:
                    fwt.write(f"{val & 0xFFFF:04x}\n")

            # Expected
            for row in expected:
                for val in row:
                    # Accommodate larger accumulator width (32-bit)
                    fexp.write(f"{val & 0xFFFFFFFF:08x}\n")

    print(f"Generated {in_hex}, {wt_hex}, {exp_hex}")

def main():
    if len(sys.argv) < 2:
        print("Usage: python3 json_to_hex.py [ws|is|os|all]")
        return

    target = sys.argv[1]
    if target == 'all':
        for arch in ['ws', 'is', 'os']:
            convert_to_hex(arch)
    else:
        convert_to_hex(target)

if __name__ == '__main__':
    main()
