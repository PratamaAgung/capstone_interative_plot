#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

# Define UI for application that draws a histogram
shinyUI(
    dashboardPage(skin = 'yellow',
                  
                  dashboardHeader(title = 'AnalystJobOpening'),
                  dashboardSidebar(
                      
                      sidebarMenu(
                          menuItem(text = "Overview", icon = icon("chart-line"), tabName = 'overview'),
                          menuItem(text = "Locations", icon = icon("map-marked-alt"), tabName = 'locations'),
                          menuItem(text = "Job List", icon = icon("clipboard-list"), tabName = 'data')
                      )
                      
                  ),
                  dashboardBody(
                      
                      tabItems(
                          tabItem(tabName = 'data',
                                  
                                  h2("Data Analyst Job Opening Data"),
                                  h4("Here are the list of pandemic period job openings for data analyst in the US"),
                                  p('You can use the filter on the table to make your search a lot easier!'),
                                  DT::dataTableOutput(outputId = 'data')
                                  
                          ),
                          
                          tabItem(tabName = 'locations',
                              
                              h2('The Company Location'),
                              h4('The jobs are spread all over the country!'),
                              sliderInput("salary_range", label = p('Choose ones  with your desired salary'), 
                                          min = min(master_data_clean$Avg.Salary, na.rm = T), 
                                          max = max(master_data_clean$Avg.Salary, na.rm = T), 
                                          value = c(60, 100)
                              ),
                              p(em('*in thousands USD')),
                              
                              plotlyOutput(outputId = 'map')
                              
                          ),
                          
                          tabItem(tabName = 'overview'
                              
                              
                              
                          )
                      )
                      
                  )
    )    
)
