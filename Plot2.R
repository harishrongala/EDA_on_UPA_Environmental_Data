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
total_emissions_by_year <-
        aggregate(baltimore$Emissions,
                  by = list(baltimore$year),
                  FUN = sum)
## Name the total_emissions dataFrame appropriately
names(total_emissions_by_year) <- c("Year", "Total.Emission")

## Set up plot
par(mfrow = c(1, 1))
## Plot points
with(
        total_emissions_by_year,
        plot(
                Year,
                Total.Emission,
                main = "Total PM2.5 emissions in Baltimore City, Maryland",
                xlab = "Year",
                ylab = "Total PM2.5 emission in tons",
                pch = 19,
                col = "red",
                cex = 2
        )
)
## Connect points with lines
with(total_emissions_by_year,
     lines(Year, Total.Emission, col = "black"))
## Save to file
dev.copy(png, "Plot2.png")
## Turn off png device
dev.off()
