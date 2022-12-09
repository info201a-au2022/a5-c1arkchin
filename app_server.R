library(tidyverse)
library(shiny)
library(plotly)
library(dplyr)

owid_co2_data <- read.csv("https://raw.githubusercontent.com/info201a-au2022/a5-c1arkchin/main/sources/owid-co2-data.csv")
#Make the data set ONLY countries:
countries_owid_co2_data <- subset(subset(owid_co2_data, iso_code != ""), iso_code != "OWID_WRL")

#Making my 3 values

# which country has the highest carbon emissions in 2021?
most_carbon_emissions <- countries_owid_co2_data %>% 
  filter(year == max(year, na.rm = TRUE)) %>% 
  filter(co2_per_capita == max(co2_per_capita, na.rm = TRUE)) %>% 
  pull(country)
most_carbon_emissions

# which country grew the most in co2 emissions in 2021?
country_co2_growth <- countries_owid_co2_data %>% 
  filter(year == max(year, na.rm = TRUE)) %>% 
  filter(co2_growth_prct == max(co2_growth_prct, na.rm = TRUE)) %>% 
  pull(country)
country_co2_growth
# what percentage did that country grow in co2 emissions?
most_co2_growth <- countries_owid_co2_data %>% 
  filter(year == max(year, na.rm = TRUE)) %>% 
  filter(co2_growth_prct == max(co2_growth_prct, na.rm = TRUE)) %>% 
  pull(co2_growth_prct)
most_co2_growth

# which country has the highest co2 emissions of all time?
alltime_highest_co2_country <- countries_owid_co2_data %>% 
  filter(co2 == max(co2, na.rm = TRUE)) %>% 
  pull(country)
alltime_highest_co2_country

# Making variables for my drop down plot filtering choices

# Adding my drop down choices to a variable that I can call from.
dropdown_choices <- countries_owid_co2_data %>% 
  select(country, year, coal_co2, flaring_co2, cement_co2, oil_co2, gas_co2, trade_co2, methane, nitrous_oxide, other_industry_co2)

# Variable that gathers the types of CO2 emission elements
element_choices <- dropdown_choices %>% 
  select(coal_co2, flaring_co2, cement_co2, oil_co2, gas_co2, trade_co2, methane, nitrous_oxide, other_industry_co2)

# Variable that gathers the user's selected country from the data set.
# unique() to group the individual countries together
selected_country <- unique(dropdown_choices$country)

#calling server function
server <- function(input, output) {
  output$most_carbon_emissions <- renderText(most_carbon_emissions)
  output$country_co2_growth <- renderText(country_co2_growth)
  output$most_co2_growth <- renderText(most_co2_growth)
  output$alltime_highest_co2_country <- renderText(alltime_highest_co2_country)
  
#Creating the visualization plot
  output$scatterplot <- renderPlotly({
    scatter_df <- countries_owid_co2_data %>% 
      group_by(country) %>% 
      select(year, coal_co2, flaring_co2, cement_co2, oil_co2, gas_co2, trade_co2, methane, nitrous_oxide, other_industry_co2) %>% 
      filter(country == input$selected_country)
    
  #Plotting the visualization data set I made
    scatter_plot <- ggplot(scatter_df, aes_string(x = scatter_df$year, y = input$y_var)) + 
      xlab("Year") +
      ylab(paste("CO2 emission caused by", input$y_var, "(Million Tonnes)")) +
      ggtitle(paste("Change of CO2 Emission Types each year from",
                    input$y_var, "in", input$selected_country)) +
      geom_point()
    
    ggplotly(scatter_plot) 
  })
}

