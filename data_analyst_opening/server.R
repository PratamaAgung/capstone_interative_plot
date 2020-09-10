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
    
    output$salary.sector <- renderPlotly({
        master_data_clean %>%
            mutate(
                Salary.Estimation = case_when(
                    input$salary_type == 1 ~ Min.Salary,
                    input$salary_type == 2 ~ Avg.Salary,
                    TRUE ~ Max.Salary
                )
            ) %>%
            filter(Sector %in% input$select_sector) %>%
            plot_ly(
                x = ~Sector,
                y = ~Salary.Estimation,
                split = ~Sector,
                type = 'violin',
                box = list(
                    visible = T
                ),
                meanline = list(
                    visible = F
                )
            ) %>%
            layout(
                xaxis = list(
                    visible = T,
                    showticklabels = F
                ),
                yaxis = list (
                    title = 'Salary Estimation'
                )
            )
    })
    
    output$salary.role <- renderPlotly({
        master_data_clean %>%
            mutate(
                Salary.Estimation = case_when(
                    input$salary_type == 1 ~ Min.Salary,
                    input$salary_type == 2 ~ Avg.Salary,
                    TRUE ~ Max.Salary
                )
            ) %>%
            plot_ly(
                x = ~Role.Level,
                y = ~Salary.Estimation,
                color = ~Role.Level,
                type = 'box',
                jitter = 0.8,
                boxpoints = "all",
                pointpos = 0,
                marker = list(size=2),
                text = ~paste0(Role.Level, ' : $' , Salary.Estimation, 'K'),
                hoverinfo = "text"
            ) %>%
            layout (
                yaxis = list (
                    title = 'Salary Estimation'
                ),
                showlegend = F
            )
    })
    
    output$company.size <- renderPlotly({
        master_data_clean %>%
            filter(Size != 'Unknown') %>%
            count(Size) %>%
            plot_ly(
                x = ~Size,
                y = ~n,
                color = ~Size,
                type='bar',
                text = ~paste0(Size, ' : ' , n, ' companies'),
                hoverinfo = "text"
            ) %>%
            layout (
                yaxis = list (
                    title = 'Number of Openings'
                ),
                showlegend = F
            )
    })
    
    output$company.rating <- renderPlotly(({
        dense <- density(master_data_clean[master_data_clean$Rating > 0,]$Rating)
        
        master_data_clean %>%
            filter(Rating > 0) %>%
            plot_ly(
                x=~Rating,
                type='histogram',
                name = 'Histogram',
                hovertemplate = "Rating %{x}: %{y} companies"
            ) %>%
            add_trace(
                x=dense$x,
                y = dense$y,
                type = 'scatter',
                mode='lines',
                fill = "tozeroy", 
                yaxis = "y2", 
                name = "Density",
                hovertemplate = "Rating %{x:.3f}: %{y}"
            ) %>%
            layout(
                yaxis2 = list(overlaying = "y", side = "right"),
                yaxis = list(title='Number of Openings')
            )
    }))

})
