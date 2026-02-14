# parseMetab: Metabolic Pathway Analysis R Package

A comprehensive R package for parsing, analyzing, and visualizing metabolic pathway activity across multiple cancer cohorts using GSVA (Gene Set Variation Analysis) and CellFie metabolic task scoring.

## Overview

`parseMetab` provides integrated workflows for:

- **Metabolic Database Construction**: Download and process KEGG metabolic pathway data
- **Pathway Activity Quantification**: Compute GSVA scores for metabolic pathways and CellFie task scoring
- **Multi-Cohort Comparison**: Compare metabolic pathway dysregulation across cancer types
- **Survival Analysis**: Identify metabolic biomarkers associated with patient prognosis
- **Visualization**: Generate comprehensive heatmaps, boxplots, and survival curves

## Installation

```r
# From local package directory
devtools::load_all("parseMetab")

# Or install from source
devtools::install("parseMetab")
```

## Key Features

### 1. Metabolic Database Management

- **`getdb_metabolism()`**: Download and structure KEGG metabolic pathways
  - Extracts human metabolic pathways (hsa01100)
  - Maps pathway genes and compounds
  - Creates both wide (list) and long (tibble) format databases
  - Saves structured databases as RDS files

### 2. GSVA Pathway Activity Analysis

- **`visualizeGSVSscoresGroup()`**: Boxplots of pathway activity across cancer types
  - Compares metabolic activity in all samples vs. normal controls
  - Generates publication-quality visualizations
  
- **`visualizeGSVSscoresClass()`**: Pathway activity aggregated by metabolic class
  - Groups pathways by metabolic category (Lipid, Energy, Carbohydrate, etc.)
  - Shows class-level dysregulation patterns

- **`makeLimmaDotplot_TCGA()`**: Comprehensive dot-plot of dysregulated pathways
  - Nested faceting by metabolic class
  - Point size/color represents significance and t-statistic
  - Handles multiple cancer cohorts

### 3. CellFie Metabolic Task Analysis

- **`systemDiffAnalysis()`**: End-to-end paired differential analysis
  - Extracts metabolic system genes from CellFie output
  - Performs paired limma testing (tumor vs. normal)
  - Supports multiple cohorts (Hu2025, Zhou2020)
  - Flexible data source paths for reproducibility

- **`getSystem()`**: Extract and annotate system-specific genes
  - Filters genes by metabolic system
  - Converts entrez IDs to gene symbols via mygene service

- **`visualizeDiffFeatures()`**: Heatmap of differential feature expression
  - Significance overlays (FDR < 0.05)
  - Row annotations by metabolic class
  - Auto-scaling for data size

### 4. Effect Size Visualization

- **`makeEffectSizeBoxplot_system()`**: Distribution of effects by metabolic system
  - Combined violin and boxplot visualization
  - Winsorized for outlier handling
  
- **`makeEffectSizeBoxplot_cancer()`**: Distribution of effects by cancer type
  - Aggregates across all metabolic systems
  - Dynamic PDF width scaling

- **`makeExprBoxplot_system()`**: Feature abundance across systems
  - Shows baseline expression patterns
  - Useful for identifying abundant vs. sparse metabolic tasks

### 5. Survival Analysis

- **`metabolicSurvival_coxreg()`**: Cox proportional hazards regression
  - Univariate and multivariable models with stepwise fallback
  - Tests proportional hazards assumption (Schoenfeld residuals)
  - FDR-corrected p-values
  - Returns hazard ratios with 95% confidence intervals

- **`metabolicSurvival_Kaplan_Meier()`**: Kaplan-Meier survival curves
  - Stratifies by pathway activity (High/Low using 35th/65th percentiles)
  - Log-rank test for survival differences
  - Generates individual survival plots
  - FDR-corrected significance testing

- **`visualizeDiffFeatures_sur()`**: Heatmap of hazard ratios
  - Visualizes prognostic associations across cohorts
  - Color gradient represents protective (blue, HR < 1) to risk (red, HR > 1)
  - Significance overlays for FDR < 0.1

## Workflow Example

```r
library(parseMetab)

# 1. Set up directories
outDirHu <- "./results/SystemAnalysis_Hu/"
outDirZhou <- "./results/SystemAnalysis_Zhou/"
outDirSummary <- "./results/Summary/"

# 2. Extract metabolic system and perform paired differential analysis
results <- systemDiffAnalysis(
  System = "LIPIDS METABOLISM",
  outDirHu = outDirHu,
  outDirZhou = outDirZhou
)

# 3. Visualize differential features
visualizeDiffFeatures(
  limma_rslt = results$limma_rslt_listHu,
  taskInfo = results$systemHu,
  outdir = outDirSummary,
  depth = "Depth3"
)

# 4. Create effect size comparison
makeEffectSizeBoxplot_system(
  rslt_lists = results,
  dataset = "Hu",
  effect.statistic = "logFC"
)

# 5. Perform survival analysis
cox_results <- metabolicSurvival_coxreg(meta, GSVAscores)
km_results <- metabolicSurvival_Kaplan_Meier(meta, GSVAscores, outdir)

# 6. Visualize survival associations
visualizeDiffFeatures_sur(
  metabolicSur_rslts = cox_results,
  kegg_metab_db_table = kegg_db,
  outDir = outDirSummary,
  pvalue_cutoff = 0.05
)
```

