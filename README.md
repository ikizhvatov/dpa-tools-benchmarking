# DPA tools benchmarking

Benchmarking of various tooling for differential power analysis. Very simple so far.

## Tools and configuration

Daredevil: https://github.com/SideChannelMarvels/Daredevil

Jlsca: https://github.com/Riscure/Jlsca

Standard install described in the repositories of these tools.

## Test case 1: Absolute sum all-bit DPA on AES-128

Traceset: aes128_sb_ciph_deadbeefcafebabe1122334455667788.trs (100K traces, 512 float32 samples/trace, 32 byte data)

    $ cd testcase01
    $ ./prepareTraceset.sh
    [... printout ...]
    $ ./run_jlsca.sh
    [... log with timing in the end ...]
    $ ./run_daredevil.sh
    [... log with timing in the end ...]


### Platform 1

i5-3230M 2.6 GHz, 4 GB RAM, 300 GB HDD, Ubuntu 16.04 x64 / Windows 7 x64

#### Tool versions
* Daredevil f27dc64, built with clang 3.8.0-2ubuntu4, run in Ubuntu
* Jlsca 41b7163, run with julia 0.5.2 in Ubuntu

#### Results

| Tool                                        | Time, s |
|:------------------------------------------- |:------- |
| Daredevil 4 threads                         | 980     |
| Jlsca 1 worker, conditional averaging       | 23      |

#### Comments
* Dadredevil 2 threads similar performance