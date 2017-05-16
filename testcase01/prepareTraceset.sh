#!/bin/bash

echo "Unpacking the trs..."
tar xjvf aes128_sb_ciph_deadbeefcafebabe1122334455667788.trs.tar.bz2

echo "Converting the trs into daredevil split binary format..."
julia -e 'using Jlsca.Trs; trs2splitbin(ARGS[1], 1, 16, false)' aes128_sb_ciph_deadbeefcafebabe1122334455667788.trs
mv data_UInt8_100000t.bin aes128_sb_ciph_deadbeefcafebabe1122334455667788.input
mv samples_Float32_100000t.bin aes128_sb_ciph_deadbeefcafebabe1122334455667788.trace
