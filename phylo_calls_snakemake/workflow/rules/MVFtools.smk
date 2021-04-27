rule MVFtools_ConvertVCF2MVF:
	input:
	    vcf="data/{chromosome}.vcf"
	output:
	    mvf="data/{chromosome}.mvf"
	conda:
	   "envs/environment.yml"
	shell:
	    "python3 src/mvftools.py ConvertVCF2MVF --vcf {input.vcf} --out {output.mvf}"

rule MVFtools_FilterMVF:
	input:
	   mvf="data/{chromosome}.mvf"
	output:
	   upper_mvf="{chromosome}_upper.mvf"
        conda:
           "envs/environment.yml"
	shell:
	   """python3 mvftools/mvftools.py FilterMVF --actions promotelower
		--mvf {input.mvf}
		--out {output.upper_mvf}"""

rule MVFtools_LegacyTranslateMVF:
	input:
	   upper_mvf="{chromosome}_upper.mvf"
	output:
	   codon_mvf="{chromosome}_codon.mvf"
        conda:
           "envs/environment.yml"
	shell:
	   """python3 mvftools/mvftools.py LegacyTranslateMVF --mvf {input.upper_mvf}
		--out {output.codon_mvf}
		--output-data codon"""

rule MVFtools_InferGroupSpecificAllele:
	input:
	   codon_mvf="{chromosome}_codon.mvf"
	   allelegroups="ACIDIC:LA0436_starmap5.Aligned.out.sorted.bam,LA0429_starmap5.Aligned.out.sorted.bam,LA2933_starmap5.Aligned.out.sorted.bam,LA1322_starmap5.Aligned.out.sorted.bam BASIC:LA1589_starmap5.Aligned.out.sorted.bam,LA2744_starmap5.Aligned.out.sorted.bam,LA2964_starmap5.Aligned.out.sorted.bam,LA1782_starmap5.Aligned.out.sorted.bam,LA4117_starmap5.Aligned.out.sorted.bam --speciesgroups GAL:LA0436_starmap5.Aligned.out.sorted.bam CHE:LA0429_starmap5.Aligned.out.sorted.bam LYC:LA2933_starmap5.Aligned.out.sorted.bam NEO:LA1322_starmap5.Aligned.out.sorted.bam PIM:LA1589_starmap5.Aligned.out.sorted.bam PER:LA2744_starmap5.Aligned.out.sorted.bam PER:LA2964_starmap5.Aligned.out.sorted.bam CHI:LA1782_starmap5.Aligned.out.sorted.bam CHI:LA4117_starmap5.Aligned.out.sorted.bam"
	output:
	   totalcountmatch="outputs/{chromosome}_pH.total"
        conda:
           "envs/environment.yml"
	shell:
	   """python3 mvftools/mvftools.py InferGroupSpecificAllele --mvf {input.codonmvf}
		--allelegroups {input.allelegroups} > {output.totalcountmatch}"""

