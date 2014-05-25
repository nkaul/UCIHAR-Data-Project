# run_analysis.R
# run_analysis.R script performs the following functions on UCI HAR Dataset.
# Downloads the dataset from the links provided in project details
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive activity names. 
# 5. Creates a second, independent tidy data set with the average of each variable for 
# each activity and each subject


## Downloading and obtaining the dataset from the link mentioned
# ------------------------------------------------------------------------------
# create data folder if it does not exist
if (!file.exists("data")) {dir.create("data")}

# download file
harDataUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(harDataUrl, destfile = "./data/UCI_HAR_Dataset.zip", method = "curl")
list.files("./data")

# unzipping files
unzip("./data/UCI_HAR_Dataset.zip", exdir="./data")
list.files("./data/UCI HAR Dataset")


## 1. Merges the training and the test sets to create one data set.
# ------------------------------------------------------------------------------
# importing the activity and featurevariable datasets to create featureVariables and activityLabels data frames
featureVariables <- read.table("./data/UCI HAR Dataset/features.txt", sep="", header=FALSE)
activityLabels <- read.table("./data/UCI HAR Dataset/activity_labels.txt", sep="", header=FALSE)

# updating the column names for activity and featurevariable data frames
colnames(featureVariables) <- c("varId", "varName")
colnames(activityLabels) <- c("activityId", "activityName")

# importing training and test datasets to create xTest, yTest, subjectTest data frames
xTest <- read.table("./data/UCI HAR Dataset/test/X_test.txt", sep="",header=FALSE)
yTest <- read.table("./data/UCI HAR Dataset/test/y_test.txt", sep="", header=FALSE)
subjectTest <- read.table("./data/UCI HAR Dataset/test/subject_test.txt", sep="", header=FALSE)

# importing training and test datasets to create xTrain, yTrain, subjectTrain data frames
xTrain <- read.table("./data/UCI HAR Dataset/train/X_train.txt", sep="", header=FALSE)
yTrain <- read.table("./data/UCI HAR Dataset/train/y_train.txt", sep="", header=FALSE)
subjectTrain <- read.table("./data/UCI HAR Dataset/train/subject_train.txt", sep="", header=FALSE)

# updating the column names for training and test data frames
colnames(xTest) <- featureVariables$varName
colnames(yTest) <- "activityId"
colnames(subjectTest) <- "subjectId"

colnames(xTrain) <- featureVariables$varName
colnames(yTrain) <- "activityId"
colnames(subjectTrain) <- "subjectId"

# Aggregating test data frames into one data frame
testData <- cbind(subjectTest, yTest, xTest)
# Aggregating training data frames into one data frame
trainData <- cbind(subjectTrain, yTrain, xTrain)

# Aggregating and merging test and training data frames in one data frame
AggregateData <- rbind(testData, trainData)


## 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
# ------------------------------------------------------------------------------
# creating a vector of Indexs where mean() and std() exist in column names of AggregateData data frame
# Note this excludes meanFreq()-X measurements or angle measurements where the term mean exists
subsetFeatureVarIndex <- grep("mean\\(\\)|std\\(\\)", names(AggregateData))

# create subset of data based on mean() and std() column indices 
# and also includng first 2 columns which have subjectId and activityId values
subsetAggregateData <- AggregateData[ , c(1,2, subsetFeatureVarIndex)]


# ------------------------------------------------------------------------------
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive activity names. 

# camelcase has been used for R objects created and variable names for data fame to improve readibility
# cleaning the column names to be human readable and more desciptive
# Below script removes "-" and "()" from variables names and replaces mean by Mean and std by Std to get proper 
# camelcase in variable names e.g. "tBodyAcc-mean()-X" is changed to "tBodyAccMeanX" 
names(subsetAggregateData) <- gsub("-", "", names(subsetAggregateData))
names(subsetAggregateData) <- gsub("\\(\\)", "", names(subsetAggregateData))
names(subsetAggregateData) <- gsub("mean", "Mean", names(subsetAggregateData))
names(subsetAggregateData) <- gsub("std", "Std", names(subsetAggregateData))


# below merge of activityLabels and subsetAggregateData adds new column to create a new 
# data.frame with corresponding activityName for each activityID in eacg row
subFinalData <- merge(activityLabels, subsetAggregateData, by="activityId", all=TRUE)

# Below remove the activityId column which is no longer needed because we mapped acitityName 
# to create final data.frame 
finalData <- subset(subFinalData, select = -activityId)


# ------------------------------------------------------------------------------
## 5. Creates a second, independent tidy data set with the average of each variable for 
## each activity and each subject

# Below involves using reshap2 package to reshare data in order to create required tidy dataset
library(reshape2)
# using melt function to reshare data activityName, subjectId and all measurement values
finalDataMelt <- melt(finalData, id.vars=c("activityName", "subjectId"), measure.vars=(names(finalData[3:68])) )

# creating new tidy data.frame avgSujectActivities using cast function to reshare data and provide 
# average of each measurement variable for each activity and each subject
avgSujectActivities <- dcast(finalDataMelt, activityName + subjectId ~variable, mean)

# writng new tidy data.frame "avgSujectActivities" to a text file excluding row names to create
# the required tidy data file 180 observations and 68 columns
# (2 columns for activityName and subjectID and 66 columns for measurement variables) 
write.table(avgSujectActivities, "avgSujectActivities.txt", sep="\t", row.names=FALSE)


