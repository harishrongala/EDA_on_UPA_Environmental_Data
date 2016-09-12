## Dataset download link
data_url <-
        "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
## Check if it already exists else download the file
if (!file.exists("pm25_data.zip")) {
        download.file(data_url, "./pm25_data.zip")
}
## Unzip the dataset
unzip("pm25_data.zip")
## Read summary data file
data1 <- readRDS("summarySCC_PM25.rds")
## Read Source classification file
data2 <- readRDS("Source_Classification_Code.rds")
## Subset "Baltimore City" & "Los Angeles County" observations
baltimore_Los_Angeles <-
        subset(data1, data1$fips == "24510" | data1$fips == "06037")
## Replace fips code with city names
baltimore_Los_Angeles$fips[baltimore_Los_Angeles$fips == "24510"] <-
        "Baltimore City"
baltimore_Los_Angeles$fips[baltimore_Los_Angeles$fips == "06037"] <-
        "Los Angeles County"
## Find the motor vehicle SCC from data2
is_motor_vehicle <- grep('^[Mm]obile', data2$EI.Sector)
## Filter out data2 - We need motor_vehicle data
motor_vehicle_scc <- data2[is_motor_vehicle, 1:3]
## We are interested only in SCC column
motor_vehicle_scc <- motor_vehicle_scc$SCC
## Subset baltimore_Los_Angeles data based on motor vehicle scc
baltimore_Los_angeles_motor_vehicle <-
        subset(baltimore_Los_Angeles,
               baltimore_Los_Angeles$SCC %in% motor_vehicle_scc)

## Add total emissions and group by year and fips
total_motor_vehicle_emissions_by_year <-
        aggregate(Emissions ~ year + fips,
                  data = baltimore_Los_angeles_motor_vehicle,
                  FUN = sum)

## Load ggplot2
library(ggplot2)

## Plot points
pl <- ggplot(
        total_motor_vehicle_emissions_by_year,
        aes(year, Emissions, group = fips, color = fips)
) + geom_point() + geom_line(lwd = 2) + labs(title = "Total PM2.5 Emissions \n from motor vehicles in \n Baltimore City and Los Angeles County ", x =
                                                     "Year", y = "PM2.5 in tons")
## Explicitly call print
print(pl)
## Save to file
dev.copy(png, "Plot6.png")
## Turn off png device
dev.off()
