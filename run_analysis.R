library(dplyr)
library(data.table)
library(tidyr)

filesPath <- "C:/Users/Documents/Data Science Training/Getting and Cleaning Data/UCI HAR Dataset"

# Read subject files
dataSubjectTrain <- tbl_df(read.table(file.path(filesPath, "train", "subject_train.txt")))
dataSubjectTest  <- tbl_df(read.table(file.path(filesPath, "test" , "subject_test.txt" )))

# Read activity files
dataActivityTrain <- tbl_df(read.table(file.path(filesPath, "train", "Y_train.txt")))
dataActivityTest  <- tbl_df(read.table(file.path(filesPath, "test" , "Y_test.txt" )))

#Read data files.
dataTrain <- tbl_df(read.table(file.path(filesPath, "train", "X_train.txt" )))
dataTest  <- tbl_df(read.table(file.path(filesPath, "test" , "X_test.txt" )))

# Merges the training and the test sets to create one data set.

# Merge Activity and Subject files - This will merge the training and the test sets by row binding and rename variables
alldataSubject <- rbind(dataSubjectTrain, dataSubjectTest)
setnames(alldataSubject, "V1", "subject")
alldataActivity<- rbind(dataActivityTrain, dataActivityTest)
setnames(alldataActivity, "V1", "activityNum")

#combine the DATA training and test files
dataTable <- rbind(dataTrain, dataTest)

# Extracts only the measurements on the mean and standard deviation for each measurement
dataFeaturesMeanStd <- grep("mean\\(\\)|std\\(\\)",dataFeatures$featureName,value=TRUE) #var name

# Taking measurements for the mean and standard deviation and add "subject","activityNum"
dataFeaturesMeanStd <- union(c("subject","activityNum"), dataFeaturesMeanStd)
dataTable<- subset(dataTable,select=dataFeaturesMeanStd)

# Uses descriptive activity names to name the activities in the data set
dataTable <- merge(activityLabels, dataTable , by="activityNum", all.x=TRUE)
dataTable$activityName <- as.character(dataTable$activityName)

## create dataTable with variable means sorted by subject and Activity
dataTable$activityName <- as.character(dataTable$activityName)
dataAggr<- aggregate(. ~ subject - activityName, data = dataTable, mean) 
dataTable<- tbl_df(arrange(dataAggr,subject,activityName))

# Appropriately labels the data set with descriptive variable names.
#Names before
head(str(dataTable),2)
# Names after
head(str(dataTable),6)

##write to text file on disk
write.table(dataTable, "TidyData.txt", row.name=FALSE)


