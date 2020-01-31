---
title: "Gtex-Disgenet analysis"
output: 
  html_document: 
    keep_md: yes
    toc: yes
    toc_float: yes
---

This document shows how the correlation between tissue and disease is revealed by analyzing a gtex dataset *Median gene-level TPM by tissue*() and *Curated gene-disease associations* from Disgenet().

# Preparation
First, the two datasets are download from [Gtex](https://storage.googleapis.com/gtex_analysis_v8/rna_seq_data/GTEx_Analysis_2017-06-05_v8_RNASeQCv1.1.9_gene_median_tpm.gct.gz) and [Disgenet](https://www.disgenet.org/static/disgenet_ap1/files/downloads/curated_gene_disease_associations.tsv.gz) websites, and then imported to the environment.
