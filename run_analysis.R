library(dplyr)
###############################################################################
# FILES TO PROCESS
###############################################################################
features.file <- c("features.txt")              # list of columns that is in each data file.
activitylabels.file <- c("activity_labels.txt") # class labels the activity names
traindata.file <- c('train/X_train.txt')        # Training data set
trainlabels.file <- c('train/y_train.txt')      # Training labels
testdata.file <- c('test/X_test.txt')           # Test data set
testlabels.file <- c('test/y_test.txt')         # Test labels

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
        for (i in 1:datalength) {
                r <- x.df[i, ]
                bad <- is.na(r)
                newdf <- rbind(newdf, r[!bad])
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


# get the train data 1) read from file, 2) align the data 3) filter down to only means and std
# 4) add the type of activity from the labels
traindata.df <- data.frame()
traindata.df <- read.csv(traindata.file, sep = " ", header = FALSE, colClasses = c("numeric"))
traindata.df <- aligndata(traindata.df)
traindata.df <- traindata.df[ , meanstd.tbl$colnum]
traindata.df <- cbind(activity, traindata.df) #DEBUG



############################################################################
# TEST DATA
# get the label names for train data as factors
testlabels.df <- read.csv2(testlabels.file, sep = " ", header = FALSE, stringsAsFactors = FALSE)
activity <- factor(testlabels.df$V1, c("1", "2", "3", "4", "5", "6"))
levels(activity) <- activity.df$V2


# get the test data 1) read from file, 2) align the data 3) filter down to only means and std
# 4) add the type of activity
testdata.df <- data.frame()
testdata.df <- read.csv(testdata.file, sep = " ", header = FALSE, colClasses = c("numeric"))
testdata.df <- aligndata(testdata.df)
testdata.df <- testdata.df[ , meanstd.tbl$colnum]
testdata.df <- cbind(activity, testdata.df) #DEBUG

 
###############################################################################
# MERGE the training and test data 
###############################################################################
merge.df <- rbind(traindata.df, testdata.df)

###############################################################################
# AVERAGE the values and write to disk
###############################################################################
merge.df$activity <- as.numeric(merge.df$activity) #DEBUG
averages <- sapply(merge.df, mean)
write.table(averages, file = "averages.csv", row.name = FALSE)


