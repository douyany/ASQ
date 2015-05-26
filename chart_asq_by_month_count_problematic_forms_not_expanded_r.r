# in addition to counting the number of forms each month,
# this graph also displays the forms where the minimum standard dataset 
# is not available 

# read in the data
mdata <- read.table("h://mbg_db_reporting//reports//20150330_asq_nonnineMCI_nonminstd_counts.csv",
  header=TRUE, sep=",")
  
##sort the rows 
##as they come into the dataset from the import and local datasets  
mdata<-mdata[order(mdata$CountyID, mdata$SubYear, mdata$SubMonth), ]  
mdata$X<-NULL

## dataset for ASQ:  20150330_asq_nonnineMCI_nonminstd_counts.csv

## finding max value within a county for how many forms
## within the time window

### find the result using tapply
maxofrowsASQ<-tapply(mdata$NumFormsASQ, mdata$CountyID, max)
maxofrowsSE<-tapply(mdata$NumFormsSE, mdata$CountyID, max)

### put result into data frame
### with first column as county id
maxofrows2<-data.frame("CountyID"=names(maxofrowsASQ), maxofrowsASQ)
maxofrows3<-data.frame("CountyID"=names(maxofrowsSE), maxofrowsSE)

library(psych)
describe(maxofrows2)
describe(maxofrows3)

### merge info about max per county 
### back with the rest of the dataset
mdata2<-merge(mdata, maxofrows2, by="CountyID")
mdata3<-merge(mdata2, maxofrows3, by="CountyID")

### closeness of obs from ASQ and ASQ:SE
### create a new column for where the numbers are too close columns will go
mdata3$numstooclose<-NA
mdata3$diffbetASQandSE<-abs(mdata3$NumFormsASQ-mdata3$NumFormsSE)
describe(mdata3$diffbetASQandSE)

### generate percentage of how much the difference between the values is 
### relative to the range of the graph
index<- (!is.na(mdata3$diffbetASQandSE) & !is.na(mdata3$maxofrowsASQ))
head(index)
tail(index)
mdata3$pctdiffbetASQandSE[index]<-(mdata3$diffbetASQandSE[index]/mdata3$maxofrowsASQ[index])
describe(mdata3$pctdiffbetASQandSE)
index<-NULL

### "fill in" the value for the observations
### are too close between the ASQ and ASQ:SE
###
###
### in this way, the graph will be ready to draw the 
### top line when putting all the lines on the graph
index <- mdata3$pctdiffbetASQandSE<.30
mdata3$numstooclose[index]<-mdata3$NumFormsASQ[index]


# create a vector for the values of the labels
# will omit the value, if the value is zero
# will omit the value, if the value is the same as the value in 
mdata3$nonnineMCI[mdata3$nonnineMCI==0] <-NA
mdata3$nonminstd[mdata3$nonminstd==0] <-NA


## look over some rows
head(mdata3)

# if value is the same between the number of non-nine-digit MCI
# and the number of non-min-standard-dataset forms
# it doesn't need to be printed twice
mdata3$sameMCInonstd <-mdata3$nonnineMCI==mdata3$nonminstd
head(mdata3$sameMCInonstd)
tail(mdata3$sameMCInonstd)

# describe the dataset
library(psych)
describe(mdata3)
# all vars are being stored as numbers

# trying to get the graph using reshape . melt
## max of rows will be same within a county 
## should not add any rows to the table
library(reshape2)
mydata<- melt(mdata3, id=c("CountyID", "SubYear", "SubMonth", 
	"maxofrowsASQ", "maxofrowsSE", "sameMCInonstd", "diffbetASQandSE",
	"pctdiffbetASQandSE"))
head(mydata)
tail(mydata)


# load lattice library 
library(lattice)

  
#use zoo package to convert year and month into a date 
#load(zoo)
library(zoo)
mydata$yrmo <- as.yearmon(paste(mydata$SubYear, mydata$SubMonth, sep="-")) 

