# Setup
setwd("~/Documents/Coursera/DataAnalysis/ExData_Plotting1")
library('RCurl')

#Download and create temp zip file
temp <- getBinaryURL("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip")
con <- file("power.zip", open = "wb")
writeBin(temp, con)
close(con)

#Unzip and read household_power_consumption.txt to data.frame
power <- read.table(unz("power.zip", "household_power_consumption.txt"),
                    sep = ";",
                    header=TRUE)

#Create Date/Time Column
power$DateTime <- as.POSIXct(paste(power$Date, power$Time), format="%d/%m/%Y %H:%M:%S")

#Modify the Date column for subsetting
power$Date <- as.Date(power$Date,'%d/%m/%Y')

#Subset the Dataset
power_test <- subset(power,power$Date >= "2007-02-01" & power$Date <= "2007-02-02")

#Clear out the ?
power_test[,2:9][power_test[,2:9] == "?"] <- NA

#Set the column in question to numeric
power_test$Global_active_power <- as.numeric(power_test$Global_active_power)

#Call the PNG Save and Plot
png(filename = "plot3.png",width = 480, height = 480,units = "px")

plot(power_test$DateTime,power_test$Sub_metering_1,type='l',
     xlab="",ylab="Energy Sub Metering",yaxt = 'n')
lines(power_test$DateTime,power_test$Sub_metering_2, type="l",col='red')
lines(power_test$DateTime,power_test$Sub_metering_3, type="l",col='blue')
axis(side=2,at=c(0,10,20,30),labels=c(0,10,20,30))
legend("topright",legend=c('Sub Metering 1','Sub Metering 2','Sub Metering 3'),
       lty=1,col=c('black','red','blue'))

dev.off()