# About

An implementation of the prediction strength algorithm from Tibshirani, Walther, Botstein, and Brown's "Cluster validation by prediction strength".

# Examples

		# Three clusters in 2 dimensions
		x = c(rnorm(20, mean = 0), rnorm(20, mean = 3), rnorm(20, mean = 5))
		y = c(rnorm(20, mean = 0), rnorm(20, mean = 5), rnorm(20, mean = 0))
		data = cbind(x, y)

		png("examples/3_clusters_2d.png")
		qplot(x, y)
		dev.off()
		
![3 clusters in 2 dimensions](https://github.com/echen/prediction-strength/raw/master/examples/3_clusters_2d.png)

		png("examples/3_clusters_2d_ps.png")
		prediction_strength(data)
		dev.off()
		
![3 clusters in 2 dimensions](https://github.com/echen/prediction-strength/raw/master/examples/3_clusters_2d_ps.png)

		# Four clusters in 3 dimensions
		x = c(rnorm(20, mean = 0), rnorm(20, mean = 3), rnorm(20, mean = 5), rnorm(20, mean = -10))
		y = rnorm(80, mean = 0)
		z = c(rnorm(40, mean = -5), rnorm(40, mean = 0))
		data = cbind(x, y, z)

		png("examples/4_clusters_3d.png")
		scatterplot3d(x, y, z)
		dev.off()
		
![4 clusters in 3 dimensions](https://github.com/echen/prediction-strength/raw/master/examples/4_clusters_3d.png)
		
		png("examples/4_clusters_3d_ps.png")
		prediction_strength(data)
		dev.off()
		
![4 clusters in 3 dimensions](https://github.com/echen/prediction-strength/raw/master/examples/4_clusters_3d_ps.png)