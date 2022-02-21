#inspecting the page with /robots.txt bring us to a 404 not found page.  
#this means that there is no robots.txt: the web master doesn't provide
#any restriction to scrapigin activities.Therefore, we decided to proced
#with the following tasks of the exercise.

library(rvest)
library(tidyverse)
install.packages("httr")
install.packages("XML")

url <- "https://beppegrillo.it/un-mare-di-plastica-ci-sommergera/"

require(httr)

#Create a function `download_politely(from_url, to_html)` to download politely
#the web page:
download_politely <- function(from_url, to_html, my_email, my_agent = R.Version()$version.string) {
  
  require(httr)
  
  # Check that arguments are inputted as expected:
  stopifnot(is.character(from_url))
  stopifnot(is.character(to_html))
  stopifnot(is.character(my_email))
  
  # GET politely
  blog <- httr::GET(url = from_url, 
                    add_headers(
                      From = my_email, 
                      `User-Agent` = R.Version()$version.string
                    )
  )
  # If status == 200, extract content and save to a file:
  if (httr::http_status(blog)$message == "Success: (200) OK") {
    bin <- content(blog, as = "raw")
    writeBin(object = bin, con = to_html)
  } else {
    cat("Houston, we have a problem!")
  }
}

# Call the customized function:
download_politely(from_url = url, 
                  to_html = here::here("blog_polite.html"), 
                  my_email = "ravarellierica@gmail.com")


blog_links <- rvest::read_html(x = url) %>% ##parsing
  html_elements(css="a")%>% ##getting nodes corresponding to links
  html_attr("href") ##getting only the attribute "href"

view(blog_links)
typeof(blog_links)
blog_links[1:115]

##Get only links => select only strings beginning with https

all_links <- str_subset(blog_links,  pattern = "^https?.*")
all_links

##Get only Grillo's blog links

onlyGrillo_links <- str_subset(blog_links, pattern="^https?://beppegrillo.it.*")
onlyGrillo_links

#without duplicates

without_dubles <- unique(onlyGrillo_links)
without_dubles[1:29]

##Generate a tibble with Grillo's blog links

Grillo_links <- tibble(
          x1=without_dubles,
          x2=1:29)
view(Grillo_links)

