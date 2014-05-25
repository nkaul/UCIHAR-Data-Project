UCIHAR-Data-Project
===================

Course Project for Gettting &amp; Celaning Data based on Human Activity Recognition Using Smartphones Dataset

This file explains how all of the scripts work and how they are connected.  

Original Data Source
Data for analysis is downloaded from the belwo URL
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip


This repo includes 
run_analysis.R 
This is the script used to perform analysis on raw data to create a tidy datafile called "avgSujectActivities.txt"

Functions of "run_analysis.R" Script
Downloads the dataset from the URL mentioned above and unzips it to create UCI HAR Dataset folder
Imports "test" and "train" datsets and creates data frames from then and then Merges the training and the test sets to create one data frame.
Extracts a subset of data with only the measurements on the mean "mean()" and standard deviation "std()" for each measurement Also excludes meanFreq()-X measurements or angle measurements where the term mean exists resulting in 66 measurement variables.
Updates the variable names in dataframe variable names for data fame to improve readibility
Appropriately labels the data set with descriptive activity names in place of activity Ids
Reshapes dataset to create a data frame with average of each measurement variable for each activity and each subject
Writes new tidy data frame to a text file to create the required tidy data set file of 180 observations and 68 columns(2 columns for activityName and subjectID and 66 columns for measurement variables) 


CodeBook.md
code book describes the variables, the data, and any transformations and work performed to clean up the data.

avgSujectActivities.txt
This is the tidy data file created after after running "run_analysis.R" scipt on the original data downloaded from 
this URL https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
This tidy dataset contains following
180 observations and 68 columns(2 columns for activityName and subjectID and 66 columns for measurement variables)
Each measurement variable column is average value for each combination of subjectId and activityName




