# hardware_df

Hardware Double Fetch Bug detection based on Coccinelle engine

Designed for Linux source files.

1. Introduction of the script files.

 In the root directory, there are 11 script files that are important to know:

 (1)start.sh: Shellscript to start the parsing. This script will clearn the files that are left from the last parsing and invoke the cocci script and python script to parse the source files. Our approach is conducted on 4 stages: identify, switch, refine, and prune. See details from the paper. 

 (2)identify.cocci: The cocci script of stage 1, identity the files double fetching from I/O memory with wrapper functions.

 (3)copy_identified_files.py: Python script to copy the results of stage 1 from the source locations to the same location : stage1_identified/.

 (4)switch.cocci: The cocci script of stage 2, switch the similar wrapper functions with a representative function to reduce the combinatorial cases to match. Results are stored in stage2_switched/.

 (5)refine.cocci: The cocci script of stage 3, refine the matching with additional rules.

 (6)copy_refined_files.py: Python script to copy the refined results of stage 3 from stage2_switched/ to stage3_refined/.

 (7)convert_record.py: Python script to covert the results from string lines to structed python dict, so as to facilitate the removal in stage 4.

 (8)refine.cocci: The cocci script of stage 4, use additional rules to remove false positives. Results are still stored in stage3_refined after false positives are removed.

 (9)tool.py: Helper functions used when handling the results using python.

 (10)print.py: Print the final results in a friendly way.

 (11)README.md: this file.


2. How to use.
(1) Install Coccinelle on the machine.
  Mac OS:  “brew install coccinelle”
  Ubuntu:  “apt-get install coccinelle”

(2) "mkdir testdir" in the root directory of this source code.

(3) Copy the Linux source files that are to be parsed to "testdir".

(3) Run “./start.sh”  for parsing.

(4) See the results by "python print.py", and see the source files from stage3_refined/.

3. Some txt files and subdirectories are created during the procedure, please do not remove them.







