# MOSuite-plot-volcano-enhanced

Code Ocean capsule: MOSuite - Plot Volcano Enhanced

- [Code Ocean Capsule](https://poc-nci.codeocean.io/capsule/0997557/tree) | [Latest Release](https://poc-nci.codeocean.io/capsule/7581039/tree/latest)
- [MOSuite R package docs](https://ccbr.github.io/MOSuite/)

## DEG inputs

Attach a MOSuite DEG MOO (`.rds`) or the wide `DEG_Analysis.csv` emitted by
[OMIX DEG Analysis](https://github.com/NIDAP-Community/OMIX/tree/main/modules/OMIX-DEG-Analysis).
No counts or sample metadata are required.

- `--input_type`: `auto` (default), `moo`, or `table`. Auto prefers exactly
  one RDS; otherwise it discovers one `DEG_Analysis.csv`, `.tsv`, or `.txt`
  recursively. Metadata, inventories and count tables are not selected.
- `--input_file`: optional explicit file selector for different names or
  ambiguous attachments. Choose `table` when both input formats are attached
  and you want to use the CSV.
- Tables require unique feature IDs and contrast-prefixed statistics:
  `_logFC` and `_adjpval` or `_pval`, plus `_tstat` for default labeling.
  Feature IDs default to the
  first column (`GeneName` for OMIX); `--feature_id_colname` overrides it.

Significance/change columns now default to automatic detection instead of
the example contrasts `B-A` and `B-C`. This handles arbitrary OMIX contrasts
without editing the panel. Explicit column selections remain supported and
unchanged. Both routes use the same existing data-frame plotting method;
multiple contrasts retain the existing per-contrast image filenames.
Standard errors are not relabeled as standard deviations.

## Validation and maintenance

Run `Rscript tests/testthat.R` from the repository root. Tests cover panel
bindings and actual MOO/table plotting parity, including underscore-containing
contrasts. Enhanced Volcano returns plot data but does not normally write
a companion CSV; tests capture that return solely to compare the two routes.
Code Ocean validation is still required before release.

`code/deg-input.R` is capsule-owned, shared verbatim with the Summary Volcano,
Venn and Filter Differential Expression capsules. Keep copies and input tests
synchronized; the SyncWeaver-managed MOSuite code and source pin are unchanged.