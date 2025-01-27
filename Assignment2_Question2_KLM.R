#21:219:220 Fundamentals of Data Visualization, Spring 2021
#Assignment 2 - Question 2
#Kobe Lee Martinez, RUID: 202006380

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
myData <- read.csv("Assignment2Question3Data.csv")
myData
class(myData)
summary(myData)
################################

#2.1(a)
#Replacing the continuous values of these cols. with specific categorical data
#using the factor function; instead of creating new cols., I replaced the existing ones
myData$sex <- factor(myData$sex ,levels=c( 1 , 2 ) ,labels=c( "female" , "male" ) )
myData$died <- factor(myData$died ,levels=c( 1 , 2 ) ,labels=c( TRUE , FALSE ) )
myData$intubed <- factor(myData$intubed ,levels=c( 1 , 2 ) ,labels=c( "yes" , "no" ) )
myData$pneumonia <- factor(myData$pneumonia ,levels=c( 1 , 2 ) ,labels=c( "yes" , "no" ) )
myData$pregnancy <- factor(myData$pregnancy ,levels=c( 1 , 2 ) ,labels=c( "yes" , "no" ) )
myData$diabetes <- factor(myData$diabetes ,levels=c( 1 , 2 ) ,labels=c( "yes" , "no" ) )
myData$copd <- factor(myData$copd ,levels=c( 1 , 2 ) ,labels=c( "yes" , "no" ) )
myData$asthma <- factor(myData$asthma ,levels=c( 1 , 2 ) ,labels=c( "yes" , "no" ) )
myData$inmsupr <- factor(myData$inmsupr ,levels=c( 1 , 2 ) ,labels=c( "yes" , "no" ) )
myData$hypertension <- factor(myData$hypertension ,levels=c( 1 , 2 ) ,labels=c( "yes" , "no" ) )
myData$other_disease <- factor(myData$other_disease ,levels=c( 1 , 2 ) ,labels=c( "yes" , "no" ) )
myData$cardiovascular <- factor(myData$cardiovascular ,levels=c( 1 , 2 ) ,labels=c( "yes" , "no" ) )
myData$obesity <- factor(myData$obesity ,levels=c( 1 , 2 ) ,labels=c( "yes" , "no" ) )
myData$renal_chronic <- factor(myData$renal_chronic ,levels=c( 1 , 2 ) ,labels=c( "yes" , "no" ) )
myData$tobacco <- factor(myData$tobacco ,levels=c( 1 , 2 ) ,labels=c( "yes" , "no" ) )
myData$covid_res <- factor(myData$covid_res ,levels=c( 1 , 2, 3 ) ,labels=c( "yes" , "no", "pending" ) )
myData$contact_other_covid <- factor(myData$contact_other_covid ,levels=c( 1 , 2 ) ,labels=c( "yes" , "no" ) )
myData$icu <- factor(myData$icu ,levels=c( 1 , 2 ) ,labels=c( "yes" , "no" ) )

#calls the improved dataframe, but now contains <NA> values
myData 

#took out the pregnancy col using negative index because this col
#was causing all of the male patients to be erased when clearing <NA> rows
myData <- myData[,-7]
myData
############################################
#2.1(b)
#cleared <NA> rows using complete.cases
complete_myData <- myData[complete.cases(myData),]
complete_myData
#obtained the unique values for sex col to make sure both male and female patients were there
sex_label <- sort(unique(complete_myData$sex))

#2.2(a,b,c)
#Created a generalized linear model based on the died col. and the corresponding cols as predictors
#for died. The function produces the coefficients needed for future predictions
model1 <- glm(died ~ sex + age + obesity + contact_other_covid + diabetes + cardiovascular, 
              data = complete_myData,
              family = "binomial")
#prediction function used to predict death rates based on the values in model1; values >0.5
#will be true and those below will be false
#type response will produce 0&1 for the linear regression
complete_myData$predict1 <- predict(model1, data = complete_myData, type = "response")>0.5
#calculates the accuracy of the prediction
ACC1 <- mean(complete_myData$predict1==complete_myData$died)
#created a function to produce model accuracy based on the model and data
getModelAcc <- function(model, data){
  predicted <- predict(model, data, type = "response")>0.5
  acc = mean(predicted == data$died)
  return(acc)
}



