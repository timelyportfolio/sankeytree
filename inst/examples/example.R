library(rpart)
library(partykit)
library(pipeR)

#set up a little rpart as an example
rp <- rpart(
  hp ~ cyl + disp + mpg + drat + wt + qsec + vs + am + gear + carb,
  method = "anova",
  data = mtcars,
  control = rpart.control(minsplit = 4)
)

#convert rpart to a hierarchy using convert_rpart in converters.R
# this was the original conversion
# and I already see lots of room for improvement
convert_rpart(rp)
