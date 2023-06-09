#' @title Read xgboost_meta_data from csv file
#' @description  Except reading csv file, function also applies log_transformation to Hyperparameters: eta, gamma, lambda, alpha.\cr
#' Pay attention to printed texts generated by the function, while being executed.
#' @param file `character(1)` path to xgboost_meta_data file
#' @return `data.table()` of xgboost_meta_data.
#' @export
read_meta_data = function(file) {
  assertString(file)

  meta_data = data.table::fread(file)
  setkey(meta_data, data_id, auc)
  catf("[INFO] xgboost_meta_data contains %d missing values\n", sum(!stats::complete.cases(meta_data))) # missing data check

  # Skewness
  cat("[INFO] Hyperparameters in meta_data have following skewness:\n")
  print(apply(meta_data[, - c("task_id", "data_id", "dataset", "repl", "auc", "timetrain")], 2, e1071::skewness))

  cat("\n[INFO] Since Hyperparameters: eta, gamma, lambda and alpha are highly skewed, log transformation will be applied on them.\n\n")
  # Log Transformation
  meta_data[, c("eta", "gamma", "lambda", "alpha") := lapply(.SD, log),
            .SDcols = c("eta", "gamma", "lambda", "alpha")]

  # Change names of transformed Hyperparametrs to *_log
  setnames(
    meta_data,
    old = c("eta", "gamma", "lambda", "alpha"),
    new = c("eta_log", "gamma_log", "lambda_log", "alpha_log")
  )
  cat("[INFO] Column names of transformed Hyperparameters has been modified with log_* prefix.\n")
  meta_data
}
