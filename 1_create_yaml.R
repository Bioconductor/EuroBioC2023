
library(stringr)

url <- 'https://docs.google.com/spreadsheets/d/1E2ZrjRzNBFHlqERUkLucCRezCer_Ze-qpYmQMGbSyIU/gviz/tq?tqx=out:csv&sheet=2023'
fname <- tempfile()
download.file(url = url, destfile = fname, quiet = TRUE)
schedule <- read.csv(fname)

select_cols <- c(
    'day',
    'title', 'paper', 'session_type', 'authors', 'affiliation', 'abstract',
    'time', 'talks',
    'github',
    'presenting_author', 'presenting_author2', 'presenting_author3', 'presenting_author4', 'presenting_author5', 'presenting_author6',
    'twitter', 'twitter2', 'twitter3', 'twitter4', 'twitter5', 'twitter6',
    'youtube', 'youtube2', 'youtube3', 'youtube4', 'youtube5', 'youtube6',
    'details'
)
x <- schedule[, select_cols, drop = FALSE]
x$paper <- tolower(x$paper)
x$abstract <- gsub('"', "'", x$abstract)
x <- x[which(x$session_type != ''),]

x$github <- ifelse(is.na(x$github), '', x$github)
x$details <- ifelse(is.na(x$details), '', x$details)

x$presenting_author <- ifelse(is.na(x$presenting_author), '', x$presenting_author)
x$presenting_author2 <- ifelse(is.na(x$presenting_author2), '', x$presenting_author2)
x$presenting_author3 <- ifelse(is.na(x$presenting_author3), '', x$presenting_author3)
x$presenting_author4 <- ifelse(is.na(x$presenting_author4), '', x$presenting_author4)
x$presenting_author5 <- ifelse(is.na(x$presenting_author5), '', x$presenting_author5)
x$presenting_author6 <- ifelse(is.na(x$presenting_author6), '', x$presenting_author6)

x$twitter <- ifelse(is.na(x$twitter), '', x$twitter)
x$twitter2 <- ifelse(is.na(x$twitter2), '', x$twitter2)
x$twitter3 <- ifelse(is.na(x$twitter3), '', x$twitter3)
x$twitter4 <- ifelse(is.na(x$twitter4), '', x$twitter4)
x$twitter5 <- ifelse(is.na(x$twitter5), '', x$twitter5)
x$twitter6 <- ifelse(is.na(x$twitter6), '', x$twitter6)

x$youtube <- ifelse(is.na(x$youtube), '', x$youtube)
x$youtube2 <- ifelse(is.na(x$youtube2), '', x$youtube2)
x$youtube3 <- ifelse(is.na(x$youtube3), '', x$youtube3)
x$youtube4 <- ifelse(is.na(x$youtube4), '', x$youtube4)
x$youtube5 <- ifelse(is.na(x$youtube5), '', x$youtube5)
x$youtube6 <- ifelse(is.na(x$youtube6), '', x$youtube6)

schedule <- x

output_dir <- 'data/abstracts/'
message('Creating yaml files in ', output_dir)

#use "" instead of NAs
scheduleBlank <- schedule #make copy
# scheduleBlank[is.na(scheduleBlank)] <- "" 

##  datetime to character
scheduleBlank$time <- sub("^.+ (.+):00", "\\1", scheduleBlank$time)

if (!file.exists(output_dir)) {
    dir.create(output_dir)
} else {
    ## Overwrite whatever output was generated before
    unlink(output_dir, recursive = TRUE)
    dir.create(output_dir)
}


iCount = 1

while (iCount <= nrow(scheduleBlank)) {
    
    oneRow <- scheduleBlank[iCount, ]
    
    fileNameSpace <- paste(oneRow$day, "_",
                           oneRow$time, "_",
                           oneRow$session_type,"_",
                           oneRow$paper,
                           ".yaml", 
                           sep = "" )
    fileNameFinal <- gsub(" |:", '', fileNameSpace) 
    # fileNameFinal <- str_replace_all(string = fileNameSpace, 
    # pattern =  c(" |:"), 
    # replacement =   '')
    
    fileNameFinal <- sub("_.yaml$", ".yaml", fileNameFinal)
    
    iCount2 = 1
    while (iCount2 <= ncol(oneRow)) {
        
        
        oneValueName <- names(oneRow)[iCount2]
        oneValue <- paste("\"",unlist(oneRow[iCount2]),"\"", sep = "")
        
        if (oneValueName == "talks" && any(grepl("paper", oneValue))) {
            oneValue <- sub("^\"(.+)\"$", "\\1", oneValue)
        }
        
        # write to file for the first time. Create new file
        if (iCount2 == 1) {
            # create file , no append
            line <- paste0(oneValueName, ": ", oneValue)
            write.table(line, col.names = FALSE, row.names = FALSE, 
                        file = paste(output_dir, 
                                     fileNameFinal, sep = ""), 
                        append = FALSE, 
                        quote = FALSE, )
            
        } else {
            # append to existing file
            line <- paste0(oneValueName, ": ", oneValue)
            write.table(
                x = line, col.names = FALSE, row.names = FALSE,
                file = paste0(output_dir, fileNameFinal), append = TRUE, quote = FALSE
            )
        } 
        
        iCount2 <- iCount2 + 1
    }
    
    iCount <- iCount + 1
}
