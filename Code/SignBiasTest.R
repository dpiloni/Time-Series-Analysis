SignBiasTest <- function(rendimenti,residui) {
	rendimenti <- as.vector(rendimenti)
      residui <- as.vector(residui)
	segno <- matrix(0,length(rendimenti),1)
	for(i in 2:length(rendimenti)){ 
			if(rendimenti[i-1] < 0) {segno[i] <- 1} 
		}
	b1 <- segno[2:length(rendimenti)]
	serie2 <- residui^2
	sign <- lm(serie2[2:length(residui)] ~ b1)
	return(sign)
}