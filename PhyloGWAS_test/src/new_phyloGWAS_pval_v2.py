"""
This script determines if nonsynonymous variants are  enriched for an input 
biallelic site pattern, relative to null simulations in ms. 

Author: Mark Hibbins

Modified from this script written by Meng Wu for Wu et al. 2018 (Moecular Ecology):
https://github.com/wum5/JaltPhylo/blob/master/python_scripts/phyloGWAS_pval.py
"""


import argparse
import numpy as np

def parse_total(total_path):

    """
    Gets relevant info from .total file, which is 
    output from InferGroupSpecificAllele
    """

    total_file = open(total_path, "r")

    for line in total_file:

        line = line.strip().split()
        
        if line[0] == "total_nsyn_codons":
            ns_count = int(line[1])
        elif line[0] == "nonsynonymous_changes":
            ns_expected = int(line[1])

    total_file.close()

    return ns_count, ns_expected


def parse_ms(ms_file, obs_pattern, subset_size):

    """
    Gets trait patterns from ms simulations 
    for samples specified in observed pattern
    """

    #Parse observed trait pattern

    obs_pattern = obs_pattern.split(",")
    obs_pattern_dict = {}

    for pair in obs_pattern:
        pair = pair.split(":")
        obs_pattern_dict[int(pair[0])] = pair[1]


    #Count matching patterns in ms sims 

    sample_counter, subset_tracker, n_matching = 0, 0, 0
    subset_counts = []
    pattern_dict = {}
    obs_keys = obs_pattern_dict.keys()

    with open(ms_file, "r") as sims:

        for line in sims:
    
            line = line.strip().split()

            if subset_tracker >= subset_size:
                subset_counts.append(n_matching)
                n_matching = 0
                subset_tracker = 0

            if len(line) > 0:

                if line[0] == "//":

                    for key in list(pattern_dict):
                        if key not in obs_keys:
                            del pattern_dict[key]

                    if pattern_dict == obs_pattern_dict:
                        n_matching += 1

                    sample_counter = 0
                    pattern_dict = {}
                    subset_tracker += 1

                elif line[0] == "0" or line[0] == "1":
                    sample_counter += 1
                    pattern_dict[sample_counter] = line[0]            



    return(subset_counts)

       
def calc_pval(subset_counts, ns_expected):

    #Calculate p-value
    n_extreme = 0

    for count in subset_counts:
        if count >= int(ns_expected):
            n_extreme += 1

    rank = float(n_extreme)/len(subset_counts)
    pval = 1 - (2*abs(0.5 - rank))

    return(pval, len(subset_counts), subset_counts)

def main():

    parser = argparse.ArgumentParser(description = "PhyloGWAS p-value")
    parser.add_argument("-i", "--total_file", required = True, 
            help = ".total file that InferGroupSpecificAllele writes as output")
    parser.add_argument("-m", "--ms_file", required = True,
            help = "ms simulation output file")
    parser.add_argument("-p", "--pattern", required = True,
            help = "Series of comma-separated ID:state pairs, specifying the trait pattern to be tested")
    args = parser.parse_args()

    ns_count, ns_expected = parse_total(args.total_file)

    subset_counts = parse_ms(args.ms_file, args.pattern, ns_count)
    
    pval, subset_length, subset_counts = calc_pval(subset_counts, ns_expected)

    max_val = max(subset_counts)
    min_val = min(subset_counts)

    print("Expected " + str(ns_expected) + " variants")
    print("In " + str(subset_length) + " simulations:")
    print("Saw as many as " + str(max_val) + " and as few as " + str(min_val))

    if pval > 0:
        print("p = " + str(pval))
    elif pval == 0:
        print("p < " + str(1/len(subset_counts)))


if __name__ == "__main__":
    main()

