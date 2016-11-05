## User interface coding for the Shiny web app

library(shiny)


shinyUI(fluidPage(theme = "bootstrap.css",
    
    ## title panel setup
    titlePanel(title = div(img(src="Space_Invader.PNG", height = 56, width = 64),
                           span("IGN Video Game Reviews",
                                style = "font-family:'Courier New'; font-weight:bold")),
               windowTitle = "Shiny App: Video Game Reviews"),

    

    sidebarLayout(
        
        ## begin sidebar panel
        sidebarPanel(
            
            span(strong(em(textOutput("sideText"))), style="color:#00e1ff"),
            
            br(),
            
            ## divides sidebar into two columns for filtering checkbox groups
            fluidRow(
                column(6,
                       checkboxGroupInput("platforms",
                                          "Platforms:",
                                          choices = keepPlatforms,
                                          selected = keepPlatforms),
                       actionButton("selectAllPlats", "All/Random",
                                    class="btn btn-primary"),
                       br(), br(),
                       img(src="controller.png", height = 51.5, width = 116)
                ),
                column(6,
                       checkboxGroupInput("genres",
                                          "Genres:",
                                          choices = genreChoices,
                                          selected = genreChoices),
                       actionButton("selectAllGenres", "All/Random",
                                    class="btn btn-primary"),
                       br(), br(),
                       img(src="Hylian_Shield.png", height = 120, width = 100)
                )
            )
        ),
    
        
        ## begin main panel
        mainPanel(
            
            span(strong(em(textOutput("mainText"))), style="color:#00e1ff"),
            
            br(),
            
            ## set up tabs for Platform and Genre plots and Data table
            tabsetPanel(type = "tabs", id = "tabs",
                        ## Platforms tab
                        tabPanel("Platforms", br(),
                                 conditionalPanel("input.tabs == 'Platforms' & input.platforms != '' & input.genres != ''",
                                                  plotOutput("platPlot")),
                                 conditionalPanel("input.tabs == 'Platforms' & input.platforms == ''",
                                                  textOutput("platError")),
                                 conditionalPanel("input.tabs == 'Platforms' & input.genres == ''",
                                                  textOutput("genreError")),
                                 br(), br(), br(), br(), br(), br(),
                                 tableOutput("platTable")
                        ),
                        ## Genres tab
                        tabPanel("Genres", br(),
                                 conditionalPanel("input.tabs == 'Genres' & input.platforms != '' & input.genres != ''",
                                                  plotOutput("genrePlot")),
                                 conditionalPanel("input.tabs == 'Genres' & input.platforms == ''",
                                                  textOutput("platError2")),
                                 conditionalPanel("input.tabs == 'Genres' & input.genres == ''",
                                                  textOutput("genreError2")),
                                 br(), br(), br(), br(), br(), br(),
                                 tableOutput("genreTable")
                        ),
                        ## data table tab
                        tabPanel("Data", br(),
                                 dataTableOutput("gamesTable")
                        )
                            
            )
        )
    )
))