url = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, destfile = "/Users/MarkChrystal/Desktop/R Files/Data/run_analysis.zip", method = "libcurl")
unzip(zipfile="/Users/MarkChrystal/Desktop/R Files/Data/run_analysis.zip",exdir="./R Files/data")

#read in training tables
x_train <- read.table("./R Files/data/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./R Files/data/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./R Files/data/UCI HAR Dataset/train/subject_train.txt")

# Read in testing tables
x_test <- read.table("./R Files/data/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./R Files/data/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./R Files/data/UCI HAR Dataset/test/subject_test.txt")

# Read in features
features <- read.table('./R Files/data/UCI HAR Dataset/features.txt')

# Read in  activity labels
activitylabel = read.table('./R Files/data/UCI HAR Dataset/activity_labels.txt')

##3. Uses descriptive activity names to name the activities in the data set
##4. Appropriately labels the data set with descriptive variable names.

colnames(x_train) <- features[,2] 
colnames(y_train) <-"activityId"
colnames(subject_train) <- "subjectId"
colnames(x_test) <- features[,2] 
colnames(y_test) <- "activityId"
colnames(subject_test) <- "subjectId"
colnames(activitylabel) <- c('activityId','activityType')

##1. Merges the training and the test sets to create one data set.

merge_train <- cbind(y_train, subject_train, x_train)
merge_test <- cbind(y_test, subject_test, x_test)
combined_test_train <- rbind(merge_train, merge_test)

##2. Extracts only the measurements on the mean and standard deviation for each measurement.

column_names <- colnames(combined_test_train)
mean_sd <- (grepl("activityId" , column_names) | 
                   grepl("subjectId" , column_names) | 
                   grepl("mean.." , column_names) | 
                   grepl("std.." , column_names) )
meanNsd <- combined_test_train[ , mean_sd == TRUE]
##4. Appropriately labels the data set with descriptive variable names.
activitynames <- merge(meanNsd, activitylabel,
                              by='activityId',
                              all.x=TRUE)
##5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
tidy_data <- aggregate(. ~subjectId + activityId, activitynames, mean)
tidy_data <- tidy_data[order(tidy_data$subjectId, tidy_data$activityId),]
write.table(tidy_data, "Tidy_Data.txt", row.name=FALSE)
View(tidy_data)
