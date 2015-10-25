# Merge test and training datasets into one set

# setwd("d:/coursera/gcd_project/UCI HAR Dataset")

xtest <- read.table("UCI HAR Dataset/test/X_test.txt", header=FALSE)
ytest <- read.table("UCI HAR Dataset/test/y_test.txt", header=FALSE)
stest <- read.table("UCI HAR Dataset/test/subject_test.txt", header=FALSE)
xtrain <- read.table("UCI HAR Dataset/train/X_train.txt", header=FALSE)
ytrain <- read.table("UCI HAR Dataset/train/y_train.txt", header=FALSE)
strain <- read.table("UCI HAR Dataset/train/subject_train.txt", header=FALSE)
act_labels <- read.table("UCI HAR Dataset/activity_labels.txt", header=FALSE)
colnames(act_labels) <- c("Activity","ActivityDescription")

features <- read.table("features.txt", header=FALSE, colClasses=c("NULL", "character"))


# Set column names based on features.txt and create a new 'set' column containing
# either 'test' or 'train' to identify the source dataset.
# Also only keep variables mean() and std()

cnames <- unlist(features, use.names=FALSE)
colnames(xtest) <- cnames
colnames(xtrain) <- cnames

xtest <- xtest[ ,grepl("mean\\(|std\\(", names(xtest))]
xtrain <- xtrain[ ,grepl("mean\\(|std\\(", names(xtrain))]
xtest$set <- rep("test", nrow(xtest))
xtrain$set <- rep("train", nrow(xtrain))


# Tack on a column for the activity ID from ytest / ytrain

colnames(ytest) <- c("Activity")
colnames(ytrain) <- c("Activity")
xtest <- cbind(xtest, ytest)
xtrain <- cbind(xtrain, ytrain)


# Tack on a column for the subject ID from stest / strain

colnames(stest) <- c("Subject")
colnames(strain) <- c("Subject")
xtest <- cbind(xtest, stest)
xtrain <- cbind(xtrain, strain)


# Merge testing and training data

alldata <- rbind(xtest, xtrain)


# Create ActivityDescription column by merging with act_labels

alldata <- merge(alldata, act_labels, by = "Activity")


# Calculate average for each variable by activity and subject

library(plyr)
summary <- ddply(alldata,c("Subject","ActivityDescription"),numcolwise(mean))


# write to output text file

write.table(summary, file="output.txt", row.names=FALSE)
