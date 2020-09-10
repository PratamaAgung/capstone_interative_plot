#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

    output$data <- DT::renderDataTable(
        master_data_clean %>%
            select(Job.Title, Salary.Estimate, Avg.Salary, Company.Name, Rating, Location, Size, Revenue, Industry, Sector),
        filter = 'top',
        options = list(
            pageLength = 20
        )
    )
    
    output$map <- renderPlotly({
        map_opening %>%
            filter(Avg.Salary >= input$salary_range[1] & Avg.Salary <= input$salary_range[2]) %>%
            group_by(city, state_id, lat, lng) %>%
            summarise(
                Number.Opening = n()
            ) %>%
            ungroup() %>%
            plot_geo(height=600) %>%
            add_markers(
                x = ~lng, 
                y = ~lat, 
                size = ~Number.Opening,
                split = ~Number.Opening,
                opacity = 1,
                text = ~paste0(city, ', ', state_id, ' : ' , Number.Opening, ' openings'),
                hoverinfo = "text"
            ) %>%
            layout(
                geo = list(
                    scope = 'usa',
                    projection = list(type = 'albers usa'),
                    showland = TRUE,
                    landcolor = toRGB("gray85"),
                    subunitwidth = 1,
                    countrywidth = 1,
                    subunitcolor = toRGB("white"),
                    countrycolor = toRGB("white")
                ),
                showlegend = F
            )
    })

})
