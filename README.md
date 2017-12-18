Getting and Cleaning Data Course Project - UCI-HAR Data
=============================

## Requirements:

- Merges the training and the test sets to create one data set.
- Extracts only the measurements on the mean and standard deviation for each measurement.
- Uses descriptive activity names to name the activities in the data set
- Appropriately labels the data set with descriptive variable names.
- From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## Script
run_analysis.R will:
- Download the data from a URL
- Import the data from the files
- Merge the training and test data into one data set
- Properly label the columns with meaningful labels
- Extract columns which contain means or standard deviations
- Replace the label IDs with actual labels
- Then will create a summary data set containing the mean of each column for each subject and activity
- The summary data will be written to a files

The code can be run with:
```
source("run_analysis.R")
```

## Code Book
A code book has been included in CodeBook.md which describes the variables and transformations performed.
