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

##Call the PNG Save
png(filename = "plot4.png",width = 480, height = 480,units = "px")

##Build the grid of Charts
par(mfrow=c(2,2))

##Chart 1 Top Left (Plot 2)
plot(power_test$DateTime,power_test$Global_active_power/600,type='l',
     xlab="",ylab="Global Active Power (kilowatts)",yaxt = 'n')
axis(side=2,at=c(0,2,4,6),labesl=c(0,2,4,6))

##Chart 2 Top Right 
plot(power_test$DateTime,power_test$Voltage,type='l',
     xlab="datetime",ylab="Voltage")

##Chart 3 Bottom Left (Plot 3)
plot(power_test$DateTime,power_test$Sub_metering_1,type='l',
     xlab="",ylab="Energy Sub Metering",yaxt = 'n')
lines(power_test$DateTime,power_test$Sub_metering_2, type="l",col='red')
lines(power_test$DateTime,power_test$Sub_metering_3, type="l",col='blue')
axis(side=2,at=c(0,10,20,30),labesl=c(0,10,20,30))
legend("topright",legend=c('Sub Metering 1','Sub Metering 2','Sub Metering 3'),
       lty=1,col=c('black','red','blue'))

##Chart 4 Bottom Right
plot(power_test$DateTime,power_test$Global_reactive_power,type='l',
     xlab="datetime",ylab="Global_reactive_power")

dev.off()