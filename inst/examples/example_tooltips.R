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

# some examples of tooltips
# null tooltip so nothing
sankeytree(rp, nodeHeight = 50)
# some simple variables
sankeytree(rp, nodeHeight = 50, tooltip = list("n"))
sankeytree(rp, nodeHeight = 50, tooltip = list("n","description"))
# a javascript function
sankeytree(rp, nodeHeight = 50,
   tooltip = htmlwidgets::JS("function(d){return d.n}")
)
# arbitray html
sankeytree(rp, nodeHeight = 50,
   tooltip = htmlwidgets::JS("
function(d){
  return [
    '<div style=\"overflow:scroll;\">',
    '<h1>I Am A Tooltip</h1>',
    '<p>tooltips can do amazing things if built correctly</p>',
    '<p>I could be even be a chart</p>',
    '</div>'
  ].join(' ');
}
  ")
)

