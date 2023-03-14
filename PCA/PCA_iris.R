if (!require("FactoMineR")) install.packages("FactoMineR")
if (!require("factoextra")) install.packages("factoextra")

# Load the required libraries
library(FactoMineR)
library(factoextra)

# Load the iris dataset
data(iris)

# Remove any rows with missing data
iris <- na.omit(iris)

# Select the numeric columns to use in the analysis
numeric_cols <- sapply(iris, is.numeric)
numeric_data <- iris[, numeric_cols]

# Scale the numeric data to have mean 0 and standard deviation 1
scaled_data <- scale(numeric_data)

# Perform PCA on the iris dataset
iris.pca <- PCA(scaled_data, graph = FALSE)

# Print the summary of the PCA results
summary(iris.pca)

# Useful link: http://www.sthda.com/english/wiki/fviz-pca-quick-principal-component-analysis-data-visualization-r-software-and-data-mining
# Plot the results
fviz_pca_var(
  iris.pca, col.var = "contrib", 
  gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"), 
  repel = TRUE
)

fviz_pca_ind(
  iris.pca, col.ind = iris$Species, 
  palette = c("#00AFBB", "#E7B800", "#FC4E07"), 
  addEllipses = TRUE, 
  ellipse.type = "t", 
  legend.title = "Species", 
  repel = TRUE
)

# Change the color by groups, add ellipses
fviz_pca_biplot(
  iris.pca, label="var", habillage=iris$Species,
  palette = c("#00AFBB", "#E7B800", "#FC4E07"), 
  addEllipses=TRUE, ellipse.level=0.95
)

# fviz_pca_biplot(
#   iris.pca, axes = c(1, 2), geom = c("point", "text"),
#   label = "all", invisible = "none", labelsize = 4, pointsize = 2,
#   habillage = "none", addEllipses = FALSE, ellipse.level = 0.95,
#   col.ind = "black", col.ind.sup = "blue", alpha.ind = 1,
#   col.var = "steelblue", alpha.var = 1, col.quanti.sup = "blue",
#   col.circle = "grey70"
# ) 
