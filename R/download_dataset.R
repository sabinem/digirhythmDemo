#' Download dataset of package digiRythm
#'
#' The function tries to download the dataset.
#' Errors are catched and reported
#'
#' @param id id of digirythm example dataset
#'
#' @export
#'
#' @examples download_dataset("516b_2")
download_dataset <- function(id) {
  tryCatch(
    {
      digirythm_url <- "https://github.com/nasserdr/digiRhythm_sample_datasets/raw/main/"
      file_ending <- ".csv"
      download_url <- paste0(digirythm_url, id, file_ending)
      storage_path <- here::here("data", paste0(id, file_ending))
      download.file(download_url, destfile = storage_path)
    },
    error = function(error_message) {
      stop(error_message)
    }
  )
}
