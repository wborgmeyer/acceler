### Introduction

This is the programming assignment for Week 4 of "Getting and Cleaning Data"

### How to run

There is a single script titled run_analysis.R that will process the data.
It is assumed that the script will run from the working directory of the data extraction
(i.e "UCI HAR Dataset").  The R script will then process the data from features.txt,
features_info.txt, activity_labels.txt, and the data files in test and train directories.

The summary data, which is the average of each measurement by subject and activity is written to the file tidydata.txt (submitted as part of the assignment).