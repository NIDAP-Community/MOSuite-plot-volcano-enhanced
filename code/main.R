#!/usr/bin/env Rscript
rlang::global_entrace()
library(argparse)
library(glue)
library(MOSuite)
library(readr)
library(stringr)
library(dplyr)

# set up capsule environment
setup_capsule_environment()

# parse CLI arguments
parser <- ArgumentParser()

parser$add_argument(
  "--feature_id_colname",
  type = "character",
  default = NULL,
  help = "Column name for feature IDs"
)
parser$add_argument(
  "--signif_colname",
  type = "character",
  default = "B-A_adjpval,B-C_adjpval",
  help = "Column names of significance values (comma-separated)"
)
parser$add_argument(
  "--signif_threshold",
  type = "double",
  default = 0.05,
  help = "Significance cutoff for p-values"
)
parser$add_argument(
  "--change_colname",
  type = "character",
  default = "B-A_logFC,B-C_logFC",
  help = "Column names of fold change values (comma-separated)"
)
parser$add_argument(
  "--change_threshold",
  type = "double",
  default = 1.0,
  help = "Fold change cutoff for significance"
)
parser$add_argument(
  "--value_to_sort_the_output_dataset",
  type = "character",
  default = "p-value",
  help = "How to sort output: 'fold-change' or 'p-value'"
)
parser$add_argument(
  "--num_features_to_label",
  type = "integer",
  default = 30,
  help = "Number of top features to label"
)
parser$add_argument(
  "--use_only_addition_labels",
  type = "logical",
  default = FALSE,
  help = "Use only additional labels, ignore top features"
)
parser$add_argument(
  "--additional_labels",
  type = "character",
  default = "",
  help = "Comma-separated feature names to label"
)
parser$add_argument(
  "--is_red",
  type = "logical",
  default = TRUE,
  help = "Highlight significant points in red"
)
parser$add_argument(
  "--lab_size",
  type = "double",
  default = 4,
  help = "Size of labels in plot"
)
parser$add_argument(
  "--change_sig_name",
  type = "character",
  default = "p-value",
  help = "Name for significance column in plot"
)
parser$add_argument(
  "--change_lfc_name",
  type = "character",
  default = "log2FC",
  help = "Name for fold change column in plot"
)
parser$add_argument(
  "--title",
  type = "character",
  default = "Volcano Plots",
  help = "Title of the plot"
)
parser$add_argument(
  "--use_custom_lab",
  type = "logical",
  default = FALSE,
  help = "Use custom labels"
)
parser$add_argument(
  "--ylim",
  type = "double",
  default = 0,
  help = "Y-axis limits"
)
parser$add_argument(
  "--custom_xlim",
  type = "character",
  default = "",
  help = "Custom X-axis limits"
)
parser$add_argument(
  "--xlim_additional",
  type = "double",
  default = 0,
  help = "Additional space for X-axis limits"
)
parser$add_argument(
  "--ylim_additional",
  type = "double",
  default = 0,
  help = "Additional space for Y-axis limits"
)
parser$add_argument(
  "--axis_lab_size",
  type = "double",
  default = 24,
  help = "Size of axis labels"
)
parser$add_argument(
  "--point_size",
  type = "double",
  default = 2,
  help = "Size of points in plot"
)
parser$add_argument(
  "--image_width",
  type = "integer",
  default = 3000,
  help = "Output image width in pixels"
)
parser$add_argument(
  "--image_height",
  type = "integer",
  default = 3000,
  help = "Output image height in pixels"
)
parser$add_argument(
  "--dpi",
  type = "integer",
  default = 300,
  help = "Dots per inch of output image"
)
parser$add_argument(
  "--interactive_plots",
  type = "logical",
  default = FALSE,
  help = "Whether to create interactive plots"
)
parser$add_argument(
  "--plot_filename",
  type = "character",
  default = "volcano_enhanced.png",
  help = "Plot output filename"
)

args <- parser$parse_args()

# load multiOmicDataSet from data directory
moo <- load_moo_from_data_dir()

# run MOSuite
plot_volcano_enhanced(
  moo,
  feature_id_colname = args$feature_id_colname,
  signif_colname = parse_optional_vector(args$signif_colname),
  signif_threshold = args$signif_threshold,
  change_colname = parse_optional_vector(args$change_colname),
  change_threshold = args$change_threshold,
  value_to_sort_the_output_dataset = args$value_to_sort_the_output_dataset,
  num_features_to_label = args$num_features_to_label,
  use_only_addition_labels = args$use_only_addition_labels,
  additional_labels = args$additional_labels,
  is_red = args$is_red,
  lab_size = args$lab_size,
  change_sig_name = args$change_sig_name,
  change_lfc_name = args$change_lfc_name,
  title = args$title,
  use_custom_lab = args$use_custom_lab,
  ylim = args$ylim,
  custom_xlim = args$custom_xlim,
  xlim_additional = args$xlim_additional,
  ylim_additional = args$ylim_additional,
  axis_lab_size = args$axis_lab_size,
  point_size = args$point_size,
  image_width = args$image_width,
  image_height = args$image_height,
  dpi = args$dpi,
  interactive_plots = args$interactive_plots,
  plot_filename = args$plot_filename
)
