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


dashboardPage(
  dashboardHeader(title = "Poor WEKA"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Confusion matrix", tabName = "confusionMatrix", icon = icon("table")),
      menuItem("Learning curves plot", tabName = "learningCurves", icon = icon("table")),
      menuItem("Datatable", tabName = "dataTable", icon = icon("table"))
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "confusionMatrix",
              fluidRow(
                column(3,
                       selectInput("selectAlgorithm", label = h3("Select algorithm"),
                                   choices = list("Random Forest" = "rf", 
                                                  "Decision Tree" = "dt",
                                                  "Logistic Regression" = "lr", 
                                                  "Neural Network" = "nn"), 
                                   selected = "rf"))
              ),
              fluidRow(
                column(5,
                       plotOutput("confusionMatrix"))
              )),
      tabItem(tabName = "learningCurves",
              fluidRow(
                column(3,
                       checkboxGroupInput("chooseAlgorithms", label = h3("Choose algorithm(s)"),
                                   choices = list("Random Forest" = "rf", 
                                                  "Decision Tree" = "dt",
                                                  "Logistic Regression" = "lr", 
                                                  "Neural Network" = "nn",
                                                  "Support Vector Machine" = "svm"), 
                                   selected = "rf"))
              ),
              fluidRow(
                column(5,
                       plotOutput("learning_curves"))
              )),
      tabItem(tabName = "dataTable",
              fluidRow(
                column(10,
                       DTOutput("dataTableOutput"))
              ),
              fluidRow(
                column(5,
                       plotOutput("selectedRowPlot"))
              ))
    )
  )
)

