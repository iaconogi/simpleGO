
IDprocessing = function (gene.list,background=NA,use.synonims=FALSE)
{
print("Preprocessing your gene IDs...")


if (use.synonims==TRUE)
    data(org.ann.list.syn)
  else
    data(org.ann.list.normal)

class.names=c('Human, Gene Symbol','Human, ENSEMBL','Mouse, Gene Symbol','Mouse, ENSEMBL')
mapped=list()
mapped$map1=which(is.element(org.ann[[1]]$symbol,gene.list ))
mapped$map2=which(is.element(org.ann[[2]]$ensembl_id,gene.list))
mapped$map3=which(is.element(org.ann[[3]]$symbol,gene.list))
mapped$map4=which(is.element(org.ann[[4]]$ensembl_id,gene.list))

hits=unlist(lapply(mapped, length))
best.hit=which(hits==max(hits))


if (best.hit==1 | best.hit==2) organism.detected='Human'
if (best.hit==3 | best.hit==4) organism.detected='Mouse'
if (best.hit==1 | best.hit==3) code.detected='Gene Symbols'
if (best.hit==2 | best.hit==4) code.detected='Ensembl'

print(sprintf('Recognized your gene names as %s, %s',organism.detected,code.detected))




if (organism.detected=='Human' & code.detected=='Gene Symbols')
  {
  gene.list=org.ann[[1]]$gene_id[mapped$map1]
  background=which(is.element(org.ann[[1]]$symbol,background))
  background=org.ann[[1]]$gene_id[background]
  }

if (organism.detected=='Human' & code.detected=='Ensembl')
  {
  gene.list=org.ann[[2]]$gene_id[mapped$map2]
  background=which(is.element(org.ann[[2]]$ensembl_id,background))
  background=org.ann[[2]]$gene_id[background]
}

if (organism.detected=='Mouse' & code.detected=='Gene Symbols')
  {
  gene.list=org.ann[[3]]$gene_id[mapped$map3]
  background=which(is.element(org.ann[[3]]$symbol,background))
  background=org.ann[[3]]$gene_id[background]
}

if (organism.detected=='Mouse' & code.detected=='Ensembl')
  {
  gene.list=org.ann[[4]]$gene_id[mapped$map4]
  background=which(is.element(org.ann[[4]]$ensembl_id,background))
  background=org.ann[[4]]$gene_id[background]
  }


rm(org.ann,pos = ".GlobalEnv")
return(list(gene.list=gene.list,background=background,species=organism.detected))
}
