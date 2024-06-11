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
library(DT)
library(DALEX)
library(shinythemes)
library(pROC)



function(input, output, session) {
  
  data <- read.csv("./data/AIDS_Classification.csv")
  data <- data %>%
    rename("treatment" = "trt")
  data <- data %>%
    rename("weight" = "wtkg")
  data <- data %>%
    rename("hemophilia" = "hemo")
  data <- data %>%
    rename("homosexual_activity" = "homo")
  data <- data %>%
    rename("karnofsky_score" = "karnof")
  data <- data %>%
    rename("days_before_anti_retrovial" = "preanti")
  data <- data %>%
    rename("non_white" = "race")
  data <- data %>%
    rename("antiretroviral_history" = "str2")
  data <- data %>%
    rename("treatment_ZDV" = "treat")
  data <- data %>%
    rename("CD4_baseline" = "cd40")
  data <- data %>%
    rename("CD4_after_20days" = "cd420")
  data <- data %>%
    rename("CD8_baseline" = "cd80")
  data <- data %>%
    rename("CD8_after_20days" = "cd820")

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
      scale_fill_gradient(low = "white", high = "blue") +
      labs(x = "Reference", y = "Prediction") +
      scale_x_discrete(labels = c("infected", "healthy")) +
      scale_y_discrete(labels = c("healthy", "infected")) +
      theme_minimal()
    
    conf_matrix_plot
  })
  
  output$ROCcurve <- renderPlot({
    predictions <- model_predictions()
    # Create ROC curve
    rocobj <- plot.roc(test_data$infected, as.numeric(predictions),
                      percent=TRUE,
                       ci=TRUE, xlim=c(100,0)) # Adjusted x-axis limits
    
    # Print the AUC (will contain the CI)
    ciobj <- ci.se(rocobj, 
                   specificities=seq(0, 100, 5)) # Calculate CI of sensitivity
    
    # Plot CI as a shape
    plot(ciobj, type="shape", col="#1c61b6AA") # Blue shape
    
    # Plot CI of thresholds
    plot(ci(rocobj, of="thresholds", thresholds="best"))
  })
  

  output$dataTableOutput <- renderDT({
    dt_data = data[][-c(14, 15, 16, 17, 18, 19, 20, 21, 22)]
    datatable(dt_data, filter = 'top', options = list(
      pageLength = 5, autoWidth = TRUE, selection = "single"))
  })
  
  get_model <- reactive({
    input_model <- input$selectAlgorithm2
    
    if (input_model == "Random Forest") {
      model <- randomForest(infected ~ ., data = train_data, ntree = 100)
    } else if (input_model == "Decision Tree") {
      model <- rpart(infected ~ ., data = train_data, method = "class")
    } else if (input_model == "Logistic Regression") {
      model <- glm(infected ~ ., data = train_data, family = binomial)
    } else {
      model <- nnet(infected ~ ., data = train_data, size = 5)
    }
    
    return(model)
  })
  
  output$selectedRowPlot <- renderPlot({
    selected_row <- input$dataTableOutput_rows_selected
    if (length(selected_row) == 1) {
      model <- get_model()
      explain <- DALEX::explain(model = model,
                                   data = data[-23],
                                   y = data$infected == "1", 
                                   label = input$selectAlgorithm2)
      record = data[selected_row,][-23]
      bd_rf <- predict_parts(explainer = explain,
                             new_observation = record,
                             type = "break_down")
      plot(bd_rf)
    } else if (length(selected_row) > 1){
      plot.new()
      text(0.5, 0.5, "Please select a single row", cex = 1.5)
    }
  })
  
  
  plot_dist <- function(attribute) {
    # Create a data frame with the column referenced by attribute
    df <- data.frame(value = data[[attribute]])
    
    # Plot density using ggplot2 with a dynamic title
    p<-ggplot(df, aes_string(x = "value")) +
      geom_density(fill = "blue", alpha = 0.3) +
      ggtitle(paste("Density plot of attribute", attribute)) +
      xlab(paste(attribute)) +
      ylab("Density") +
      theme_minimal()
    
    print(p)
  }
  
  plot_dist_discrete <- function(attribute) {
    # Create a data frame with the column referenced by attribute
    df <- data.frame(value = data[[attribute]])
    
    # Calculate the x-axis limits
    
    # Plot bar chart using ggplot2 with a dynamic title and specified x-axis limits
    p <- ggplot(df, aes_string(x = "value")) +
      geom_bar(fill = "blue", alpha = 0.3) +
      ggtitle(paste("Bar chart of attribute", attribute)) +
      xlab(paste(attribute)) +
      ylab("Frequency") +
      scale_x_continuous(breaks = seq(min(df$value), max(df$value), by = 1)) + 
      theme_minimal()
    
    print(p)
  }
  
  input_column <- reactive({
    column <- input$selectColumn
  })
  
  numeric_attr = c("time", "age", "weight", "days_before_anti_retrovial", "CD4_baseline", "CD4_after_20days", "CD8_baseline", "CD8_after_20days")
  output$selectedColumnPlot <- renderPlot({
    attribute <- input_column()
    if (attribute %in% numeric_attr) {
      plot_dist(attribute)
    }
    else {
      plot_dist_discrete(attribute)
    }
  })
  
  
  input_attribute <- reactive({
    attribute <- input$selectAttribute
  })
  
  output$violinPlot <- renderPlot({
    data$infected <- as.factor(data$infected)
    attribute <- input_attribute()
    p_violin <- ggplot(data, aes(x = infected, y = .data[[attribute]], fill = infected)) +
      geom_violin(trim = FALSE) +
      scale_fill_manual(values = c("0" = "dodgerblue", "1" = "tomato")) +
      theme_minimal() +
      labs(x = "infected", y = attribute, title = paste("Violin Plot of", attribute, "by Infected Status"))
    
    p_violin
  })
  
  
  output$Boxplot <- renderPlot({
    data$infected <- as.factor(data$infected)
    attribute <- input_attribute()
    ggplot(data, aes(x = infected, y = .data[[attribute]], fill = infected)) +
      geom_boxplot() +
      theme_minimal() +
      scale_fill_manual(values = c("0" = "dodgerblue", "1" = "tomato")) +
      labs(title = paste("Box Plot of", attribute, "by Infection Status"),
           x = "infected",
           y = attribute)
  })
}

