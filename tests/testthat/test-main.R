test_that("Code Ocean panel uses named parameters accepted by main.R", {
  main_args <- extract_main_arguments(read_repo_file("code", "main.R"))
  panel_lines <- read_repo_file(".codeocean", "app-panel.json")
  panel_args <- extract_panel_param_names(panel_lines)

  expect_true(
    any(grepl('"named_parameters"[[:space:]]*:[[:space:]]*true', panel_lines)),
    info = "Code Ocean should pass parameters by name to main.R"
  )
  expect_same_values(panel_args, main_args)
})

test_that("enhanced volcano capsule keeps expected CLI parameter contract", {
  main_lines <- read_repo_file("code", "main.R")
  main_text <- paste(main_lines, collapse = "\n")

  expected_args <- c(
    "feature_id_colname",
    "signif_colname",
    "signif_threshold",
    "change_colname",
    "change_threshold",
    "value_to_sort_the_output_dataset",
    "num_features_to_label",
    "use_only_addition_labels",
    "additional_labels",
    "is_red",
    "lab_size",
    "change_sig_name",
    "change_lfc_name",
    "title",
    "use_custom_lab",
    "ylim",
    "custom_xlim",
    "xlim_additional",
    "ylim_additional",
    "axis_lab_size",
    "point_size",
    "image_width",
    "image_height",
    "dpi",
    "interactive_plots",
    "plot_filename"
  )

  expect_same_values(extract_main_arguments(main_lines), expected_args)
  expect_match(main_text, "plot_volcano_enhanced\\(")
  expect_match(
    main_text,
    "signif_colname = parse_optional_vector\\(args\\$signif_colname\\)"
  )
  expect_match(
    main_text,
    "change_colname = parse_optional_vector\\(args\\$change_colname\\)"
  )
})

test_that("Code Ocean panel preserves enhanced volcano defaults", {
  panel_lines <- read_repo_file(".codeocean", "app-panel.json")

  expect_equal(
    extract_panel_default(panel_lines, "signif_colname"),
    "B-A_adjpval,B-C_adjpval"
  )
  expect_equal(
    extract_panel_default(panel_lines, "change_colname"),
    "B-A_logFC,B-C_logFC"
  )
  expect_equal(
    extract_panel_default(panel_lines, "value_to_sort_the_output_dataset"),
    "p-value"
  )
  expect_equal(
    extract_panel_default(panel_lines, "num_features_to_label"),
    "30"
  )
  expect_equal(extract_panel_default(panel_lines, "title"), "Volcano Plots")
  expect_equal(
    extract_panel_default(panel_lines, "plot_filename"),
    "volcano_enhanced.png"
  )
})

test_that("Code Ocean boolean controls are TRUE/FALSE lists", {
  panel_lines <- read_repo_file(".codeocean", "app-panel.json")

  expect_boolean_list_parameter(
    panel_lines,
    "use_only_addition_labels",
    "FALSE"
  )
  expect_boolean_list_parameter(panel_lines, "is_red", "TRUE")
  expect_boolean_list_parameter(panel_lines, "use_custom_lab", "FALSE")
  expect_boolean_list_parameter(panel_lines, "interactive_plots", "FALSE")
})

test_that("run wrapper prepares result directories and forwards CLI arguments", {
  run_lines <- read_repo_file("code", "run")
  run_text <- paste(run_lines, collapse = "\n")

  expect_match(run_text, "mkdir -p \\.\\./results/figures \\.\\./results/moo")
  expect_match(run_text, 'Rscript main\\.R "\\$@"')
})
