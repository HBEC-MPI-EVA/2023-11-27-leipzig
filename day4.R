
# 1) functions and vectorization in R

calc_fahrenheit_to_celcius <- function(x) {
  x <- as.numeric(x)
  if(is.na(x)) stop()
  out <- (5/9) * (x - 32)
  out <- round(out, 1)
  return(out)
}

calc_celcius_to_fahrenheit <- function(x) {
  output <- 9/5 * x + 32
  return(output)
}

calc_celcius_to_fahrenheit(calc_fahrenheit_to_celcius(100))

gapminder <- read.csv("gapminder_data.csv")

calc_fahrenheit_to_celcius(gapminder$gdpPercap) # works, but weird

library(dplyr)



gapminder %>%
  filter(continent == "Asia") %>% 
  filter(year == 1952) %>% 
  summarise(
    countries = toString(country),
    popSum = sum(pop),
    nCountries = n(),
    pop_per_country_avg = popSum / nCountries,
  ) %>% 
  as.data.frame()


calc_avg_pop <- function(my_dat, my_continent, my_year = 1982) {

  if(!all(c("continent", "year") %in% names(my_dat))) stop("data frame is missing continent or year")
  if(nrow(my_dat) == 0) warning("data frame contains no rows")
  
  out <- my_dat %>% 
    filter(continent == my_continent) %>% 
    filter(year == my_year) %>% 
    summarise(
      popSum = sum(pop),
      nCountries = n(),
      pop_per_country_avg = popSum / nCountries,
    ) %>% 
    as.data.frame()
  
  return(out)
  
}


calc_avg_pop(my_dat = gapminder, my_continent = "Europe", my_year = 1962)
calc_avg_pop(my_continent = "Europe", my_year = 1962, my_dat = gapminder)

calc_avg_pop(gapminder, "Europe", 1962)
calc_avg_pop(gapminder, "Europe", 1972)
calc_avg_pop(gapminder, "Asia", 1982)

calc_avg_pop(gapminder, "Asia")




# defensive programming in functions

# if (...) stop()
# if (...) warning()
# stopifnot
# is.numeric, is.na


# using dput





# 2) stochastic simulation and the Kelly betting model

# if you could double your money on a coin flip, or lose it all, would you do it?

y <- 1
if (runif(1) < 0.5) {
  y <- y + y
  # y <- 2 * y
  print(paste("you win! current value is", y))
} else {
  y <- y - y
  # y <- 0
  print(paste("you lose! current value is", y))
}



# n_flips - number of times we make the bet
# pr_win - probability of winning the bet


n_flips <- 10
pr_win <- 0.9
s <- 1.0 # stake, fraction of y willing to bet

y <- 1
for (i in 1:n_flips){
  if (runif(1) < pr_win) {
    y <- y + s * y
    print(paste("bet", i, "- you win! current value is", y))
  } else {
    y <- y - s * y
    print(paste("bet", i, "- you lose! current value is", y))
  }
}






bet_sim <- function(n_flips, pr_win, s, verbose = FALSE){
  
  if(!is.numeric(pr_win)) stop()
  if(pr_win > 1) stop()
  if(pr_win < 0) stop()

  if(!is.numeric(s)) stop()
  if(s > 1) stop()
  if(s < 0) stop("invalid s")

  if (n_flips <= 0) stop()
    
  y <- 1
  for (i in 1:n_flips){
    if (runif(1) < pr_win) {
      y <- y + s * y
      if (verbose) print(paste("bet", i, "- you win! current value is", y))
    } else {
      y <- y - s * y
      if (verbose) print(paste("bet", i, "- you lose! current value is", y))
    }
  }
  return(y)  
}

bet_sim(n_flips = 10, pr_win = 0.9, s = 1.0)

bet_sim(n_flips = 1, pr_win = 0.9, s = 0.5)

bet_sim(n_flips = 1000, pr_win = 0.8, s = 0.1)



# parameter sweep over s, the stake size

dat <- data.frame(
  s = seq(0, 1, by = 0.05),
  pr_win = seq(0, 1, by = 0.05),
  avg_payoff = NA,
  median_payoff = NA
)

pr_win <- 0.9

for (i in 1:nrow(dat)) {
  y_sim <- replicate(10000, bet_sim(n_flips = 10, pr_win = pr_win, s = dat$s[i]))
  dat$avg_payoff[i] <- mean(y_sim)
  dat$median_payoff[i] <- median(y_sim)
  print(i)
}

par(mfrow = c(1, 2))
plot(dat$s, dat$avg_payoff, type = "l")
plot(dat$s, dat$median_payoff, type = "l")


# kelly criterion: optimum (median maximized) stake is 2 * pr_win - 1
# if pr_win > 0.5
# if pr_win < 0.5, bet nothing!
# https://en.wikipedia.org/wiki/Kelly_criterion

abline(v = 2 * pr_win - 1, lty = 2)


# if we wanted a full grid search 
dat <- expand.grid(
  s = seq(0, 1, by = 0.1),
  pr_win = seq(0, 1, by = 0.1),
  n_flips = seq(10, 100, by = 10),
  avg_payoff = NA,
  median_payoff = NA
)



























