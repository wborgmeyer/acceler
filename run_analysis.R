library(dplyr)
###############################################################################
# FILES TO PROCESS
###############################################################################
features.file <- c("features.txt")              # list of columns that is in each data file.
activitylabels.file <- c("activity_labels.txt") # class labels the activity names
traindata.file <- c('train/X_train.txt')        # Training data set
trainlabels.file <- c('train/y_train.txt')      # Training labels
trainsubjects.file <- c('train/subject_train.txt') # Training Subject Data
testdata.file <- c('test/X_test.txt')           # Test data set
testlabels.file <- c('test/y_test.txt')         # Test labels
testsubjects.file <- c('test/subject_test.txt') # Test subjects data

#################################################################################################
# Function -    aligndata
# Description - take each row of data in the data frame and remove the NA values,
#               in the processing compressing the row down to a shorter vector.  
#               Take all of the rows and put them in a new data frame that is returned.
#################################################################################################
aligndata <- function (x.df) {
        newdf <- data.frame()
        datalength <- nrow(x.df)
        #datalength <- 10 #DEBUG
        print(c("Aligning", datalength, "Rows"))
        i <- 1
        while (i <= datalength) {
                r <- as.numeric(x.df[i, ])
                bad <- is.na(r)
                # some lines have wierd line breaks that i can't seem to filter.  When that
                # happens just concatenate the two lines and move on.
                if (sum(!bad) != 561) {
                        print(c("Sum", sum(!bad), "Line", i))
                        r <- c(r, as.numeric(x.df[i+1, ]))
                        i <- i + 1
                }
                bad <- is.na(r)
                newdf <- rbind(newdf, r[!bad])
                i <- i + 1
        }
        names(newdf) <- features.df$colname
        
        newdf
}


# START PROCESSING!!!!!
###############################################################################


###############################################################################
# GLOBAL DATA
# get the column names from features.file
features.df <- read.csv2(features.file, sep = " ", header = FALSE, stringsAsFactors = FALSE)
names(features.df) <- c("colnum", "colname")
# extract only the mean and the standard deviation columns
meanstd.tbl <- filter(features.df, grepl('mean\\(\\)|std\\(\\)', colname))

# Get the activity labels
activity.df <- read.csv(activitylabels.file, sep = " ", header = FALSE, stringsAsFactors = FALSE)


###############################################################################
# TRAINING DATA
# get the label names for train data as factors
trainlabels.df <- read.csv2(trainlabels.file, sep = " ", header = FALSE, stringsAsFactors = FALSE)
activity <- factor(trainlabels.df$V1, c("1", "2", "3", "4", "5", "6"))
levels(activity) <- activity.df$V2

# get the training subject data
subject <- read.csv(trainsubjects.file, header = FALSE)
names(subject) <- c("subject")


# get the train data 1) read from file, 2) align the data 3) filter down to only means and std
# 4) add the type of activity from the labels
traindata.df <- data.frame()
traindata.df <- read.csv(traindata.file, sep = " ", header = FALSE, stringsAsFactors = FALSE)
print(dim(traindata.df))
traindata.df <- aligndata(traindata.df)
traindata.df <- traindata.df[ , meanstd.tbl$colnum]
traindata.df <- cbind(activity, subject, traindata.df) #DEBUG



############################################################################
# TEST DATA
# get the label names for train data as factors
testlabels.df <- read.csv2(testlabels.file, sep = " ", header = FALSE, stringsAsFactors = FALSE)
activity <- factor(testlabels.df$V1, c("1", "2", "3", "4", "5", "6"))
levels(activity) <- activity.df$V2

# get the test subject data
subject <- read.csv(testsubjects.file, header = FALSE)
names(subject) <- c("subject")


