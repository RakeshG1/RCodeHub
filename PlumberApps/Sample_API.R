# Import Libraries #
# ---------------- #
pacman::p_load(RPostgreSQL, 
                data.table, 
                dplyr, 
                tidyverse, 
                timetk, 
                lubridate, 
                skimr, 
                summarytools, 
                ggplot2
                )


# API End Points #
# -------------- #

#* Load and Show Data
#* @param filepath - Enter Filepath
#* @param filename - Enter Filename
#* @get /showData
#* @serializer csv
function(filepath, filename){

    # Data Path
    data_path = paste(filepath,filename, sep="")
    print(paste("Data Path : ", data_path))

    # Load Data
    df <- fread(data_path, header=TRUE, sep=",")

}


#* Load and Summarise Data
#* @param filepath - Enter Filepath
#* @param filename - Enter Filename
#* @get /dataOverview
#* @serializer csv
function(filepath, filename){

    # Data Path
    data_path = paste(filepath,filename, sep="")
    print(paste("Data Path : ", data_path))
    
    # Load Data 
    df <- fread(data_path, header=TRUE, sep=",")
    
    # Data Overview
    print(str(df))
    dim(df)
    #df <- as.data.frame(str(df))
    
    df_summary <- as.data.table(summary(df))
    print(df_summary)
    
}


#* Load and Plot Data
#* @param filepath - Enter Filepath
#* @param filename - Enter Filename
#* @param dateCol - Enter DateCol
#* @param groupbyCol - Enter GroupbyCol
#* @param valueCol - Enter ValueCol
#* @get /plotTimeseries
#* @serializer contentType list(type='image/png')
function(filepath, filename, dateCol, groupbyCol, valueCol){
    
    # Data Path
    data_path = paste(filepath,filename, sep="")
    print(paste("Data Path : ", data_path))
    
    # Load Data
    df <- fread(data_path, header=TRUE, sep=",")
    
    df[[dateCol]] <- as.POSIXct(df[[dateCol]], format="%d-%m-%Y")
    str(df)

    # Summarise Date 
    df_counts <- df %>%
                    group_by(eval(as.symbol(groupbyCol)), eval(as.symbol(dateCol))) %>%
                    summarise(avg = mean(eval(as.symbol(valueCol))))
    print(df_counts)
    
    # Replacing Col Names
    colnames(df_counts)[which(names(df_counts) == "eval(as.symbol(dateCol))")] <- dateCol
    colnames(df_counts)[which(names(df_counts) == "eval(as.symbol(groupbyCol))")] <- groupbyCol
    print(df_counts)
    
    # Timeseries Plot
    p = df_counts %>% ggplot(aes(x=eval(as.symbol(dateCol)), y = avg)) +
                    geom_bar(position = "dodge", stat = "identity") + 
                    facet_grid(rows = vars(eval(as.symbol(groupbyCol)))) +
                    xlab(dateCol) +
                    ggtitle(sprintf("%s - Avg Time series Plot Over %s", valueCol, dateCol))
    file = 'file.png'
    ggsave(file,p)
    readBin(file, 'raw', n = file.info(file)$size)
    
}