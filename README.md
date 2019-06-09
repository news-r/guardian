<!-- README.md is generated from README.Rmd. Please edit that file -->


<!-- badges: start -->
[![Travis build status](https://travis-ci.org/news-r/guardian.svg?branch=master)](https://travis-ci.org/news-r/guardian)
[![AppVeyor build status](https://ci.appveyor.com/api/projects/status/github/news-r/guardian?branch=master&svg=true)](https://ci.appveyor.com/project/news-r/guardian)
<!-- badges: end -->

# guardian

Access over 2 million pieces of content from [The Guardian](https://www.theguardian.com/)

## Installation

You can install the development version from [GitHub](https://github.com/) with:

``` r
# install.packages("remotes")
remotes::install_github("news-r/guardian")
```

## Setup

To get started, You need a [free API key](https://open-platform.theguardian.com/access/). Then either specify the aforementioned key using `guardian_key` or specify it as environment variable (likely in your .Renviron) as `GUARDIAN_API_KEY`.

```r
guardian_key("xxXXxxXx")
```

## Example

The package revolves around the following principle, first create your API calls then execute them with `gd_call`. This is because the package is built upon the [async package](https://github.com/r-lib/async) which lets you execute API calls asynchonously: the (free) developer plan allows you to do up to 12 calls per second. 

Below we look for 15 pages of articles on "Brexit".


```r
library(guardian)

# search for brexit articles
(to_search <- gd_search("brexit", pages = 15))
#> ℹ 15 calls

# actually execute 15 calls (1 per page)
results <- gd_call(to_search)
#> ℹ Making 15 calls in 2 batches of 12
head(results)
#>                                                                                          id
#> 1                                             politics/2019/apr/09/brexit-what-happens-next
#> 2                       politics/2019/jun/06/forgotten-social-history-and-the-brexit-debate
#> 3 business/2019/jun/02/corbyn-destructive-ambiguity-brexit-failed-euroscepticism-collapsing
#> 4                            politics/2019/may/30/brexit-to-compromise-or-make-hard-choices
#> 5                     politics/2019/may/29/government-spends-almost-100m-brexit-consultants
#> 6                                world/2019/may/24/friday-briefing-is-this-mays-brexit-exit
#>      type sectionId sectionName   webPublicationDate
#> 1 article  politics    Politics 2019-04-09T18:49:09Z
#> 2 article  politics    Politics 2019-06-06T17:06:24Z
#> 3 article  business    Business 2019-06-02T06:00:31Z
#> 4 article  politics    Politics 2019-05-30T17:04:16Z
#> 5 article  politics    Politics 2019-05-29T17:53:22Z
#> 6 article     world  World news 2019-05-24T05:17:02Z
#>                                                               webTitle
#> 1                                       What happens next with Brexit?
#> 2             Forgotten social history and the Brexit debate | Letters
#> 3 Corbyn’s destructive ambiguity on Brexit has failed | William Keegan
#> 4               Brexit – to compromise or make hard choices? | Letters
#> 5                 Government spends almost £100m on Brexit consultants
#> 6                          Friday briefing: Is this May's Brexit exit?
#>                                                                                                                  webUrl
#> 1                                             https://www.theguardian.com/politics/2019/apr/09/brexit-what-happens-next
#> 2                       https://www.theguardian.com/politics/2019/jun/06/forgotten-social-history-and-the-brexit-debate
#> 3 https://www.theguardian.com/business/2019/jun/02/corbyn-destructive-ambiguity-brexit-failed-euroscepticism-collapsing
#> 4                            https://www.theguardian.com/politics/2019/may/30/brexit-to-compromise-or-make-hard-choices
#> 5                     https://www.theguardian.com/politics/2019/may/29/government-spends-almost-100m-brexit-consultants
#> 6                                https://www.theguardian.com/world/2019/may/24/friday-briefing-is-this-mays-brexit-exit
#>                                                                                                                       apiUrl
#> 1                                             https://content.guardianapis.com/politics/2019/apr/09/brexit-what-happens-next
#> 2                       https://content.guardianapis.com/politics/2019/jun/06/forgotten-social-history-and-the-brexit-debate
#> 3 https://content.guardianapis.com/business/2019/jun/02/corbyn-destructive-ambiguity-brexit-failed-euroscepticism-collapsing
#> 4                            https://content.guardianapis.com/politics/2019/may/30/brexit-to-compromise-or-make-hard-choices
#> 5                     https://content.guardianapis.com/politics/2019/may/29/government-spends-almost-100m-brexit-consultants
#> 6                                https://content.guardianapis.com/world/2019/may/24/friday-briefing-is-this-mays-brexit-exit
#>   isHosted    pillarId pillarName
#> 1    FALSE pillar/news       News
#> 2    FALSE pillar/news       News
#> 3    FALSE pillar/news       News
#> 4    FALSE pillar/news       News
#> 5    FALSE pillar/news       News
#> 6    FALSE pillar/news       News
```
