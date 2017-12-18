## Script to download, merge and tidy data set with smart phone and wearable data
## By: Eric Scuccimarra (skooch@gmail.com) 
## 2017-12-18

## Download and unzip the files
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

# make sure the destination directory exists, if not create it
if (!file.exists("data")) {
    dir.create("data")
}

# download the file
download.file(url, destfile="data/har.zip")
unzip("data/har.zip", exdir="data/UCI_HAR")

## Read the data in

# Read the feature labels so we can use them as column names for data
features <- read.table("data/UCI_HAR/UCI HAR Dataset//features.txt", col.names = c("id", "name"))

# Import the training data
X_train <- read.table("data/UCI_HAR/UCI HAR Dataset/train/X_train.txt", col.names=features$name)
subject_train  <- read.table("data/UCI_HAR/UCI HAR Dataset/train/subject_train.txt", col.names=c("subject"))
y_train  <- read.table("data/UCI_HAR/UCI HAR Dataset/train/y_train", col.names=c("y"))

# combine the data with the labels
training_data <- cbind(X_train, subject_train, y_train)

# Import the test data
X_test <- read.table("data/UCI_HAR/UCI HAR Dataset/test/X_test.txt", col.names=features$name)
subject_test  <- read.table("data/UCI_HAR/UCI HAR Dataset/test/subject_test.txt", col.names=c("subject"))
y_test  <- read.table("data/UCI_HAR/UCI HAR Dataset/test/y_test", col.names=c("y"))

# combine the data with the labels
test_data <- cbind(X_test, subject_test, y_test)

