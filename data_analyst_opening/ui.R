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
                          
                          tabItem(tabName = 'overview',
                              
                              h1('Job Openings for Data Analyst'),
                              h3('Greeting, Analysts!'),
                              h4('Following the pandemic situation, finding a job becoming more and more difficult.
                                 Let\'s see how it affects our field.'),
                              p(HTML(paste0('Data used in this visualization comes from ', 
                                            a(href = 'https://www.kaggle.com/andrewmvd/data-analyst-jobs', 'Kaggle'),
                                            '. It contains job openings in the US, scrapped from Glassdoor website in June 2020.'))),
                              
                              fluidRow(
                                valueBox(length(master_data_clean$Job.Title), "Job Openings", icon = icon("users"), color = 'blue'),
                                valueBox(length(unique(master_data_clean$Company.Name)), "Companies", icon = icon("building"), color = 'blue'),
                                valueBox(length(unique(master_data_clean$Location)), "Cities", icon = icon("map-marked-alt"), color = 'blue')
                              ),
                              
                              fluidRow(
                                box(title = strong(em('Job Profile')), solidHeader = T, 
                                    collapsible = T, status = 'primary', width = 12,
                                    
                                    # h4('Salary is an important part that may lead to a better level of job satisfaction'),
                                    # p(em('Especially when you have several bills to pay :)')),
                                    
                                    radioButtons(
                                      "salary_type", label = p("Select what kind of estimated salary you want to display (in thousands USD)"),
                                      choices = list("Minimum" = 1, "Average" = 2, "Maximum" = 3), 
                                      selected = 2, inline = T
                                    ),
                                    
                                    hr(),
                                    
                                    h4('Salary On Each Role Level'),
                                    plotlyOutput(outputId = 'salary.role'),
                                    
                                    hr(),
                                    
                                    h4('Salary On Each Sector'),
                                    selectInput("select_sector", label = "Choose sector(s)", 
                                        choices = unique(master_data_clean$Sector), 
                                        selected = c('Non-Profit', 'Information Technology', 'Education'), 
                                        multiple = T
                                    ),
                                    plotlyOutput(outputId = 'salary.sector')
                                    
                                    
                                )
                              ),
                              
                              fluidRow(
                                box(title = strong(em('Company Profile')), solidHeader = T, 
                                    collapsible = T, status = 'primary', width = 12,
                                    
                                    h4('Company Size'),
                                    plotlyOutput(outputId = 'company.size'),
                                    
                                    hr(),
                                    
                                    h4('Company Rating'),
                                    plotlyOutput(outputId = 'company.rating')
                                    
                                    
                                )
                              )
                              
                          )
                      )
                      
                  )
    )    
)