## Data Structures

### Input Requirements

#### Expression Data
- Matrix or data frame with genes as rows and samples as columns
- Must include "genes" column with gene identifiers
- Typically normalized (log2-transformed) expression values

#### Sample Metadata
- Data frame with rows corresponding to samples
- Required columns: `sample.submitter_id`, `Condition`, `Patient`, `Cancer_type`
- Optional: `age_at_diagnosis`, `gender`, `ajcc_pathologic_stage` (for Cox models)
- For survival: `vital_status`, `days_to_death`, `days_to_last_follow_up`

#### Pathway Metadata
- KEGG metabolic database: `gs_name` (pathway ID) and `class` (metabolic category)
- CellFie task hierarchy: `Depth1` (system), `Depth3` (task/pathway)

### Output Formats

All functions save results in both RDS (for R analysis) and XLSX (for spreadsheet review):
- `systemTaskInfoHu.RDS/XLSX`: System task information
- `limma_rslt_listHu.RDS/XLSX`: Differential expression results
- `HR_survival.pdf`: Hazard ratio heatmap
- `KaplanMeierCurves_*.pdf`: Individual survival curves

## Key Parameters

### Common Parameters

| Parameter | Description | Default |
|-----------|-------------|---------|
| `System` | Metabolic system to analyze | "LIPIDS METABOLISM" |
| `dataset` | Dataset selection (Hu/Zhou) | "Hu" |
| `effect.statistic` | Effect size metric (logFC/t) | "logFC" |
| `winsorize.quantil` | Percentile for outlier clipping | 0.05 |
| `pvalue_cutoff` | Significance threshold | 0.05 |

### Survival Analysis

| Parameter | Description | Default |
|-----------|-------------|---------|
| `sig.statistic` | Significance column (P.Value/adj.P.Val) | "adj.P.Val" |
| `sig.cutoff` | Pathway inclusion threshold | 0.05 |
| `effect.statistic` | Effect measure (logFC/t/AveExpr) | "logFC" |

## Dependencies

Core packages:
- `dplyr`: Data manipulation
- `ggplot2`: Visualization
- `limma`: Differential expression analysis
- `survival`: Survival analysis
- `pheatmap`: Heatmap generation
- `GSVA`: Gene set variation analysis
- `KEGGREST`: KEGG database access
- `mygene`: Gene ID mapping

## Citation

If you use this package in your research, please cite:

```
@software{parseMetab2025,
  title={parseMetab: Metabolic Pathway Analysis R Package},
  author={Yuan, Li},
  year={2025},
  url={https://github.com/yourusername/parseMetab}
}
```

## Troubleshooting

### Common Issues

**Problem**: mygene queries fail with network timeout
- **Solution**: Check internet connectivity; consider using cached gene symbol mappings

**Problem**: Limma model fails to fit for certain cancer types
- **Solution**: Ensure >4 paired samples and 2+ conditions per cancer type; function has automatic fallback to simpler models

**Problem**: Survival curves don't show significant differences (log-rank p > 0.05)
- **Solution**: Consider adjusting percentile cutoffs (currently 35th/65th) or using alternative stratification

**Problem**: Heatmap dimensions are too large
- **Solution**: Adjust `w` and `h` parameters manually or filter pathways before visualization

## Project Structure

```
parseMetab/
├── R/
│   └── script.R           # Main functions
├── data/                  # Sample datasets
├── man/                   # Function documentation
├── tests/                 # Unit tests
└── vignettes/             # Tutorials and examples
```

## Contributing

Contributions are welcome! Please:
1. Fork the repository
2. Create a feature branch (`git checkout -b feature/improvement`)
3. Commit changes with descriptive messages
4. Push to the branch (`git push origin feature/improvement`)
5. Open a pull request

## Support

For bugs, feature requests, or questions:
- Open an issue on GitHub
- Check existing documentation in function help pages (`?functionName`)
- See vignettes for detailed tutorials

## License

This package is licensed under the MIT License. See LICENSE file for details.

## Changelog

### v1.0.0 (2025-02-12)
- Initial release
- Comprehensive roxygen2 documentation for all major functions
- Support for multi-cohort metabolic pathway analysis
- Integrated survival analysis pipeline
- Publication-quality visualization functions

## References

- Hanzelmann, S., Castelo, R., & Guinney, J. (2013). GSVA: Gene set variation analysis for microarray and RNA-seq data. BMC Bioinformatics, 14, 7.
- Schalm, S., Oefner, P., & Haliburton, G. (2022). Computational identification of metabolic pathway dysregulation in cancer.
- KEGG: Kanehisa, M., & Goto, S. (2000). KEGG: Kyoto Encyclopedia of Genes and Genomes.

---

**Last Updated**: February 12, 2026
**Maintainer**: Yuan Li
**Package Version**: 1.0.0
