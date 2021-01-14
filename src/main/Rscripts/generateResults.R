library('org.renjin.cran:arules')

issues <- read.transactions('vulnerabilities.csv', format = 'basket', sep=',')
print(summary(issues))