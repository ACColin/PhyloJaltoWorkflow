# PhyloGWAS test with the ms command

## Table of content
 * [Outline](#outline)
 * [Dataset](#dataset)
 * [Requirements](#requirements)
 * [Converting branch lengths to coalescent units from an ultrametric phylogeny](#converting-branch-lengths-to-coalescent-units-from-an-ultrametric-phylogeny)
 * [Building the *ms* command ](#building-the-*ms*-command)
 * [Evaluating the significance from *ms* output](#evaluating-significance-from-*ms*-output)

## Outline
The PhyloGWAS test for trait-specific sequence differences uses the program *ms* ([Hudson 2002](https://academic.oup.com/bioinformatics/article/18/2/337/225783)) to determine if the number of nonsynonymous calls that show the same pattern as the trait binaries for the accession groups (from the MVFtools step) is greater than expected under a null hypothesis.
In this tutorial, I will show how to build the *ms* command and define the different arguments used. Then, I will show the use of the PhyloGWAS python script to evaluate the output of the *ms* simulation.

## Dataset
I will be using the non synonymous calls output file on chromosome 1 from the MVFtools tutorial. The simulation requires branch lengths in coalescent units for the 14 accessions. In this case we will be using the best maximum-likelihood quartet-based phylogeny provided by [Pease et al.](https://journals.plos.org/plosbiology/article?id=10.1371/journal.pbio.1002379). 

## Requirements
 * ***ms* program**: Go to the page `http://home.uchicago.edu/~rhudson1/source/mksamples.html`, follow the link to the `ms.folder` and download the file `ms.tar.gz`.
 
## Converting branch lengths to coalescent units from an ultrametric phylogeny
 
This step is not necessary for the eucs data. This part will be developped after building the best ML quartet-based phylogeny. :seedling:
 
## Building the *ms* command
This is what the ms command looks like in the materials and methods of Pease et al.:
![ms_command_script](images/ms_command_script.PNG)

* The first two numerical arguments specify the number of individuals per locus (58) and the number of loci (10^9)
 * In Pease et al. and Wu et al., these very large simulated datasets are partitioned into smaller ones later on to test significance;
 * In our example in tomato chromosome 1, there were 53,748 variable amino acid sites, so this simulated dataset would be broken up into many smaller ones of 53,748 each.
 * `-s 1` means each locus contains an individual variable site; so really, we are simulating 10^9 independent variable sites
 * `-I` is used to specify population structure; since this is a phylogeny, we specify 29 populations with 2 samples from each one (29 2’s)
 * the `-ej` commands are originally used to specify population joining events but in our case this will be translated in speciation times. For example, `-ej 0.6852423 13 12` means that lineage 13 joins to lineage 12 at time 0.6852423
 * To construct these commands, you will need an ultrametric phylogeny of the relevant species, and some way to convert the branch lengths to coalescent units

## Evaluating the significance from *ms* output

Once the *ms* job is done running, I use the *ms* simulation output,  
