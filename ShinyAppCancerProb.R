library(shiny)
library(randomForest)
library(caret)
library(ggplot2)
library(dplyr)
library(tidyr)

# User Interface
ui <- fluidPage(
  titlePanel("Cancer Prediction using Random Forest"),
  sidebarLayout(
    sidebarPanel(
      fileInput("file", "Choose CSV File", accept = c(".csv")),
      numericInput("train_percent", "Training Percentage", value = 70, min = 50, max = 100),
      actionButton("run", "Run Analysis")
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("Confusion Matrix", tableOutput("confusion_matrix")),
        tabPanel("Probability Distribution", plotOutput("probability_distribution")),
        tabPanel("Statistical Table", tableOutput("statistical_table"))  # New tab for statistics
      )
    )
  )
)

# Server logic
server <- function(input, output) {
  observeEvent(input$run, {
    req(input$file)
    data <- read.csv(input$file$datapath)
    
    # Ensure the type column exists and check its structure
    if (!"type" %in% colnames(data)) {
      stop("The dataset must have a 'type' column.")
    }
    
    # Convert 'type' to factor
    data$type <- as.factor(data$type)
    
    # Split the data into training and testing sets
    set.seed(123)
    train_index <- createDataPartition(data$type, p = input$train_percent / 100, list = FALSE)
    train_data <- data[train_index, ]
    test_data <- data[-train_index, ]
    
    # Train the Random Forest model
    rf_model <- randomForest(type ~ ., data = train_data, ntree = 100, importance = TRUE)
    
    # Make predictions on the test set
    rf_predictions <- predict(rf_model, test_data)
    confusion <- confusionMatrix(rf_predictions, test_data$type)
    
    # Output confusion matrix with custom labels
    output$confusion_matrix <- renderTable({
      confusion_table <- as.data.frame(confusion$table)
      confusion_table
    })
    
    # Get probabilities of being 'Cancer'
    rf_probabilities <- predict(rf_model, test_data, type = "prob")
    test_data$Cancer_Probability <- rf_probabilities[, 2]  # Probability of being 'Cancer'
    
    # Identify misclassified samples
    test_data$Misclassified <- (rf_predictions != test_data$type)
    
    # Probability Distribution Plot
    output$probability_distribution <- renderPlot({
      ggplot(test_data) +
        geom_histogram(aes(x = Cancer_Probability, fill = ifelse(Misclassified, "Misclassified", as.character(type))),
                       binwidth = 0.05, alpha = 0.7, position = 'identity') +
        labs(title = "Cancer vs Control: Probability Distribution",
             x = "Probability of Cancer",
             y = "Count") +
        theme_minimal() +
        scale_fill_manual(values = c("blue", "red", "green"), 
                          name = "Type", 
                          labels = c("Control", "Cancer", "Misclassified")) +
        guides(fill = guide_legend(title = "Sample Type"))  # Add legend title
    })
    
    # Generate statistical table for each column
    stat_function <- function(data, col_number) {
      # Calculate mean for type 0 and type 1
      mean_0 <- mean(data[data$type == 0, col_number], na.rm = TRUE)
      mean_1 <- mean(data[data$type == 1, col_number], na.rm = TRUE)
      
      # Calculate standard deviation for type 0 and type 1
      sd_0 <- sd(data[data$type == 0, col_number], na.rm = TRUE)
      sd_1 <- sd(data[data$type == 1, col_number], na.rm = TRUE)
      
      # Perform unpaired t-test between type 0 and type 1 for the specified column
      t_test_result <- t.test(data[data$type == 0, col_number], data[data$type == 1, col_number])
      p_value <- t_test_result$p.value
      
      col_name <- colnames(data)[col_number]
      
      # Combine the results into a dataframe with row names and column name as 'gene_X'
      output_stats <- data.frame(
        stat_value = c(mean_0, mean_1, sd_0, sd_1, p_value),  # store results in one column
        row.names = c("mean_type_0", "mean_type_1", "sd_type_0", "sd_type_1", "p_value")
      )
      colnames(output_stats) <- col_name
      return(output_stats)
    }
    
    # Calculate statistics for all columns
    overall_result_stat <- stat_function(data, 1)
    for (i in 2:(ncol(data) - 1)) {
      result_stat_function <- stat_function(data, i)
      overall_result_stat <- cbind(overall_result_stat, result_stat_function)
    }
    
    # Output the statistical table, including row names
    output$statistical_table <- renderTable({
      overall_result_stat
    }, rownames = TRUE)  # Ensure row names are shown in the table
  })
}

# Run the Shiny app
shinyApp(ui = ui, server = server)

