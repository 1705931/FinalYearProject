library(rjson)
library(XML)
library(plyr)

json_input <- ("D:\\IntelliJ Projects\\FinalYearProject\\src\\main\\bandit_output\\Zope_vuln.json")
json_data <- fromJSON(file = json_input)
results <- json_data$results
xml_input <- xmlParse("D:\\IntelliJ Projects\\FinalYearProject\\src\\main\\pygount_output\\Zope_lines.xml")
xml_data <- xmlToList(xml_input)
loc <- xml_data$files

#Create a dataframe from bandit and pygount outputs
results_df<-as.data.frame(do.call("cbind", results))
loc_df<-as.data.frame(do.call("cbind", loc))
#Switch the rows and columns, so that every new record appears as a row and not a column
results_df_new <- as.data.frame(t(results_df))
loc_df_new <- as.data.frame(t(loc_df))

#Sum up number of lines in each file and add it as a new column:
loc_df_new$blank <- as.integer(unlist(loc_df_new$blank))
loc_df_new$code <- as.integer(unlist(loc_df_new$code))
loc_df_new$comment <- as.integer(unlist(loc_df_new$comment))
loc_df_new$total_lines <- rowSums(loc_df_new[,c(1,2,3)])

#set the headings for the resulting dataframe
results_headings <- c("filename", "issue_severity", "line_number", "test_id")
results_df_formatted <- results_df_new[results_headings]

#You cannot group variables if they are in a list, so unlist to character or integer
results_df_formatted$filename <- as.character(unlist(results_df_formatted$filename))
results_df_formatted$issue_severity <- as.character(unlist(results_df_formatted$issue_severity))
results_df_formatted$line_number <- as.integer(unlist(results_df_formatted$line_number))
results_df_formatted$test_id <- as.character(unlist(results_df_formatted$test_id))
loc_df_new$total_lines <- as.integer(unlist(loc_df_new$total_lines))

#Use the total_lines variable from the loc_df and add it as lines_of_code_in_file to the results df
results_df_formatted$total_lines_in_file <- loc_df_new$total_lines[match(results_df_formatted$filename, loc_df_new$name)]
#Create the initial CSV file
#write.table(x = results_df_formatted, file = "D:\\IntelliJ Projects\\FinalYearProject\\results.csv", row.names = FALSE, append = FALSE, col.names = TRUE, sep = ",")
#Add more data to that CSV file
#write.table(x = results_df_formatted, file = "D:\\IntelliJ Projects\\FinalYearProject\\results.csv", row.names = FALSE, append = TRUE, col.names = FALSE, sep = ",")

#plot(results_df_formatted$total_lines_in_file, results_df_formatted$line_number)
#coplot(results_df_formatted$line_number ~ results_df_formatted$total_lines_in_file | results_df_formatted$issue_severity=="HIGH")
#ggplot(aes(x = total_lines_in_file, y = line_number),
#       data = results_df_formatted) +
#  geom_line(aes(color = issue_severity))

vuln_data_by_file <- ddply(results_df_formatted, "filename",
                    c(function(df1)paste(df1$issue_severity,
                                         collapse = ","),
                      function(df1)paste(df1$line_number,
                                         collapse = ","),
                      function(df1)paste(df1$test_id,
                                         collapse = ","),
                      function(df1)paste(df1$total_lines_in_file,
                                         collapse = ",")))
colnames(vuln_data_by_file) <- c("filename","issue_severities","line_numbers","test_ids","total_lines")
vuln_data_by_file$total_lines <- sapply(strsplit(vuln_data_by_file$total_lines, ","), function(x) paste(rle(x)$values, collapse = ","))

#write.table(x = vuln_data_by_file, file = "D:\\IntelliJ Projects\\FinalYearProject\\results_2.csv", row.names = FALSE, append = FALSE, col.names = TRUE, sep = ",")
write.table(x = vuln_data_by_file, file = "D:\\IntelliJ Projects\\FinalYearProject\\results_2.csv", row.names = FALSE, append = TRUE, col.names = FALSE, sep = ",")