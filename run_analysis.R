## Script for combining the test and traing data sets from the UCI HAR Dataset
## Activity and subjects are  matched with results'
## Mean and standard and deviation data are extracted from the results.

## Firstly unzip data
unzip('getdata_projectfiles_UCI HAR Dataset.zip', files = NULL, list = F, overwrite = TRUE,
      junkpaths = FALSE, unzip = "internal",
      setTimes = FALSE)

## read relevant files into as dataframes
trnSub <- read.table('UCI HAR Dataset/train/subject_train.txt')
                  
trnX <- read.table('UCI HAR Dataset/train/X_train.txt')                       

trnY <- read.table('UCI HAR Dataset/train/y_train.txt')                
tstSub <- read.table('UCI HAR Dataset/test/subject_test.txt')

tstX <- read.table('UCI HAR Dataset/test/X_test.txt')

tstY <- read.table('UCI HAR Dataset/test/y_test.txt')
                
features.labels <- read.table('UCI HAR Dataset/features.txt')

activity.labels <- read.table('UCI HAR Dataset/activity_labels.txt')

## add column names to subject and activity frames
colnames(trnSub) <- c("subject")
colnames(tstSub) <- c("subject")
colnames(trnY) <- c("activity")
colnames(tstY) <- c("activity")

## label the factors in the activity dataframes
tstY$activity <- factor(tstY$activity, levels=c(1,2,3,4,5,6),
                labels=c("Walking", "Walking_upstairs",
                         "Walking_downstairs","Sitting",
                         "Standing", "Laying")) 
 
trnY$activity <- factor(trnY$activity, levels = c(1,2,3,4,5,6),
                         labels = c("Walking", "Walking_upstairs",
                                    "Walking_downstairs", "Sitting",
                                    "Standing", "Laying"))

## join the subject, activity and results dataframes togehter by columns 
tst.join <- cbind(tstSub, tstY, tstX)
trn.join <- cbind(trnSub, trnY, trnX) 

## give the columns descriptive names
colnames(trn.join) <-  c("subject", "activity", as.character(features.labels$V2))
colnames(tst.join) <-  c("subject", "activity",as.character(features.labels$V2))

## from dataframe extract only columns dealing with means and standard deviations
tst.join.mean.std <- tst.join[ grep("subject|activity|mean|std|Mean", colnames(tst.join), )]
trn.join.mean.std <- trn.join[ grep("subject|activity|mean|std|Mean", colnames(trn.join), )]

## join test and training data by rows
test.and.trn.mean.std <- rbind(tst.join.mean.std, trn.join.mean.std) 

## calculate mean values for each column ordered by subject and activity
options(warn=-1)

averages <- aggregate(test.and.trn.mean.std, 
                      by = list(  as.factor(test.and.trn.mean.std$subject),
                                  test.and.trn.mean.std$activity),
                     FUN = mean)
options(warn=0)

## some housekeeping to ensure column names make sense and remove an NA column
## after the aggregate function does it thing.

averages2 <- subset(averages, select = -c(activity,subject) )
names(averages2)[names(averages2)=="Group.2"] <- "Activity"
names(averages2)[names(averages2)=="Group.1"] <- "Subject"

## uncomment line below to simplify column names
##names(averages2) <- gsub("-","",names(averages2))

## to write new dataset to file:
# write.table(averages2, file = "Means_and_SDs_HAR_Data.csv",  sep = ",",
#             row.names = FALSE)


##example plot of data below

names(averages2)[names(averages2)=="tBodyAcc-mean()-X"] <- "tBodyacc_MeanX"
library(ggplot2)
print(ggplot(averages2, aes(Subject,tBodyacc_MeanX, colour = Activity)) + geom_point() )
