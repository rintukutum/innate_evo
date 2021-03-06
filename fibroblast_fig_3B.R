library(grid)
library(psych)
library(ggplot2)
source("common_functions.R")

##################################################################################
######################## Read data ###############################################
##################################################################################

gene_table = read.csv(file = "fibroblast_data/fibroblast_data.csv", row.names = 1, header = T)
gene_table = gene_table[is.na(gene_table$divergence)==0,]
gene_table = gene_table[gene_table$human_padj<0.01,]

##################################################################################
######################## Noise ###################################################
##################################################################################

gene_table = gene_table[is.na(gene_table$DM_pIC4)==0,]

gene_table$tata_class = "b"
gene_table[gene_table$TATA>0,]$tata_class = "a"

gene_table$cpg_class = "b"
gene_table[is.na(gene_table$CGI)==0,]$cpg_class = "a"

tata_genes      = gene_table[gene_table$TATA>0,] 
tata_less_genes =  gene_table[gene_table$TATA==0,] 

cpg_genes      = gene_table[is.na(gene_table$CGI)==0,] 
cpg_less_genes = gene_table[is.na(gene_table$CGI)==1,] 



##################################################################################
######################## Statistics - CpG ########################################
##################################################################################

empirical_p_value_cpg <- calc_empirical_p(
  cpg_genes$DM_pIC4,
  cpg_less_genes$DM_pIC4
)

##################################################################################
######################## Plot - CpG ##############################################
##################################################################################

box_gg = ggplot(gene_table[gene_table$cpg_class%in%c("a","b"),], 
                aes(x = cpg_class, y = DM_pIC4,fill = cpg_class)) +
  geom_boxplot(outlier.colour = NA) + 
  coord_cartesian(ylim = c(-0.9, 2.0)) +
  scale_fill_manual(values=c("#5B6BBC", "#a3a3a3")) +
  geom_signif(comparisons=list(c("a","b")), annotations=formatSignificance(empirical_p_value_cpg),
              y_position = c(1.85), tip_length = 0, vjust=0.4) +
  labs(x="",
       y="Cell-to-cell variability (DM)") +
  scale_x_discrete(labels=c("CGI","CGI-less"),
                   breaks=c("a","b")) +
  theme_classic() + 
  theme(legend.position = "none") +
  theme(axis.text.x = element_text(angle = (0),colour="black", size = 12, face="bold"))+
  theme(axis.text.y = element_text(angle = (0),colour="black", size = 10)) +
  theme(axis.title.x = element_text(colour="black", size = 12)) +
  theme(axis.title.y = element_text(colour="black", size = 12))

pdf("output_figures/fig_3B_cpg.pdf", width = 2.5, height = 3,useDingbats = F)
print(box_gg)
dev.off()



##################################################################################
######################## Statistics - TATA #######################################
##################################################################################


empirical_p_value_tata <- calc_empirical_p(
  tata_genes$DM_pIC4,
  tata_less_genes$DM_pIC4
)

##################################################################################
######################## Plot - TATA #############################################
##################################################################################

box_gg = ggplot(gene_table[gene_table$tata_class %in% c("a","b"),], 
                aes(x = tata_class, y = DM_pIC4, fill = tata_class)) +
  geom_boxplot(outlier.colour = NA) + 
  coord_cartesian(ylim = c(-0.9, 2.0)) +
  scale_fill_manual(values=c("#5B6BBC", "#a3a3a3")) +
  geom_signif(comparisons=list(c("a","b")), annotations=formatSignificance(empirical_p_value_tata),
              y_position = c(1.85), tip_length = 0, vjust=0.4) +
  labs(x="",
       y="Cell-to-cell variability (DM)") +
  scale_x_discrete(labels=c("TATA","TATA-less"),breaks=c("a","b")) +
  theme_classic() + 
  theme(legend.position = "none") +
  theme(axis.text.x = element_text(angle = (0),colour="black", size = 12, face="bold"))+
  theme(axis.text.y = element_text(angle = (0),colour="black", size = 10)) +
  theme(axis.title.x = element_text(colour="black", size = 12)) +
  theme(axis.title.y = element_text(colour="black", size = 12))

pdf("output_figures/fig_3B_tata.pdf", width = 2.5, height = 3,useDingbats = F)
print(box_gg)
dev.off()
