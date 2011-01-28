# An implementation of the prediction strength algorithm from Tibshirani, Walther, Botstein, and Brown's "Cluster validation by prediction strength".

library(ggplot2)

# Given a matrix `data`, where rows are observations and columns are individual dimensions, compute and plot the prediction strength.
prediction_strength = function(data, min_num_clusters = 1, max_num_clusters = 10, num_trials = 5) {
	num_clusters = min_num_clusters:max_num_clusters
	prediction_strengths = c()
	for (i in 1:num_trials) {
		y = maply(num_clusters, function(n) calculate_prediction_strength(data, n))
		prediction_strengths = cbind(prediction_strengths, y)
	}
	
	means = aaply(prediction_strengths, 1, mean)
	stddevs = aaply(prediction_strengths, 1, sd)
	
	print(plot_prediction_strength(means, stddevs, num_clusters))

	# We use 0.8 as our prediction strength threshold. Find the largest number of clusters with a prediction strength greater than this threshold; this forms our estimate of the number of clusters.
	if (any(means > 0.8)) {
		estimated = max((1:length(means))[means > 0.8])		
	} else {
		estimated = which.max(means)
	}
	print(paste("The estimated number of clusters is ", estimated, ".", sep = ""))	
}

plot_prediction_strength = function(means, stddevs, num_clusters) {
	qplot(num_clusters, means, xlab = "# clusters", ylab = "prediction strength", geom = "line", main = "Estimating the number of clusters via the prediction strength") + geom_errorbar(aes(num_clusters, ymin = means - stddevs, ymax = means + stddevs), size = 0.3, width = 0.2, colour = "darkblue")
}

calculate_prediction_strength = function(data, num_clusters) {
	# R's k-means algorithm doesn't work when there is only one cluster.
	if (num_clusters == 1) {
		1 # The prediction strength is always 1 for 1 cluster, in any case.
	} else {
		rands = runif(nrow(data), min = 0, max = 1)
		training_set = data[(1:length(rands))[rands <= 0.5], ]
		test_set = data[(1:length(rands))[rands > 0.5], ]		
		
		# Run k-means `nstart` times.
		kmeans_training = kmeans(training_set, centers = num_clusters, nstart = 10)
		kmeans_test = kmeans(test_set, centers = num_clusters, nstart = 10)
		
		# The prediction strength is the minimum prediction strength among all clusters.
		prediction_strengths = maply(1:num_clusters, function(n) prediction_strength_of_cluster(test_set, kmeans_test, kmeans_training$center, n))
		min(prediction_strengths)
	}	
}

# Calculate the proportion of pairs of points in test cluster `k` that would again be assigned to the same cluster, if each were clustered according to its closest training cluster mean.
prediction_strength_of_cluster = function(test_set, kmeans_test, training_centers, k) {
	if (sum(kmeans_test$cluster == k) <= 1) {
		1 # No points in the cluster.
	} else {
		test_cluster = test_set[kmeans_test$cluster == k, ]
		count = 0
		for (i in 1:(nrow(test_cluster)-1)) {
			for (j in (i+1):nrow(test_cluster)) {
				p1 = test_cluster[i, ]
				p2 = test_cluster[j, ]			
				if (closest_center(training_centers, p1) == closest_center(training_centers, p2)) {
					count = count + 1
				}
			}
		}
		# Return the proportion of pairs that stayed in the same cluster.
		count / (nrow(test_cluster) * (nrow(test_cluster) - 1) / 2) 
	}
}

# Returns the index of the center that x is closest to. (TODO: Vectorize...)
closest_center = function(centers, x) {
	min_index = -1
	min_distance = 999999
	for (i in 1:nrow(centers)) {
		center = centers[i, ]
		d = sum((x - center)^2)
		if (d < min_distance) {
			min_index = i
			min_distance = d
		}
	}
	min_index
}