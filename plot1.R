## Set working directory
setwd("~/Documents/Coursera/GettingCleaningData/Project1/ExData_Plotting1")

##Load Library
## RCurl is used to download the zip file
library('RCurl')

##Download and create temp zip file
temp <- getBinaryURL("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip")
con <- file("power.zip", open = "wb")
writeBin(temp, con)
close(con)

##Unzip and read household_power_consumption.txt to data.frame
power <- read.table(unz("power.zip", "household_power_consumption.txt"),
                    sep = ";",
                    header=TRUE)

##Create Date/Time Column
power$DateTime <- as.POSIXct(paste(power$Date, power$Time), format="%d/%m/%Y %H:%M:%S")

##Modify the Date column for subsetting
power$Date <- as.Date(power$Date,'%d/%m/%Y')

##Subset the Dataset
power_test <- subset(power,power$Date >= "2007-02-01" & power$Date <= "2007-02-02")

##Clear out the ?
power_test[,2:9][power_test[,2:9] == "?"] <- NA

##Set the column in question to numeric
power_test$Global_active_power <- as.numeric(power_test$Global_active_power)

##Call the PNG Save and Plot
png(filename = "plot1.png",width = 480, height = 480,units = "px")

hist(power_test$Global_active_power/600, breaks=12,col="red",main="Global Active Power",
     xlab="Global Active Power (kilowatts)",ylab="Frequency",ylim=c(0,1200),xlim=c(0,6),xaxt="n")
axis(side=1,at=c(0,2,4,6),labels=c(0,2,4,6))

dev.off()
