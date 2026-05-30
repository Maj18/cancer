#!/usr/bin/bash
# Define the exact disease names from your HTML option values
diseases=(
  "adrenocortical_carcinoma"
  "bladder_urothelial_carcinoma"
  "breast_cancer"
  "cervical_carcinoma"
  "colorectal_adenocarcinoma"
  "esophageal_carcinoma"
  "glioblastoma_multiforme"
  "head_and_neck_squamous_cell_carcinoma"
  "kidney_chromophobe_renal_cell_carcinoma"
  "kidney_renal_clear_cell_carcinoma"
  "kidney_renal_papillary_cell_carcinoma"
  "acute_myeloid_leukemia"
  "liver_hepatocellular_carcinoma"
  "low_grade_glioma"
  "lung_adenocarcinoma"
  "lung_squamous_cell_carcinoma"
  "ovarian_serous_cystadenocarcinoma"
  "pancreatic_ductal_adenocarcinoma"
  "paraganglioma_and_pheochromocytoma"
  "prostate_adenocarcinoma"
  "skin_cutaneous_melanoma"
  "stomach_adenocarcinoma"
  "thyroid_papillary_carcinoma"
  "uterine_corpus_endometrial_carcinoma"
  "uterine_carcinosarcoma"
)

# Loop through each disease name and execute the download command
for disease in "${diseases[@]}"; do
  echo "Downloading file for: ${disease}"
  wget https://bioinformatics.mdanderson.org/estimate/tables/${disease}_RNAseqV2.txt
done


