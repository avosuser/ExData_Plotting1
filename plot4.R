
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
                        
# Draw the 4 line and directly save the histogram to disk as plot4.png

png(filename = "plot4.png", units = "px", width = 480, height = 480)

#par(mfrow = c(2,2), mar = c(4, 4, 2, 1))
par(mfrow = c(2,2))



plot(powerdata$Date_time, powerdata$Global_active_power, type = "l", 
     xlab = "",ylab = "Global Active Power",
     cex.lab = 1, cex.axis = 1)

plot(powerdata$Date_time, powerdata$Voltage, type = "l", 
     xlab = "datetime", ylab = "Voltage",
     cex.lab = 1, cex.axis = 1)

plot(powerdata$Date_time, powerdata$Sub_metering_1, type = "n", xlab = "", ylab = "Energy sub metring",
     cex.main = 1, cex.lab = 1, cex.axis = 1)

points(powerdata$Date_time, powerdata$Sub_metering_1, col = "black", type = "l")
points(powerdata$Date_time, powerdata$Sub_metering_2, col = "red", type = "l")
points(powerdata$Date_time, powerdata$Sub_metering_3, col = "blue", type = "l")

legend("topright", lty = c(1, 1, 1), lwd = c (1, 1, 1),  col = c("black", "red", "blue"), 
       c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), bty = "n", cex = 0.75)

plot(powerdata$Date_time, powerdata$Global_reactive_power, type = "l", 
     xlab = "datetime",ylab = "Global_reactive_power",
     cex.lab = 1, cex.axis = 1)


dev.off()