# get the test data 1) read from file, 2) align the data 3) filter down to only means and std
# 4) add the type of activity
testdata.df <- data.frame()
testdata.df <- read.csv(testdata.file, sep = " ", header = FALSE, stringsAsFactors = FALSE)
testdata.df <- aligndata(testdata.df)
testdata.df <- testdata.df[ , meanstd.tbl$colnum]

#merge the data
testdata.df <- cbind(activity, subject, testdata.df) #DEBUG
names(subject) <- c("subject")


###############################################################################
# MERGE the training and test data 
###############################################################################
merge.df <- rbind(traindata.df, testdata.df)

###############################################################################
# Create a tidy data set that averages each variable for each activity and subject
###############################################################################
groupdata <- group_by(merge.df, subject, activity)
tidydata <- summarize(groupdata, 
          `Average-tBodyAcc-mean()-X` = mean(`tBodyAcc-mean()-X`),
          `Average-tBodyAcc-mean()-Y` = mean(`tBodyAcc-mean()-Y`),
          `Average-tBodyAcc-mean()-Z` = mean(`tBodyAcc-mean()-Z`),
          `Average-tBodyAcc-std()-X` = mean(`tBodyAcc-std()-X`),
          `Average-tBodyAcc-std()-Y` = mean(`tBodyAcc-std()-Y`),
          `Average-tBodyAcc-std()-Z` = mean(`tBodyAcc-std()-Z`),
          `Average-tGravityAcc-mean()-X` = mean(`tGravityAcc-mean()-X`),
          `Average-tGravityAcc-mean()-Y` = mean(`tGravityAcc-mean()-Y`),
          `Average-tGravityAcc-mean()-Z` = mean(`tGravityAcc-mean()-Z`),
          `Average-tGravityAcc-std()-X` = mean(`tGravityAcc-std()-X`),
          `Average-tGravityAcc-std()-Y` = mean(`tGravityAcc-std()-Y`),
          `Average-tGravityAcc-std()-Z` = mean(`tGravityAcc-std()-Z`),
          `Average-tBodyAccJerk-mean()-X` = mean(`tBodyAccJerk-mean()-X`),
          `Average-tBodyAccJerk-mean()-Y` = mean(`tBodyAccJerk-mean()-Y`),
          `Average-tBodyAccJerk-mean()-Z` = mean(`tBodyAccJerk-mean()-Z`),
          `Average-tBodyAccJerk-std()-X` = mean(`tBodyAccJerk-std()-X`),
          `Average-tBodyAccJerk-std()-Y` = mean(`tBodyAccJerk-std()-Y`),
          `Average-tBodyAccJerk-std()-Z` = mean(`tBodyAccJerk-std()-Z`),
          `Average-tBodyGyro-mean()-X` = mean(`tBodyGyro-mean()-X`),
          `Average-tBodyGyro-mean()-Y` = mean(`tBodyGyro-mean()-Y`),
          `Average-tBodyGyro-mean()-Z` = mean(`tBodyGyro-mean()-Z`),
          `Average-tBodyGyro-std()-X` = mean(`tBodyGyro-std()-X`),
          `Average-tBodyGyro-std()-Y` = mean(`tBodyGyro-std()-Y`),
          `Average-tBodyGyro-std()-Z` = mean(`tBodyGyro-std()-Z`),
          `Average-tBodyGyroJerk-mean()-X` = mean(`tBodyGyroJerk-mean()-X`),
          `Average-tBodyGyroJerk-mean()-Y` = mean(`tBodyGyroJerk-mean()-Y`),
          `Average-tBodyGyroJerk-mean()-Z` = mean(`tBodyGyroJerk-mean()-Z`),
          `Average-tBodyGyroJerk-std()-X` = mean(`tBodyGyroJerk-std()-X`),
          `Average-tBodyGyroJerk-std()-Y` = mean(`tBodyGyroJerk-std()-Y`),
          `Average-tBodyGyroJerk-std()-Z` = mean(`tBodyGyroJerk-std()-Z`),
          `Average-tBodyAccMag-mean()` = mean(`tBodyAccMag-mean()`),
          `Average-tBodyAccMag-std()` = mean(`tBodyAccMag-std()`),
          `Average-tGravityAccMag-mean()` = mean(`tGravityAccMag-mean()`),
          `Average-tGravityAccMag-std()` = mean(`tGravityAccMag-std()`),
          `Average-tBodyAccJerkMag-mean()` = mean(`tBodyAccJerkMag-mean()`),
          `Average-tBodyAccJerkMag-std()` = mean(`tBodyAccJerkMag-std()`),
          `Average-tBodyGyroMag-mean()` = mean(`tBodyGyroMag-mean()`),
          `Average-tBodyGyroMag-std()` = mean(`tBodyGyroMag-std()`),
          `Average-tBodyGyroJerkMag-mean()` = mean(`tBodyGyroJerkMag-mean()`),
          `Average-tBodyGyroJerkMag-std()` = mean(`tBodyGyroJerkMag-std()`),
          `Average-fBodyAcc-mean()-X` = mean(`fBodyAcc-mean()-X`),
          `Average-fBodyAcc-mean()-Y` = mean(`fBodyAcc-mean()-Y`),
          `Average-fBodyAcc-mean()-Z` = mean(`fBodyAcc-mean()-Z`),
          `Average-fBodyAcc-std()-X` = mean(`fBodyAcc-std()-X`),
          `Average-fBodyAcc-std()-Y` = mean(`fBodyAcc-std()-Y`),
          `Average-fBodyAcc-std()-Z` = mean(`fBodyAcc-std()-Z`),
          `Average-fBodyAccJerk-mean()-X` = mean(`fBodyAccJerk-mean()-X`),
          `Average-fBodyAccJerk-mean()-Y` = mean(`fBodyAccJerk-mean()-Y`),
          `Average-fBodyAccJerk-mean()-Z` = mean(`fBodyAccJerk-mean()-Z`),
          `Average-fBodyAccJerk-std()-X` = mean(`fBodyAccJerk-std()-X`),
          `Average-fBodyAccJerk-std()-Y` = mean(`fBodyAccJerk-std()-Y`),
          `Average-fBodyAccJerk-std()-Z` = mean(`fBodyAccJerk-std()-Z`),
          `Average-fBodyGyro-mean()-X` = mean(`fBodyGyro-mean()-X`),
          `Average-fBodyGyro-mean()-Y` = mean(`fBodyGyro-mean()-Y`),
          `Average-fBodyGyro-mean()-Z` = mean(`fBodyGyro-mean()-Z`),
          `Average-fBodyGyro-std()-X` = mean(`fBodyGyro-std()-X`),
          `Average-fBodyGyro-std()-Y` = mean(`fBodyGyro-std()-Y`),
          `Average-fBodyGyro-std()-Z` = mean(`fBodyGyro-std()-Z`),
          `Average-fBodyAccMag-mean()` = mean(`fBodyAccMag-mean()`),
          `Average-fBodyAccMag-std()` = mean(`fBodyAccMag-std()`),
          `Average-fBodyBodyAccJerkMag-mean()` = mean(`fBodyBodyAccJerkMag-mean()`),
          `Average-fBodyBodyAccJerkMag-std()` = mean(`fBodyBodyAccJerkMag-std()`),
          `Average-fBodyBodyGyroMag-mean()` = mean(`fBodyBodyGyroMag-mean()`),
          `Average-fBodyBodyGyroMag-std()` = mean(`fBodyBodyGyroMag-std()`),
          `Average-fBodyBodyGyroJerkMag-mean()` = mean(`fBodyBodyGyroJerkMag-mean()`),
          `Average-fBodyBodyGyroJerkMag-std()` = mean(`fBodyBodyGyroJerkMag-std()`))

write.table(tidydata, file = "tidydata.txt", row.name = FALSE)
