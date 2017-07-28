---
title       : BL6024 - Quantitative Skills for Biologists using R
subtitle    : "Lecture 1: An introduction to R"
framework   : io2012        # {revealjs, io2012, html5slides, dzslides, ...}
highlighter : highlight.js  # {highlight.js, prettify, highlight}
hitheme     : tomorrow      # 
widgets     : [mathjax, quiz, bootstrap]           # {mathjax, quiz, bootstrap}
mode        : selfcontained # {standalone, draft}
knit        : slidify::knit2slides
logo        : logo_ucc.png
biglogo     : BEES_logo.jpg
---

## Read-And-Delete

1. Write using R Markdown
2. Use an empty line followed by three dashes to separate slides!
3. Designate the class of the next slide

--- .class #id 

## R code with output


```r
plot(cars)
abline(lm(dist ~ speed, data = cars), col = "red")
```

![plot of chunk unnamed-chunk-1](assets/fig/unnamed-chunk-1-1.png)


--- .class #id 

## R code only


```r
plot(cars)
abline(lm(dist ~ speed, data = cars), col = "red")
```


--- .class #id

## Output only

![plot of chunk unnamed-chunk-3](assets/fig/unnamed-chunk-3-1.png)


--- .class #id

## Images

<div style='text-align: center;'>
    <img src="assets/img/hen_harrier.jpg" style="height:500px"></img>
</div>


--- .class #id &twocol

## Two Column Layout   

This slide has two columns. Append `&twocol` to slide separator.
*** =left
- point 1
- point 2
- point 3
*** =right
- point 1
- point 2
- point 3

--- .class #id

## Insert Live Website

<iframe src = 'http://arcaravaggi.github.io' height='600px'></iframe>
