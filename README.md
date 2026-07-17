# Pan-cancer metabolic landscapes: A multi-omics view

This repository contains the complete analytical pipeline and R scripts required to reproduce the findings, figures, and statistical analyses presented in our manuscript:

> **Pan-cancer metabolic landscapes: A multi-omics view**  
> *Journal of Proteome Research* (Under Review)  

---

## 📊 Overview of the Analytical Pipeline
The computational workflow integrates large-scale proteomic, bulk transcriptomic (TCGA), and spatial transcriptomic (SMTdb) datasets comprising **3,226 samples across 24 human cancer types**. 

By leveraging a highly controlled, predominantly patient-matched design, this pipeline implements:
1. **Reaction-Level Functional Task Scoring and differential activity analysis** via our companion R package `parseMetab`.
2. **Metabolic pathway-level enrichment analysis and differential enrichment analysis** via our companion R package `parseMetab`
3. **Multi-Omics Batch Integration** utilizing integrative Non-Negative Matrix Factorization (iNMF) with quantitative PERMANOVA validation.
4. **Pathway-Level Tumor Purity Controls** utilizing *limma*-based continuous covariate regression via our companion R package `parseMetab`
5. **Co-Expression Network Modeling** to isolate conserved metabolic hub genes via our companion R package `parseMetab`
6. **Immunometabolic Coupling Analyses** uncovering non-linear microenvironmental saturation effects.
7. **Pan-Cancer Clinical Survival Analysis** (Kaplan-Meier & Cox Proportional Hazards modeling).

---

## 🛠️ Environmental Reproducibility (Docker)
To guarantee platform-independent reproducibility, eliminate package version discrepancies, and match the development environment precisely, all analyses should be executed within our dedicated, version-controlled Docker container.

* **Docker Hub Image ID:** `yuanli202004/cancer:v2.0.2`

### Running the Environment
You can pull and launch the RStudio Server or standalone R console container using:
```bash
docker pull yuanli202004/cancer:v2.0.2
# Start the container:
docker run -it --rm -v $(pwd):/work yuanli202004/cancer:v2.0.2 bash
# Within the docker, activate the conda env:
conda activate SMS7546
# Navigate the shared folder:
cd /work/
# Start R and here you go...
R
```

---

## 📦 Software Dependencies & Core Package
The majority of the high-resolution core workflow is streamlined using our companion package, `parseMetab` (v1.0.4). 

* **Source Code:** [Maj18/parseMetab](https://github.com/Maj18/parseMetab)
* **Permanent Software Archive:** [10.5281/zenodo.19153922](https://doi.org/10.5281/zenodo.19153922)

---

## 📁 Repository Structure
```text

├── notebooks/
│   ├── Hu2025.qmd      # Functional task scoring and differential metabolic activity analysis via parseMetab
│   ├── Hu2025_GSVA.qmd  # Metabolic pathway-level enrichment analysis and differential enrichment analysis via parseMetab
│   ├── Zhou2020.qmd  # Functional task scoring and differential metabolic activity analysis via parseMetab
│   ├── Zhou2020_GSVA.qmd  # Metabolic pathway-level enrichment analysis and differential enrichment analysis via parseMetab
│   ├── TCGA.qmd  # Metabolic pathway-level enrichment analysis and differential enrichment analysis via parseMetab
│   ├── TCGA_sensitivityAnalysis_purity.qmd   # Sensitivity analysis with Pathway-Level Tumor Purity Controls during differential analysis
│   ├── SMTdb.qmd   # Metabolic pathway-level enrichment analysis and differential enrichment analysis via parseMetab
│   ├── featureDiff_Network.qmd  # Metabolic protein-level enrichment analysis and differential enrichment analysis via parseMetab, as well as co-expression network analysis via parseMetab
│   ├── SurvivalAnalysis_TCGA_hubGenes.qmd  # Pan-Cancer Clinical Survival Analysis
│   ├── CellFieTasksVsKEGGpathways.qmd    # Cross-workflow metabolic profile correlation analysis
│   ├── TCGA_GSVAscoresVSimmuneScores.qmd  # Immunometabolic characterization and coupling analysis 
│   ├── IntegrativeVisualization.qmd  # Multi-omics integration via parseMetab
│   └── Summary.qmd # Prepare tables and figures for publication
├── src/
│   └── GetImmuneScores_TCGA.sh
└── README.md                  # Repository documentation

```


---

## 💾 Data Availability
The final, compiled processed datasets supporting the conclusions of this article are included within the manuscript's supplementary materials.

---

## ✉️ Contact
For questions regarding the analysis pipeline or data requests, please contact:
* **Yuan Li** - uncork-shady-next@duck.com
