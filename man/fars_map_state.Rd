% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/fars_functions.R
\name{fars_map_state}
\alias{fars_map_state}
\title{Generate a map for the specified state number showing the locations of motor vehicle fatalities for the year specified.
the function includes error trapping to capture invalid state numbers and display an error message.}
\usage{
fars_map_state(state.num, year)
}
\arguments{
\item{state.num}{The number of the state of interest}

\item{year}{the year of interest}
}
\value{
A map for the specified state number showing the locations of motor vehicle fatalities for the year specified
}
\description{
Generate a map for the specified state number showing the locations of motor vehicle fatalities for the year specified.
the function includes error trapping to capture invalid state numbers and display an error message.
}
\examples{
\dontrun{fars_map_state(10,2013)}

}
