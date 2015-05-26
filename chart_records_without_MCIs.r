# in addition to counting the number of forms each month,
# this graph also displays the forms where the minimum standard dataset 
# is not available 

/* Number and Dataset */
/* 1 ASQ */
/* 2 ASQ:SE */
/* 3 CANS */
/* 4 FAST: Child */
/* 5 FES: Baseline */
/* 6 FES: Faciltator */
/* 7 FES: Follow-Up */
/* 8 FES: Survey */

# read in the data
mdata <- read.table("h://mbg_db_reporting//reports//20150324_records_without_MCIs.csv",
  header=TRUE, sep=",")

  # describe the dataset
library(psych)
describe(mdata)

# load lattice library 
library(lattice)

  
#use zoo package to convert year and month into a date 
#load(zoo)
library(zoo)
mdata$yrmo <- as.yearmon(paste(mdata$SubYear, mdata$SubMonth, sep="-")) 


# add factors for county names
mdata$COUNTY_ID<-factor(mdata$COUNTY_ID,
 levels = c(2, 20, 22, 35, 51, 61),
 labels = c("Allegheny","Crawford","Dauphin","Lackawanna","Philadelphia","Venango"))

# add factors for dataset names
mdata$WhichDataset<-factor(mdata$WhichDataset,
 levels = seq(1, 8, 1),
 labels = c("ASQ", "ASQ:SE", "CANS", "FAST Child", 
	"FES BL", "FES FFS", "FES Follow-Up", "FES Survey"))

# create a date that is in word rather than in decimal format
mdata$timelabels<-as.Date(mdata$yrmo)
mdata$timelabels


### load the package
library(ggplot2)

### load the scales package
library(scales)

## time to make the chart 

 ##saves file as pdf
pdf(file="h://mbg_db_reporting//reports//20150325_records_without_MCI.pdf", paper="letter", height = 10) 

## need to specify legend title to both
## fill and colour,
## as both dimensions are used
p<- ggplot(mdata, aes(x=timelabels, y=NoforCANS))
p + geom_area(aes(colour=WhichDataset, fill=WhichDataset), position='stack') +
	facet_wrap(~ COUNTY_ID, ncol=1, scales="free_y") + 
		labs(x="Submission Month", y="Number of Assessments") +
				scale_fill_discrete(name="Which Asmt.")+
				scale_colour_discrete(name="Which Asmt.")+
			ggtitle("Number of Records \nwithout MCI")+
			scale_x_date(labels=date_format("%m"))

## turn off device			
dev.off()
			