
install.packages("migest")
library("migest")
  
    mat <- cbind(c(1,2,0.2),c(2,3,0.5),c(3,1,0.3))
    df <- data.frame(mat)
    df
    mig_chord(df)

    
    