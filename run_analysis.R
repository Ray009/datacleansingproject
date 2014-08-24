## run_analysis.R 
##
## This script read files with collected data from the accelerometers from the Samsung Galaxy 
## S smartphone as described in the file features._info.txt
##
## Specifically, this file does the follwowing steps:
##
## 1.Merges the training and the test sets to create one data set.
## 2.Extracts only the measurements on the mean and standard deviation for each measurement. 
## 3.Uses descriptive activity names to name the activities in the data set
## 4.Appropriately labels the data set with descriptive variable names.
## 
## All files are assumed to be in the same directory structure as the zip file
## downloaded for the project.


##########################################################################################
## First, extract the features list from features.txt in order to identify the columns
## to be extracted from the data files (i.e mean and std data) and to label the columns

library(data.table)

print("Running run_analysis.R, please wait...")

myfeatures <- read.delim("./UCI HAR Dataset/features.txt", sep = "", header = FALSE )
x <- grep("mean\\(\\)|std\\(\\)",myfeatures[,2], perl=TRUE)
v <- as.vector(myfeatures[,2])
v2 <- v[x]
mycolnames <- sub("\\(\\)","",v2)  # contain the column names to be used
mycolnames <- gsub("-","_",mycolnames)  # contain the column names to be used
mycolclasses <- replace(rep("NULL",nrow(myfeatures)),x,NA) # indicates which column to extract when reading the data

## Read the activity labels file
activity_labels <- read.delim("./UCI HAR Dataset/activity_labels.txt", sep = "", header = FALSE )
colnames(activity_labels) <- c("activity","activity_label")

## Read x_train.txt
x_train <- read.delim("./UCI HAR Dataset/train/X_train.txt", sep = "",  colClasses = mycolclasses, header = FALSE )
colnames(x_train) <- mycolnames

# Add a sequence in order to easily merge later
s1 <- seq(1,nrow(x_train))
x_train <- cbind(x_train, seq=s1)

# Open train subjects ID file
subject_train <- read.delim("./UCI HAR Dataset/train/subject_train.txt", sep = "", header = FALSE )
subject_train <- cbind(subject_train, seq=s1)
colnames(subject_train) <- c("subject_id","seq")
x_train$group <- "TRAIN"

# Merge by seq
x_train <- merge(x_train, subject_train)

# Open activity file
y_train <- read.delim("./UCI HAR Dataset/train/y_train.txt", sep = "", header = FALSE )
y_train <- cbind(y_train, seq=s1)
colnames(y_train) <- c("activity","seq")
x_train <- merge(x_train, y_train)
x_train <- merge(x_train, activity_labels)
x_train <- x_train[order(x_train$seq),]

# Now read the test data set (x_test.txt)
x_test <- read.delim("./UCI HAR Dataset/test/X_test.txt", sep = "",  colClasses = mycolclasses, header = FALSE )
colnames(x_test) <- mycolnames

# Add a sequence in order to easily merge later.  Start sequence at the next available integer
s1 <- seq(nrow(x_train) + 1, nrow(x_train) + nrow(x_test))
x_test <- cbind(x_test, seq=s1)

# open test subjects ID file
subject_test <- read.delim("./UCI HAR Dataset/test/subject_test.txt", sep = "", header = FALSE )
subject_test <- cbind(subject_test, seq=s1)
colnames(subject_test) <- c("subject_id","seq")
x_test$group <- "TEST"

# Merge by seq
x_test <- merge(x_test, subject_test)

# Open activity file to obtain the activity names labels. The activity names labels will be
# used to identify the activity in the data sets, not the number.  This satisfies requirement
# number 3
y_test <- read.delim("./UCI HAR Dataset/test/y_test.txt", sep = "", header = FALSE )
y_test <- cbind(y_test, seq=s1)
colnames(y_test) <- c("activity","seq")
x_test <- merge(x_test, y_test)
x_test <- merge(x_test, activity_labels)
x_test <- x_test[order(x_test$seq),]

# merge test and train datasets
x_alldata <- rbind(x_test, x_train)
x_alldata <- subset(x_alldata, select =-activity)
x_alldata <- x_alldata[order(x_alldata$seq),]
x_alldata <- data.table(x_alldata)

# create second data table with just the averages by subject and activity
x_alldata2 <- x_alldata[, lapply(.SD, mean, na.rm=TRUE), by=c("subject_id","activity_label"), .SDcols=mycolnames] 

# create files with tidy data
write.table(x_alldata,"tidy_all_data.txt",row.name=FALSE)
write.table(x_alldata2,"tidy_avg_data.txt",row.name=FALSE)

print("Files tidy_all_data.txt and tidy_avg_data.txt have been created")
