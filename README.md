# COVID-19 Data Visualization and Analysis

This R project analyzes and visualizes COVID-19 data to uncover racial biases in New Jersey and assess survival rates based on demographics and pre-existing health conditions. The project includes two scripts, `chances_of_survival.R` and `racial_biases.R`, each generating visualizations as PDF files.


## Table of Contents

- [Features](#features)
- [Usage](#usage)
- [Code Structure](#code-structure)
- [Requirements](#requirements)
- [File Output](#file-output)
- [License](#license)
- [Important Note](#important-note)


## Features

- **Racial Bias Analysis**: 

  - Examines disparities in COVID-19 deaths by race in New Jersey populations
    
  - Highlights over- and under-represented racial groups using a bar chart
    
  - Incorporates annotations and legends for clear interpretation of results
    
- **Survival Rate Analysis**: 

  - Evaluates COVID-19 survival rates based on age, gender, and pre-existing conditions
    
  - Uses logistic regression to predict survival probabilities
    
  - Visualizes survival trends through line graphs for males and females
      

## Usage

1. **Prepare the Data**:
   
   - Place the required CSV files (`racial_biases_data.csv`, `chances_of_survival_data.csv`) in the working directory

2. **Run the Scripts**:
   
   - Execute `racial_biases.R` and `chances_of_survival.R` in RStudio or another R environment
   
3. **Generated Outputs**:
   
   - `racial_biases.pdf`: Bar chart analyzing racial biases in COVID-19 deaths
     
   - `chances_of_survival.pdf`: Line graph showing COVID-19 survival rates
     

## Code Structure

- **racial_biases.R**:
  
  - Prepares and cleans data by filtering out irrelevant entries
    
  - Groups data by age and race, calculates biases, and generates a bar chart
    
- **chances_of_survival.R**:
  
   - Cleans and factorizes data to prepare for logistic regression
     
   - Builds models to predict survival rates based on age, gender, and health conditions
     
   - Visualizes predictions in a line graph format
     

## Requirements

- R programming environment (preferably RStudio)
  
- Required R packages:
     
           - `RColorBrewer`

           - `GISTools`

           - `Cairo`

## File Output

- **Visualization PDFs**:

  - `racial_biases.pdf`: A bar chart showing racial biases in COVID-19 deaths in New Jersey
    
  - `chances_of_survival.pdf`: A line graph visualizing survival rates by age and gender
    
- **Example Visualization (Racial Biases)**:

  - Bar chart showcasing over- and under-representation of deaths by racial group
    
  - Clear legends and captions for interpretability

- **Example Visualization (Chances of Survival)**:
 
  - Line graph indicating survival rate trends by age and gender, supported by logistic regression predictions
 

## License

This project is licensed under the MIT License. See the LICENSE file for details.


## Important Note

This project is designed to demonstrate data analysis and visualization techniques using R. It provides insights into the impact of COVID-19 across different populations and highlights critical health-related patterns.
