# Getting and Cleaning Data Course Project 

# This block of code will get the list of files 

path_file <- file.path("C:/Users/habim/OneDrive/Desktop/RStudioProgms/GettingAndCleanDataFinalAssignment/UCI HAR Dataset")
files <- list.files(path_file, recursive = TRUE)
print(files)


# Read files and assign them to variables 

activityLabels  <- read.table(file.path(path_file, "activity_labels.txt"), col.names = c("ID", "Activity"))
features <- read.table(file.path(path_file, "features.txt"), col.names = c("Order", "Functions"))
subject_test <- read.table(file.path(path_file, "test/subject_test.txt"), col.names = "Subject" )
subject_train <- read.table(file.path(path_file, "train/subject_train.txt"), col.names = "Subject" )
x_test <- read.table(file.path(path_file, "test/X_test.txt"), col.names = features$Functions )
y_test <- read.table(file.path(path_file, "test/Y_test.txt"), col.names = "ID" )
x_train <- read.table(file.path(path_file, "train/X_train.txt"), col.names = features$Functions )
y_train <- read.table(file.path(path_file, "train/Y_train.txt"), col.names = "ID" )


#Merge the test and training set 

x_data <- rbind(x_train, x_test)
y_data <- rbind(y_train, y_test)
subject_data <- rbind(subject_train,subject_test)
merged_DataSet <- cbind(subject_data, y_data, x_data)
subject_data1 = as.character(subject_data)

#Extracts only the measurements on the mean and standard deviation for each measurement.
library(magrittr)
library(webuse)
library(dplyr)

TidyData <- merged_DataSet %>% select(subject_data1, code, contains("mean"), contains("std"))


TidyData$code <- activities[TidyData$code, 2]


names(TidyData)[2] = "activity"
names(TidyData)<-gsub("Acc", "Accelerometer", names(TidyData))
names(TidyData)<-gsub("Gyro", "Gyroscope", names(TidyData))
names(TidyData)<-gsub("BodyBody", "Body", names(TidyData))
names(TidyData)<-gsub("Mag", "Magnitude", names(TidyData))
names(TidyData)<-gsub("^t", "Time", names(TidyData))
names(TidyData)<-gsub("^f", "Frequency", names(TidyData))
names(TidyData)<-gsub("tBody", "TimeBody", names(TidyData))
names(TidyData)<-gsub("-mean()", "Mean", names(TidyData), ignore.case = TRUE)
names(TidyData)<-gsub("-std()", "STD", names(TidyData), ignore.case = TRUE)
names(TidyData)<-gsub("-freq()", "Frequency", names(TidyData), ignore.case = TRUE)
names(TidyData)<-gsub("angle", "Angle", names(TidyData))
names(TidyData)<-gsub("gravity", "Gravity", names(TidyData))


Data <- TidyData %>%
  group_by(subject, activity) %>%
  summarise_all(funs(mean))
write.table(Data, "Data.txt", row.name=FALSE)
