
# I am using the below two packages in my code so please install and use these packages in case you want to run my code.
# The read.csv.sql function in the sqldf package reads only the filtered data into R, thereby saving memory.
# The lubridate package is used to manipulate date and time variables.
# data.table package is similar to data.frame but faster with more features.

install.packages("sqldf")
install.packages("lubridate")
install.packages("data.table")
library(lubridate)
library(sqldf)
library(data.table)

# Setup your working directory modify as needed for your environment
# Download the file, unzip it and save it to disk

WD <- c("C:/Users/20537710/Documents/Coursera/Exploratory Data Analysis/Power")
setwd(WD)

fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(fileUrl, destfile = "./household_power_consumption.zip")
unzip("household_power_consumption.zip", overwrite=TRUE)

# Extract the needed data and write it to a Data table, convert all '?' to NA

sql <- "select * from file where Date in ('1/2/2007','2/2/2007')"
powerdata <- data.table(read.csv.sql(file = "household_power_consumption.txt", sql = sql ,sep=";", header=TRUE ))
powerdata[powerdata == "?"] <- NA
                        
# Add a new column to powerdata by combining the Date and Time columns using dmy_hms function from lubridate package

powerdata[,Date_time:=dmy_hms(paste(Date, Time))]
                        
# Draw the histogram to screen copy and save the histogram to disk as plot1.png

hist(powerdata$Global_active_power, main = "Global Active Power",
     xlab = "Global Active Power (kilowatts)", ylab = "Frequency",
     col = "red", cex.main = 0.75, cex.lab = 0.75, cex.axis = 0.75)

dev.copy(png, filename = "plot1.png", units = "px", width = 480, height = 480)
dev.off()

