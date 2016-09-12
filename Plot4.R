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
## Look for coal sources
is_coal <- grep('[Cc]oal$', data2$EI.Sector)
## Filter out data2 - We need Coal source data
data2 <- data2[is_coal, 1:3]
## We need SCC of coal to filter data1
coal_scc <- data2$SCC
## Based on coal scc, subset data1
coal_data <- subset(data1, data1$SCC %in% coal_scc)

## Add total emissions and group by year
total_coal_emissions_by_year <-
        aggregate(Emissions ~ year, data = coal_data,
                  FUN = sum)

## Plot the data
## Set up plot
par(mfrow = c(1, 1))
## Plot points
with(
        total_coal_emissions_by_year,
        plot(
                year,
                Emissions,
                main = "Total PM2.5 emissions from coal sources in U.S",
                xlab = "Year",
                ylab = "Total PM2.5 emission in tons",
                pch = 19,
                col = "red",
                cex = 2
        )
)
## Connect points with lines
with(total_coal_emissions_by_year,
     lines(year, Emissions, col = "black"))
## Save as a png file
dev.copy(png, "Plot4.png")
## Turn off png device
dev.off()
