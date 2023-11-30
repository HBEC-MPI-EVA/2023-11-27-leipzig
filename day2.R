
# in R, what's the difference between a data frame, and a list?
# a: a data frame is a special kind of list!

x <- list(NA, 3, "L")

y <- c(NA, 3, "L")

my_dog <- list(
  name = "Thor",
  sex = "male",
  favorite_foods = list("peanut butter", "kibble", "paper"),
  weigh_ins = c(3.4, 3.5, 3.2, 3.3)
)


cats <- data.frame(
  name = c("Loki", "Tickles", "Bjork", "Cinnabun"),
  color = c("black", "tabby", "white", "ginger"),
  num_lives = c(2L, 8L, 1L, 9L),
  likes_string = c(TRUE, FALSE, FALSE, NA)
)


catliss <- list(
  name = c("Loki", "Tickles", "Bjork", "Cinnabun"),
  color = c("black", "tabby", "white", "ginger"),
  num_lives = c(2L, 8L, 1L, 9L),
  likes_string = c(TRUE, FALSE, FALSE, NA)
)

cats$name[1] <- "Lokii"

cats_test <- cats

cats_test$name[1] <- catliss


# how to add stuff onto a data frame?

cats$age <- c(5, 8, 3, 7)

nrow(cats)
ncol(cats)
dim(cats)

new_cat <- list(color = "gray", name = "Jelly Bean", cholesterol = "high")

rbind(cats, new_cat)

library(dplyr)

cats_plus <- bind_rows(cats, new_cat)


# dplyr munging!

gapminder <- read.csv("data/gapminder_data.csv")

str(gapminder)

sum(gapminder$pop[which(gapminder$continent == "Asia" & gapminder$year == 1952)])

gapminder %>%
  filter(continent == "Asia") %>% 
  filter(year == 1952) %>% 
  summarise(
    popSum = sum(pop),
    nCountries = n(),
    pop_per_country_avg = popSum / nCountries,
    nCountries2 = length(country), # same as n()
    nCountries3 = length(unique(country)) # same as n()
  )


gapminder %>%
  filter(continent == "Asia") %>% 
  filter(year == 1952) -> gm_asia_1952

str(gm_asia_1952)

# say you wanted these calculations on EVERY continent for 1952?

gapminder %>%
  group_by(continent) %>% 
  filter(year == 1952) %>% 
  summarise(
    popSum = sum(pop),
    nCountries = n(),
    pop_per_country_avg = popSum / nCountries,
  )

# say you wanted these calculations on EVERY YEAR for ASIA?

gapminder %>%
  filter(continent == "Asia") %>% 
  group_by(year) %>% 
  summarise(
    popSum = sum(pop),
    nCountries = n(),
    pop_per_country_avg = popSum / nCountries,
  ) %>% 
  as.data.frame()

# say you wanted these calculations for EVERY YEAR for EVERY CONTINENT?

gapminder %>%
  group_by(continent, year) %>% 
  summarise(
    countries = toString(country),
    popSum = sum(pop),
    nCountries = n(),
    pop_per_country_avg = popSum / nCountries,
  ) %>% 
  as.data.frame()



# Download the gapminder dataset from the internet
download.file("https://raw.githubusercontent.com/swcarpentry/r-novice-gapminder/main/episodes/data/gapminder_data.csv",
              destfile = "data/gapminder_data.csv")
gapminder <- read.csv("data/gapminder.csv")

# Install packages if not yet
install.packages("ggplot2")
install.packages("dplyr")
# Load packages
library(ggplot2)
library(dplyr)

# Initial plot: plot life expectancy over GDP per capita
## Add data
ggplot(data = gapminder)  # empty pane
## Add mapping aesthestics additionally
ggplot(data = gapminder,
       mapping = aes(x = year, y = lifeExp)) # empty pane with axes set to minimum and maximum values
## Add plotting layer
ggplot(data = gapminder,
       mapping = aes(x = year, y = lifeExp)) +
geom_point() # scatter plot

# Hint: data and mapping are not necessary
ggplot(gapminder,
       aes(x = year, y = lifeExp)) +
geom_point()

# New plot: plot life expectancy over years
ggplot(gapminder, aes(x = year, y = lifeExp)) +
geom_point()

# Add colour by changing the colour of points by continent
ggplot(gapminder, aes(x = year, y = lifeExp, colour = continent)) +
geom_point()

# Instead of a scatter plot, highlight the change over time with lines
ggplot(data = gapminder,
       mapping = aes(x = year, y = lifeExp,
                     group = country, colour = continent)) +
  geom_line()

# We can plot both lines and points
ggplot(data = gapminder,
       mapping = aes(x = year, y = lifeExp,
                     group = country, colour = continent)) +
  geom_line() +
  geom_point() 

# To avoid having both the colours and lines, we can move the colour aesthetics 
# to geom_line
ggplot(data = gapminder,
       mapping = aes(x = year, y = lifeExp)) +
  geom_line(aes(group = country, colour = continent)) +
  geom_point()

# In case, you want different colour schemes for lines and points, you can use "fill" for
# points instead
# This requires us to set the shape to specific shapes that can be filled; you can see an
# overview of all shapes by executing "?pch" in the R console
ggplot(data = gapminder,
       mapping = aes(x = year, y = lifeExp)) +
  geom_line(aes(group = country, colour = continent)) +
  geom_point(aes(fill = continent, shape = continent), colour = "grey30") +
  scale_shape_manual(values = c(21, 22, 23, 24, 25))
  scale_colour_manual()

# Colour names can be specified either by R's known colour names or by their HEX code
# You can find the list of all known R colours here: https://r-charts.com/colors/
  
# Perform simple statistical analysis: linear regression between gdpPercap and lifeExp
# prior to the statistical analysis, we will log10-transform the gdpPercap variable to
# obtain a quasi-linear relationship between the variables
  ggplot(gapminder, aes(x = gdpPercap, y = lifeExp)) +
    geom_point(alpha = 0.3) +
    geom_smooth(method = "lm", linewidth = 2.5, colour = "#FF4040") +
    scale_x_log10()
  
# You can get an overview of which aesthestics you can change for a given geom_ layer
# in ggplot, run "?geom_point" or the name of geom layer in your R console and scroll
# towards the section Aesthestics in the help menu
  
# Let's plot the change of the life expectancy over time per country, displaying each
# country in its own little plot
lifexp_plt <- gapminder %>%
  filter(continent == "Americas") %>%
  ggplot(aes(x = year, y = lifeExp)) +
  geom_line(aes(group = country)) +
  labs( # Allows you to change the name of the axes title, the legend title or set the plot title
    y = "life expectancy [y]",
    title = "Development of the life expectancy in the Americas (1952-2007)"
  ) +
  facet_wrap(~ country) +
  # theme allows you to manipulate the parts of the plot that are independent of data
  theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5),
        strip.background = element_blank())
lifexp_plt
  
# Save plot to PDF
ggsave("~/Desktop/lifexp_development_americas.pdf",
       plot = lifexp_plt,
       width = 12,
       height = 8,
       units = "cm",
       useDingbats = FALSE)
# Reason why to always use "useDingbats = FALSE": https://stackoverflow.com/questions/9992275/ggplot2-pdf-import-in-adobe-illustrator-missing-font-adobepistd
