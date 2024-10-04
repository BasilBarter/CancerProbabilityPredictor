# Cancer Cell Prediction Using RNA Expression

This project focuses on using machine learning to predict the likelihood of a cell being cancerous based on the RNA expression levels of specific genes. It leverages Random Forest models trained and tested on data from the [Curated Microarray Database (CUMIDA)](https://sbcb.inf.ufrgs.br/cumida#datasets). The objective of the project was to develop a reliable tool that could classify cells as cancerous or non-cancerous based on gene expression data.

## Motivation

This project was inspired by my experience at **Cellected**, where I applied several skills gained during my time there. The aim was to create a user-friendly machine-learning application that could assist in the early detection of cancer by analyzing RNA expression data.

## Project Overview

The project began as a draft in **R Markdown**, where I initially developed and tested the machine learning model. The core machine learning model used was a Random Forest classifier, chosen for its accuracy and ability to handle complex, high-dimensional datasets like RNA expression data.

To make the application accessible and user-friendly, the project was transformed into a **Shiny App**, providing a clean interface for users to upload data, run predictions, and view results through visualizations and statistical summaries. This transition allowed the project to not only serve as a functional model but also to demonstrate complex data science concepts in a way that is easy for non-experts to interact with and understand.

## Features

- **RNA Expression-Based Prediction**: The app predicts whether a cell is cancerous based on gene expression data.
- **Curated Microarray Database (CUMIDA)**: The dataset used for training and testing the model comes from CUMIDA, a well-curated collection of microarray data.
- **Machine Learning Model**: The model is built using a Random Forest algorithm, which has been tested for accuracy and efficiency in classifying cancerous vs. non-cancerous cells.
- **Shiny Interface**: The final product includes a user-friendly Shiny app that allows users to:
  - Upload gene expression data.
  - Run the prediction model.
  - View the results, including probability distributions, confusion matrices, and statistical summaries.
  
## Lessons Learned and Future Improvements

While the current version of the project provides a strong foundation, there are a few areas for improvement:
- **Model Optimization**: Further tuning of hyperparameters could improve the accuracy of predictions.
- **Data Expansion**: Incorporating additional datasets or features, such as clinical metadata, could enhance the robustness of the model.
- **Model Generalization**: Exploring other machine learning models (e.g., Support Vector Machines, Neural Networks) could provide better generalization to new data.

This project was an excellent introduction to machine learning in the biomedical field and provided valuable insight into deploying models in a user-friendly format.

