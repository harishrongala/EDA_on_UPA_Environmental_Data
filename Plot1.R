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

## Add total emissions in the U.S group by year
total_emissions_by_year <-
        aggregate(data1$Emissions, by = list(data1$year), FUN = sum)
## Name the total_emissions dataFrame appropriately
names(total_emissions_by_year) <- c("Year", "Total.Emission")

## Set up plot
par(mfrow = c(1, 1))
## Plot points
with(
        total_emissions_by_year,
        plot(
                Year,
                Total.Emission / 1000,
                main = "Total PM2.5 emissions in U.S",
                xlab = "Year",
                ylab = "Total PM2.5 emission * 1000 in tons",
                pch = 19,
                col = "red",
                cex = 2
        )
)
## Connect points with lines
with(total_emissions_by_year,
     lines(Year, Total.Emission / 1000, col = "black"))
## Save to file
dev.copy(png, "Plot1.png")
## Turn off png device
dev.off()