# add factors for county names
mydata$CountyID<-factor(mydata$CountyID,
 levels = c(2, 20, 22, 35, 51, 61),
 labels = c("Allegheny","Crawford","Dauphin","Lackawanna","Philadelphia","Venango"))

# create a date that is in word rather than in decimal format
mydata$timelabels<-as.Date(mydata$yrmo)
mydata$timelabels

# have labels for Number of Forms be above the point
# have labels for Number of Problematic Forms be below the point
# create a vector 
mydata$pos_vector <- NA
##mydata$pos_vector <- rep(NA, length(mydata$yearmon))
mydata$pos_vector[mydata$variable=="NumFormsASQ"] <- 3
mydata$pos_vector[mydata$variable=="NumFormsSE"] <- 1

## when number is along the top at the max
mydata$pos_vector[mydata$variable=="numstooclose"] <- 3

# change value to "below point" for problematic forms
mydata$pos_vector[mydata$variable %in% c("nonminstd", "nonnineMCI")] <- 1

mydata$pos_vector
#### if there are values for the num of records that are non-min-std,
#### put the y-value of those records' label at -(max)
#### helps stretch out the range of the data,
#### so that the lines will not overlap each other





# create a vector for the values of the labels
# will put the value at -.5(max) on the y-axis, if the value is for non-nine digit MCI 
# will put the value at -(max) on the y-axis,  for non-min std dataset values
# will omit the value, if the value is the same as the value in 

# will use the ASQ (rather than SE) value as the multiplier,
# as ASQ values are usually of higher magnitude
mydata$ylabel_vector <- mydata$value

## where the info is for non-nine MCI
index<- mydata$variable=="nonnineMCI"

mydata$ylabel_vector[index] <- (-.5)*mydata$maxofrowsASQ[index]
index<-NULL

index<- mydata$variable=="nonminstd"
mydata$ylabel_vector[index] <- (-1)*mydata$maxofrowsASQ[index]
index<-NULL

### for the points along the top for the max
### for when values are too close
index<- mydata$variable=="numstooclose"
mydata$ylabel_vector[index] <- (1)*mydata$maxofrowsASQ[index]
index<-NULL

# version of command
# if value for number of records of that type is NA
# will also set location to NA
mydata <-within(mydata, 
	ylabel_vector <-ifelse(is.na(mydata$value), NA, ylabel_vector)
		)

		## will try not to modify the scale anymore
## make y-position farther away from zero for the ASQ values
## trying to make graph more readable
## in the baseline version, did a multiply by 2
## in the second version, added twenty and then multiplied by 2
## mydata$ylabel_vector[mydata$variable=="NumFormsASQ"] <- (mydata$value+20)*2
## want this command to come before the command adding the equals sign

## if scale is going to be drawn at the max amount,
## want to remove the label at the line 
mydata$value[mydata$pctdiffbetASQandSE<.30 & mydata$variable =="NumFormsASQ"]<-""


## change value to "=" if nonMCI is same as nonminstd
mydata$value[mydata$sameMCInonstd & mydata$variable =="nonnineMCI"]<-"="


describe(mydata$ylabel_vector)
head(mydata$ylabel_vector)
tail(mydata$ylabel_vector, n=20)


# set colors for points
## have the number of forms written out in different colors
mydata$pointcolor <- NA
mydata$pointcolor[mydata$variable =="NumFormsASQ"] <-"black"
mydata$pointcolor[mydata$variable =="numstooclose"] <-"black"
mydata$pointcolor[mydata$variable =="NumFormsSE"] <-"burlywood4"
mydata$pointcolor[mydata$variable =="nonminstd"] <-"red"
mydata$pointcolor[mydata$variable =="nonnineMCI"] <-"darkorchid1"
head(mydata$pointcolor)
tail(mydata$pointcolor)
####c("black", "burlywood4", "red", "green3")


# setup for no margins on the legend
# bottom margin is the first number in the sequence
# top margin is the third number in the sequence


 
####
####
####Various iterations of the graph
#### towards the final version of the graph
####
####
# with all the counties on same graph
xyplot(mydata$value ~ mydata$yrmo)
# each county on own graph
xyplot(mydata$value ~ mydata$yrmo |factor(mydata$CountyID) )

