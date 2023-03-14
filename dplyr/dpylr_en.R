# Set-up -----------------------------------------------------------------------

# The purpose of this script is to introduce the basics of dplyr.

# author : @alannagenin

# Packages ---------------------------------------------------------------------

# empty the environment
rm(list = ls())

# if dplyr not installed
# install.packages(“dplyr”)
library(dplyr)
library(ggplot2)

# colors
install.packages("wesanderson")
library(wesanderson)
library(RColorBrewer)

# Introduction to dplyr --------------------------------------------------------

# The %>% operator is a pipe, it enables passing several functions at once keeping
# the code redable.
# keyboard shortcut CTRL + SHIFT + M

# creating a data frame
df <- data.frame(a = 0, b = c(1, 2, 3), c = c(NaN, 5, 6), d = 6)

# Without the %>% operator
select(df, a, b)

# By using the %>% operator
df %>% select(a, b)

# Documentation: https://dplyr.tidyverse.org/
# dplyr is a grammar of data manipulation, providing a consistent set of verbs
# that help you solve the most common data manipulation challenges:
# mutate() adds new variables that are functions of existing variables
# select() picks variables based on their names.
# filter() picks cases based on their values.
# summarise() reduces multiple values down to a single summary.
# arrange() changes the ordering of the rows.

# Cheat sheet: https://raw.githubusercontent.com/rstudio/cheatsheets/main/data-transformation.pdf

# Data -------------------------------------------------------------------------

# see all the built-in datasets
# data()

# we will take the starwars dataset
# load the dataset in the global environment
data("starwars")

# Examples ---------------------------------------------------------------------

# head: print x first elements
starwars %>% head()

# summarise: get a summary of the dataset
starwars %>% summarise(
  n = n(),
  total_mass = sum(mass, na.rm = TRUE),
  total_height = sum(height, na.rm = TRUE),
  avg_mass = mean(mass, na.rm = TRUE),
  avg_height = mean(height, na.rm = TRUE)
)

# summarise + group_by: get a summary of the dataset by specie
starwars %>%
  group_by(species) %>% 
  summarise(
    n = n(),
    avg_mass = mean(mass, na.rm = TRUE),
    avg_height = mean(height, na.rm = TRUE)
  )


# select: keep first 3 columns
starwars %>% 
  select(name, height, mass)
# or
starwars %>% 
  select(name:mass)
# or
starwars %>% 
  select(1:3)

# select: keep columns that end with 'color'
starwars %>% 
  select(name, ends_with("color"))

# filter: select all the female characters
female_characters <- starwars %>% filter(sex == "female")

# mutate: compute the BMI index where BMI = mass/height^2 (mass in kg and height in m)
# caution here height in cm
starwars %>% 
  mutate(bmi = mass / ((height/100)  ^ 2))

# group_by + summarise + filter: compute the number of characters and their 
# average mass for each specie and keep only those who have at least 2 people and
# an average mass of 50 kg.
starwars %>%
  group_by(species) %>%
  summarise(
    n = n(),
    avg_mass = mean(mass, na.rm = TRUE)
  ) %>%
  filter(
    n > 1,
    avg_mass > 50
  )

# distinct: remove rows with duplicate values
starwars %>% 
  select(homeworld) %>% 
  distinct()

# Hands-on ---------------------------------------------------------------------

# 1) starwars: keep masculine characters that have a light skin color


# 2) starwars: mean birth year per home world sorted by avg_birth_year (desc)


# 3) load iris dataset


# 4) iris: keep columns that end with 'width' + print 6 first rows


# 5) iris: keep columns that start with 'sepal' + print 6 first rows


# Hints ---------------------------------------------------------------------

# 1) starwars: keep masculine characters that have a light skin color
# --> use select + filter

# 2) starwars: mean birth year per home world sorted by avg_birth_year (desc)
# --> use group_by + mutate + select + arrange

# 3) load iris dataset
# --> use data

# 4) iris: keep columns that end with 'width' + print 6 first rows
# --> use select + head

# 5) iris: keep columns that start with 'sepal' + print 6 first rows
# --> use select + head

# ggplot -----------------------------------------------------------------------

# geom_point: plot the height and mass of female characters
ggplot(female_characters) +
  geom_point(aes(x=height, y=mass))

# geom_boxplot: boxplot of mass given by the sex of the characters
ggplot(starwars) +
  geom_boxplot(aes(x=sex, y=mass))

# add colors
ggplot(starwars %>% filter(mass < 100)) +
  geom_boxplot(aes(x=sex, y=mass, fill=sex)) +
  ylim(c(0, 100)) +
  scale_fill_manual(values = wes_palette(name="GrandBudapest2", n=4)) +
  theme_minimal()

# add labels
ggplot(starwars %>% filter(mass < 100)) +
  geom_boxplot(aes(x=sex, y=mass, fill=sex)) +
  ylim(c(0, 100)) +
  scale_fill_manual(values = brewer.pal(n = 4, name = "Paired")) +
  labs(
    title = "Mass boxplot per sex",
    x = "Sex",
    y = "Mass"
  ) +
  theme_minimal()

# Hands-on ---------------------------------------------------------------------

# 1) plot the histogram of height distribution


# 2) plot the histogram of height distribution changing the theme and adding a title


# 3) plot the histogram of height distribution by gender changing the theme and 
# adding a title


# 4) plot the histogram of height distribution by gender changing the theme and 
# adding a title having one graph per gender


# Hints ------------------------------------------------------------------------

# 1) plot the histogram of height distribution
# geom_histogram

# 2) plot the histogram of height distribution changing the theme and adding a title
# labs and theme_xx where xx is the name of a theme

# 3) plot the histogram of height distribution by gender changing the theme and 
# adding a title
# geom_histogram(aes(x=height, fill=gender))

# 4) plot the histogram of height distribution by gender changing the theme and 
# adding a title having one graph per gender
# facet_grid(rows = xxx) --> replace xxx
# scale_fill_manual(xxx)--> replace xxx