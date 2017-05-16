# DPA tools benchmarking

Benchmarking of various tooling for differential power analysis

## Tools and configuration

Daredevil: https://github.com/SideChannelMarvels/Daredevil

Jlsca: https://github.com/Riscure/Jlsca

Standard install described in the repositories of these tools.

## Test case 1: AES-128 absolute sum all-bit DPA

Traceset: aes128_sb_ciph_deadbeefcafebabe1122334455667788.trs (100K traces, 512 float32 samples/trace, 32 byte data)

Converstion script into Daredevil split binary format included

Machine: i5-3230M 2.6 GHz, 4 GB RAM, 300 GB HDD, Ubuntu 16.04 x64 / Windows 7 x64

| Tool                                        | Time, s |
|:------------------------------------------- |:------- |
| daredevil (Ubuntu                           | s       |
| Jlsca (Ubuntu)                              |  s      |


