#!/usr/bin/env Rscript
rlang::global_entrace()
library(argparse)
library(glue)
library(readr)
library(stringr)
library(dplyr)
devtools::load_all('/code/MOSuite')

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
  default = "t-statistic",
  help = "How to sort output: 'fold-change', 'p-value', or 't-statistic'"
)
parser$add_argument(
  "--num_features_to_label",
  type = "integer",
  default = 20,
  help = "Number of top features to label"
)
parser$add_argument(
  "--label_features",
  type = "logical",
  default = FALSE,
  help = "Label only features from custom_gene_list"
)
parser$add_argument(
  "--custom_gene_list",
  type = "character",
  default = "",
  help = "Comma-separated feature names or IDs to label"
)
parser$add_argument(
  "--label_font_size",
  type = "double",
  default = 5,
  help = "Size of labels in plot"
)
parser$add_argument(
  "--custom_label_color",
  type = "character",
  default = "black",
  help = "Color for labels from custom_gene_list"
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
  "--use_default_x_axis_limit",
  type = "logical",
  default = TRUE,
  help = "Use the default X-axis limit"
)
parser$add_argument(
  "--x_axis_limit",
  type = "double",
  default = 5,
  help = "Custom X-axis limit, used when default X-axis limit is disabled"
)
parser$add_argument(
  "--use_default_y_axis_limit",
  type = "logical",
  default = TRUE,
  help = "Use the default Y-axis limit"
)
parser$add_argument(
  "--y_axis_limit",
  type = "double",
  default = 10,
  help = "Custom Y-axis limit, used when default Y-axis limit is disabled"
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
  label_features = args$label_features,
  custom_gene_list = args$custom_gene_list,
  label_font_size = args$label_font_size,
  custom_label_color = args$custom_label_color,
  change_sig_name = args$change_sig_name,
  change_lfc_name = args$change_lfc_name,
  title = args$title,
  use_custom_lab = args$use_custom_lab,
  use_default_x_axis_limit = args$use_default_x_axis_limit,
  x_axis_limit = args$x_axis_limit,
  use_default_y_axis_limit = args$use_default_y_axis_limit,
  y_axis_limit = args$y_axis_limit,
  axis_lab_size = args$axis_lab_size,
  point_size = args$point_size,
  image_width = args$image_width,
  image_height = args$image_height,
  dpi = args$dpi,
  interactive_plots = args$interactive_plots,
  plot_filename = args$plot_filename
)
