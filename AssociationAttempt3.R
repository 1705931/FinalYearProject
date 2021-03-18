#Load the rjson package for reading JSON files
#Load the dplyr package for grouping data
library(rjson)
library(plyr)
library(arules)
library(rlist)
library(XML)
#library(xml2)
inputData <- ("D:\\IntelliJ Projects\\FinalYearProject\\src\\main\\bandit_output\\chromium_vuln.json")
inputData <- ("D:\\IntelliJ Projects\\FinalYearProject\\src\\main\\bandit_output\\asterisk_vuln.json")
xmlInput <- xmlParse("D:\\IntelliJ Projects\\FinalYearProject\\src\\main\\pygount_output\\asterisk_lines.xml")
xml_data <- xmlToList(xmlInput)
files <- xml_data$files

#xmlInput2 <- read_xml("D:\\IntelliJ Projects\\FinalYearProject\\src\\main\\pygount_output\\asterisk_lines.xml")

files_scanned_issues_found_data <- read.csv('D:\\IntelliJ Projects\\FinalYearProject\\1_files_scanned_issues_found_data.csv', sep=",")
plot(main = "Files Scanned vs Issues Found", files_scanned_issues_found_data, xlab = "Files Scanned", ylab = "Issues Found")
files_scanned_vuln_files <- read.csv('D:\\IntelliJ Projects\\FinalYearProject\\2_files_scanned_vuln_files.csv', sep=",")
plot(main = "Files Scanned vs Vulnerable Files", files_scanned_vuln_files, xlab = "Files Scanned", ylab = "Vulnerable Files")
issues_found_lines_in_repo<- read.csv('D:\\IntelliJ Projects\\FinalYearProject\\3_lines_in_repo_issues_found.csv', sep=",")
plot(main = "Issues Found vs Lines in Repository", issues_found_lines_in_repo, xlab = "Lines in Repository", ylab = "Issues Found")
vuln_files_lines_in_repo<- read.csv('D:\\IntelliJ Projects\\FinalYearProject\\4_vuln_files_lines_in_repo.csv', sep=",")
plot(main = "Vulnerable Files vs Lines in Repository", vuln_files_lines_in_repo, xlab = "Vulnerable Files", ylab = "Lines in Repository")

data_for_clustering <- read.csv('D:\\IntelliJ Projects\\FinalYearProject\\issues_data.csv', sep=",")
plot(data_for_clustering)
data_for_clustering = na.omit(data_for_clustering) # deletion of missing data
data_for_clustering = scale(data_for_clustering) # standardize variables
plot(main = "Data After Processing", data_for_clustering)

wh = c()
fit <- kmeans(data_for_clustering, 5)
aggregate(data_for_clustering, by=list(fit$cluster), FUN=mean)
Kgroups = fit$cluster
plot(main = "Scatterplot for 5 clusters", data_for_clustering, col=Kgroups)


json_data <- fromJSON(file = inputData)
results <- json_data$results
metrics <- json_data$metrics

#Create a dataframe from the results and the metrics
results_df<-as.data.frame(do.call("cbind", results))
metrics_df<-as.data.frame(do.call("cbind", metrics))
loc_df<-as.data.frame(do.call("cbind", files))
#Switch the rows and columns, so that every new record appears as a row and not a column
results_df_new <- as.data.frame(t(results_df))
metrics_df_new <- as.data.frame(t(metrics_df))
loc_df_new <- as.data.frame(t(loc_df))
#Calculate some initial statistics
files_scanned <- length(metrics)-1
issues_found <- length(results)
loc_in_repo <- metrics_df_new$loc["_totals"]
no_of_issues <- c("Files Scanned: ", files_scanned, "Lines of Code: ", loc_in_repo, "Issues Found: ", issues_found)
no_of_issues <- c(files_scanned, loc_in_repo, issues_found)
print(no_of_issues)
#head(no_of_issues) summary(no_of_issues) str(no_of_issues) View(no_of_issues) lapply(no_of_issues, head)

