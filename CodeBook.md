# CodeBook

This document describes the data transformations in run_analysis.R

Prior to running the script it is assumed that the user has downloaded and
extracted the data.  The script should be run from the working directory of
the extracted data.

## Data overview

The data processed in this script is from the accelerometers from the Samsung Galaxy S smartphone. A full description is available online.

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Here are the data

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

## Data Files

features.file - contains the variable names for the columns used to identify the data

activitylabels.file - factor labels the activities that the test subject performed (SITTING, WALKING, etc)

traindata.file - The set of data that was collected to train the algorithms 

trainlabels.file - The activities that were being performed as part of the training

trainsubjects.file - A unique number identifying the identifyiing the individual training subjects

testdata.file - The test data set that was used to verify the algorithms

testlabels.file - The activities that were being performed as part of the testing

testsubjects.file - A unique number identifying the identifyiing the individual test subjects


## Data Transformations

### Global Data

1) The labels of each of the data columns is extracted from features.file

2) The activity labels (what the person is doing per each measurement)
is extracted from activitylabels.file

3) For the assingment only the average and mean values are needed. A new vector is created
to identify which columns hold average and mean data by identifying only varaibles with 
mean() and std()

### Training Data and Test data

The training and test data is extracted with exactly the same procedure.

1) The activities of what the person was doing is extracted from (train|test)labels.file  This data
is transformed into an ordered factor list with labels using the activity labels from the global
data

2) The identity of the subject is extracted from the subject_(train|test).txt file

3) The measured training data is extracted from the (train|test)data.file.  

4) The NA values from the (train|test)data.file are stripped using the aligndata function.

5) The mean and standard deviation values are extracted from the data using the 
columns from the global data, step 3)

6) The subject number, activity, and measurements are binded into a single data frame.

## Data Merge and Summary

1) The training and test data are merged into one data frame, merge.df.  

2) The data values are grouped by subject and activity.  The data is averaged using the summarize function mean() for each column.

3) The data are written to the file tidydata.txt




