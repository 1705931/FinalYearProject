data <- read.csv("D:\\IntelliJ Projects\\FinalYearProject\\data_for_classification.csv")
data$issue_severity <- as.factor(data$issue_severity)
data$test_id <- as.factor(data$test_id)
data$ï..filename <- NULL
data$line_number <- NULL
data$total_lines_in_file <- NULL

library(nnet)
portion <- sample(1:nrow(data), 0.1*nrow(data))
myNet <- nnet(issue_severity~ test_id + line_number_value, data=data, subset=portion, size=2)
newPredictedValues <- predict(myNet, newdata = data[-portion,])
