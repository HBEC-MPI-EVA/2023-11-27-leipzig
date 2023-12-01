#Linear regression

# Functional dependence:
# y = m + b*x 
# Model:
# y ~ m + b*x + e (e = residuals)

#load libraries and data
library(tidyverse)
#What packages are included in tidyverse:
tidyverse_packages()

getwd()
setwd("~/Dropbox/carpentry-2023/")
gapminder <- read.csv("data/gapminder_data.csv")


#One single country: ----

#we can combine tidyverse with ggplot:

gapminder %>%
  filter(country == "United States") %>%
  ggplot(aes(x = year, y = pop)) +
  geom_point(color="blue") +
  theme_minimal() 

#or, alternatively, build a separate dataset that we will use in the following: 

gapminder %>%
  filter(country == "United States") -> yuesei

yuesei %>%
  ggplot(aes(x = year, y = pop)) +
  geom_point(color="blue") +
  theme_minimal() 


#linear model:
my.model <- lm(pop ~ year, data = yuesei)

summary(my.model)

#we add the predictions so we can plot them:
yuesei$pred_pop <- predict(my.model)

yuesei %>%
  ggplot(aes(x = year, y = pop)) +
  geom_point(color="blue") +
  geom_line(aes(x=year, y=pred_pop), color="red") +
  theme_minimal() 


#how to predict outcomes outside the original dataset:
#1. by hand
coef(my.model)
coef(my.model)[1] -> intercept
coef(my.model)[2] -> slope

new.dataset <- as.data.frame(seq(1902,2052, by=5))
colnames(new.dataset) <- "year"

new.dataset$predictions <- intercept + slope*new.dataset$year

new.dataset %>%
  ggplot(aes(x=year, y= predictions))+
  geom_line()

#the easy way:
new.dataset <- as.data.frame(seq(1902,2052, by=5))
colnames(new.dataset) <- "year"
new.dataset$predictions <- predict(my.model,new.dataset)

new.dataset %>%
  ggplot(aes(x=year, y= predictions))+
  geom_line()


#residuals

yuesei$residuals_pop <- residuals(my.model)

yuesei %>%
  ggplot(aes(x = year, y = residuals_pop)) +
  geom_point(color="blue") +
  geom_hline(yintercept = 0, color="red") +
  theme_minimal() 

#we can repeat this with any country in the dataset:

gapminder %>%
  filter(country == "Argentina") %>%
  ggplot(aes(x = year, y = pop)) +
  geom_point(color="blue") +
  theme_minimal() 


gapminder %>%
  filter(country == "Argentina") -> arg

lm(pop ~ year, data= arg) -> my.model.2
summary(my.model.2)

#Two countries together:-----

gapminder %>%
  filter(country == "Argentina" | country == "United States") -> two.countries

two.countries %>%
ggplot(aes(x = year, y = pop)) +
  geom_point(color="blue") +
  theme_minimal() 

#there is not a clear linear tendency that applies to both datasets. If we try to model it like above:

my.simple.model <- lm(pop ~ year, data = two.countries)
summary(my.simple.model)

#Non-significant coefficients. Let's see how they look:

two.countries$pred_pop <- predict(my.simple.model)

two.countries %>%
  ggplot(aes(x = year, y = pop)) +
  geom_point(color="blue") +
  geom_line(aes(x=year, y=pred_pop), color="red") +
  theme_minimal() 
  
#Horrible. It's just an average of two clearly distinct datasets that doesn't fit any of them correctly

#Let's add a new variable to account for the country:

my.better.model <- lm(pop ~ year + country, data = two.countries)

summary(my.better.model)

#All predictors are significant. It looks good so far...

two.countries$pred_pop <- predict(my.better.model)

two.countries %>%
  ggplot(aes(x = year, y = pop, group=country)) +
  geom_point(color="blue") +
  geom_line(aes(x=year, y=pred_pop), color="red") +
  theme_minimal() 

# not quite, actually. The intercepts are ok, but the slope for the upper dots is clearly underestimated, while that for the lower dots is clearly overestimated

# what this model is doing is using a different intercept for every country, but the same slope for both:

# y_c = m_c + b*x_c 

#which can be seen as:

# y_A = m_A + b*x_A
# y_U = m_U + b*x_U

#or:

# y = if(A)*m_A +if(U)*m_U + b*x

#internally, R is sorting alphabetically (Argentina is the first one), so the raw intercept and slope for year are the ones for Argentina, and the one for the USA adds to the former:

#m_A = (Intercept)
#m_U = (Intercept) + countryUnited States

#This is not enough. Let's try adding an interaction between year and country, which will give us a different slope (year) for each country:

my.best.model <- lm(pop ~ year*country, data = two.countries)
summary(my.best.model)

#Everything's significant, we are good so far...

two.countries$pred_pop <- predict(my.best.model)

two.countries %>%
  ggplot(aes(x = year, y = pop, group=country)) +
  geom_point(color="blue") +
  geom_line(aes(x=year, y=pred_pop), color="red") +
  theme_minimal() 

#looks good now!

#What the model looks like now:

# y_c = m_c + b_c*x_c

#or:

# y_A = m_A + b_A*x_A
# y_U = m_U + b_U*x_U

#more explicitely:

# y = if(A)*m_A +if(U)*m_U + (if(A)*b_A+ if(A)*b_U)*x

#in R terms:

#m_A = (Intercept)
#m_U = (Intercept) + countryUnited States
#b_A = year
#b_U = year + year:countryUnited States

#we can compare these m_U and b_U with those in my.model, and m_A and b_A with those in my.model.2


#Lots of countries:----

#Let's do the same for all the American continent

gapminder %>%
  filter(continent == "Americas") -> americas

