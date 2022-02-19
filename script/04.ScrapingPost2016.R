library(tidyverse)
library(httr)
library(curl)
library(rvest)

browseURL("https://beppegrillo.it/category/archivio/2016/")
download.file(url = "https://beppegrillo.it/category/archivio/2016/ ", 
              destfile = here::here("Blog 2016"))

read_html(here::here("Blog 2016")) %>% 
  html_elements(css = ".td_module_10 a") %>% 
  html_text(trim = TRUE)

download_politely <- function(from_url, to_html, my_email, my_agent = R.Version()$version.string) {require(httr)
  stopifnot(is.character(from_url))
  stopifnot(is.character(to_html))
  stopifnot(is.character(my_email))
  blog <- httr::GET(url = from_url, 
                    add_headers(
                      From = my_email, 
                      `User-Agent` = R.Version()$version.string
                    )
  )
  if (httr::http_status(blog)$message == "Success: (200) OK") {
    bin <- content(blog, as = "raw")
    writeBin(object = bin, con = to_html)
  } else {
    cat("Houston, we have a problem!")
  }
}

# Build the full list of links to each page:
require(stringr)
links <- str_c("https://beppegrillo.it/category/archivio/2016/page/", 1:47)
dir.create("links 2016")   # Create a new folder where to store all the files

# Loop over the link for each page:
for (i in seq_along(links)) {
  cat(i, " ")
  download_politely(from_url = links[i], 
                    to_html = here::here("links 2016", str_c("page_",i,".html")), 
                    my_email = "albaproficuo@icloud.com")
  
  Sys.sleep(2)
}
