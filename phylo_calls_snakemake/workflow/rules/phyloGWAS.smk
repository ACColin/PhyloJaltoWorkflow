rule ms_simulation:
	output:
	   ms_sim="outputs/ms_sim.txt"
        conda:
           "envs/environment.yml"
	shell:
	   "python3"
	   "conda deactivate"
rule PhyloGWAS_pval:
	inuput:
	   mvf_file=""
	   ms_file=""
	   pattern=""
	   expected_num=""
	output:
	   pval: "phylo_pval_output.txt"
        conda:
           "envs/environment2.yml"
	shell:
	   "conda activate p2.7"
	   "python2 src/phyloGWAS_pval.py --mvf_file {input.mvf_file} --ms_file {input.ms_file} --pattern {input.pattern} --expected_num {input.expected_num} > {output}"

