# You should create one R script called run_analysis.R that does the following. 
# Merges the training and the test sets to create one data set.
# Extracts only the measurements on the mean and standard deviation for each measurement. 
# Uses descriptive activity names to name the activities in the data set
# Appropriately labels the data set with descriptive variable names. 
# From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
library(plyr)
#download file
datedownload <- date()
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20dataset.zip"
download.file(fileUrl,destfile="~/Documents/R/coursera/03_Gettingdata/00_quiz/project.zip",method="curl")
#unzip file
unzip(zipfile="project.zip")
#setting the path
setwd("~/Documents/R/coursera/03_Gettingdata/00_quiz/UCI HAR dataset")

#Read data from the files into the variables

#Read the Activity files
dataActivity.Test  <- read.table(file.path("test" , "Y_test.txt" ),header = FALSE)
dataActivity.Train <- read.table(file.path("train", "Y_train.txt"),header = FALSE)

#Read the Subject files
dataSubject.Train <- read.table(file.path("train", "subject_train.txt"),header = FALSE)
dataSubject.Test  <- read.table(file.path("test" , "subject_test.txt"),header = FALSE)

#Read Fearures files
dataFeatures.Test  <- read.table(file.path("test" , "X_test.txt" ),header = FALSE)
dataFeatures.Train <- read.table(file.path("train", "X_train.txt"),header = FALSE)

## Merge dataset

# Merge data tables by rows

dataSubject <- rbind(dataSubject.Train, dataSubject.Test)
dataActivity<- rbind(dataActivity.Train, dataActivity.Test)
dataFeatures<- rbind(dataFeatures.Train, dataFeatures.Test)

#set names to variables

names(dataSubject)<-c("subject")
names(dataActivity)<- c("activity")
dataFeaturesNames <- read.table(file.path("features.txt"),head=FALSE)
names(dataFeatures)<- dataFeaturesNames$V2

#Merge columns to get the data frame data for all data
dataCombine <- cbind(dataSubject, dataActivity)
data <- cbind(dataFeatures, dataCombine)

#Subset Features by measurements on the mean and standard deviation 
subdataFeaturesNames<-dataFeaturesNames$V2[grep("mean\\(\\)|std\\(\\)", dataFeaturesNames$V2)]
# Subset the data frame data by seleted names of Features
selectedNames<-c(as.character(subdataFeaturesNames), "subject", "activity" )
data<-subset(data,select=selectedNames)

#Read descriptive activity names from “activity_labels.txt”
activityLabels <- read.table(file.path( "activity_labels.txt"),header = FALSE)

# facorize Variale activity in the data frame data using descriptive activity names
data$activity<-factor(data$activity);
data$activity<- factor(data$activity,labels=as.character(activityLabels$V2))

# Appropriately labels the data set with descriptive variable names
# In the former part, variables activity and subject and names of the activities have been labelled using descriptive names.In this part, Names of Feteatures will labelled using descriptive variable names.
# Example: 
# prefix t is replaced by time
# Acc is replaced by Accelerometer
# BodyBody is replaced by Body
names(data)<-gsub("^t", "time", names(data))
names(data)<-gsub("^f", "frequency", names(data))
names(data)<-gsub("Acc", "Accelerometer", names(data))
names(data)<-gsub("Gyro", "Gyroscope", names(data))
names(data)<-gsub("Mag", "Magnitude", names(data))
names(data)<-gsub("BodyBody", "Body", names(data))
names(data)

# In this part,a second, independent tidy data set will be created with the average of each variable for each activity and each subject based on the data set in step 4.

data2<-aggregate(. ~subject + activity, data, mean)
data2<-data2[order(data2$subject,data2$activity),]
#codebook
write.table(data2, file = "tidydata.txt",row.name=FALSE)

 
# The tidy data set a set of variables for each activity and each subject. 10299 instances are split into 180 groups (30 subjects and 6 activities) and 66 mean and standard deviation features are averaged for each group. The resulting data table has 180 rows and 69 columns – 33 Mean variables + 33 Standard deviation variables + 1 Subject( 1 of of the 30 test subjects) + ActivityName + ActivityNum . The tidy data set’s first row is the header containing the names for each column.






