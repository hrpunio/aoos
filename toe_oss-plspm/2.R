library(car)

vif(lm(prestige ~ income + education, data=Duncan))

vif(lm(prestige ~ income + education + type, data=Duncan))

