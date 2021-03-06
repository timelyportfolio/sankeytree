#' Convert rpart to d3.js hierarchy
#' 
#' This thing is not even close to being done.
#' 
#' @param rpart_data \code{rpart} object to be converted
convert_rpart = function (rpart_data = NULL) {
  rpk <- as.party(rpart_data)
  data = rapply(rpk$node,unclass,how="replace")
  #fill in information at the root level for now
  #that might be nice to provide to our interactive graph
  data$info = rapply(
    unclass(rpk)[-1]
    ,function(l){
      l = unclass(l)
      if( class(l) %in% c("terms","formula","call")) {
        l = paste0(as.character(l)[-1],collapse=as.character(l)[1])
      }          
      attributes(l) <- NULL
      return(l)
    }
    ,how="replace"
  )
  
  #get all the other meta data we need and merge it in to the list
  
  ## changed pattern from [1-9] to [0-9] because we were missing node 10 
  rpk.text <- invisible( capture.output( print(rpk) ) ) %>>%
    ( .[grep( x = ., pattern = "(\\[)([0-9]*)(\\])")] ) %>>%
    strsplit( "[\\[\\|\\]]" , perl = T) %>>%
    (
      lapply(
        seq.int(1,length(.)),
        function(i){
          x <- .[[i]]
          tail(x,2) %>>%
            (tail_data ~
               data.frame(
                 "id" = as.numeric(tail_data[1])
                 , description = tail_data[2]
                 , stringsAsFactors = F
               ) 
            )
        }
      )
    )  %>>%
    (do.call(rbind,.))
  
  # binding the node names from rpk with more of the relevant meta data from rp
  # i don't think that partykit imports this automatically for the inner nodes, so i did it manually
  rpk.text <- cbind(rpk.text, rpart_data$frame)
  
  # rounding the mean DV value
  rpk.text$yval <- round(rpk.text$yval, 2)
  
  # terminal nodes have descriptive stats in their names, so I stripped these out
  # so the final plot wouldn't have duplicate data
  rpk.text$description <- sapply(strsplit(rpk.text[,2], ":"), "[", 1)  
  
  # do the merge of rpk.text with data by
  # walking the tree and joining by id
  join_data <- function(l){
    l <- unclass(l)
    modifyList(l,subset(rpk.text,id==l$id))
  }
  
  merge_data <- function(l){
    l <- join_data(l)
    if("kids" %in% names(l) && length(l$kids)>0){
      lapply(
        1:length(l$kids),
        function(n){
          l$kids[[n]] <<- merge_data(l$kids[[n]])
        }
      )
    } else if("kids" %in% names(l) && length(l$kids)==0) {
      l$kids <- NULL
    }
    l
  }

  merge_data(data)
}
