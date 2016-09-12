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
## Subset "Baltimore City" observations
baltimore <- subset(data1, data1$fips == "24510")

## Find the motor vehicle SCC from data2
is_motor_vehicle <- grep('^[Mm]obile', data2$EI.Sector)
## Filter out data2 - We need motor_vehicle data
motor_vehicle_scc <- data2[is_motor_vehicle, 1:3]
## We are interested only in SCC column
motor_vehicle_scc <- motor_vehicle_scc$SCC
## Subset baltimore data based on motor vehicle scc
baltimore_motor_vehicle <-
        subset(baltimore, baltimore$SCC %in% motor_vehicle_scc)

## Add total emissions in the U.S and group by year
total_motor_vehicle_emissions_by_year <-
        aggregate(Emissions ~ year,
                  data = baltimore_motor_vehicle,
                  FUN = sum)

## Set up plot
par(mfrow = c(1, 1), mar = c(5, 5, 3, 3))
## Plot points
with(
        total_motor_vehicle_emissions_by_year,
        plot(
                year,
                Emissions,
                main = "Total PM2.5 emissions \n from motor vehicles in Baltimore City, Maryland",
                xlab = "Year",
                ylab = "Total PM2.5 emission in tons",
                pch = 19,
                col = "red",
                cex = 2
        )
)
## Connect points with lines
with(total_motor_vehicle_emissions_by_year,
     lines(year, Emissions, col = "black"))
## Save to file
dev.copy(png, "Plot5.png")
## Turn off png device
dev.off()
