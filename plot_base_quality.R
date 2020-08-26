# date: 20200812
library('getopt')
para<- matrix(
  c(
    'help',	'h',	0,	"logical",
    'R1_report',	'r',	1,	"character",
    'R2_report',	'R',	1,	"character",
    'out_prefix',	'o',	1,	"character"
    ), byrow=TRUE, ncol=4
)

opt <- getopt(para, debug=FALSE)
usage <- function(para=NULL){
  #cat(getopt(para, usage=TRUE))
  cat("
      Plot base content and quality from PE fastq report of fqtools_plus
      Usage example:
        Rscript plot_Base_quality.R -r /path/sample_R1.fq.gz.report -R /path/sample_R2.fq.gz.report -o /path/sample
      Options:
      --R1_report  r character sample_R1.fq.gz.report, fastq_1 report of fqtools_plus [forced]
      --R2_report  R character sample_R2.fq.gz.report, fastq_2 report of fqtools_plus [forced]
      --out_prefix o character prefix for outputfiles [forced]
      \n")
  q(status=1)
}

if ( !is.null(opt$help) || is.null(opt$R1_report) || is.null(opt$R2_report) || is.null(opt$out_prefix) ){ usage(para) }

#######################################################################
plot_base <- function(R1_report, R2_report, outfile="base.pdf"){
  R1_base <- R1_report[c('A','T','C','G','N')]
  R2_base <- R2_report[c('A','T','C','G','N')]
  Base_df <- rbind(R1_base, R2_base)
  Base_df['sum'] = Base_df$A + Base_df$T + Base_df$C + Base_df$G
  Base_df$A = Base_df$A*100/Base_df$sum
  Base_df$T = Base_df$T*100/Base_df$sum
  Base_df$C = Base_df$C*100/Base_df$sum
  Base_df$G = Base_df$G*100/Base_df$sum
  Base_df$N = Base_df$N*100/Base_df$sum
  
  content_max = max(c(Base_df$A,Base_df$T,Base_df$C,Base_df$G))
  high = 70
  if(content_max > 70)
    high = 90
  width = 1.5
  low = 0
  xais = seq(0, dim(Base_df)[1], 25)
  yais = seq(low, high,10)
  legend_xposi=dim(Base_df)[1]*3/5;
  
  pdf(outfile, w=5, h=4)
  par(mar=c(2.5, 2.5, 2.5, 0.25))
  
  plot(rownames(Base_df),Base_df$A,type="l",bty="l",col="red",ylim=c(low,high),xlab="",ylab="",xaxt="n", yaxt="n")
  points(rownames(Base_df), Base_df$A, col = "red", pch=20)
  lines(rownames(Base_df), Base_df$T, col="blue", lwd=width)
  points(rownames(Base_df), Base_df$T, col = "blue", pch=20)
  lines(rownames(Base_df), Base_df$C, col="green", lwd=width)
  points(rownames(Base_df), Base_df$C, col = "green", pch=20)
  lines(rownames(Base_df), Base_df$G, col="darkmagenta", lwd=width)
  points(rownames(Base_df), Base_df$G, col = "darkmagenta", pch=20)
  lines(rownames(Base_df), Base_df$N, col="turquoise4",lwd=width)
  points(rownames(Base_df), Base_df$N, col = "turquoise4", pch=20)
  
  legend(legend_xposi, 65, c("A%","T%","C%", "G%","N%"),lwd=1,cex=0.8,col = c("red","blue","green","darkmagenta","turquoise4"),bty="n")
  
  axis(side=1, xais, tcl=-0.2, labels=FALSE)
  mtext("Position",side=1,line=1)
  mtext(xais,side=1,las=1,at=xais,cex=0.6)
  axis(side=2,yais,tcl=-0.2,label=F)
  mtext(yais,side=2,las=1,at=yais,cex=0.6,line=0.5)
  mtext("Percent(%)",side=2,line=1.5)
  abline(v=150,lty=2,col="black")
  title("Base Distribution ")
  dev.off()
}

mean_Q <- function(R_quality){
  R_Q_df = data.frame(position=seq(1,dim(R_quality)[1]))
  R_Q_df['mean_quality'] = 0

  for (i in 1:dim(R_quality)[1]){
    total_base <- 0
    total_quality <- 0
    for (j in 1:dim(R_quality)[2]-1){
      q_value = R_quality[i,j+1]
      total_base = total_base + q_value
      total_quality = total_quality + q_value*j
    }
    R_Q_df[i,'mean_quality'] <- total_quality/total_base
  }
  return(R_Q_df)
}


plot_Quality_Distribution <- function(R1_report, R2_report, outfile="quality.pdf"){
  R1_quality <- subset(R1_report, select=-c(X.,A,T,C,G,N))
  R2_quality <- subset(R2_report, select=-c(X.,A,T,C,G,N))
  df_Q <- rbind(mean_Q(R1_quality), mean_Q(R2_quality))
  
  pdf(outfile, w=5, h=4)
  xais = seq(0, dim(df_Q)[1], 25)
  yais<-seq(0,40,10)
  legend_xposi=dim(df_Q)[1]*3/5;
  
  plot(rownames(df_Q), df_Q$mean_quality, type="l", bty="l", col="red", ylim=c(0,50), xlab="", ylab="", xaxt="n", yaxt="n")
  axis(side=1, xais, tcl=-0.2, labels=FALSE)
  mtext("Position",side=1,line=1)
  mtext(xais,side=1,las=1,at=xais,cex=0.6)
  axis(side=2,yais,tcl=-0.2,label=F)
  mtext(yais,side=2,las=1,at=yais,cex=0.6,line=0.5)
  mtext("Percent(%)",side=2,line=1.5)
  abline(v=dim(R1_quality)[1],lty=2,col="black")
  title("Mean Quality Distribution ")
  legend(legend_xposi,47, c("mean_quality"),lwd=1,cex=0.8,col = c("red"),bty="n")
  dev.off()
}


R1_report <- read.csv(opt$R1_report, sep="\t",header=1)
R1_report <- subset(R1_report, T != "NA")
R2_report <- read.csv(opt$R2_report, sep="\t",header=1)
R2_report <- subset(R2_report, T != "NA")

plot_base(R1_report, R2_report, paste(opt$out_prefix, ".base.pdf",sep=''))
plot_Quality_Distribution(R1_report, R2_report, paste(opt$out_prefix, ".quality.pdf",sep=''))





