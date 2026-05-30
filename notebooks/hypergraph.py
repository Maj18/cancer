import pandas as pd

# Example gene-level scores (z-scores, fold changes)
rna_scores = pd.read_csv("rna_gene_scores.csv", index_col=0)
prot_scores = pd.read_csv("prot_gene_scores.csv", index_col=0)

# Define hyperedges (pathways)
hyperedges = {
    "glycan_biosynthesis": ["FUT1", "FUT8", "ST6GAL1", "B4GALT1"],
    "nucleotide_metabolism": ["RRM1", "TYMS", "DHFR"]
}

# Aggregate gene-level scores per pathway
pathway_scores = {}
for path, genes in hyperedges.items():
    present_genes = [g for g in genes if g in rna_scores.index or g in prot_scores.index]
    
    # Combine RNA + protein, replace missing with 0
    combined = []
    for g in present_genes:
        rna_val = rna_scores.loc[g].values[0] if g in rna_scores.index else 0
        prot_val = prot_scores.loc[g].values[0] if g in prot_scores.index else 0
        combined.append((rna_val + prot_val) / 2)  # simple average
    pathway_scores[path] = sum(combined) / len(combined)

# Convert to DataFrame
df_pathways = pd.DataFrame.from_dict(pathway_scores, orient='index', columns=["Score"])
print(df_pathways)
