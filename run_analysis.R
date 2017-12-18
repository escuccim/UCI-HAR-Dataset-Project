## Script to download, merge and tidy data set with smart phone and wearable data
## By: Eric Scuccimarra (skooch@gmail.com) 
## 2017-12-18

## Download and unzip the files
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

# make sure the destination directory exists, if not create it
if (!file.exists("data")) {
    dir.create("data")
}

# download the file if it doesn't already exist
if(!file.exists("data/har.zip")){
    download.file(url, destfile="data/har.zip")    
}
# unzip the file if it doesn't exist
if(!file.exists("data/UCI_HAR")){
    unzip("data/har.zip", exdir="data/UCI_HAR")    
}

# clear vars
rm(url)

print("Data downloaded")

## Read the data in, label and merge it

# Read the feature labels so we can use them as column names for data
features <- read.table("data/UCI_HAR/UCI HAR Dataset/features.txt", col.names = c("id", "name"))

# read the activity labels as they will be used later
activity_names <- read.table("data/UCI_HAR/UCI HAR Dataset/activity_labels.txt", col.names = c("id", "label"))

# Import the training data
X_train <- read.table("data/UCI_HAR/UCI HAR Dataset/train/X_train.txt", col.names=features$name)
subject_train  <- read.table("data/UCI_HAR/UCI HAR Dataset/train/subject_train.txt", col.names=c("subject"))
y_train  <- read.table("data/UCI_HAR/UCI HAR Dataset/train/y_train.txt", col.names=c("label"))

# combine the data with the labels
training_data <- cbind(X_train, subject_train, y_train)

# delete the old vars
rm(X_train, subject_train, y_train)

# Import the test data
X_test <- read.table("data/UCI_HAR/UCI HAR Dataset/test/X_test.txt", col.names=features$name)
subject_test  <- read.table("data/UCI_HAR/UCI HAR Dataset/test/subject_test.txt", col.names=c("subject"))
y_test  <- read.table("data/UCI_HAR/UCI HAR Dataset/test/y_test.txt", col.names=c("label"))

# combine the data with the labels
test_data <- cbind(X_test, subject_test, y_test)

# delete the old vars
rm(X_test, subject_test, y_test)

# combine the training and test data
data <- rbind(training_data, test_data)

# delete the old vars to save memory
rm(test_data, training_data, features)

print("Data imported and merged!")


## Extract the mean and std from the data
keep_columns <- grepl("mean|std|^subject$|^y$", names(data))
data <- data[,keep_columns]

# delete the unneeded vars
rm(keep_columns)

print("Non-mean and std columns filtered out")


## Replace the activity codes with names in the classification column
data <- merge(data, activity_names)[-1]
# remove the id column
data$id = NULL

# turn the column into a factor
data$label <- as.factor(data$label)

# clear vars
rm(activity_names)

print("Label IDs replaced with text")

## Replace the column names with human readable names

# extract the names and set them to lowercase
names <- names(data)
names <- tolower(names)

# filter out prefixes
names <- gsub("^t","time-",names)
names <- gsub("^f","frequency-",names)

# replace the abbreviations
names <- gsub("acc", "-acceleration", names)
names <- gsub("mag", "-magnitude", names)

# remove "..."
names <- gsub("[.]+", "-", names)
names <- gsub("-$","",names)

# replace the column names with the cleaned names
names(data) <- names

print("Columns renamed")
rm(names)

## Create new data set with averages for each subject and variable

source("check.packages.R")
# load the function to check if packages are installed

# check that the packages are installed, if not install them
packages <- c("dplyr","tidyr")
check.packages(packages)
rm(packages)

# load the libraries
library(dplyr)
library(tidyr)

# group the data, summarize it, and then gather into a new data set where each row has its value the mean for one variable, one subject and one label
summary_data <- data %>% group_by(subject, label) %>% summarize_all(funs(mean)) %>% gather(variable, value, -label, -subject)

# write the data to a file
write.table(summary_data, file="data/summary_data.txt", row.name=FALSE)
write.table(data, file="data/tidy_data.txt")