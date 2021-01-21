library('org.renjin.cran:arules')

issues <- read.transactions('vulnerabilities.csv', format = 'basket', sep=',')
print(summary(issues))

# association.rules <- apriori(issues)
# association.rules <- apriori(issues, parameter = list(supp=0.1, conf=0.8))
# print(summary(association.rules))
