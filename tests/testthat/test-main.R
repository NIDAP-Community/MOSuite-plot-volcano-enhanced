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
    "label_features",
    "custom_gene_list",
    "label_significant_features_only",
    "label_font_size",
    "default_label_color",
    "custom_label_color",
    "draw_connectors",
    "change_sig_name",
    "change_lfc_name",
    "title",
    "title_font_size",
    "use_custom_lab",
    "use_default_x_axis_limit",
    "x_axis_limit",
    "use_default_y_axis_limit",
    "y_axis_limit",
    "axis_lab_size",
    "axis_tick_lab_size",
    "point_size",
    "color_of_signif_threshold_line",
    "color_of_non_significant_features",
    "color_of_logfold_change_threshold_line",
    "color_of_features_meeting_only_signif_threshold",
    "color_for_features_meeting_pvalue_and_foldchange_thresholds",
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
  expect_match(main_text, "label_features = args\\$label_features")
  expect_match(main_text, "custom_gene_list = args\\$custom_gene_list")
  expect_match(
    main_text,
    "label_significant_features_only = args\\$label_significant_features_only"
  )
  expect_match(main_text, "label_font_size = args\\$label_font_size")
  expect_match(main_text, "default_label_color = args\\$default_label_color")
  expect_match(main_text, "custom_label_color = args\\$custom_label_color")
  expect_match(main_text, "draw_connectors = args\\$draw_connectors")
  expect_match(
    main_text,
    "use_default_x_axis_limit = args\\$use_default_x_axis_limit"
  )
  expect_match(main_text, "x_axis_limit = args\\$x_axis_limit")
  expect_match(
    main_text,
    "use_default_y_axis_limit = args\\$use_default_y_axis_limit"
  )
  expect_match(main_text, "y_axis_limit = args\\$y_axis_limit")
  expect_match(main_text, "axis_tick_lab_size = args\\$axis_tick_lab_size")
  expect_match(
    main_text,
    "color_of_non_significant_features = args\\$color_of_non_significant_features"
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

test_that("draw_connectors is exposed as a disabled-by-default boolean", {
  main_lines <- read_repo_file("code", "main.R")
  main_text <- paste(main_lines, collapse = "\n")
  panel_lines <- read_repo_file(".codeocean", "app-panel.json")

  expect_true("draw_connectors" %in% extract_main_arguments(main_lines))
  expect_match(main_text, '"--draw_connectors"')
  expect_match(main_text, "type = \\\"logical\\\"")
  expect_match(main_text, "default = FALSE")
  expect_match(main_text, "draw_connectors = args\\$draw_connectors")
  expect_boolean_list_parameter(panel_lines, "draw_connectors", "FALSE")
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
