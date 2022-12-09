library(shiny)
library(shinythemes)

#sourcing app_server.R
source("app_server.R")

# Making the introduction page
introduction <- fluidPage(
  theme = shinytheme("darkly"),
  headerPanel("Introduction"),
  p(strong("INFO201 - A5 - By: Clark Chin")),
  img(src = "air.png", height = "300px", width = "450px"),
  p("The purpose of this project is to highlight the growth, changes, and highest records of Carbon Dioxide Emissions
     on our planet. I want to find the countries with the highest emission rates in relation to their populations. 
     I also want to find the countries that have
     started to raise their CO2 emissions. Ultimately, I hope to raise awareness for which countries
     are the leading producers of CO2 emissions, and also find which countries are on the track to becoming big
     creators of emissions on our planet."),
  h3("Value 1: Country With The Highest CO2 Emissions Per Capita"),
  HTML(paste0(
    "In 2021, the country with the highest CO2 emissions per capita was ",
    textOutput("most_carbon_emissions", inline = TRUE), "."
  )),
  p(),
  h3("Value 2: Country With The Largest CO2 Emissions Growth in 2021"),
  HTML(paste0(
    "In 2021, the country thats CO2 emissions grew the most was ",
    textOutput("country_co2_growth", inline = TRUE),
    ". They grew by ",
    textOutput("most_co2_growth", inline = TRUE), "%."
  )),
  p(),
  h3("The Country With The Highest CO2 Emissions of All Time"),
  HTML(paste0(
    " The country with the highest CO2 emissions of all time is ",
    textOutput("alltime_highest_co2_country", inline = TRUE), "."
  )),
)

# Making the visualization page
visualization <- fluidPage(
  headerPanel("Visualization"),
  sidebarLayout(
    sidebarPanel(
      # widgets
      h4("Filter"),
        year_input <- selectInput(
          label = "Select a Country:",
          inputId = "selected_country",
          choices = selected_country       
          
        ),
        y_input <- selectInput(
          label = "Select an Emission Material:",
          inputId = "y_var",
          choices = colnames(element_choices)         
          )
        ),
    # data visualization plot and captions
    mainPanel(
      plotlyOutput("scatterplot"),
      p(),
      p("This scatter plot displays the CO2 Emissions of a given cause by Year in each Country.
         One thing that is interesting to see is that when filtering for more established countries like The United States and China,
         we see a gradual growth of CO2 emissions across the years, but while filtering for a country like Afghanistan,
         we see points all over the place. This finding stays true while filtering for each type of Emission Material as well.
         If we dive deeper into this pattern, we can start to see a direct correlation between less developed countries having
         varying CO2 Emission results each year, while more developed countries have strong, gradual climbs in their CO2 Emissions per year."),
      )
    )
  )

# Adding my pages to a ui function
ui <- navbarPage(
  "Global Representation of CO2 Emissions",
  tabPanel("Introduction", introduction),
  tabPanel("Visualization", visualization)
)

