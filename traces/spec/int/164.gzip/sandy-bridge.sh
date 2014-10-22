#!/bin/sh
../../../../dineroIV -l1-isize 32k -l1-iassoc 8 -l1-ibsize 64 -l1-irepl l \
-l1-dassoc 8 -l1-dbsize 64 -l1-dsize 32k  -l1-drepl l \
-l2-uassoc 8 -l2-ubsize 64 -l2-usize 256k -l2-urepl l \
-l3-uassoc 8 -l3-ubsize 64 -l3-usize 2m   -l2-urepl l \
-informat s -trname gzip_m2b -maxtrace 1
