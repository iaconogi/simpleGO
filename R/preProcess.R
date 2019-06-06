# GOdata=as.data.frame(org.Hs.egGO2ALLEGS)
#
# ens.ids=unique(GOdata[,1])
# go.ids=unique(GOdata[,2])
#
# go.ids.num=rep(0,nrow(GOdata))
# for (k in 1:length(go.ids))
#   go.ids.num[which(GOdata[,2]==go.ids[k])]=k
#
# ens.ids.num=rep(0,nrow(GOdata))
# for (k in 1:length(ens.ids))
#   ens.ids.num[which(GOdata[,1]==ens.ids[k])]=k
#
# GO.matrix=new("dgTMatrix", Dim = as.integer(c(max(go.ids.num),max(ens.ids.num))), i = as.integer(go.ids.num)-1L,j = as.integer(ens.ids.num)-1L, x = rep(1,length(ens.ids.num)))
# rownames(GO.matrix)=Term(GOTERM[go.ids])
# colnames(GO.matrix)=ens.ids
# rm(list=setdiff(ls(), "GO.matrix"))
# GO.matrix=GO.matrix>0
# save.image(file = './data/human_matrix.RData')
#
#
# GOdata=as.data.frame(org.Mm.egGO2ALLEGS)
#
# ens.ids=unique(GOdata[,1])
# go.ids=unique(GOdata[,2])
#
# go.ids.num=rep(0,nrow(GOdata))
# for (k in 1:length(go.ids))
#   go.ids.num[which(GOdata[,2]==go.ids[k])]=k
#
# ens.ids.num=rep(0,nrow(GOdata))
# for (k in 1:length(ens.ids))
#   ens.ids.num[which(GOdata[,1]==ens.ids[k])]=k
#
# GO.matrix=new("dgTMatrix", Dim = as.integer(c(max(go.ids.num),max(ens.ids.num))), i = as.integer(go.ids.num)-1L,j = as.integer(ens.ids.num)-1L, x = rep(1,length(ens.ids.num)))
# rownames(GO.matrix)=Term(GOTERM[go.ids])
# colnames(GO.matrix)=ens.ids
# rm(list=setdiff(ls(), "GO.matrix"))
# GO.matrix=GO.matrix>0
# save.image(file = './data/mouse_matrix.RData')


# rm(list=ls())
# org.ann.symbol=as.data.frame(org.Hs.eg.db::org.Hs.egSYMBOL)
# save.image(file = './data/org.ann.Hs.symbol.RData')
#
# rm(list=ls())
# org.ann.symbol=as.data.frame(org.Mm.eg.db::org.Mm.egSYMBOL)
# save.image(file = './data/org.ann.Mm.symbol.RData')
#
# rm(list=ls())
# org.ann=list()
# org.ann[[1]]=as.data.frame(org.Hs.eg.db::org.Hs.egSYMBOL)
# org.ann[[2]]=as.data.frame(org.Hs.eg.db::org.Hs.egENSEMBL2EG)
# org.ann[[3]]=as.data.frame(org.Mm.eg.db::org.Mm.egSYMBOL)
# org.ann[[4]]=as.data.frame(org.Mm.eg.db::org.Mm.egENSEMBL2EG)
# save.image(file = './data/org.ann.list.normal.RData')
#
#
# rm(list=ls())
# org.ann=list()
# dummy=as.data.frame(org.Hs.eg.db::org.Hs.egALIAS2EG)
# colnames(dummy)=c('gene_id','symbol')
# org.ann[[1]]=dummy
# org.ann[[2]]=as.data.frame(org.Hs.eg.db::org.Hs.egENSEMBL2EG)
# dummy=as.data.frame(org.Mm.eg.db::org.Mm.egALIAS2EG)
# colnames(dummy)=c('gene_id','symbol')
# org.ann[[3]]=dummy
# org.ann[[4]]=as.data.frame(org.Mm.eg.db::org.Mm.egENSEMBL2EG)
# rm(dummy)
# save.image(file = './data/org.ann.list.syn.RData')
