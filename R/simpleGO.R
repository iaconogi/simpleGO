#' simpleGO
#'
#' Simple GO enrichment with automatic clustering of the GO terms
#'
#' @param gene.list \code{character vector} with the gene set you want to enrich. Supports Human or Mouse, Gene Symbols or Ensembl.
#' @param background If you want to provide a custom background, again as \code{character vector}.
#' @param p Cutoff for the Benjamini corrected p-values.
#' @param excel.export A \code{character} with the file name in which you want to save the GO enrichments.
#' @param use.synonims If you are providing genes as Symbols, this will increase the number of recognized IDs. However, it can produce an increase in the number of your genes beacuse of older, redundant synonims shared between different genes.
#'
#' @return  A \code{list} in which each element is a data.frame with the results of the enrichment for each GO functional cluster.
#'
#'
#' @examples
#' simpleGO(gene.list=c('Celf4','Eapp','Fzd8','Larp1'),p=0.01,excel.export="test.xlsx")
#'
#' @export

simpleGO = function (gene.list,background=NA,p=0.05,excel.export=NA,use.synonims=FALSE)
{

former.length.genes=length(gene.list)
former.length.background=length(background)

out=IDprocessing(gene.list,background,use.synonims)
gene.list=out$gene.list
background=out$background
species=out$species

if (length(background)>0)
  print(sprintf('Recognized %g/%g of your gene list (%.2f %%) and %g/%g of your background (%.2f %%) ',length(gene.list),former.length.genes,length(gene.list)*100/former.length.genes,length(background),former.length.background,length(background)/former.length.background*100))
else
  print(sprintf('Recognized %g/%g of your gene list (%.2f %%)',length(gene.list),former.length.genes,length(gene.list)*100/former.length.genes))



if (species=='human')
  {
  print('Loading human data')
  data(human_matrix)
  data(org.ann.Hs.symbol)
  }
else
  {
  print('Loading mouse data')
  data(mouse_matrix)
  data(org.ann.Mm.symbol)
  }


if (length(background)>0)
{
  print('Using custom background')
  ix=which(is.element(colnames(GO.matrix),background))
  GO.matrix=GO.matrix[,ix]
}



pop.size=ncol(GO.matrix)
samp.size=length(gene.list)
pop.hits=Matrix::rowSums(GO.matrix>0)
samp.hits=Matrix::rowSums(GO.matrix[,which(is.element(colnames(GO.matrix),gene.list))]>0)



p.val=phyper(samp.hits, pop.hits, pop.size-pop.hits, samp.size,lower.tail = FALSE)+dhyper(samp.hits, pop.hits, pop.size-pop.hits, samp.size)
p.val=p.adjust(p.val,method = 'BH')


significant=which(p.val<p)

if ( length(significant)==0)
  {
  print('No enrichments found with the current settings. Try to increase p')
  return(NA)
  }
else
  print(sprintf('Found %g terms enriched',length(significant)))

p.val=p.val[significant]
samp.hits=samp.hits[significant]
pop.hits=pop.hits[significant]
ix=order(p.val)

if (length(ix)>1000)
{
  print('More than 1000 GO terms enriched, considering only 500')
  ix=ix[1:1000]
}

p.val=p.val[ix]
samp.hits=samp.hits[ix]
pop.hits=pop.hits[ix]
GO.matrix.full=as.matrix(GO.matrix[significant,which(is.element(colnames(GO.matrix),gene.list))])
GO.matrix.full=GO.matrix.full[ix,]
rm(GO.matrix,pos = ".GlobalEnv")

print(dim(GO.matrix.full))

genes=list()
gene.IDs=colnames(GO.matrix.full)

for ( k in 1:length(p.val))
      {
      if (length(p.val)==1)
        gene.ids=gene.IDs[which(GO.matrix.full>0)]
      else
        gene.ids=gene.IDs[which(GO.matrix.full[k,]>0)]
      genes[[k]]=org.ann.symbol$symbol[which(is.element(org.ann.symbol$gene_id,gene.ids))]
      }


rm(org.ann.symbol,pos = ".GlobalEnv")
ix=order(p.val,decreasing = FALSE)


jdist=philentropy::distance(x = GO.matrix.full,method = 'jaccard')
groups=bigscale.cluster(jdist)

print(sprintf('Divided the %g enriched GO terms into %g distinct functional groups',length(p.val),max(groups)))


enrich= data.frame(p.value=p.val,overlap=samp.hits,signature=pop.hits)
for (k in 1:nrow(enrich))
    enrich[k,4]=paste(genes[[k]], collapse = ',')
colnames(enrich)=c('BH p-value','Overlap','GO Signature','Genes')

enrich.out=list()
for (k in 1:max(groups))
  enrich.out[[k]]=enrich[which(groups==k),]

rm(enrich)

if (is.na(excel.export))
  return(enrich.out)
else
  {
    print(sprintf('Exporting the results in the file %s',excel.export))
    try(file.remove(excel.export))
    for (k in 1:max(groups))
      {
      xlsx::write.xlsx(enrich.out[[k]], excel.export, sheetName=sprintf("Group %g",k),append=TRUE)
      }
    return(enrich.out)
  }
}



bigscale.cluster = function (D,plot.clusters=FALSE,method.treshold=0.2,verbose=TRUE){

  gc()

  ht=hclust(as.dist(D),method='ward.D')

  result=rep(0,100)
  for (k in 1:100)
      {
      mycl <- cutree(ht, h=max(ht$height)*k/100)
      result[k]=max(mycl)
      }
  movAVG=zoo::rollapply(data = -diff(result),10,mean, fill = NA)

  cut.depth=max(which(movAVG>method.treshold))
  if (is.infinite(cut.depth)) cut.depth=50

  if (cut.depth<100)
    mycl = cutree(ht, h=max(ht$height)*cut.depth/100)
  else
    mycl = rep(1,length(ht$order))

  if (verbose)
    print(sprintf('Automatically cutting the tree at %g percent, with %g resulting clusters',cut.depth,max(mycl)))

  if (plot.clusters)
  {
    d=as.dendrogram(ht)
    plot(d)
  }

  return(mycl)
}

