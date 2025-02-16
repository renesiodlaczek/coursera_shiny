library(shiny)
library(palmerpenguins)
library(rpart)
library(rpart.plot)
library(DT)
library(bslib)

server <- function(input, output) {
    
    penguins$year <- as.factor(penguins$year)
    
    train_model <- eventReactive(input$train, {
        rpart::rpart(species ~ .,
                     data = penguins,
                     na.action = na.rpart,
                     method = "class",
                     parms = list(split = input$radio_split_criterion),
                     minsplit = input$minsplit,
                     cp = input$cp,
                     maxdepth = input$maxdepth
        )
    })
    
    predict_species <- reactive({
        newdata <- data.frame(island = input$dropdown_island,
                              bill_length_mm = input$slider_bill_length,
                              bill_depth_mm = input$slider_bill_depth,
                              flipper_length_mm = input$slider_flipper_length,
                              body_mass_g = input$slider_body_mass,
                              sex = input$dropdown_sex,
                              year = input$dropdown_year)
        predict(train_model(), newdata = newdata)
        })
    
    output$prediction <- renderPrint({predict_species()})
    
    output$plot_decision_tree <- renderPlot({
        rpart.plot::rpart.plot(train_model())
    })
    
    output$table <- DT::renderDataTable({
        DT::datatable(penguins)
    })
    
}