#Sum up number of lines in each file and add it as a new column:
loc_df_new$blank <- as.integer(unlist(loc_df_new$blank))
loc_df_new$code <- as.integer(unlist(loc_df_new$code))
loc_df_new$comment <- as.integer(unlist(loc_df_new$comment))
loc_df_new$total_lines <- rowSums(loc_df_new[,c(1,2,3)])

#set the headings for the dataframes
results_headings <- c("filename", "issue_severity", "line_number", "test_id")
metrics_headings <- c("SEVERITY.HIGH", "SEVERITY.MEDIUM", "SEVERITY.LOW", "loc")
results_df_formatted <- results_df_new[results_headings]
metrics_df_formatted <- metrics_df_new[metrics_headings]
#You cannot group variables if they are in a list, so unlist to character or integer
results_df_formatted$filename <- as.character(unlist(results_df_formatted$filename))
results_df_formatted$issue_severity <- as.character(unlist(results_df_formatted$issue_severity))
results_df_formatted$line_number <- as.integer(unlist(results_df_formatted$line_number))
results_df_formatted$test_id <- as.character(unlist(results_df_formatted$test_id))
metrics_df_formatted$loc <- as.integer(unlist(metrics_df_formatted$loc))
loc_df_new$total_lines <- as.integer(unlist(loc_df_new$total_lines))

#Use the loc variable from the metrics dataframe and add it as lines_of_code to the results dataframe
#Not good since loc in metrics is wrong
#results_df_formatted$lines_of_code <- metrics_df_formatted$loc[match(results_df_formatted$filename, row.names(metrics_df_formatted))]

#Use the total_lines variable from the loc_df and add it as lines_of_code_in_file to the results df
results_df_formatted$total_lines_in_file <- loc_df_new$total_lines[match(results_df_formatted$filename, loc_df_new$name)]

write.table(x = results_df_formatted, file = "D:\\IntelliJ Projects\\FinalYearProject\\results.csv", row.names = FALSE, append = FALSE, col.names = TRUE, sep = ",")

#Group data by test_id, combine all line numbers with the corresponding test_id
vuln_data <- ddply(results_df_formatted,"issue_severity",
                  function(df1)paste(df1$line_number,
                                       collapse = ","))

vuln_data2 <- ddply(results_df_formatted,"test_id",
                  c(function(df1)paste(df1$line_number,
                                       collapse = ","),
                    function(df1)paste(df1$issue_severity,
                                       collapse = ",")))

vuln_data3 <- ddply(results_df_formatted,c("test_id", "issue_severity"),
                  function(df1)paste(df1$line_number,
                                     collapse = ","))

vuln_data4 <- ddply(results_df_formatted, "filename",
                    c(function(df1)paste(df1$issue_severity,
                                         collapse = ","),
                      function(df1)paste(df1$line_number,
                                         collapse = ","),
                      function(df1)paste(df1$test_id,
                                         collapse = ","),
                      function(df1)paste(df1$total_lines_in_file,
                                         collapse = ",")))

vuln_data5 <- ddply(results_df_formatted, "filename",
                    c(function(df1)paste(sum(df1$issue_severity,
                                             collapse = ","))))

#vuln_data$test_id <- NULL
colnames(vuln_data) <- c("issue_severity","line_numbers")
colnames(vuln_data3) <- c("test_id","issue_severity","line_numbers")
colnames(vuln_data4) <- c("filename","issue_severities","line_numbers","test_ids","total_lines")

#total number of each severity type
sev_line_no_total <- table(results_df_formatted$issue_severity)
cat("\nTotal Number of Severities: \n")
cat(sev_line_no_total)
#print at which line number each severity happened
issue_sev_vs_line_no <- table(results_df_formatted$issue_severity, results_df_formatted$line_number)
issue_sev_vs_line_no <- as_tibble(issue_sev_vs_line_no)
print(issue_sev_vs_line_no)
cat(issue_sev_vs_line_no)

