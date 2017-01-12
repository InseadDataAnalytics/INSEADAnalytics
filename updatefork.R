# Sync a forked copy of INSEADAnalytics with the master project. For details,
# see https://github.com/InseadDataAnalytics/INSEADAnalytics/issues/7

if (!require(git2r)) {
  install.packages("git2r", repos="http://cran.r-project.org/", quiet=TRUE)
  library(git2r)
}

repo <- repository(".")
if (!("upstream" %in% remotes(repo))) {
  remote_add(repo, "upstream", "https://github.com/InseadDataAnalytics/INSEADAnalytics")
}

fetch(repo, "upstream")
checkout(repo, "master")
merge(repo, "upstream/master")

message("
  Your local copy of INSEADAnalytics is now in sync with the master project.
  You can update your remote copy by clicking 'Push' in the 'Git' panel or
  by executing the following:
  
  push(repo, credentials=cred_user_pass(readline('Github username: '), readline('Github password: ')))
")
# push(repo, credentials=cred_user_pass(readline("Github username: "), readline("Github password: ")))
