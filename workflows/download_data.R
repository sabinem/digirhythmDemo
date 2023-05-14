# download a single dataset
id <- "516b_2"
download_dataset(id)

download_dataset <- function(id) {
  digirythm_url <- "https://github.com/nasserdr/digiRhythm_sample_datasets/raw/main/"
  file_ending <- ".csv"
  download_url <- paste0(digirythm_url, id, file_ending)
  storage_path <- here::here("data", paste0(id, file_ending))
  download.file(download_url, destfile = storage_path)
}
