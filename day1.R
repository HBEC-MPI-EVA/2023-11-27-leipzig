6*7
print("Ciao Leipzig")
print(x = "Ciao Leipzig")
print(x = "Ciao Leipzig", quote = FALSE)
print(x = "Hello Kitty")

six_times_seven <- 6*7

print(x = six_times_seven)

install.packages("ggplot2")
library(ggplot2)

ggplot()

ggplot2::ggplot()

#data types and structures
greetings_city_vec <- c("Ciao leipzig", "Goodbye Berlin", "Hi Dresden")

greetings_city_vec[3]

str(greetings_city_vec)

num_vec <- c(1, 2, 3)

str(num_vec)

chr_vec <- c("1", "2", "3", "HEDVIG")

as.numeric(chr_vec)

output <- empty_vec <- c(,)

as.numeric(empty_vec)

as.character(num_vec)

log_vec <- as.numeric(c(TRUE, FALSE))

sum(log_vec)

num_log_vec <- as.numeric(log_vec)

as.character(log_vec)

name_vec <- c("Angela", "Hedvig", "Ezequiel")
sort(name_vec)

name_factor_vec <- factor(x = c("Angela", "Hedvig", "Ezequiel", "Hedvig", "Bret", "Hedwig"), 
                          levels = c("Ezequiel", "Hedvig", "Angela"))
name_factor_vec

sort(name_factor_vec)
sum(name_factor_vec)
sum(chr_vec)

names_as_numbers <- as.numeric(name_vec)

as.numeric(name_factor_vec)

list <- list("hedvig", TRUE, 1)

str(list)

gapminder <- read.csv("https://raw.githubusercontent.com/swcarpentry/r-novice-gapminder/main/episodes/data/gapminder_data.csv")

str(gapminder)

gapminder[3:6,4:6]

sum(gapminder$pop)

not_afgan_gapminder <- subset(x = gapminder, country != "Afghanistan")

empty <- c()
empty_2 <- c("", "", NA)
str(empty_2)

base::table(gapminder$country, useNA = "always")

table(empty_2, useNA = "always")

afgan_gapminder <- subset(x = gapminder, country == "Afghanistan")

gapminder$country == "Afghanistan"

afgan_gapminder$year

year_1992_dataframe  <- subset(x = gapminder, year == 1992)

sum(year_1992_dataframe$pop)

year_1992_dataframe$pop

format(max(year_1992_dataframe$pop), big.mark = ",")

format(year_1992_dataframe$pop, big.mark = ",")

year_1992_dataframe$pop <- format(year_1992_dataframe$pop, big.mark = ",")

sum(year_1992_dataframe$pop)

subset(year_1992_dataframe, pop == max(year_1992_dataframe$pop))

subset(year_1992_dataframe, pop == 3333333333333333333333)

subset(year_1992_dataframe, country == "afganistan")

year_1992_dataframe[year_1992_dataframe$pop == max(year_1992_dataframe$pop),4]

year_1992_dataframe[, "country"]
year_1992_dataframe$country

max(year_1992_dataframe[,3])

str(year_1992_dataframe$pop)

chara_vector <- c("Hedvig", "Ezequiel")

max(chara_vector)

letter_vector <- c("A","b", "AA", "B","c", "3", NA, NULL, "   b", "   ")
max(letter_vector, na.rm = TRUE)
sort(letter_vector)

str(year_1992_dataframe)
table(year_1992_dataframe$pop)
unique(year_1992_dataframe$pop)

is.numeric(letter_vector)
is.character(letter_vector)
is.factor(letter_vector)

letter_vector <- c("A","b", "AA", "B","c", "3", NA, NULL, "   b", "   ", NaN)

is.na(letter_vector)

letter vector <- c("A","b", "AA", "B","c", "3", NA, NULL, "   b", "   ", NaN, NULL, NULL, NULL)
print(letter vector)

is.na(c("letter_vector"))

length(c("letter_vector"))
length(letter_vector)
length(letter vector)
length(letter vector)

length(c(NA, "hello"))

is.nan(letter vector)

str(c(1, "hedvig",TRUE))