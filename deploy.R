install.packages(c("shiny", "rsconnect"))
library(rsconnect)


setAccountInfo(
  name = Sys.getenv("SHINY_ACC_NAME"),
  token = Sys.getenv("TOKEN"),
  secret = Sys.getenv("SECRET")
)

deployApp(appName = Sys.getenv("MASTER_NAME"))