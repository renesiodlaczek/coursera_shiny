library(shiny)
library(palmerpenguins)
library(rpart)
library(rpart.plot)
library(DT)
library(bslib)

penguins$year <- as.factor(penguins$year)

ui <- fluidPage(
    #bslib::input_dark_mode(), 
    
    titlePanel("Predict Penguin Species using a Decision Tree"),
    
    sidebarLayout(
        
        sidebarPanel(
            h3("Input values"),
            selectInput("dropdown_island", "Island", 
                        levels(penguins$island), 
                        selected = levels(penguins$island)[1]
                        ),
            sliderInput("slider_bill_length", "Bill length (mm)", 
                        min = as.integer(min(penguins$bill_length_mm, na.rm = TRUE)), 
                        max = as.integer(max(penguins$bill_length_mm, na.rm = TRUE)), 
                        value = as.integer(mean(penguins$bill_length_mm, na.rm = TRUE))
                        ),
            sliderInput("slider_bill_depth", "Bill depth (mm)", 
                        min = as.integer(min(penguins$bill_depth_mm, na.rm = TRUE)), 
                        max = as.integer(max(penguins$bill_depth_mm, na.rm = TRUE)), 
                        value = as.integer(mean(penguins$bill_depth_mm, na.rm = TRUE))
                        ),
            sliderInput("slider_flipper_length", "Flipper length (mm)", 
                        min = as.integer(min(penguins$flipper_length_mm, na.rm = TRUE)), 
                        max = as.integer(max(penguins$flipper_length_mm, na.rm = TRUE)), 
                        value = as.integer(mean(penguins$flipper_length_mm, na.rm = TRUE))
                        ),
            sliderInput("slider_body_mass", "Body mass (g)", 
                        min = as.integer(min(penguins$body_mass_g, na.rm = TRUE)), 
                        max = as.integer(max(penguins$body_mass_g, na.rm = TRUE)), 
                        value = as.integer(mean(penguins$body_mass_g, na.rm = TRUE))
                        ),
            radioButtons("dropdown_sex", "Sex", 
                        levels(penguins$sex), 
                        selected = levels(penguins$sex)[1]
                        ),
            selectInput("dropdown_year", "Year", 
                        levels(penguins$year), 
                        selected = levels(penguins$year)[1]
                        ),
            h3("Predicted species"),
            verbatimTextOutput("prediction")
        ),
        
        mainPanel(
            tabsetPanel(type = "tabs",
                        tabPanel("Decision Tree",
                                 #br(),
                                 h3("Training parameters"),
                                 radioButtons("radio_split_criterion", "Splitting criterion",
                                              choices = c("gini", "information"),
                                              selected = "gini"
                                              ),
                                 sliderInput("minsplit", "Minimum observations per split", 
                                             min = 1, 
                                             max = 100, 
                                             value = 10
                                             ),
                                 sliderInput("cp", "Complexity parameter", 
                                             min = 0.00001, 
                                             max = 0.1, 
                                             value = 0.01
                                             ),
                                 sliderInput("maxdepth", "Maximum depth", 
                                             min = 1, 
                                             max = 10, 
                                             value = 6
                                             ),
                                 actionButton("train", "Train decsion tree"),
                                 plotOutput("plot_decision_tree")),
                        tabPanel("Data",
                                 DT::dataTableOutput("table")
                                 ),
                        tabPanel("Documentation",
                                 h4("About"),
                                 "This app is used for the educational purpose of learning how the decision tree classification algorithm works. A basic understanding of the algorithm is required.",
                                 
                                 h4("Data"),
                                 "The underlying dataset is called 'Palmer Archipelago (Antarctica) Penguin Data'. It contains size measurements, clutch observations and blood isotope ratios for adult foraging Adélie, Chinstrap and Gentoo penguins observed on islands in the Palmer Archipelago near Palmer Station, Antarctica. Data were collected and made available by Dr. Kristen Gorman and the Palmer Station Long Term Ecological Research (LTER) Program.
                                 The data can be viewed in the tab 'Data'.",
                                 
                                 h4("Usage"),
                                 "The goal is to train a decision tree classifier to predict a penguin's species based on different penguin features. To fit the decision tree to the data the button 'Train decision tree' needs to be clicked in the tab 'Decision Tree'. For the training below described hyperparameters must be selected. Once the training is done a visual representation of the fitted decision tree appears.
                                 To better understand how a prediction with the fitted classifier works different penguin features can be selected on the left side. Once the algorithm is trained and all features are selected the predicted probabilites appear at the bottom of the screen automatically.",
                                 
                                 h4("Hyperparameters"),
                                 h5("Splitting criterion: The splitting criterion is used to determine the best feature to split the data at each node. In this case either the gini index or information gain can be used."),
                                 h5("Minimum observations per split: Minimum number of observations that must exist in a node in order for a split to be attempted."),
                                 h5("Complexity parameter (cp): Any split that does not decrease the overall lack of fit by a factor of cp is not attempted. The main role of this parameter is to save computing time by pruning off splits that are obviously not worthwhile. Essentially,the user informs the program that any split which does not improve the fit by cp will likely be pruned off by cross-validation, and that hence the program need not pursue it."),
                                 h5("Maximum depth: Set the maximum depth of any node of the final tree, with the root node counted as depth 0.")
                        )
            )
        )
    )
)

