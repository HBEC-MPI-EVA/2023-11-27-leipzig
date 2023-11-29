
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

gapminder <- read.csv("data/gapminder_data.csv")

library(ggplot2)

ggplot(data = gapminder,
       mapping = aes(x = gdpPercap, y = lifeExp))

