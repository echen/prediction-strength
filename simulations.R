library(scatterplot3d)

# Three clusters in 2 dimensions
x = c(rnorm(20, mean = 0), rnorm(20, mean = 3), rnorm(20, mean = 5))
y = c(rnorm(20, mean = 0), rnorm(20, mean = 5), rnorm(20, mean = 0))
data = cbind(x, y)

png("3_clusters_2d.png")
qplot(x, y)
dev.off()

png("3_clusters_2d_ps.png")
prediction_strength(data)
dev.off()

# Four clusters in 3 dimensions
x = c(rnorm(20, mean = 0), rnorm(20, mean = 3), rnorm(20, mean = 5), rnorm(20, mean = -10))
y = rnorm(80, mean = 0)
z = c(rnorm(40, mean = -5), rnorm(40, mean = 0))
data = cbind(x, y, z)

png("4_clusters_3d.png")
scatterplot3d(x, y, z)
dev.off()

png("4_clusters_3d_ps.png")
prediction_strength(data)
dev.off()