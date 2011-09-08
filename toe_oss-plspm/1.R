library(car)

data <- read.csv("badanie2__216.csv", header=T, sep=";");

##dd=rnorm(216)/2 + data$s10;

##
vif(lm(data$ocenaoss ~ data$s7 + data$s8 + data$s9 + data$s10));

##
vif(lm(data$ocenaoss ~ data$s2 + data$s3 + data$s4 + data$s5 + data$s6 ));

vif(lm(data$ocenaoss ~ data$s11 + data$s12 ));

vif(lm(data$ocenaoss ~ data$s13 + data$s14 ));

summary(data);
sd(data);


