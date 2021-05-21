#!/bin/bash/env python


cd /data/w0565/data1/Colin_AC/JaltoProject/GitRepo/PhyloJaltoWorkflow/PhyloGWAS_test/
python3 src/new_phyloGWAS_pval_v2.py -i data/Pease_tomato_pH.total -m ms_sim_tomato_ch1.txt -p 27:0,25:0,21:0,18:0,22:1,14:1,10:1,9:1,8:1 > new_phylogwas_pval_test.txt

