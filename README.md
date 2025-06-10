## PWEKA (Poor WEKA) Dashboard

### [Demo](https://pbalewski.shinyapps.io/PWEKA_Dashboard/)
Hosted on shinyapps.io free version, so can be a little slow.
### Overview
Welcome to the PWEKA (Poor WEKA) Dashboard project!<br />
This repository contains an interactive R Shiny dashboard that allows user to test different classification algorithms, look for attributes distribution, display fancy graphs
and many others. For now functionality can be tested only on one dataset, but maybe in the future we will extend it so it will became OGWEKA;)<br />

## Team Members:
- PBalewski
- WojtekNagorka
## Repository Structure

```plaintext
├── data/
│   ├── AIDS_Classification.csv
├── www/
│   ├── style.css
├── README.md
├── server.R
├── ui.R
```
## Content

- data/: This directory contains the CSV files used in the dashboard.
- www/: This directory contains custom CSS styles for the dashboard.
- server.R: The server logic of the Shiny application.
- ui.R: The user interface definition of the Shiny application.
- README.md: provides an overview of the project.

## [Data](https://www.kaggle.com/datasets/aadarshvelu/aids-virus-infection-prediction)

The dataset for this project includes various health parameters for patients, along with information indicating whether they are infected with the AIDS virus.

## Data Fields
We have updated several attribute names to enhance their clarity and make them more user-friendly.
- time: time to failure or censoring
- treatment: treatment indicator (0 = ZDV only; 1 = ZDV + ddI, 2 = ZDV + Zal, 3 = ddI only)
- age: age (yrs) at baseline
- weight: weight (kg) at baseline
- hemophilia: hemophilia (0=no, 1=yes)
- homosexual_activity: homosexual activity (0=no, 1=yes)
- drugs: history of IV drug use (0=no, 1=yes)
- karnofsky_score: Karnofsky score (on a scale of 0-100)
- oprior: Non-ZDV antiretroviral therapy pre-175 (0=no, 1=yes)
- z30: ZDV in the 30 days prior to 175 (0=no, 1=yes)
- days_before_anti_retrovial: days pre-175 anti-retroviral therapy
- non_white: race (0=White, 1=non-white)
- gender: gender (0=F, 1=M)
- antiretroviral_history: antiretroviral history (0=naive, 1=experienced)
- strat: antiretroviral history stratification (1='Antiretroviral Naive',2='> 1 but <= 52 weeks of prior antiretroviral therapy',3='> 52 weeks)
- symptom: symptomatic indicator (0=asymp, 1=symp)
- treatment_ZDV: treatment indicator (0=ZDV only, 1=others)
- offtrt: indicator of off-trt before 96+/-5 weeks (0=no,1=yes)
- CD4_baseline: CD4 at baseline
- CD4_after_20days: CD4 at 20+/-5 weeks
- CD8_baseline: CD8 at baseline
- CD8_after_20days: CD8 at 20+/-5 weeks
- infected: is infected with AIDS (0=No, 1=Yes)

## Running the Dashboard
To run the dashboard locally, follow these steps (you must have R language installed on your computer):
1. Clone the repository:
 ```bash
git clone https://github.com/PBalewski/DV_Dashboard
cd DV_Dashboard
 ```
2. Install the necessary R packages:
```R
install.packages(c("shiny", "leaflet", "shinydashboard", "ggplot2", "dplyr", "randomForest", "rpart", "nnet", "caret", "mlr", "DT", "DALEX", "shinythemes", "pROC"))
```
3. Run the Shiny app:
```R
shiny::runApp()
```  
  
