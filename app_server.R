library(tidyverse)
library(shiny)
library(plotly)
library(dplyr)

owid_co2_data <- read.csv("sources/owid-co2-data.csv")
View(owid_co2_data)

#Make the dataset ONLY countries:
countries_owid_co2_data <- subset(subset(owid_co2_data, iso_code != ""), iso_code != "OWID_WRL")

#Making my 3 values
most_carbon_emissions <- countries_owid_co2_data %>% 
  filter(year == max(year, na.rm = TRUE)) %>% 
  filter(co2_per_capita == max(co2_per_capita, na.rm = TRUE)) %>% 
  pull(country)
most_carbon_emissions

country_co2_growth <- countries_owid_co2_data %>% 
  filter(year == max(year, na.rm = TRUE)) %>% 
  filter(co2_growth_prct == max(co2_growth_prct, na.rm = TRUE)) %>% 
  pull(country)
country_co2_growth
most_co2_growth <- countries_owid_co2_data %>% 
  filter(year == max(year, na.rm = TRUE)) %>% 
  filter(co2_growth_prct == max(co2_growth_prct, na.rm = TRUE)) %>% 
  pull(co2_growth_prct)
most_co2_growth

alltime_highest_co2_country <- countries_owid_co2_data %>% 
  filter(co2 == max(co2, na.rm = TRUE)) %>% 
  pull(country)
alltime_highest_co2_country


#Making a data set for my visualization page

filtered_owid <- countries_owid_co2_data %>% 
  select(country, year, cement_co2, flaring_co2, oil_co2, coal_co2, gas_co2, other_industry_co2) %>% 
  rename(
         cement = cement_co2, 
         flare = flaring_co2, 
         oil = oil_co2, 
         coal = coal_co2, 
         gas = gas_co2, 
         other = other_industry_co2)
vis_data <- filtered_owid %>% 
  select(cement, flare, oil, coal, gas, other)
selected_country <- unique(filtered_owid$country)

#calling server function
server <- function(input, output) {
  output$most_carbon_emissions <- renderText(most_carbon_emissions)
  output$country_co2_growth <- renderText(country_co2_growth)
  output$most_co2_growth <- renderText(most_co2_growth)
  output$alltime_highest_co2_country <- renderText(alltime_highest_co2_country)
  
  # creating the data visualization plot
  output$scatterplot <- renderPlotly({
    df <- countries_owid_co2_data %>% 
      group_by(country) %>% 
      select(year, cement_co2, flaring_co2, oil_co2, coal_co2, gas_co2, other_industry_co2) %>% 
      rename(cement = cement_co2, 
             flare = flaring_co2, 
             oil = oil_co2, 
             coal = coal_co2, 
             gas = gas_co2, 
             other = other_industry_co2) %>% 
      filter(country == input$selected_country)
    
  #Plotting the vis data set I made
    my_plot <- ggplot(df, aes_string(x = df$year, y = input$y_var)) + 
      geom_point() +
      xlab("Year") +
      ylab(paste("CO2 emission caused by", input$y_var, "(Million Tonnes)")) +
      ggtitle(paste("Change of CO2 Emission Types each year from",
                    input$y_var, "in", input$selected_country))
    ggplotly(my_plot) 
  })
}
