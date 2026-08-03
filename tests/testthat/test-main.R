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

test_that("enhanced volcano capsule wires every app panel parameter into main.R", {
  main_lines <- read_repo_file("code", "main.R")
  main_text <- paste(main_lines, collapse = "\n")
  panel_lines <- read_repo_file(".codeocean", "app-panel.json")
  panel_args <- extract_panel_param_names(panel_lines)

  expect_match(main_text, "plot_volcano_enhanced\\(")

  for (param_name in panel_args) {
    expect_match(
      main_text,
      sprintf("args$%s", param_name),
      fixed = TRUE,
      info = sprintf("main.R should read args$%s", param_name)
    )
  }

  # Comma-separated inputs must be parsed into vectors before use.
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
    "t-statistic"
  )
  expect_equal(
    extract_panel_default(panel_lines, "num_features_to_label"),
    "20"
  )
  expect_equal(
    extract_panel_default(panel_lines, "label_significant_features_only"),
    "TRUE"
  )
  expect_equal(extract_panel_default(panel_lines, "label_font_size"), "5")
  expect_equal(
    extract_panel_default(panel_lines, "default_label_color"),
    "black"
  )
  expect_equal(
    extract_panel_default(panel_lines, "custom_label_color"),
    "black"
  )
  expect_equal(extract_panel_default(panel_lines, "x_axis_limit"), "5")
  expect_equal(extract_panel_default(panel_lines, "y_axis_limit"), "10")
  expect_equal(extract_panel_default(panel_lines, "axis_tick_lab_size"), "16")
  expect_equal(extract_panel_default(panel_lines, "title"), "Volcano Plots")
  expect_equal(extract_panel_default(panel_lines, "title_font_size"), "24")
  expect_equal(
    extract_panel_default(panel_lines, "color_of_signif_threshold_line"),
    "black"
  )
  expect_equal(
    extract_panel_default(panel_lines, "color_of_non_significant_features"),
    "grey30"
  )
  expect_equal(
    extract_panel_default(
      panel_lines,
      "color_of_logfold_change_threshold_line"
    ),
    "forestgreen"
  )
  expect_equal(
    extract_panel_default(
      panel_lines,
      "color_of_features_meeting_only_signif_threshold"
    ),
    "royalblue"
  )
  expect_equal(
    extract_panel_default(
      panel_lines,
      "color_for_features_meeting_pvalue_and_foldchange_thresholds"
    ),
    "red2"
  )
  expect_equal(
    extract_panel_default(panel_lines, "plot_filename"),
    "volcano_enhanced.png"
  )
})

test_that("Code Ocean boolean controls are TRUE/FALSE lists", {
  panel_lines <- read_repo_file(".codeocean", "app-panel.json")

  expect_boolean_list_parameter(panel_lines, "label_features", "FALSE")
  expect_boolean_list_parameter(
    panel_lines,
    "label_significant_features_only",
    "TRUE"
  )
  expect_boolean_list_parameter(panel_lines, "draw_connectors", "FALSE")
  expect_boolean_list_parameter(panel_lines, "use_default_x_axis_limit", "TRUE")
  expect_boolean_list_parameter(panel_lines, "use_default_y_axis_limit", "TRUE")
  expect_boolean_list_parameter(panel_lines, "use_custom_lab", "FALSE")
  expect_boolean_list_parameter(panel_lines, "interactive_plots", "FALSE")
})

test_that("run wrapper prepares result directories and forwards CLI arguments", {
  run_lines <- read_repo_file("code", "run")
  run_text <- paste(run_lines, collapse = "\n")

  expect_match(run_text, "mkdir -p \\.\\./results/figures \\.\\./results/moo")
  expect_match(run_text, 'Rscript main\\.R "\\$@"')
})
