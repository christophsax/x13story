library(seasonal)
checkX13()

# First read in the data from an external file. This is the only time this 
#  will be done. 
getwd() #Ctrl + Shift + H to setwd() in Rstudio
x <- read.table("Hobby, toy, and game stores.dat")
x <- ts(data = x$V3, start = c(1992, 1), frequency = 12) 

# Now we can include the data directly into this R script. This makes discussion
# and electronic communication about the series much smoother. 
dput(x)

# Load Data
x <- structure(c(620L, 585L, 643L, 706L, 660L, 721L, 678L, 653L, 638L, 
                 789L, 1332L, 3226L, 598L, 576L, 683L, 735L, 685L, 722L, 745L, 
                 682L, 671L, 799L, 1480L, 3275L, 618L, 637L, 819L, 782L, 742L, 
                 758L, 778L, 801L, 806L, 987L, 1677L, 3445L, 683L, 665L, 823L, 
                 867L, 821L, 873L, 851L, 846L, 846L, 993L, 1830L, 3616L, 705L, 
                 737L, 890L, 862L, 669L, 849L, 877L, 874L, 870L, 1094L, 2002L, 
                 4073L, 730L, 791L, 1032L, 896L, 947L, 940L, 963L, 958L, 971L, 
                 1141L, 2009L, 3643L, 858L, 883L, 987L, 1022L, 986L, 1016L, 1042L, 
                 1025L, 1005L, 1197L, 2011L, 3801L, 933L, 966L, 1135L, 1076L, 
                 1061L, 1101L, 1083L, 1101L, 1111L, 1277L, 2096L, 3711L, 893L, 
                 1002L, 1106L, 1136L, 1072L, 1098L, 1124L, 1132L, 1175L, 1285L, 
                 2161L, 3763L, 880L, 971L, 1176L, 1063L, 1038L, 1107L, 1094L, 
                 1065L, 1050L, 1303L, 2445L, 3628L, 896L, 966L, 1186L, 1014L, 
                 1078L, 1065L, 1103L, 1087L, 1048L, 1347L, 2468L, 3651L, 910L, 
                 940L, 1111L, 1139L, 1088L, 1064L, 1094L, 1087L, 1095L, 1286L, 
                 2223L, 3545L, 962L, 1045L, 1125L, 1082L, 974L, 1024L, 1086L, 
                 1016L, 1051L, 1311L, 2187L, 3451L, 950L, 980L, 1173L, 1098L, 
                 1061L, 1049L, 1077L, 1028L, 1019L, 1229L, 2120L, 3471L, 1063L, 
                 1022L, 1117L, 1094L, 1040L, 1048L, 1070L, 1043L, 1086L, 1205L, 
                 1933L, 3299L, 948L, 974L, 1188L, 1064L, 1050L, 1096L, 1102L, 
                 1084L, 1102L, 1275L, 2208L, 3253L, 1043L, 1077L, 1183L, 1080L, 
                 1131L, 1044L, 1097L, 1065L, 1061L, 1218L, 1959L, 3117L, 1031L, 
                 1009L, 1095L, 1086L, 1064L, 1020L, 1058L, 1007L, 1063L, 1194L, 
                 1842L, 2999L, 953L, 1000L, 1155L, 1059L, 1030L, 1024L, 1070L, 
                 1039L, 1074L, 1254L, 1990L, 3064L, 967L, 1023L, 1193L, 1184L, 
                 1065L, 1061L, 1082L, 1067L, 1143L, 1243L, 1951L, 3033L, 1063L, 
                 1182L, 1259L, 1146L, 1175L, 1120L, 1113L, 1117L, 1148L, 1263L, 
                 1929L, 2963L, 1019L, 1068L, 1239L, 1107L, 1116L, 1057L, 1106L, 
                 1145L, 1161L, 1338L, 2134L, 3263L, 1012L, 1084L, 1213L, 1195L, 
                 1170L, 1084L, 1183L, 1185L, 1253L, 1360L, 2140L, 3511L, 1157L, 
                 1190L, 1360L, 1260L, 1274L, 1196L), 
                 .Tsp = c(1992, 2015.4166666666, 12), class = "ts")

# initial look at raw data
plot(x)

# Let's assume there is to be a discussion about two possible prior adjustment
# methods.
# Method A - take a log transform and let auto AO detection
# Method B - no transform and include more AO's

# First look at model with log transform selected 
mA <- seas(x, transform.function="log", 
             x11.seasonalma = "s3x5",
             forecast.maxlead = "12",
             outlier.types = "AO",
             regression.aictest = "td")
lines(final(mA), col="red")
summary(mA)

# We get two AO's:  (1) May 1996
#                   (2) Dec 1996
abline(v = 1996 + 4/12, col="red", lty="dotted")
abline(v = 1996 + 11/12, col="red", lty="dotted")

# Now look at model with no transform selected 
mB <- seas(x, transform.function="none", 
             x11.seasonalma = "s3x5",
             forecast.maxlead = "12",
             outlier.types = "AO",
             regression.aictest = "td")
lines(final(mB), col="blue")
summary(mB)

# We get 7 AO's now - add the 5 new AO's to the plot
abline(v = c(2001 + 10/12, 
             2002 + 10/12,
             2007 + 10/12, 
             2013 + 11/12,
             2014 + 11/12), col = "blue", lty = "dotted")

# One idea would be to add the easter regressor in. For Hobbies, Toys and games 
# this seems prevalent.
mAE <- seas(x, transform.function="log", 
               x11.seasonalma = "s3x5",
               forecast.maxlead = "12",
               outlier.types = "AO",
               regression.aictest = "td, easter")
mBE <- seas(x, transform.function="none", 
               x11.seasonalma = "s3x5",
               forecast.maxlead = "12",
               outlier.types = "AO",
               regression.aictest = "td, easter")
summary(mAE)
summary(mBE)
# Easter does not rectify any outliers between model A and B

# Plot of model A and B final adjustment with easter regressor included
plot(x)
lines(final(mAE), col="red")
lines(final(mBE), col="blue")

# Let's look at some regression diagnostics 
op <- par()
par(mfrow=c(2,3), mar=c(2,2,2,2))
plot(residuals(mAE), type="p", pch=19); abline(h=0, lty="dotted")
acf(residuals(mAE), lag.max = 24)
qqnorm(residuals(mAE))
plot(residuals(mBE), type="p", pch=19); abline(h=0, lty="dotted")
acf(residuals(mBE), lag.max = 24)
qqnorm(residuals(mBE))
par(op)


