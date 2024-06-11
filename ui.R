#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(leaflet)
library(shinydashboard)
library(ggplot2)
library(dplyr)
library(randomForest)
library(rpart)
library(nnet)
library(caret)
library(mlr)
library(DT)
library(DALEX)
library(shinythemes)
library(pROC)




dashboardPage(
  dashboardHeader(title = "PWEKA (Poor WEKA)"),
  dashboardSidebar(
    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "style.css")
    ),
    sidebarMenu(
      menuItem("Algorithms analizer", tabName = "algorithmsAnalizer", icon = icon("table")),
      menuItem("Dataset analizer", tabName = "dataTable", icon = icon("th")),
      menuItem("Fancy plots vizualizer", tabName = "fancyPlot", icon = icon("chart-line"))
    )
  ),
  dashboardBody(
    includeCSS("www/style.css"),
    tabItems(
      tabItem(tabName = "algorithmsAnalizer",
              fluidRow(
                column(4),
                column(3, h3("Select algorithm to analyze")),
              ),
              fluidRow(
                column(4),
                column(6,
                       selectInput("selectAlgorithm", label = NULL,
                                   choices = list("Random Forest" = "rf", 
                                                  "Decision Tree" = "dt",
                                                  "Logistic Regression" = "lr", 
                                                  "Neural Network" = "nn"), 
                                   selected = "rf"))
              ),
              fluidRow(
                column(7, h3("Confusion matrix")),
                column(5, h3("ROC curve")),
              ),
              fluidRow(
                column(5,
                       plotOutput("confusionMatrix")),
                column(2),
                column(5,
                       plotOutput("ROCcurve"))
              )),
      tabItem(tabName = "dataTable",
              fluidRow(
                column(4),
                column(5, h3("Datatable consisting all patients health data"))
              ),
              fluidRow(
                column(12,
                       DTOutput("dataTableOutput"))),
              fluidRow(
                column(6, 
                       h3("Select attribute to see its distribution")),
                column(6, 
                       h3("Select a record from a table to see the features importance analysis"))
              ),
              fluidRow(
                column(6,
                       selectInput("selectColumn", label = NULL, choices = list(
                         "time" = "time",
                         "treatment" = "treatment",
                         "age" = "age",
                         "weight" = "weight",
                         "hemophilia" = "hemophilia",
                         "homosexual_activity" = "homosexual_activity",
                         "drugs" = "drugs",
                         "karnofsky_score" = "karnofsky_score",
                         "oprior" = "oprior",
                         "z30" = "z30",
                         "days_before_anti_retrovial" = "days_before_anti_retrovial",
                         "non_white" = "non_white",
                         "gender" = "gender",
                         "antiretroviral_history" = "antiretroviral_history",
                         "strat" = "strat",
                         "symptom" = "symptom",
                         "treatment_ZDV" = "treatment_ZDV",
                         "offtrt" = "offtrt",
                         "CD4_baseline" = "CD4_baseline",
                         "CD4_after_20days" = "CD4_after_20days",
                         "CD8_baseline" = "CD8_baseline",
                         "CD8_after_20days" = "CD8_after_20days",
                         "infected" = "infected"),
                         selected = "time")),
                column(6,
                       selectInput("selectAlgorithm2", label = "Select algorithm",
                                   choices = list("Random Forest" = "Random Forest", 
                                                  "Decision Tree" = "Decision Tree",
                                                  "Logistic Regression" = "Logistic Regression", 
                                                  "Neural Network" = "Neural Network"), 
                                   selected = "rf"))
              ),
              fluidRow(
                column(5,
                       plotOutput("selectedColumnPlot")),
                column(1),
                column(5,
                       plotOutput("selectedRowPlot"))
              )),
      tabItem(tabName = "fancyPlot",
              fluidRow(
                column(4),
                column(3, h3("Select attribute to visualize"))
              ),
              fluidRow(
                column(4),
                column(6,
                       selectInput("selectAttribute", label = NULL, choices = list(
                         "time" = "time",
                         "age" = "age",
                         "weight" = "weight",
                         "days_before_anti_retrovial" = "days_before_anti_retrovial",
                         "CD4_baseline" = "CD4_baseline",
                         "CD4_after_20days" = "CD4_after_20days",
                         "CD8_baseline" = "CD8_baseline",
                         "CD8_after_20days" = "CD8_after_20days"),
                         selected = "time"))
              ),
              fluidRow(
                column(5,
                       plotOutput("violinPlot")),
                column(1),
                column(5,
                       plotOutput("Boxplot"))
              )
      ))
  )
)

