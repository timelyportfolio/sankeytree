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


# do with kyphosis example
sankeytree(
  rpart(Kyphosis ~ Age + Number + Start, data = kyphosis),
  maxLabelLength = 10,
  nodeHeight = 200
)



# try standard flare.json d3.js hierarchy
url <- "http://bl.ocks.org/mbostock/raw/1093025/flare.json"
flare <- jsonlite::fromJSON(url,simplifyDataFrame=FALSE)
sankeytree(flare)

# use data.tree to assign a size at each level
library(data.tree)
flare_dt <- as.Node(flare,mode="explicit",childrenName="children")
# only assigned at the lower levels
flare_dt$Get("size")
# assign a size at each level with sum
flare_dt$Do(
  function(x) {
    Aggregate(x, "size", sum, cacheAttribute = "size", traversal = "post-order")
  }
)
sankeytree(as.list(flare_dt,mode="explicit",unname=TRUE))
