rule ms_simulation:
	output:
	   ms_sim="outputs/ms_sim_{chromosome}.txt"
        conda:
           "envs/environment.yml"
	shell:
	   "./ms_sim_script.sh > {output.ms_sim}"

def get_binary_trait_string(traitstring):
	return config["samples"][traitstring.sample]

rule PhyloGWAS_pval:
	inuput:
	   mvf_file="data/{chromosome}.mvf"
	   ms_file="outputs/ms_sim_{chromosome}.txt"
	   get_binary_trait_string
	   expected_num=""
	output:
	   pval: "phylo_pval_output.txt"
        conda:
           "envs/environment2.yml"
	shell:
	   "conda activate p2.7"
	   "python2 src/phyloGWAS_pval.py --mvf_file {input.mvf_file} --ms_file {input.ms_file} --pattern {input.pattern} --expected_num {input.expected_num} > {output}"

