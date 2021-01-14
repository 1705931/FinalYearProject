#Load the rjson package for reading JSON files
library('org.renjin.cran:rjson')
#Load the plyr package for grouping data
library('org.renjin.cran:plyr')

json_data <- fromJSON(file = inputData)
results <- json_data$results
#Create a dataframe from the results
results_df<-as.data.frame(do.call("cbind", results))
#Switch the rows and columns, so that every new record appears as a row and not a column
results_df_new <- as.data.frame(t(results_df))
#set the headings for the dataframe
headings <- c("test_id", "line_number")
results_df_formatted <- results_df_new[headings]
# print(results_df_formatted)

#You cannot group variables if they are in a list, so unlist to character
results_df_formatted$test_id <- as.character(unlist(results_df_formatted$test_id))
results_df_formatted$line_number <- as.character(unlist(results_df_formatted$line_number))
#Group data by test_id, combine all line numbers with the corresponding test_id
vuln_data <- ddply(results_df_formatted,"test_id",
                   function(df1)paste(df1$line_number,
                                      collapse = ","))
vuln_data$test_id <- NULL
colnames(vuln_data) <- "line_numbers"
write.csv(vuln_data,"vulnerabilities.csv", quote = FALSE, row.names = FALSE)
print(vuln_data)