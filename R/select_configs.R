#' @title Return configuration with highest predicted accuracy and fastest training time
#' @description After estimating performace predictions for similar tasks, for each similar task select:
#' \itemize{
#'   \item One config with highest predicted accuracy
#'   \item One config with smallest expected train_time, whereas accuracy is larger than \eqn{HighestPredAUC - sigma}
#' }
#' @param perf_predictions `data.table()` data.table of performance predictions
#' @param perf_est_data `data.table()` data.table of data used in training performance estimator
#' @param sigma `numeric(1)` parameter for accuracy range in fastest configuration decision
#' @return `list()` containing configs with highest predicted accuracy  and configs with fastest train time for each similar task.
#' @export
select_configs = function(perf_predictions, perf_est_data, sigma = 0.005) {
  assertDataTable(perf_predictions)
  assertDataTable(perf_est_data)
  assertNumber(sigma, lower = 0, upper = 1)

  # Join prediction data with train_time column
  perf_predictions[, c("timetrain", "data_id") := perf_est_data[perf_predictions$row_ids, .(timetrain, data_id)]]

  # All Configs in sigma range per data_id
  selected_configs = perf_predictions[ , .SD[response > max(response) - sigma, ], by = "data_id"]

  # Configs with highest predicted performance for each data_id in group of tasks
  config_highest_ids = selected_configs[order(-response, timetrain)][, .SD[1, .(row_ids, response)], by = "data_id"]
  config_highest = cbind(
    perf_est_data[config_highest_ids$row_ids, ],
    estimated_perf = config_highest_ids$response
  )

  # Fastest performing configuration in sigma range for each data_id in group of tasks
  config_fastest_ids = selected_configs[order(timetrain)][, .SD[1, .(row_ids, response)], by = "data_id"]
  config_fastest = cbind(
    perf_est_data[config_fastest_ids$row_ids, ],
    estimated_perf = config_fastest_ids$response
  )

  # Return configurations
  list(config_highest = config_highest, config_fastest = config_fastest)
}