americas %>%
  ggplot(aes(x = year, y = pop, group = country)) +
  geom_line(color="blue", alpha=0.2) +
  geom_point(color="blue") +
  theme_minimal() 

#I'm just joining the dots with thin blue segments to see the tendency, these are NOT linear regressions yet

my.american.model <- lm(pop ~ year*country, data = americas)
summary(my.american.model)

#lots of significant stuff!

americas$pred_pop <- predict(my.american.model)

americas %>%
  ggplot(aes(x = year, y = pop, group=country)) +
  geom_point(color="blue") +
  geom_line(aes(x=year, y=pred_pop), color="red") +
  theme_minimal() 

#these are the proper linear functions coming from the regression for each country

#we can plot the residuals too:

americas$residuals <- residuals(my.american.model)

americas %>%
  ggplot(aes(x = year, y = residuals, group=country)) +
  geom_point(color="blue") +
  geom_line(color = "blue", alpha = 0.2) +
  geom_hline(yintercept = 0, color="red") +
  theme_minimal() 

#we can see the residuals trajectory of each country over the years



library(dplyr)
library(ggplot2)

gapminder <- read.csv("data/gapminder_data.csv")

gapminder |>
filter(country == "United States") -> yuesei

yuesei |>
ggplot(aes(x = year, y = pop,
    group = country,
    color = continent)) +
  geom_line() +
  geom_point() +
  scale_y_log10() +
  theme_minimal()

my_model <- lm(pop ~ year, data = yuesei)

new_dat <- data.frame(
  year = c(2023, 2027, 2033, 2037),
  pop = NA
)
new_dat$pop <- predict(my_model, new_dat)



########################## day 5, part ii

# what makes a data table 'wide' or 'long'?

d_normal <- data.frame(
  country = c("China", "China", "USA", "USA"),
  year = c(1997, 1998, 1997, 1998),
  pop = c(1000, 1200, 300, 310),
  gdpPercap = c(40, 45, 65, 70)
)
# one row per country-year
# 'normal' version of this data

d_wide <- data.frame(
  country = c("China", "USA"),
  pop_1997 = c(1000, 300),
  pop_1998 = c(1200, 310),
  gdpPercap_1997 = c(40, 65),
  gdpPercap_1998 = c(45, 70)
)
# one row per country
# a 'wide' version of the data

library(tidyr)

# pivot_longer and pivot_wider

d_long <- data.frame(
  country = c("China", "China", "China", "China", "USA", "USA", "USA", "USA"),
  year = c(1997, 1998, 1997, 1998, 1997, 1998, 1997, 1998),
  variable = c("pop", "pop", "gdpPercap", "gdpPercap", "pop", "pop", "gdpPercap", "gdpPercap"),
  value = c(1000, 1200, 40, 45, 300, 310, 65, 70)
)
# one row is a country-year-variable
# this is a 'long' version of the data


# how to convert between d_long, d_wide and d_normal?

# first: normal to long

d_normal %>% 
  pivot_longer(
    cols = c("pop", "gdpPercap"),
    names_to = "attribute", values_to = "value"
  )

# now: long to normal

d_long %>% 
  pivot_wider(
    names_from = variable,
    values_from = value
  )


# wide to long

d_wide %>% 
  pivot_longer(
    cols = c(
      starts_with("pop"),
      starts_with("gdpPercap")
    ),
    names_to = "attribute_year",
    values_to = "value"
  ) %>% 
  separate(attribute_year, into = c("attribute", "year"), sep = "_") %>% 
  select(country, year, everything()) %>% 
  mutate(year = as.numeric(year))


# long to wide!

d_long %>% 
  unite(variable_year, variable, year, sep = "_") %>% 
  pivot_wider(
    names_from = variable_year,
    values_from = value
  )


# wide to normal
# (wide to (long) to normal)

d_wide %>% 
  pivot_longer(
    cols = c(
      starts_with("pop"),
      starts_with("gdpPercap")
    ),
    names_to = "attribute_year",
    values_to = "value"
  ) %>% 
  separate(attribute_year, into = c("attribute", "year"), sep = "_") %>% 
  select(country, year, everything()) %>% 
  mutate(year = as.numeric(year)) %>% 
  pivot_wider(
    names_from = attribute,
    values_from = value
  )

# normal to wide
# = normal to long then long to wide

d_normal %>% 
  pivot_longer(
    cols = c("pop", "gdpPercap"),
    names_to = "variable", values_to = "value"
  ) %>% 
  unite(variable_year, variable, year, sep = "_") %>% 
  pivot_wider(
    names_from = variable_year,
    values_from = value
  ) -> d_wide_practice



gapminder %>% 
  pivot_longer(
    cols = c("pop", "gdpPercap", "lifeExp"),
    names_to = "variable", values_to = "value"
  ) %>% 
  unite(variable_year, variable, year, sep = "_") %>% 
  pivot_wider(
    names_from = variable_year,
    values_from = value
  ) -> gapminder_wide

View(gapminder_wide)




# misc notes

# join "scripts-and-bytes" and the "R-group"!

library("groundhog") # for loading specific past versions of packages 
groundhog.day = '2022-01-01'

#Load other packages 
groundhog.library(c('tidyverse', 'lubridate', 'brms', 'tidybayes'),groundhog.day)


# for saving a data frame to XLSX

library(openxlsx) # install.packages("openxlsx")

write.xlsx(d_wide_practice, "gapminder_wide.xlsx")

# for citing a package

citation("brms")

# using type.convert to reformat a data frame's variables

gapminder$year <- as.numeric(gapminder$year)
gapminder2 <- type.convert(gapminder, as.is = TRUE)






