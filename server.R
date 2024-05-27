#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(leaflet)
library(ggplot2)
library(dplyr)
library(shinydashboard)
library(randomForest)
library(rpart)
library(nnet)
library(caret)
library(mlr)
library(e1071)
library(pROC)
library(plotly)

install.packages("mlr")

function(input, output, session) {
  
  data <- read.csv("./data/AIDS_Classification.csv")
  set.seed(42)
  sample_index <- sample(1:nrow(data), 0.7 * nrow(data))
  train_data <- data[sample_index, ]
  test_data <- data[-sample_index, ]
  train_data$infected <- as.factor(train_data$infected)
  test_data$infected <- as.factor(test_data$infected)
  
  model_predictions <- reactive({
    input_model <- input$selectAlgorithm
    
    if (input_model == "rf") {
      rf_model <- randomForest(infected ~ ., data = train_data, ntree = 100)
      predictions <- predict(rf_model, newdata = test_data)
    } else if (input_model == "dt") {
      tree_model <- rpart(infected ~ ., data = train_data, method = "class")
      predictions <- predict(tree_model, newdata = test_data, type = "class")
    } else if (input_model == "lr") {
      logistic_model <- glm(infected ~ ., data = train_data, family = binomial)
      logistic_predictions <- predict(logistic_model, newdata = test_data, type = "response")
      predictions <- ifelse(logistic_predictions > 0.5, 1, 0)
    } else {
      nn_model <- nnet(infected ~ ., data = train_data, size = 5)
      predictions <- predict(nn_model, newdata = test_data, type = "class")
    }
    
    return(predictions)
  })
  
  output$confusionMatrix <- renderPlot({
    predictions <- model_predictions()
    cm <- confusionMatrix(factor(predictions), factor(test_data$infected), dnn = c("Prediction", "Reference"))
    plt <- as.data.frame(cm$table)
    plt$Prediction <- factor(plt$Prediction, levels = rev(levels(plt$Prediction)))
    
    conf_matrix_plot <- ggplot(plt, aes(Prediction, Reference, fill = Freq)) +
      geom_tile() + geom_text(aes(label = Freq)) +
      scale_fill_gradient(low = "white", high = "red") +
      labs(x = "Reference", y = "Prediction") +
      scale_x_discrete(labels = c("infected", "healthy")) +
      scale_y_discrete(labels = c("healthy", "infected"))
    
    conf_matrix_plot
  })
  
  
  
  learning_curves <- reactive({
    learners <- list()
    if ("rf" %in% input$chooseAlgorithms) {
      learners <- c(learners, makeLearner("classif.randomForest", predict.type = "response", ntree = 100,id="randomForest"))
    } 
    if ("dt" %in% input$chooseAlgorithms) {
      learners <- c(learners, makeLearner("classif.rpart", predict.type = "response", id="decision tree"))
    } 
    if ("lr" %in% input$chooseAlgorithms) {
      learners <- c(learners, makeLearner("classif.logreg", predict.type = "response", id="logistic regression"))
    } 
    if ("nn" %in% input$chooseAlgorithms) {
      learners <- c(learners, makeLearner("classif.nnet", predict.type = "response", size = 5, trace = FALSE, id="neural network"))
    } 
    if ("svm" %in% input$chooseAlgorithms) {
      learners <- c(learners, makeLearner("classif.svm", predict.type = "response", id="SVM"))
    }
    return(learners)
  })
  
  output$learning_curves <- renderPlot({
    learners <- learning_curves()
    if (length(learners) > 0) {
      train_task <- makeClassifTask(data = train_data, target = "infected")
      # Define the performance measure
      measure <- acc
      # Define 10-fold cross-validation
      rdesc <- makeResampleDesc("CV", iters = 10)
      learning_curve_data <- generateLearningCurveData(
        learners = learners, 
        task = train_task, 
        percs = seq(0.1, 1.0, by = 0.1),  # Training set sizes from 10% to 100%
        measures = measure, 
        resampling = rdesc
      )
      p<-plotLearningCurve(learning_curve_data) +
        ggtitle("Learning Curves for Various Classifiers with 10-Fold Cross-Validation") +
        theme_minimal()
      
      p
    }
  })
}