#total number of vulnerable files
cat("Total Number of Vulnerable Files in Repository: ", nrow(vuln_data4))

#Number of issues per file
#Use the loc variable from the metrics dataframe and add it as lines_of_code to the vuln_data4 dataframe
vuln_data4$lines_of_code <- metrics_df_formatted$loc[match(vuln_data4$filename, row.names(metrics_df_formatted))]

lines_per_file <- c(vuln_data4$filename, vuln_data4$line_numbers)

#Put the different issue severities in separate lists
low_sev <- vuln_data[vuln_data$issue_severity=="LOW",]
medium_sev <- vuln_data[vuln_data$issue_severity=="MEDIUM",]
high_sev <- vuln_data[vuln_data$issue_severity=="HIGH",]

#Convert each comma-separated value into integer
int_low_sev <- as.integer(unlist(strsplit(low_sev$line_numbers, ",")))
int_medium_sev <- as.integer(unlist(strsplit(medium_sev$line_numbers, ",")))
int_high_sev <- as.integer(unlist(strsplit(high_sev$line_numbers, ",")))

#Calculate the mean line number value for each severity
mean_low_sev <- mean(int_low_sev)
mean_medium_sev <- mean(int_medium_sev)
mean_high_sev <- mean(int_high_sev)

for(i in vuln_data4$filename){
  print(i)
}

for (i in vuln_data4$line_numbers){
  print(mean(as.integer(unlist(strsplit(i, ",")))))
}

library(tibble)
library(tidyverse)
vuln_data3 <- as_tibble(vuln_data3)
#nrow(vuln_data3)

print(vuln_data3, n = 5, width = 50)

library(igraph) # Load the igraph package
#List of test_ids from a specific file
test_list <- vuln_data4$test_ids[vuln_data4$filename=="asterisk\\build_tools\\get_documentation.py"]
test_list_formatted <- as.character(unlist(strsplit(test_list, ",")))
# The graph is un-directed because the number of test_ids may or may not be even
test_graph <- graph( c(test_list_formatted), directed = F)
test_graph
plot(test_graph)

#tr <- make_tree(length(results_df_formatted$line_number), children = length(results_df_formatted$line_number)/3, mode = "undirected")
#plot(tr, vertex.size=10, vertex.label=vuln_data4$test_ids)

library(ggplot2)
ggplot(results_df_formatted, aes(x = test_id)) +
        geom_bar() +
  xlab("test ID") +
  facet_grid(~ issue_severity) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

ggplot(results_df_formatted, aes(x = line_number)) +
  geom_bar() +
  xlab("Line Number") +
  facet_grid(~ issue_severity) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))


empty_vec <- vector(mode="list", length = length(vuln_data4$filename))


#vulnData: Data to be written
#"vulnerabilities.csv": location of file with file name to be written to
#quote: If TRUE it will surround character or factor column with double quotes.
#row.names: either a logical value indicating whether the row names of x are to be
#written along with x,or a character vector of row names to be written.
write.csv(vuln_data,"vulnerabilities.csv", quote = FALSE, row.names = FALSE)

#sep is how items are separated. In this case you have separated using ','
issues <- read.transactions('low_sev.csv', format = 'basket', sep=',', rm.duplicates = FALSE)
summary(issues)

# Create an item frequency plot for the top 20 items
if (!require("RColorBrewer")) {
  # install color package of R
  install.packages("RColorBrewer")
  #include library RColorBrewer
  library(RColorBrewer)
}
itemFrequencyPlot(issues,topN=20,type="absolute",col=brewer.pal(8,'Pastel2'), main="Absolute Line Numbers Frequency Plot")
itemFrequencyPlot(issues,topN=20,type="relative",col=brewer.pal(8,'Pastel2'),main="Relative Line Numbers Frequency Plot")

# Min Support as 0.001, confidence as 0.8.
association.rules <- apriori(issues, parameter = list(supp=0.1, conf=0.8,maxlen=10))
summary(association.rules)
