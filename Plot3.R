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
## Subset "Baltimore City" observations
baltimore <- subset(data1, data1$fips == "24510")

## Add total emissions in the U.S group by year
total_emissions_by_year_type <-
        aggregate(Emissions ~ year + type, data = baltimore,
                  FUN = sum)
## Subset based on type
type_point <- subset(total_emissions_by_year_type, type == "POINT")
type_nonpoint <-
        subset(total_emissions_by_year_type, type == "NONPOINT")
type_onroad <-
        subset(total_emissions_by_year_type, type == "ON-ROAD")
type_nonroad <-
        subset(total_emissions_by_year_type, type == "NON-ROAD")

## Load ggplot2
library(ggplot2)

## Plot points
pl <- ggplot(total_emissions_by_year_type,
             aes(year,
                 Emissions,
                 group = type,
                 color = type)) + geom_point() + geom_line(lwd =
                                                                   2) + labs(title = "Sources of PM2.5 Emissions in Baltimore City", x =
                                                                                     "Year", y = "PM2.5 Emissions in tons")
## Explicitly call print
print(pl)
## Save as a png file
dev.copy(png, "Plot3.png")
## Turn off png device
dev.off()
