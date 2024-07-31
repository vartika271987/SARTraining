### For the following line to work, you must have cluster access
### Then you should extract user data.
### Replace user name and CPU usage space by comma
### Add date before each user name

## Read clipboard
data <- read.table("clipboard",sep = ",")

## Rename columns
colnames(data) <- c("Date","User","CPUs")

## Calculate cluster usage percentage by user
data$Percentage <- 100*data$CPUs/sum(data$CPUs)

## Add time stamp
data$Time <- format(strptime(Sys.time(), "%H"),"%H%M")

## Subset data based on top and bottom percentiles
data_top <- subset(data,data$Percentage>quantile(data$Percentage, 0.95))
data_low <- subset(data,data$Percentage<quantile(data$Percentage, 0.95))
data_low <- subset(data_low,data_low$Percentage>quantile(data$Percentage, 0.50)) ## Too many low use users. Filter by 50 percentile

## Add new column
data_top$Status <- "Elite"
data_low$Status <- "Basic"

## Combine again
data_tot <- rbind(data_top,data_low)
## Load necessary libraries
library(ggplot2)

## The elites
p_top <- ggplot(data = data_tot, aes(x=Date,y=Percentage,fill=User)) +
  facet_grid(.~Status) +
  geom_bar(stat="identity", colour="black",position=position_dodge()) +
  ggtitle("Cluster usage \n by top 5 percentile users") +
  xlab("Data (yyyymmdd)") + 
  ylab("Percentage of cluster use (%)")
plot(p_top)