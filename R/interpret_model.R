#' @title Interpret Performance Estimator
#' @description Predictions are interpreted using simple Feature Impurity bar plots and
#' Ceteris Paribus Plots from DALEX package.
#' @param learner (`Learner(1)`) mlr3 learner
#' @param task (`Task(1)`) mlr3 task
#' @param new_data (`data.table(1)`) Single test data point for Ceteris Paribus Plots
#' @param class (`character(1)`) identifier for group of similar tasks
#' @return invisble `list()` containing plots.
#' @export
interpret_learner = function(learner, task, new_data, class) {
  assert_learner(learner)
  assert_task(task)
  assertDataTable(new_data, nrows = 1)
  assertString(class)
  # Feature Impurity bar plot
  pdf(file = sprintf("plots/impurity_PerfEst_%s.pdf", class), width = 30)
  barplot(learner$importance())
  dev.off()
  catf(
    "\n[INFO] Feature Impurity plot for Perf Estimator has been saved under plots/impurity_PerfEst_%s.pdf\n",
    class
  )
  Sys.sleep(2)
  # #Accumulated Local Effects
  # model = iml::Predictor$new(
  #   model = learner,
  #   data = task$data()[, - c("auc")],
  #   y = task$truth()
  # )
  # model$data$y.names = "AUC"
  # effect = FeatureEffects$new(predictor = model, features = task$feature_names)
  # ale_iml = plot(effect)
  # ggsave(
  #   ale_iml,
  #   filename = sprintf("plots/ALE_%s.pdf", class),
  #   height = 15,
  #   width = 20
  # )
  # catf(
  #   "\n[INFO] Accumulated Local Effects plot for Perf Estimator has been saved under plots/ALE_%s.pdf\n",
  #   class
  # )
  # Sys.sleep(2)

  # Ceteris Paribus Plots
  learner_explain = DALEXtra::explain_mlr3(
    model = learner,
    data = task$data()[, - c("auc")],
    y = task$truth()
  )
  cp = suppressWarnings(predict_profile(learner_explain, new_data))
  cp_DALEX = plot(cp) + ggtitle("Ceteris paribus for new prediction", " ")
  ggplot2::ggsave(
    cp_DALEX,
    filename = sprintf("plots/CP_%s.pdf", class),
    height = 15,
    width = 20
  )
  catf(
    "\n[INFO] Ceteris Paribus plot for Perf Estimator has been saved under plots/CP_%s.pdf\n",
    class
  )
  Sys.sleep(2)

  catf("\n[INFO] See interpretation plots in directory plots")
  invisible(list(CP = cp_DALEX))
}