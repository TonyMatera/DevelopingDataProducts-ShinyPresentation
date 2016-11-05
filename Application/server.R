## server functions for shiny web app

library(shiny)
source("global.R")



shinyServer(function(input, output, session) {
    
    ## sidebar instructions
    output$sideText <- renderText("Filter by platform and/or genre
                                  (must select at least one of each):")
    
    ## select all/random platforms button
    observeEvent(input$selectAllPlats, {
        if(length(input$platforms) != length(keepPlatforms)){
            updateCheckboxGroupInput(session,
                                     "platforms",
                                     "Platforms:",
                                     choices = keepPlatforms,
                                     selected = keepPlatforms)
        } else {
            updateCheckboxGroupInput(session,
                                     "platforms",
                                     "Platforms:",
                                     choices = keepPlatforms,
                                     selected = sample(keepPlatforms, 1))
        }
    })
    
    ## select all/random genres button
    observeEvent(input$selectAllGenres, {
        if(length(input$genres) != length(genreChoices)){
            updateCheckboxGroupInput(session,
                                     "genres",
                                     "Genres:",
                                     choices = genreChoices,
                                     selected = genreChoices)
        } else {
            updateCheckboxGroupInput(session,
                                     "genres",
                                     "Genres:",
                                     choices = genreChoices,
                                     selected = sample(genreChoices, 1))
        }
    })
    
    
    ## main tab instructions
    output$mainText <- renderText("Select tab to view score trend plot structured by
                                  Platform or Genre, or select Data tab for table of
                                  underlying game score data:")
    
    
    ## plot by platform
    output$platPlot <- renderPlot({
        
        selectedData <- gameData[gameData$Platform %in% input$platforms &
                                     gameData$MainGenre %in% input$genres, ]
        
        ggplot(selectedData, aes(Platform, Score)) +
            geom_count(aes(color = selectedData$Platform)) +
            scale_color_manual(values = platColors, name = "Platforms") +
            coord_flip() +
            scale_x_discrete(limits = rev(levels(factor(input$platforms)))) +
            xlab(NULL) },
        
        height = 500)
    
    ## platform summary table
    output$platTable <- renderTable({
        selectedData <- gameData[gameData$Platform %in% input$platforms &
                                     gameData$MainGenre %in% input$genres, ]
        platDF <- selectedData %>%
            group_by(Platform) %>%
            summarize(Average = mean(Score),
                      StdDev = sd(Score),
                      Min = min(Score),
                      Max = max(Score),
                      Median = median(Score))
        platDF
    })
    

    ## plot by platform
    output$genrePlot <- renderPlot({
        
        selectedData <- gameData[gameData$Platform %in% input$platforms &
                                     gameData$MainGenre %in% input$genres, ]
        
        ggplot(selectedData, aes(MainGenre, Score)) +
            geom_count(aes(color = selectedData$MainGenre)) +
            scale_color_manual(values = genreColors, name = "Genres") +
            coord_flip() +
            scale_x_discrete(limits = rev(levels(factor(input$genres)))) +
            xlab(NULL) },
        
        height = 500)
    
    ## genre summary table
    output$genreTable <- renderTable({
        selectedData <- gameData[gameData$Platform %in% input$platforms &
                                     gameData$MainGenre %in% input$genres, ]
        genreDF <- selectedData %>%
            group_by(MainGenre) %>%
            rename(Genre = MainGenre) %>%
            summarize(Average = mean(Score),
                      StdDev = sd(Score),
                      Min = min(Score),
                      Max = max(Score),
                      Median = median(Score))
        genreDF
    })
    
    
    ## main data table
    output$gamesTable <- renderDataTable({
        gameData[gameData$Platform %in% input$platforms &
                     gameData$MainGenre %in% input$genres, -5] },
        options = list(lengthMenu = list(c(15, 30, 50, 100),
                                         c('15', '30', '50', '100')),
                       pageLength = 50)
    )
    
    
    ## possible error messages
    output$platError <- renderText("Hmm... Nothing here. Maybe you should select some platforms.")
    output$genreError <- renderText("You've hit a dead end. Pick a genre, buddy.")
    output$platError2 <- renderText("Hmm... Nothing here. Maybe you should select some platforms.")
    output$genreError2 <- renderText("You've hit a dead end. Pick a genre, buddy.")
  
})
