#Load the rjson package for reading JSON files
library('org.renjin.cran:rjson')
# print(inputData)
#Read the json file and store it in the data variable. The inputData variable is passed on from Java
json_data <- fromJSON(file = inputData)
results <- json_data$results
#Convert the results list to a dataframe
results_df<-as.data.frame(do.call("cbind", results))
# str(df)
# print(typeof(df))
#Switch the rows and columns
df_new <- as.data.frame(t(results_df))
# str(df_new)
headings <- c("test_id", "issue_severity", "line_number")
vuln_data <- df_new[headings]
# str(vuln_data)
print(vuln_data)



#jsonlite works, but can't load JSON file
# library('org.renjin.cran:jsonlite')
# data <- jsonlite::fromJSON(inputData)
# data <- jsonlite::fromJSON(inputData,  simplifyDataFrame = TRUE)
# data <- read_json(inputData, simplifyDataFrame = TRUE)
# data <- fromJSON(inputData) %>% as.data.frame
# print(typeof(data))
# results = data$results

#RJSONIO doesn't work at all
# library('org.renjin.cran:RJSONIO')
# json_file <- fromJSON(inputData)
# json_file_results <- json_file$results
# df<-as.data.frame(do.call("cbind", json_file_results))

