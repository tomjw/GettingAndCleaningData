Code Description
----------------
The R script, **run_analysis.R**, takes data from the *Human Activity Recognition Using Smartphones Dataset*, 
Version 1.0, ([original Dataset](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip))  
and combines the training and test data to create a data table of the mean and standard deviation
observations of the measurements for the 30 subjects doing 6 activities.  The data table therefore has 180 observations
which covers 88 variables.

The script achieves this by extracting the dataset zip file and then reading in the necessary files.

The numeric codes for activities are lablelled and merged  with the training and test datasets.

A subset of the the two datasets dealing only with variables that are means and standard deviations is
created.  The two data sets are merged and a data table with only 88 variables compared to the 
original 563 is the result.

The aggregate function is then used to find the mean of the variables grouped by subject and activity.

The resulting data table is output to Means_and_SDs_HAR_Data.csv, as shown in the repositiry.

An example plot for one of the variables is also produced.












