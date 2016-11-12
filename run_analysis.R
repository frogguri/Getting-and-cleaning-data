

# read in all data and labels.

test <- read.table("./test/X_test.txt")
testLabel <- read.table("./test/Y_test.txt", col.names = "activityId")
testSubject <- read.table("./test/subject_test.txt", col.names ="subjectId")
train <- read.table("./train/X_train.txt")
trainLabel <- read.table("./train/y_train.txt", col.names = "activityId")
trainSubject <- read.table("./train/subject_train.txt", col.names="subjectId")
feature <- read.table("./features.txt")
activityLabel <- read.table("./activity_labels.txt", col.names=c("activityId", "activityLabel"))

# merge test and train into one dataset.

colnames(test) = feature[,2]
colnames(train) = feature[,2]
test1 <- cbind(testLabel, testSubject, test)
train1 <- cbind(trainLabel, trainSubject, train)
data <- rbind(test1, train1)

# Extracts only the measurements on the mean and standard deviation for each measurement.
val <- names(data)
dataMeanStd <- data[, c(1, 2, grep("mean", val),grep("std", val))]

# Uses descriptive activity names to name the activities and variables in the dataset.
finalData <-  merge(activityLabel, dataMeanStd, by="activityId", all.y=TRUE)
names(finalData) = gsub("[()]", "", names(finalData))

# creates a new tidy data set with the average of each variable for each activity and each subject.
library(dplyr)
dataAve <- group_by(finalData, activityLabel, subjectId) %>%
        summarise_each(funs(mean))
write.table(dataAve, "data_average.txt", row.name=FALSE)
