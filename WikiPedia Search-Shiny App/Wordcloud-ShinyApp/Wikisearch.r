# Wikipedia Search
library(tm)
library(stringi)
library(WikipediR)
library(proxy)
library(wordcloud)

SearchWiki <- function (titles) {
  # wiki.URL <- "https://en.wikipedia.org/wiki/"
  # articles <- lapply(titles,function(i) stri_flatten(readLines(stri_paste(wiki.URL,i)), col = " "))
  
  articles <- lapply(titles,function(i) page_content("en","wikipedia", page_name = i,as_wikitext=TRUE)$parse$wikitext)
  
  docs <- Corpus(VectorSource(articles)) # Get Web Pages' Corpus
  remove(articles)
  
  # Text analysis - Preprocessing 
  transform.words <- content_transformer(function(x, from, to) gsub(from, to, x))
  temp <- tm_map(docs, transform.words, "<.+?>", " ")
  temp <- tm_map(temp, transform.words, "\t", " ")
  temp <- tm_map(temp, content_transformer(tolower)) # Conversion to Lowercase
  # temp <- tm_map(temp, PlainTextDocument)
  temp <- tm_map(temp, stripWhitespace)
  temp <- tm_map(temp, removeWords, stopwords("english"))
  temp <- tm_map(temp, removePunctuation)
  temp <- tm_map(temp, stemDocument, language = "english") # Perform Stemming
  remove(docs)
  
  # Create Dtm 
  dtm <- DocumentTermMatrix(temp)
  dtm <- removeSparseTerms(dtm, 0.4)
  dtm$dimnames$Docs <- titles
  freq<-colSums(as.matrix(dtm))
  return(freq)
  
  #Wordcloud
  
  m <- as.matrix(dtm)
  v <- sort(rowSums(m),decreasing=TRUE)
  d <- data.frame(word = names(v),freq=v)
  head(d, 10)
  set.seed(1234)
  wordcloud(words = d$word,freq = d$freq,min.freq=1,max.words=200, scale=c(4,0.9), colors=brewer.pal(6, "Dark2"))
  
  
}
