
# Convert ENSEMBL/ENTREZID gene IDs to Symbol in R
# AnnotationDbi is the most popular annotation packages have been modified so that they can make use of a new set of methods to more easily access their contents. 
# These four methods are named:  columns, key types, keys and select. And they are described in this vignette. 
# They can currently be used with all chip, organism, and TxDb packages along with the popular GO.db package
# https://bioconductor.org/packages/release/bioc/vignettes/AnnotationDbi/inst/doc/IntroToAnnotationPackages.pdf 
# https://bioconductor.org/packages/release/bioc/vignettes/AnnotationDbi/inst/doc/AnnotationDbi.pdf
# https://bioconductor.org/packages/release/bioc/manuals/AnnotationDbi/man/AnnotationDbi.pdf

################################################################################
BiocManager::install("TxDb.Mmusculus.UCSC.mm10.knownGene")
BiocManager::install("org.Mm.eg.db")
BiocManager::install("AnnotationDbi")
################################################################################
library(TxDb.Mmusculus.UCSC.mm10.knownGene)
library("org.Mm.eg.db")
library("AnnotationDbi")
library(readxl)
################################################################################

# **Note:** Remember to create a "data/" and a "output/" folder in the current directory.

# Get the current working directory
wd <- getwd()

# Specify the path to the input and output directories
path_to_input <- file.path(wd, "data")
path_to_output <- file.path(wd, "output")

# Specify the pattern to search for (.txt files)
pattern <- ".txt"

################################################################################

# List files in the input directory that match the specified pattern
txt_files <- list.files(path = path_to_input, pattern = pattern, full.names = TRUE)

# Create an empty list to store data frames
data_frames <- list()

# Loop through the list of txt_files and read each file into a data frame
for (file in txt_files) {
  # Extract the filename without the extension
  filename <- tools::file_path_sans_ext(basename(file))
  
  # Read the txt file into a data frame
  data <- read.table(file, header = TRUE, sep = "\t")  # Adjust sep as needed
  
  # Store the data frame in the list with the filename as the name
  data_frames[[filename]] <- data
}
################################################################################

class(data_frames$sample_gene_cluster_1_anno$geneId)
################################################################################

# If you want to convert factors to characters for a specific data frame.
if ("sample_gene_cluster_1_anno" %in% names(data_frames)) {
  data_frames$sample_gene_cluster_1_anno$geneId <- as.character(data_frames$sample_gene_cluster_1_anno$geneId)
}

# If you want to add SYMBOL using org.Mm.eg.db for a specific data frame, for example, "sample_gene_cluster_1_anno"
if ("sample_gene_cluster_1_anno" %in% names(data_frames)) {
  library(org.Mm.eg.db)
  data_frames$sample_gene_cluster_1_anno$SYMBOL <- mapIds(org.Mm.eg.db, keys = data_frames$sample_gene_cluster_1_anno$geneId, keytype = "ENTREZID", column = "SYMBOL")
}
################################################################################

# To save as .xls file for a specific data frame, for example, "sample_gene_cluster_1_anno"
if ("sample_gene_cluster_1_anno" %in% names(data_frames)) {
  write.table(data_frames[["sample_gene_cluster_1_anno"]], file = file.path(path_to_output, "sample_gene_cluster_1_anno.xls"), sep = "\t")
}

# To save as .csv file for a specific data frame, for example, "sample_gene_cluster_1_anno"
if ("sample_gene_cluster_1_anno" %in% names(data_frames)) {
  write.table(data_frames[["sample_gene_cluster_1_anno"]], file = file.path(path_to_output, "sample_gene_cluster_1_anno.csv"), sep = ",")
}
################################################################################

# Now you have a named list of data frames with factors converted to characters, and new Excel and CSV files saved in the "output" directory

