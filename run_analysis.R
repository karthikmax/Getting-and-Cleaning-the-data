#Getting and Cleaning Data - Project 

library(plyr)

dir = "D:/Coursera/Getting and Cleaning Data/Project/"
url = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url,paste(dir,"data.zip",sep=""))
unzip(paste(dir,"data.zip",sep=""))
dry = setwd(paste(dir,"UCI HAR Dataset",sep=""))

setwd("./Inertial Signals")

# Step 1: Merging training and test sets
########################################

x_train <- read.table(paste(dry,"/train/X_train.txt",sep=""))
y_train <- read.table(paste(dry,"/train/y_train.txt",sep=""))
subject_train <- read.table(paste(dry,"/train/subject_train.txt",sep=""))

x_test <- read.table(paste(dry,"/test/X_test.txt",sep=""))
y_test <- read.table(paste(dry,"/test/y_test.txt",sep=""))
subject_test <- read.table(paste(dry,"/test/subject_test.txt",sep=""))

# create 'x' data set
x_data <- rbind(x_train, x_test)

# create 'y' data set
y_data <- rbind(y_train, y_test)

# create 'subject' data set
subject_data <- rbind(subject_train, subject_test)

# Step 2: Extract only the measurements on the mean and standard deviation for each measurement
###############################################################################################

features <- read.table(paste(dry,"/features.txt",sep=""))

# get only columns with mean() or std() in their names
ftrs_mean_std <- grep("-(mean|std)\\(\\)", features[, 2])

# subset the desired columns
x_data <- x_data[, ftrs_mean_std]

# correct the column names
names(x_data) <- features[ftrs_mean_std, 2]

# Step 3: Use descriptive activity names to name the activities in the data set
###############################################################################

activities <- read.table(paste(dry,"/activity_labels.txt",sep=""))

# update values with correct activity names
y_data[, 1] <- activities[y_data[, 1], 2]

# correcting the column name
names(y_data) <- "activity"

# Step 4: Labelling the data set with descriptive variable names
################################################################

# correcting the column name
names(subject_data) <- "subject"

# binding all the data in one data set
all_data <- cbind(x_data, y_data, subject_data)

# Step 5: Tidy data set with the average of each variable for each activity and each subject
############################################################################################

# 66 <- 68 columns but last two (activity & subject)
avg_data <- ddply(all_data, .(subject, activity), function(x) colMeans(x[, 1:66]))

write.table(avg_data, "averages_data.txt", row.name=FALSE)
