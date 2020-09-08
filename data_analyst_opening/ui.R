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
                  
                  dashboardHeader(title = 'AnalystOpening'),
                  dashboardSidebar(
                      
                      sidebarMenu(
                          menuItem(text = "Overview", icon = icon("chart-line"), tabName = 'trend'),
                          menuItem(text = "Locations", icon = icon("map-marked-alt"), tabName = 'quality'),
                          menuItem(text = "Job List", icon = icon("clipboard-list"), tabName = 'question')
                      )
                      
                  ),
                  dashboardBody(
                      
                      
                      
                  )
    )    
)
