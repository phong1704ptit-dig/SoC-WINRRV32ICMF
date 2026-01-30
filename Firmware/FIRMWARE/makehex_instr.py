#!/usr/bin/env python3
#
# Convert binary to 16-bit per line hex file (for $readmemh in 16-bit memory)
#
# Usage: ./bin2hex16.py firmware.bin nwords
#
# Example: ./bin2hex16.py firmware.bin 1024 > firmware.hex

from sys import argv

binfile = argv[1]
nwords = int(argv[2])

with open(binfile, "rb") as f:
    bindata = f.read()

assert len(bindata) < 4 * nwords
assert len(bindata) % 2 == 0  # must be multiple of 16-bit

for i in range(nwords * 2):
    byte_index = i * 2
    if byte_index + 1 < len(bindata):
        lo = bindata[byte_index]
        hi = bindata[byte_index + 1]
        print("%02x%02x" % (hi, lo))
    else:
        print("0000")


# from sys import argv

# binfile = argv[1]
# nwords = int(argv[2])

# with open(binfile, "rb") as f:
#     bindata = f.read()

# assert len(bindata) < 4*nwords
# assert len(bindata) % 4 == 0

# for i in range(nwords):
#     if i < len(bindata) // 4:
#         w = bindata[4*i : 4*i+4]
#         print("%02x%02x%02x%02x" % (w[3], w[2], w[1], w[0]))
#     else:
#         print("0")