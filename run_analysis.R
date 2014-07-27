library(data.table)

#fileUrl <- "http://archive.ics.uci.edu/ml/machine-learning-databases/00240/UCI%20HAR%20Dataset.zip"
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = "Dataset.zip", method = "curl")
unzip("Dataset.zip")
testData <- read.table("./UCI HAR Dataset/test/X_test.txt",header=FALSE)
testData_act <- read.table("./UCI HAR Dataset/test/y_test.txt",header=FALSE)
testData_sub <- read.table("./UCI HAR Dataset/test/subject_test.txt",header=FALSE)
trainData <- read.table("./UCI HAR Dataset/train/X_train.txt",header=FALSE)
trainData_act <- read.table("./UCI HAR Dataset/train/y_train.txt",header=FALSE)
trainData_sub <- read.table("./UCI HAR Dataset/train/subject_train.txt",header=FALSE)

# Descriptive activity names
activities <- read.table("./UCI HAR Dataset/activity_labels.txt",header=FALSE,colClasses="character")
testData_act$V1 <- factor(testData_act$V1,levels=activities$V1,labels=activities$V2)
trainData_act$V1 <- factor(trainData_act$V1,levels=activities$V1,labels=activities$V2)

# Appropriate labelling of dataset
features <- read.table("./UCI HAR Dataset/features.txt",header=FALSE,colClasses="character")
colnames(testData)<-features$V2
colnames(trainData)<-features$V2
colnames(testData_act)<-c("Activity")
colnames(trainData_act)<-c("Activity")
colnames(testData_sub)<-c("Subject")
colnames(trainData_sub)<-c("Subject")

# Merge test and training sets into one dataset
testData<-cbind(testData,testData_act)
testData<-cbind(testData,testData_sub)
trainData<-cbind(trainData,trainData_act)
trainData<-cbind(trainData,trainData_sub)
bigData<-rbind(testData,trainData)

# Extract mean and standard deviation
bigData_mean<-sapply(bigData,mean,na.rm=TRUE)
bigData_sd<-sapply(bigData,sd,na.rm=TRUE)

# Tidy dataset with average values
DT <- data.table(bigData)
tidy<-DT[,lapply(.SD,mean),by="Activity,Subject"]
write.table(tidy,file="tidy_dataset.csv",sep=",",row.names = FALSE)
