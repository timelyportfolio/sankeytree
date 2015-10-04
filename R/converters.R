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
  data = jsonlite::toJSON(
    data
    ,auto_unbox = T
  )
  data = gsub( x=data, pattern = "kids", replacement="children")
  data = gsub ( x=data, pattern = '"id":([0-9]*)', replacement = '"name":"node\\1"' )
  
  # calling the root node by the dataset name, but it might make more sense to call it
  # "root" so that the code can be generalized
  #  data = sub (x = data, pattern = "node1", replacement = "mtcars")
  
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
  
  # replacing the node names from node1, node2, etc., with the extracted node names and metadata from
  # rpk.text, and rp$table. 
  for (i in 2:nrow(rpk.text)) {
    data = sub (x = data, pattern = paste("node", i, sep = ""), 
                replacement = paste(rpk.text[i,2], ", mean = ", rpk.text[i,7], ", n = ", rpk.text[i,4], sep = ""), fixed = T)
  }
  data
}
