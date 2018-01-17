---
title: "3. Barplot"
author: "Alan O'Callaghan"
date: "2018-01-16"
output:
  rmarkdown::html_vignette:
    fig_caption: yes
    self_contained: yes
    toc: true
    fig_width: 10
    fig_height: 6
    depth: 3  # upto three depths of headings (specified by #, ## and ###)  
vignette: >
  %\VignetteIndexEntry{Vignette Title}
  %\VignetteEngine{knitr::rmarkdown}
  %\VignetteEncoding{UTF-8}
---





```r
g <- ggplot(mpg, aes(class))
g <- g + geom_bar(aes(fill=drv))
print(g)
```

![plot of chunk unnamed-chunk-2](figure/unnamed-chunk-2-1.png)

```r
ggplotly(g)
```

![plot of chunk unnamed-chunk-2](figure/unnamed-chunk-2-2.png)

