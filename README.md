
# Fars1

<!-- badges: start -->
[![Build status](https://ci.appveyor.com/api/projects/status/dvq4150alrljc9ev?svg=true)](https://ci.appveyor.com/project/bacgrant/fars1
<!-- badges: end -->

The goal of Fars1 is to provide functions which are intended to be used for processing data from the US National Highway Traffic Safety Administration's Fatality Analysis Reporting System, which is a nationwide census providing the American public yearly data regarding fatal injuries suffered in motor vehicle traffic crashes. The functions fars_read, make_filename, fars_read_years, and fars_summarize_years are used to provide a monthly summary of the data for a given year. The function fars_map_state is used to provide a map of the locations of fatalities for a given state in a given year.

## Installation

You can install the development version of Fars1 like so:



``` r 
install.packages("githubinstall")
library(githubinstall)
gh_install_packages("Fars1")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(Fars1)

Get monthly summaries for the years 2013, 2014 and 2015:
fars_summarize_years(c(2013,2014,2015))

Map incidents in state number 10 for the year 2013:
fars_map_state(10,2013)
```