#Returns a vector of random sample values from dataframe
#when running dim function it produces the length
IDX <- sample(1:dim(complete_myData)[1])
#multiplied more (0.6) so that the trainSize can learn more and accurately rep. the data
#rounded so the values are integers and not decimals
trainSize <- round(0.6 * dim(complete_myData)[1])
validationSize <- round(0.4 * dim(complete_myData)[1])

#Creates a subset of random values from the original dataset
trainingData <- complete_myData[IDX[1:trainSize],]
#Creates a data set with rows that are not apart of trainingData data set
validationData <- complete_myData[IDX[(trainSize+1):(trainSize+validationSize)],]

#Created a generalized linear model based on the died col. and the corresponding cols as predictors
#for died. The function produces the coefficients needed for future predictions
model1_1 <- glm(died ~ sex + age + obesity + contact_other_covid + diabetes + cardiovascular, 
              data = trainingData,
              family = "binomial")
#prediction function used to predict death rates based on the values in model1_1; values >0.5
#will be true and those below will be false
#type response will produce 0&1 for the linear regression
predict2 <- predict(model1_1, validationData, type = "response")>0.5

#2.2(d)
#Calculates the accuracy of the data set using the function created above
#stored in an empty vector
ACC <- NULL
ACC[1] <- getModelAcc(model1, complete_myData)
ACC[2] <- getModelAcc(model1_1, validationData)

#Produces False Positive Rates from the data
STEP1 <- sum(predict2 == FALSE & validationData$died == TRUE)
STEP1
RealNeg <- sum(validationData$died == TRUE)
RealNeg
FP <- STEP1/RealNeg
FP

#Produces False Negative Rate from the data
STEP2 <- sum(predict2 == TRUE & validationData$died == FALSE)
STEP2
RealPos <- sum(validationData$died == FALSE)
RealPos
FN <- STEP2/RealPos
FN

#Produces Positive Prediction Values from the data
STEP3 <- sum(predict2 == FALSE & validationData$died == FALSE)
STEP3
totalAlive <- sum(validationData$predict1 == FALSE)
totalAlive
PPV <- STEP3/totalAlive
PPV



#################################################
#2.3
#I created a pdf file named "Assignment2_Question2_KLM.pdf"
pdf_file<-"Assignment2_Question2_KLM.pdf"
pdf_file
#using the cairo_pdf function I edited the dimensions of the 
#pdf file
cairo_pdf(pdf_file,width=20,height=9.35)
par(mfrow=c(1,1), mar=c(7, 7, 7, 7))

#empty plot with specified ranges and titles
plot(x = NULL, y = NULL, xlim = range(seq(0,118,0.01)),
     ylim = c(0,1), ann = TRUE, axes = TRUE, 
     main = "Chances of Surviving COVID-19 With Pre-Existing Health Conditions",
     xlab = "Ages", ylab = "Survival Rate", cex.main=1.7, cex.lab=1.4)
#logistic prediction function used to determine the survival rates based on the quantile values  
prob <- plogis(model1_1$coefficients[1]+model1_1$coefficients[2]+model1_1$coefficients[3]+model1_1$coefficients[4]+model1_1$coefficients[5]+model1_1$coefficients[6]+model1_1$coefficients[7]*seq(0,118,0.01))
#produces the line for males from ages 0-118
lines(seq(0,118,0.01), prob, col = colorsT[2], lwd = 5)
#logistic prediction function used to determine the survival rates based on the quantile values  
probF <- plogis(model1_1$coefficients[1]+model1_1$coefficients[3]+model1_1$coefficients[4]+model1_1$coefficients[5]+model1_1$coefficients[6]+model1_1$coefficients[7]*seq(0,118,0.01))
#produces the line for females from ages 0-118
lines(seq(0,118,0.01), probF, col = colorsT[1], lwd = 5)
#legend (which is color-blind friendly) so viewers can understand that each bar
#reps. a different sex
legend("topright", col = colorsT[1:2], 
       text.font=4, bg='#f7f9fb', cex=1, pch = c(15), pt.cex = 2,
       title="Sex", legend = sex_label)

#closes file and provides URL for plot(concates. to single image)
dev.off()

