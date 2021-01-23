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
headings <- c("filename", "issue_severity", "line_number", "test_id")
results_df_formatted <- results_df_new[headings]
#You cannot group variables if they are in a list, so unlist to character
results_df_formatted$filename <- as.character(unlist(results_df_formatted$filename))
results_df_formatted$test_id <- as.character(unlist(results_df_formatted$test_id))
results_df_formatted$line_number <- as.character(unlist(results_df_formatted$line_number))
results_df_formatted$issue_severity <- as.character(unlist(results_df_formatted$issue_severity))
#Group data by test_id, combine all line numbers and issue severities with the corresponding test_id
summary_table <- ddply(results_df_formatted,c("test_id", "issue_severity"),
                    function(df1)paste(df1$line_number,
                                       collapse = ","))
colnames(summary_table) <- c("test_id", "issue_severity", "line_numbers")
#Group line numbers by issue_severity
line_no_table <- ddply(results_df_formatted,"issue_severity",
                   function(df1)paste(df1$line_number,
                                      collapse = ","))
#Group line numbers, test IDs and by issue severities by filename
filename_table <- ddply(results_df_formatted, "filename",
                    c(function(df1)paste(df1$issue_severity,
                                         collapse = ","),
                      function(df1)paste(df1$line_number,
                                         collapse = ","),
                      function(df1)paste(df1$test_id,
                                         collapse = ",")))
colnames(line_no_table) <- c("issue_severity", "line_numbers")
colnames(filename_table) <- c("filename","issue_severities","line_numbers","test_ids")
#Create a table of issue severity and line number
issue_sev_vs_line_no <- table(results_df_formatted$issue_severity, results_df_formatted$line_number)
#Put the different issue severities in separate lists
low_sev <- line_no_table[line_no_table$issue_severity=="LOW",]
medium_sev <- line_no_table[line_no_table$issue_severity=="MEDIUM",]
high_sev <- line_no_table[line_no_table$issue_severity=="HIGH",]
#Convert each comma-separated value into integer
int_low_sev <- as.integer(unlist(strsplit(low_sev$line_numbers, ",")))
int_medium_sev <- as.integer(unlist(strsplit(medium_sev$line_numbers, ",")))
int_high_sev <- as.integer(unlist(strsplit(high_sev$line_numbers, ",")))
#Calculate the mean line number value for each severity
mean_low_sev <- mean(int_low_sev)
mean_medium_sev <- mean(int_medium_sev)
mean_high_sev <- mean(int_high_sev)

