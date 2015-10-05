library(rpart)
library(partykit)
library(pipeR)
library(sankeytreeR)

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
sankeytreeR:::convert_rpart(rp)

#see what it looks like
sankeytree(rp)

sankeytree(rp, maxLabelLength = 10, nodeHeight = 100)
