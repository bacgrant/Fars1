#' Read file 'filename'
#'
#' This function reads in data from a comma separated value(csv) format file.
#' The output is returned in table format. If the named file does not exist, execution will stop and an error message displayed.
#'
#'@param filename A character string giving the name of the file to read from.
#'
#'@return This function returns the data read from the specified file in table format.
#'
#'@importFrom dplyr tbl_df
#'@importFrom readr read_csv
#'
#'@examples
#'fars_read('my_file.csv')
#'
#'@export
fars_read <- function(filename) {
        if(!file.exists(filename))
                stop("file '", filename, "' does not exist")
        data <- suppressMessages({
                readr::read_csv(filename, progress = FALSE)
        })
        dplyr::tbl_df(data)
}

#' Create filename for designated year
#'
#' this function takes a numerical year as input and prints out a filename in a specified format.
#' a non-numeric year value will result ina n error.
#'
#'@param year A numeric year value
#'
#'@return this function returns a filename in a specific format
#'
#'@examples
#'make_filename(2013)
#'
#'@export
make_filename <- function(year) {
        year <- as.integer(year)
        sprintf("accident_%d.csv.bz2", year)
}

#' For a list / vector of years, create a filename for each year, read the corresponding data file,
#' add an additional column for the year and return the month and year columns from the dataset.
#' The function includes error trapping to capture invalid years and issue a warning.
#'
#'@param years A vector of the years of interest.
#'
#'@importFrom dplyr mutate
#'@importFrom dplyr select
#'
#'@examples
#'fars_read_years(c(2013,2014,2015))
#'
#'@return The function returns the month and year columns from the dataset for each specified year
#'
#'@export
fars_read_years <- function(years) {
        lapply(years, function(year) {
                file <- make_filename(year)
                tryCatch({
                        dat <- fars_read(file)
                        dplyr::mutate(dat, year = year) %>%
                                dplyr::select(MONTH, year)
                }, error = function(e) {
                        warning("invalid year: ", year)
                        return(NULL)
                })
        })
}

#' Provide a monthly summary of the data for each year of interest.
#' Read data for each year of interest, bind rows into a single data frame,
#' group by year and month and summarise the results
#'
#'@param years A vector of the years of interest.
#'
#'@importFrom dplyr bind_rows
#'@importFrom dplyr group_by
#'@importFrom dplyr summarize
#'@importFrom tidyr spread
#'
#'
#'@examples
#'fars_summarize_years(c(2013,2014,2015))
#'
#'@return A monthly summary of teh data for each year of interest.
#'
#'@export
fars_summarize_years <- function(years) {
        dat_list <- fars_read_years(years)
        dplyr::bind_rows(dat_list) %>%
                dplyr::group_by(year, MONTH) %>%
                dplyr::summarize(n = n()) %>%
                tidyr::spread(year, n)
}

#' Generate a map for the specified state number showing the locations of motor vehicle fatalities for the year specified.
#' the function includes error trapping to capture invalid state numbers and display an error message.
#'
#'@param state.num  The number of the state of interest
#'@param year the year of interest
#'
#'@importFrom dplyr filter
#'@importFrom maps map
#'@importFrom graphics points
#'
#'@examples
#'fars_map_state(10,2013)
#'
#'@return A map for the specified state number showing the locations of motor vehicle fatalities for the year specified
#'
#'@export
fars_map_state <- function(state.num, year) {
        filename <- make_filename(year)
        data <- fars_read(filename)
        state.num <- as.integer(state.num)

        if(!(state.num %in% unique(data$STATE)))
                stop("invalid STATE number: ", state.num)
        data.sub <- dplyr::filter(data, STATE == state.num)
        if(nrow(data.sub) == 0L) {
                message("no accidents to plot")
                return(invisible(NULL))
        }
        is.na(data.sub$LONGITUD) <- data.sub$LONGITUD > 900
        is.na(data.sub$LATITUDE) <- data.sub$LATITUDE > 90
        with(data.sub, {
                maps::map("state", ylim = range(LATITUDE, na.rm = TRUE),
                          xlim = range(LONGITUD, na.rm = TRUE))
                graphics::points(LONGITUD, LATITUDE, pch = 46)
        })
}