# allow each county to have own scale 
xyplot(mydata$value ~ mydata$yrmo |factor(mydata$CountyID),scales=list(relation="free"))

# connect the points of each line 
xyplot(mydata$value ~ mydata$yrmo |factor(mydata$CountyID),scales=list(relation="free"), 
 type="b")

# in a column of six graphs
xyplot(mydata$value ~ mydata$yrmo |factor(mydata$CountyID),scales=list(relation="free"), 
 type="b",  layout = c(1,6))
 
# label x-axis and y-axis
xyplot(mydata$value ~ mydata$yrmo |factor(mydata$CountyID),scales=list(relation="free"), 
 type="b",  layout = c(1,6), xlab="Month", ylab="Num. of Forms")
 
# label x-axis and y-axis, with order of counties in alphabetical order
xyplot(mydata$value ~ mydata$yrmo |factor(mydata$CountyID),scales=list(relation="free"), 
 type="b",  layout = c(1,6), xlab="Month", ylab="Num. of Forms", index.cond=list(c(6, 5, 4, 3, 2, 1)))

 # break data into groups within the panels 
 # the new part #
xyplot(mydata$value ~ mydata$yrmo |factor(mydata$CountyID),
	groups=factor(mydata$variable), 
	scales=list(relation="free"), 
 type="l",   xlab="Month", ylab="Num. of Forms")


 ##saves file as pdf
pdf(file="h://mbg_db_reporting//reports//20150413_ASQbymo_with_issue_records.pdf", paper="letter", height = 10) 
# with the x-axis now uniform across the counties			
# removed the symbols for each point
# do not draw y-axis ticks



xyplot(mydata$ylabel_vector ~ mydata$timelabels |factor(mydata$CountyID),
	groups=factor(mydata$variable), 
   prepanel = function(x, y, subscripts) { 
         list(ylim=extendrange(mydata$ylabel_vector[subscripts], f=.25)) 

       }, 
	   
	   		 labels=mydata$value,
			 key=list( title="Number of", x = .7, y =1, corner = c(0, 0),
			 				text=list(labels=c("ASQ", "ASQ:SE", "No MCI", "Non-Min. Std. Dataset")),
			lines=list(col=c("black", "burlywood4", "darkorchid1", "red"),
				type=c("p", "p", "p", "p")
				),
			border=TRUE,
			 cex=0.5
			 ),
scales=list(
            y=list(relation="free", draw=FALSE )), 
 type="l",  layout = c(1,6), xlab="Month", 
	ylab="Number of Assessments Submitted That Month",
 pch=NA_integer_,
 lty=c(1, 1, 0, 0, 0), 
 main="Number of ASQ and ASQ:SE \nby County and Month",
 index.cond=list(c(6, 5, 4, 3, 2, 1)),
 panel= panel.superpose,
  panel.groups=function(x, y, ..., subscripts) {
               panel.xyplot(x, y, ..., subscripts=subscripts );
               panel.text(mydata$timelabels[subscripts], mydata$ylabel_vector[subscripts], labels=mydata$value[subscripts],  cex=0.8, 
			   offset=1, 
			   	col=mydata$pointcolor[subscripts],
			   position=mydata$pos_vector[subscripts])
			    panel.axis("left", ticks=FALSE, labels=FALSE)
				
            })

## y-value for problematic forms is not getting extended far enough
## for the latter counties


dev.off()
			


 			
			
# trying to draw using plot			
plot(mydata$value , mydata$yrmo 			, type="l")

plot( mydata$yrmo, mydata$value 			, type="l")

# trying to draw using ggplot
library(ggplot2)
p=ggplot( mydata, aes(x=yrmo, y=value)) + geom_line() +
    ggtitle("Growth curve for individual chicks")

	

library(xts) # Will also load zoo
mydata$datxts <- xts(mydata[-1], 
               order.by = as.yearmon(paste(mydata$SubYear, mydata$SubMonth, sep="-")) 
			   

			   
			   
			   
