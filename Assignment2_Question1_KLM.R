#21:219:220 Fundamentals of Data Visualization, Spring 2021
#Assignment 2 - Question 1
#Kobe Lee Martinez, RUID: 202006380

#1.2
#Importing libraries
library(RColorBrewer)
library(GISTools)
library(Cairo)

#Importing color palette from set 2 with all colors in pal.
#gave the color pal. an alpha level of 0.5
colors <- brewer.pal(8, "Set2")
colors
colorsT <- add.alpha(colors, .5)
colorsT

#Setting working directory to desired location
#print a list of files within wd
#importing csv file from wd
#obtaining the class the data from the csv file belongs to
#obtaining a summary of the data from the cvs file
setwd("/Users/kobea/OneDrive/Documents/Rutgers/FDMTLS of Data Vis/coding")
list.files()
myData <- read.csv("Assignment2Question2Data.csv")
myData
class(myData)
summary(myData)
######################################

#1.3(a,b)
#obtaining the unique values within the AgeGroup column
myData.Ages <- sort(unique(myData$AgeGroup))
myData.Ages
#Cleaning out the AgeGroup Col; taking out "All ages, standardized"
#and "All ages, unadjusted"; setting the State to New Jersey 
newData.Ages <- myData[myData$AgeGroup != "All ages, standardized"
                       & myData$AgeGroup != "All ages, unadjusted"
                       & myData$State == "New Jersey",]
#Checking if the unique values "All ages, standardized"
#and "All ages, unadjusted" are removed from AgeGroup col 
Ages <- sort(unique(newData.Ages$AgeGroup))
Ages

#1.1
#Grouped data from the new dataframe by ages 0-49
Ages.below50 <- newData.Ages[newData.Ages$AgeGroup < 50,]
Ages.below50
#Grouped data from the new dataframe by ages 50+
Ages.above50 <- newData.Ages[newData.Ages$AgeGroup >= 50,]
Ages.above50
######################################

#1.3
#obtaining the unique values within the RaceHispanic column
myData.Races <- sort(unique(myData$RaceHispanic))
myData.Races

#created an empty matrix with 4 rows for age groups and
#6 cols for races
Rate1 <- matrix(, nrow = 4, ncol = 6)
#For loop to produce the deaths by population per race from COVID-19
#Compares the races from the col in Ages.below50 to the unique race values in 
#myData.Races, then it produces the difference of covid deaths by population for each race
for(i in 1:length(myData.Races)){
  Races_below <- Ages.below50[Ages.below50$RaceHispanic == myData.Races[i] ,]
  Rate1[, i] <- Races_below$DistributionCovid19Deaths - Races_below$DistributionofPopulation
   
}


#Does the same as the matrix & for loop in lines 56-62
#except this loop is for those 50+
Rate2 <- matrix(, nrow = 4, ncol = 6)

for(i in 1:length(myData.Races)){
  Races_above <- Ages.above50[Ages.above50$RaceHispanic == myData.Races[i] ,]
  Rate2[, i] <- Races_above$DistributionCovid19Deaths - Races_above$DistributionofPopulation
  
}



######################################

#1.3(d)
#I created a pdf file named "Assignment2_Question1_KLM.pdf"
pdf_file<-"Assignment2_Question1_KLM.pdf"
pdf_file
#using the cairo_pdf function I edited the dimensions of the 
#pdf file
cairo_pdf(pdf_file,width=20,height=9.35)
#using the par(), I increased the
#size of the graphs and placed them in 1 row/1 col
par(mfrow=c(1,1), mar=c(7, 5, 4, 1))

#Combined the two matrices into one so that it is easier to understand when plotting
Rate3 <- rbind(Rate1,Rate2)
#Figure Caption for the graph; helps those uniformed about the information to receive a brief summary
text <- "Figure 1:  This graph shows the representation of COVID-19 cases by the populations in NJ as of 09/2020. \nThe positive values are an over-representation of COVID-19 deaths in NJ by the population race distribution.
The negative values are an under-representation of COVID-19 deaths in NJ by the population race distribution.\nAs indicated by the graph, the hispanic and black communities are the most impacted by NJ's opressive medical field."
#bar plot for the combined matrices 
barplot1 <- barplot(Rate3, main = "Racial Biases in COVID-19 Cases by NJ Populations", names.arg = myData.Races, xlab = "Races",
        ylab = "COVID-19 Deaths by Population", col = colorsT[1:8], border = colors[1:8], las = 1, beside = TRUE, space = c(.1,2), ylim = c(-60,50), cex.main=1.7, cex.lab=1.4)
#legend (which is color-blind friendly) so viewers can understand that each bar
#reps. a different age group
legend("topright", col = colorsT, 
       text.font=4, bg='#f7f9fb', cex=1, pch = c(15), pt.cex = 2,
       title="Ages", legend = Ages)
#line which passes through the origin of the graph
abline(h=0, col="blue")
#modifications for the figure caption
mtext(text, side=3, line = 0, cex = 0.8, adj = 0, padj=1)

#closes file and provides URL for plot(concates. to single image)
dev.off()

#Sorry if all the numberings are off, your directions weren't in order