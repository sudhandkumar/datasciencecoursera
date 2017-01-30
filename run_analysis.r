## Getting and Cleaning Data Final Quiz

# Read meta data
setwd("C://Users//Sudha Kumar/Documents//Coursera//Gcd//finalquiz//UCI HAR Dataset")
featurelables<-read.table("features.txt")
activitylables<-read.table("activity_labels.txt")

#Read train files

# Setwd 
setwd("C://Users//Sudha Kumar//Documents//Coursera//Gcd//finalquiz//UCI HAR Dataset/train")

#read the train data set
# read the subject of the data set
subject_train<-read.table("subject_train.txt", header= FALSE)

#read the activity that generated the features
activity_train<-read.table("y_train.txt",header= FALSE)

# read accleration and velocity data recorded as 561 features
features_train<-read.table("X_train.txt",header=FALSE)



# Setwd 
setwd("C://Users//Sudha Kumar//Documents//Coursera//Gcd//finalquiz//UCI HAR Dataset/test")


#read the test dataset

subject_test<-read.table("subject_test.txt", header= FALSE)
activity_test<-read.table("y_test.txt",header= FALSE)
features_test<-read.table("X_test.txt",header=FALSE)

#merge the data sets

subject<-rbind(subject_train,subject_test)
activity<-rbind(activity_train,activity_test)
features<-rbind(features_train,features_test)

#Name the columns of the dataset

colnames(subject)= "Subject"
colnames(activity) ="Activity"
# transpose the matrix to column
colnames(features)= t(featurelables[2])

#complete data set
completedata<-cbind(features,activity,subject)

##Part 2 eliminate columns in the dataset where the columns does not have mean or std

#check the dimensions of complete data which should be 10299 563
dim(completedata)

# Selecting columns that  have mean and std as part of the coloumn name

colwmeanStd<-grep("*mean*|*std*",names(completedata),ignore.case=TRUE)

# Subsetting data set to include only columns with mean and std, including activity and subject to the set
extracteddata<-completedata[,c(colwmeanStd,562,563)]


dim(extracteddata) # brings the value 10299,88 

##Part 3 use descriptive activity names

# Replace the 87th activity column with activity label desc

for(i in 1:nrow(extracteddata))
{
  activityno<-extracteddata[i,87]
  extracteddata[i,87]<- as.character(activitylables[activityno,2])
}

#Part 4 Appropriately labels the data set with descriptive variable names

#names(extracteddata)

#Changing the names as following
# t- time,acc-Accrlm, f- freq

# changing t to time
names(extracteddata)<-gsub("^t","time",names(extracteddata))
     
# Changing acc- acclrm (accerelometer)
names(extracteddata)<-gsub("Acc","Acclrm",names(extracteddata))

#changing f- Freg
names(extracteddata)<-gsub("^f","freq",names(extracteddata))


#Part 5 From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
#Sumarizes extractdata by activity and subject summariing average of al columns
resultdf<-extracteddata %>% group_by(Activity,Subject) %>% summarise_each(funs(mean))

write.table(resultdf,file="TidyDataSet.txt")
#Read the tidy data
data<-read.table("TidyDataSet.txt",header=TRUE)
# View the data 
View(data)