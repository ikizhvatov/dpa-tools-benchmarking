# DPA tools benchmarking

Very basic so far (runtime to process a traceset), and limited to computational part of DPA.

To clone this repo with the included large datasets you will need [Git-LFS](https://git-lfs.github.com). Without Git-LFS, only pointers to large datasets will be cloned.

Slides from the short talk at the Summer school on real-world crypto and privacy 2017: [floss_dpa_tooling_sibenik.pdf](floss_dpa_tooling_sibenik.pdf)

## Tools and configuration

Daredevil: https://github.com/SideChannelMarvels/Daredevil (GPLv3)

Jlsca: https://github.com/Riscure/Jlsca (GPLv3)

Inspector: https://www.riscure.com/security-tools/inspector-sca (non-free, closed-source)

Standard install described in the repositories/manuals of these tools.

## Test case 1: All-bit CPA on AES-128

Traceset: 100K traces, 512 float32 samples/trace, 32 byte data

### Running

Prepare traceset

    $ cd testcase01
    $ ./prepareTraceset.sh
    
Disable swap to avoid going into swapping

    $ sudo swapoff -a

Run measurements for main Jlsca variants and Daredevil. The timings are output at the end.

    $ ./run_jlsca_condavg.sh
    $ ./run_jlsca_inccpa.sh
    $ ./run_daredevil.sh

Inspector configuration settings included in the repository.

### Results

| Tool                                        | Laptop   | Desktop | Ratio |
|:------------------------------------------- |:-------- |:------- |:----- |
| Jlsca, conditional averaging                | 21       | 12      | 1.8   |
| Jlsca, incremental correlation              | 502      | 228     | 2.2   |
| Inspector 4.12                              | 847      | 377     | 2.3   |
| Daredevil                                   | 980      | 392     | 2.5   |

Runtime in seconds. Ratio shows speedup factor from moving to a more powerful platform. Timing for Jlsca includes Julia interpretor startup time (about 3 to 5 seconds).

### Comments
* Number of threads chosen for fastest execution:
    * for Jlsca, equal to the number of physical cores; for conditional averaging just single thread so far
    * for Daredevil and Inspector, number of physical cores x2 (assuming hyperthreading is on)
* Memory:
    * in Daredevil config, max memory is set to physical RAM size minus 1 GB.
* Windows vs Linux:
    * Jlsca in Windows similar performance to Linux
    * Daredevil on Windows (cygwin build) 30% slower than on Linux

### Platforms

**Laptop**: i5-3230M 2.6 GHz (dual-core), 4 GB 1600 MHz DDR3, HDD, Ubuntu 16.04 x64 / Windows 7 x64

**Desktop**: i7-6700 3.4 GHz (quad-core), 64 GB 2133 MHz DDR4, HDD, Ubunutu 16.04 x64 / Windows 7 x64

TurboBoost is on.

**Tool versions:**
* Daredevil 897f602, built with g++ 5.4.0-6ubuntu1~16.04.5 and run under Linux
* Jlsca 5e002a4, run with julia 0.6.1 under Linux
* Inspector 4.12, run under Windows

Note that the same Jlsca code can run (with minimal additions) on a cluster of machines. This is not included here as it is quite a different setting, but described separately [in this tutorial](https://github.com/ikizhvatov/jlsca-tutorials/blob/master/HPC.md).
