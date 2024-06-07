## PWEKA (Poor WEKA) Dashboard

### [Demo] TO ADD
Hosted on shinyapps.io free version, so can be a little slow.
### Overview
Welcome to the PWEKA (Poor WEKA) Dashboard project!
This repository contains an interactive R Shiny dashboard that allows user to test different classification algorithms, look for attributes distribution,...
and many others. For now functionality is only for one dataset, but maybe in the future, we will extend it, so it will be equally good or ever better than true WEKA;)
TO FINISH

## Team Members:
- Piotr Balewski - 156037
- Wojciech Nagórka - 156045
## Repository Structure

```plaintext
├── data/
│   ├── AIDS_Classification.csv
├── README.md
├── server.R
├── ui.R
```
## Content

- data/: This directory contains the CSV files used in the dashboard.
- server.R: The server logic of the Shiny application.
- ui.R: The user interface definition of the Shiny application.
- README.md: This file, providing an overview of the project.

## [Data](https://www.kaggle.com/datasets/aadarshvelu/aids-virus-infection-prediction)

The dataset for this project includes various health parameters for patients, along with information indicating whether they are infected with the AIDS virus.

## Data Fields
- time: time to failure or censoring
- trt: treatment indicator (0 = ZDV only; 1 = ZDV + ddI, 2 = ZDV + Zal, 3 = ddI only)
- age: age (yrs) at baseline
- wtkg: weight (kg) at baseline
- hemo: hemophilia (0=no, 1=yes)
- homo: homosexual activity (0=no, 1=yes)
- drugs: history of IV drug use (0=no, 1=yes)
- karnof: Karnofsky score (on a scale of 0-100)
- oprior: Non-ZDV antiretroviral therapy pre-175 (0=no, 1=yes)
- z30: ZDV in the 30 days prior to 175 (0=no, 1=yes)
- preanti: days pre-175 anti-retroviral therapy
- race: race (0=White, 1=non-white)
- gender: gender (0=F, 1=M)
- str2: antiretroviral history (0=naive, 1=experienced)
- strat: antiretroviral history stratification (1='Antiretroviral Naive',2='> 1 but <= 52 weeks of prior antiretroviral therapy',3='> 52 weeks)
- symptom: symptomatic indicator (0=asymp, 1=symp)
- treat: treatment indicator (0=ZDV only, 1=others)
- offtrt: indicator of off-trt before 96+/-5 weeks (0=no,1=yes)
- cd40: CD4 at baseline
- cd420: CD4 at 20+/-5 weeks
- cd80: CD8 at baseline
- cd820: CD8 at 20+/-5 weeks
- infected: is infected with AIDS (0=No, 1=Yes)

## Running the Dashboard
To run the dashboard locally, follow these steps (remember that you need to have R language installed):
1. Clone the repository:
 ```bash
git clone https://github.com/PBalewski/DV_Dashboard
cd DV-Dashboard
 ```
2. Install the necessary R packages:
```R
install.packages(c()) TO DO
```
3. Run the Shiny app:
```R
shiny::runApp()
```  
  
