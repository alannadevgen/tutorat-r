# Configuration ----------------------------------------------------------------

# Le but de ce script est d'introduire les rudiments de dplyr.

# auteur : @alannagenin

# Packages ---------------------------------------------------------------------

# vider l'environnement
rm(list = ls())

# si dplyr n'est pas installé décommenter la ligne ci-dessous
# install.packages("dplyr")
library(dplyr)
library(ggplot2)

# couleurs
install.packages("wesanderson")
library(wesanderson)
library(RColorBrewer)

# Introduction à dplyr --------------------------------------------------------

# L'opérateur %>% est un pipe, il permet de passer plusieurs fonctions à la fois 
# en gardant le code lisible.
# raccourci clavier CTRL + SHIFT + M

# création d'un data frame
df <- data.frame(a = 0, b = c(1, 2, 3), c = c(NaN, 5, 6), d = 6)

# Sans l'opérateur %>%
select(df, a, b)

# En utilisant l'opérateur %>%
df %>% select(a, b)

# Documentation : https://dplyr.tidyverse.org/
# dplyr est une grammaire de manipulation de données, fournissant un ensemble cohérent de verbes
# qui aide à résoudre les défis de manipulation de données les plus courants :
# mutate() ajoute de nouvelles variables qui sont des fonctions de variables existantes
# select() sélectionne les variables en fonction de leurs noms/index.
# filter() sélectionne les lignes en fonction de leurs valeurs.
# summarise() réduit plusieurs valeurs à un seul résumé.
# arrange() change l'ordre des lignes.

# Cheat sheet : https://raw.githubusercontent.com/rstudio/cheatsheets/main/data-transformation.pdf

# Données ----------------------------------------------------------------------

# voir tous les jeux de données built-in
data()

# charger le jeu de données dans l'environnement global
# nous prendrons le jeu de données starwars
data("starwars")

# Exemples ---------------------------------------------------------------------

# head: afficher les x premiers éléments
starwars %>% head()

# summarise: obtenir un résumé du jeu de données
starwars %>% summarise(
  n = n(),
  total_mass = sum(mass, na.rm = TRUE),
  total_height = sum(height, na.rm = TRUE),
  avg_mass = mean(mass, na.rm = TRUE),
  avg_height = mean(height, na.rm = TRUE)
)

# summarise + group_by : obtenir un résumé du dataset par espèce
starwars %>%
  group_by(species) %>% 
  summarise(
    n = n(),
    avg_mass = mean(mass, na.rm = TRUE),
    avg_height = mean(height, na.rm = TRUE)
  )


# select : garder les 3 premières colonnes
starwars %>% 
  select(name, height, mass)
# ou
starwars %>% 
  select(name:mass)
# ou
starwars %>% 
  select(1:3)

# select : garder les colonnes qui se terminent par 'color'
starwars %>% 
  select(name, ends_with("color"))

# filter : sélectionner tous les personnages féminins
female_characters <- starwars %>% filter(sex == "female")

# mutate : calculer l'indice de masse corporelle (IMC) où IMC = masse/taille^2 (masse en kg et taille en m)
# attention ici la hauteur est en cm
starwars %>% 
  mutate(bmi = mass / ((height/100)  ^ 2))

# group_by + summarise + filter : calculer le nombre de personnages et leur masse moyenne pour chaque espèce 
# et ne garder que ceux qui ont au moins 2 personnes et une masse moyenne de 50 kg.
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

# distinct : supprimer les lignes avec des valeurs en double
starwars %>% 
  select(homeworld) %>% 
  distinct()

# A vous ! ---------------------------------------------------------------------

# 1) starwars : garder les personnages masculins qui ont une couleur de peau claire

# 2) starwars : année de naissance moyenne par planète d'origine triée par année décroissante

# 3) charger le dataset iris

# 4) iris : garder les colonnes qui se terminent par 'width' + afficher les premières lignes

# 5) iris : garder les colonnes qui commencent par 'sepal' + afficher les premières lignes

# Indices ----------------------------------------------------------------------

# 1) starwars : garder les personnages masculins qui ont une couleur de peau claire
# --> utiliser select + filter

# 2) starwars : année de naissance moyenne par planète d'origine triée par année moyenne (desc)
# --> utiliser group_by + mutate + select + arrange

# 3) charger le dataset iris
# --> utiliser data

# 4) iris : garder les colonnes qui se terminent par 'width' + afficher les premières lignes
# --> utiliser select + head

# 5) iris : garder les colonnes qui commencent par 'sepal' + afficher les premières lignes
# --> utiliser select + head

# ggplot -----------------------------------------------------------------------

# geom_point: plot de la taille et de la masse des personnages féminins
ggplot(female_characters) +
  geom_point(aes(x=height, y=mass))

# geom_boxplot: boxplot de la masse en fonction du sexe des personnages
ggplot(starwars) +
  geom_boxplot(aes(x=sex, y=mass))

# ajouter des couleurs
ggplot(starwars %>% filter(mass < 100)) +
  geom_boxplot(aes(x=sex, y=mass, fill=sex)) +
  ylim(c(0, 100)) +
  scale_fill_manual(values = wes_palette(name="GrandBudapest2", n=4)) +
  theme_minimal()

# enlever la légende à droite
ggplot(starwars %>% filter(mass < 100)) +
  geom_boxplot(aes(x=sex, y=mass, fill=sex)) +
  ylim(c(0, 100)) +
  scale_fill_manual(values = brewer.pal(n = 4, name = "Paired")) +
  labs(
    title = "Boxplot de la masse par sexe",
    x = "Sexe",
    y = "Masse"
  ) +
  theme_minimal() +
  theme(
    legend.position = "none"
  )

# A vous ! ---------------------------------------------------------------------

# 1) tracer l'histogramme de la distribution des tailles

# 2) tracer l'histogramme de la distribution des tailles en changeant le thème et en ajoutant un titre

# 3) tracer l'histogramme de la distribution des tailles par genre en changeant le thème et en ajoutant un titre

# 4) tracer l'histogramme de la distribution des tailles par genre en changeant le thème et en ajoutant un titre ayant un graphique par genre

# Indices ------------------------------------------------------------------------

# 1) tracer l'histogramme de la distribution de la taille des personnages
# geom_histogram

# 1) tracer l'histogramme de la distribution de la taille des personnages + changer le thème et ajouter un titre
# labs et theme_xx où xx est le nom d'un thème

# 3) tracer l'histogramme de la distribution des tailles par genre (couleur de fond) en changeant le thème et
# en ajoutant un titre
# geom_histogram(aes(x=height, fill=gender))

# 4) tracer l'histogramme de la distribution de la taille par genre en changeant le thème et en # ajoutant un titre. 
# ajouter un titre avoir un graphique par sexe
# facet_grid(rows = xxx) --> remplacer xxx
# scale_fill_manual(xxx)--> remplacer xxx
  
