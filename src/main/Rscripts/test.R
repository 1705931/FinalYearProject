#Load the rjson package for reading JSON files
library('org.renjin.cran:rjson')
print(inputData)
#Read the json file and store it in the data variable. The inputData variable is passed on from Java
json_data <- fromJSON(file = inputData)
print(json_data)
# json_data_frame <- as.data.frame(json_data$results)
#json_data_frame <- as.data.frame(json_data)
#print(typeof(json_data))
#print(typeof(json_data_frame))



#jsonlite doesn't seem to work, stick to rjson
# library('org.renjin.cran:jsonlite')
# data <- jsonlite::fromJSON(inputData, simplifyDataFrame = TRUE)
# data <- read_json(inputData, simplifyDataFrame = TRUE)
# data <- fromJSON(inputData)
# print(typeof(data))
# results = data$results