library(tidyverse)
library(httr)
library(curl)
library(rvest)

browseURL("https://beppegrillo.it/category/archivio/2016/")

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

links

#scrape the main text from each page
to_scrape <- list.files(here::here("links 2016"), full.names = TRUE)   # get the list of pages 
main_text <- vector(mode = "list", length = length(to_scrape))    # empty container where to place the text

to_scrape

# Loop over the 47 pages and scrape the main text
for (i in seq_along(main_text)){
  main_text[[i]] <- read_html(to_scrape[i]) %>% 
    html_elements(css = ".td_module_10 .td-module-title") %>% 
    html_text(trim = TRUE)
}

str(main_text)
main_text[[1]]    # main text form page 1
main_text[[2]]    # main text form page 2


#if in a page i there is no text, the CSS selector doesn't select anything and there is a missing value (NA) in the list main_text
