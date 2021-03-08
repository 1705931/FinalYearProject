#Load the rjson package for reading JSON files
library('org.renjin.cran:rjson')
#Load the plyr package for grouping data
library('org.renjin.cran:plyr')
#Load the tibble package for printing reusult more neatly
library('org.renjin.cran:tibble')

json_data <- fromJSON(file = inputJson)

#Collect the results from the results part of the json file
results <- json_data$results
#Collect the metrics from the metrics part of the json file
metrics <- json_data$metrics
#Create a dataframe from the results and the metrics
results_df<-as.data.frame(do.call("cbind", results))
metrics_df<-as.data.frame(do.call("cbind", metrics))
#Switch the rows and columns, so that every new record appears as a row and not a column
results_df_new <- as.data.frame(t(results_df))
metrics_df_new <- as.data.frame(t(metrics_df))
#Calculate the total of files scanned in the repository, the -1 is
#needed because the first element in the json file shows total metrics
files_scanned <- length(metrics)-1
#Calculate the total of issues found
issues_found <- length(results)
#Calculate the total of the lines of code in a repository
loc_in_repo <- metrics_df_new$loc["_totals"]

#Create a simple character array to store number of files scanned and the total of loc and issues found
# no_of_issues <- c("Files Scanned: ", files_scanned, "Lines of Code: ", loc_in_repo, "Issues Found: ", issues_found)

#set the headings for the dataframe
headings <- c("filename", "issue_severity", "line_number", "test_id")
results_df_formatted <- results_df_new[headings]
#You cannot group variables if they are in a list, so unlist to character
results_df_formatted$filename <- as.character(unlist(results_df_formatted$filename))
results_df_formatted$test_id <- as.character(unlist(results_df_formatted$test_id))
results_df_formatted$line_number <- as.character(unlist(results_df_formatted$line_number))
results_df_formatted$issue_severity <- as.character(unlist(results_df_formatted$issue_severity))
#Create a table that shows the total number of each issue severity
total_issue_sev <- table(results_df_formatted$issue_severity)
#Group data by test_id, combine all line numbers and issue severities with the corresponding test_id
summary_table <- ddply(results_df_formatted,c("test_id", "issue_severity"),
                    function(df1)paste(df1$line_number,
                                       collapse = ","))
colnames(summary_table) <- c("test_id", "issue_severity", "line_numbers")
#Convert summary table to a tibble
summary_table <- as_tibble(summary_table)
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
#Convert filename table to a tibble
filename_table <- as_tibble(filename_table)
#Create a table of issue severity and line number
issue_sev_vs_line_no <- table(results_df_formatted$line_number, results_df_formatted$issue_severity)
#Convert line number vs issue severity table into a tibble
# issue_sev_vs_line_no <- as_tibble(issue_sev_vs_line_no)
#Put the different issue severities in separate lists
low_sev <- line_no_table[line_no_table$issue_severity=="LOW",]
medium_sev <- line_no_table[line_no_table$issue_severity=="MEDIUM",]
high_sev <- line_no_table[line_no_table$issue_severity=="HIGH",]
#Convert line number table into a tibble
line_no_table <- as_tibble(line_no_table)
#Convert each comma-separated value into integer
int_low_sev <- as.integer(unlist(strsplit(low_sev$line_numbers, ",")))
int_medium_sev <- as.integer(unlist(strsplit(medium_sev$line_numbers, ",")))
int_high_sev <- as.integer(unlist(strsplit(high_sev$line_numbers, ",")))
#Calculate the mean line number value for each severity
mean_low_sev <- mean(int_low_sev)
mean_medium_sev <- mean(int_medium_sev)
mean_high_sev <- mean(int_high_sev)

