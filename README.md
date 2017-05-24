# DPA tools benchmarking

Benchmarking of various tooling for differential power analysis. Very simple so far.

## Tools and configuration

Daredevil: https://github.com/SideChannelMarvels/Daredevil

Jlsca: https://github.com/Riscure/Jlsca

Standard install described in the repositories of these tools.

Timing for Jlsca includes Julia interpretor startup time (~5 seconds).

## Test case 1: All-bit CPA on AES-128

Traceset: aes128_sb_ciph_deadbeefcafebabe1122334455667788.trs (100K traces, 512 float32 samples/trace, 32 byte data)

Running:

    $ cd testcase01
    $ ./prepareTraceset.sh
    [... printout ...]
    $ ./run_jlsca_condavg.sh
    [... log with timing in the end ...]
    $ ./run_daredevil.sh
    [... log with timing in the end ...]

For memory-greedy Jlsca flavours it is recommended to disable swap:

    @ sudo swapoff -a
    $ ./run_jlsca_noninc.sh
    [... log with timing in the end ...]
    $ ./run_jlsca_inccpa.sh
    [... this will take a lot of time ...]

### Platform 1

i5-3230M 2.6 GHz (2 physical cores), 4 GB RAM, HDD, Ubuntu 16.04 x64

#### Tool versions
* Daredevil f27dc64, built with clang 3.8.0-2ubuntu4
* Jlsca 0fda401, run with julia 0.5.2

#### Results

| Tool                                        | Time, s |
|:------------------------------------------- |:------- |
| Daredevil, 4 threads                        | 980     |
| Jlsca, incremental correlation, 2 threads   | 653     |
| Jlsca, conditional averaging, 1 thread      | 23      |


#### Comments
* Dadredevil with 2 threads takes 985 s
* Jlsca in Windows similar performance to Linux
* Daredevil on Windows (cygwin build) 30% slower than on Linux

### Platform 2

i7-4790K 4.0 GHz (4 physical cores), 32 GB RAM, SSD, Linux Mint 17.3 x64

#### Tool versions
* Daredevil f27dc64, built with clang 3.4-lubuntu3
* Jlsca 41b7163, run with julia 0.5.2 in Linux

#### Results

| Tool                                        | Time, s |
|:------------------------------------------- |:------- |
| Daredevil 4 threads                         | 503     |
| Jlsca 1 worker, conditional averaging       | 14      |
