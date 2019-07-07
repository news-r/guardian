
<!-- README.md is generated from README.Rmd. Please edit that file -->

<!-- badges: start -->

[![Travis build
status](https://travis-ci.org/news-r/guardian.svg?branch=master)](https://travis-ci.org/news-r/guardian)
[![AppVeyor build
status](https://ci.appveyor.com/api/projects/status/github/news-r/guardian?branch=master&svg=true)](https://ci.appveyor.com/project/news-r/guardian)
<!-- badges: end -->

# guardian

Access over 2 million pieces of content from [The
Guardian](https://www.theguardian.com/)

## Installation

You can install the development version from
[GitHub](https://github.com/) with:

``` r
# install.packages("remotes")
remotes::install_github("news-r/guardian")
```

## Setup

To get started, You need a [free API
key](https://open-platform.theguardian.com/access/). Then either specify
the aforementioned key using `guardian_key` or specify it as environment
variable (likely in your .Renviron) as `GUARDIAN_API_KEY`.

``` r
guardian_key("xxXXxxXx")
```

## Example

The package revolves around the following principle, first create your
API calls then execute them with `gd_call`. This is because the package
is built upon the [async package](https://github.com/r-lib/async) which
lets you execute API calls asynchonously: the (free) developer plan
allows you to do up to 12 calls per second so the package
“prepares” calls. Then executes them with `gd_call` in batches of 12 (per second). If you have a premium account you
can change the batch size with the argument `batch_size` in `gd_call`. This allows collecting data much faster than if they were done one after the other.

Below we look for 15 pages of articles on “Brexit”.

``` r
library(guardian)

# search for brexit articles
(to_search <- gd_search("brexit", pages = 15))
#> ℹ 15 calls

# actually execute 15 calls (1 per page)
(results <- gd_call(to_search))
#> ℹ Making 15 calls in 2 batches of 12
#> # A tibble: 150 x 11
#>    id    type  sectionId sectionName webPublicationD… webTitle webUrl
#>    <chr> <chr> <chr>     <chr>       <chr>            <chr>    <chr> 
#>  1 poli… arti… politics  Politics    2019-06-18T16:2… Brexit … https…
#>  2 poli… arti… politics  Politics    2019-06-24T16:5… Has Bre… https…
#>  3 poli… arti… politics  Politics    2019-06-20T17:2… The lim… https…
#>  4 poli… arti… politics  Politics    2019-06-23T17:0… Brexit … https…
#>  5 busi… arti… business  Business    2019-06-11T12:0… UK jobs… https…
#>  6 poli… arti… politics  Politics    2019-06-10T16:4… Corbyn,… https…
#>  7 poli… arti… politics  Politics    2019-06-06T17:0… Forgott… https…
#>  8 poli… arti… politics  Politics    2019-04-09T18:4… What ha… https…
#>  9 busi… arti… business  Business    2019-06-02T06:0… Corbyn’… https…
#> 10 poli… arti… politics  Politics    2019-05-30T17:0… Brexit … https…
#> # … with 140 more rows, and 4 more variables: apiUrl <chr>,
#> #   isHosted <lgl>, pillarId <chr>, pillarName <chr>
```
