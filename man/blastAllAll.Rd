%% $Id: blastAllAll.Rd 189 2014-09-06 08:22:07Z larssn $

\name{blastAllAll}
\alias{blastAllAll}

\title{
  Making BLAST search all against all genomes
}
\description{
  Runs a reciprocal all-against-all BLAST search to look for similarity of proteins within and across genomes. The main job is done by the BLAST+ software.
}
\usage{
blastAllAll(in.files,out.folder,e.value=1,job=1,verbose=T)
}
\arguments{
  \item{in.files}{A text vector with the names of the FASTA files where the protein sequences of each genome is found.}
  \item{out.folder}{The name of the folder where the result files should end up.}
  \item{e.value}{The chosen E-value threshold in BLAST. Default is \samp{e.value=1}, a smaller value will speed up the search at the cost of less sensitivity.}
  \item{job}{An integer to separate multiple jobs. You may want to run several jobs in parallell, and each job should have different number here to avoid confusion on databases. Default is \samp{job=1}.}
  \item{verbose}{Logical, if \code{TRUE} some text output is produced to monitor the progress.}
}
\details{
  A basic step in pangenomics and many other comparative studies is to cluster proteins into groups or families. One commonly used approach is based on reciprocal BLASTing. This function uses the BLAST+ software available for free from NCBI (Camacho et al, 2009). 
  
  A vector listing FASTA files of protein sequences is given as input in \samp{in.files}. These files must have the GID-tag in the first token of every header, and in their filenames as well, i.e. all input files should first be prepared by \code{\link{panPrep}} to ensure this. Note that only protein sequences are considered here. If your coding genes are stored as DNA, please translate them to protein prior to using this function, see \code{\link{translate}}.
  
  A BLAST database is made from each genome in turn. Then all genomes are queried against this database, and for every pair of genomes a result file is produced. If two genomes have GID-tags \samp{GID111}, and \samp{GID222} then both result file \samp{GID111_vs_GID222.txt} and \samp{GID222_vs_GID111.txt} will be found in \samp{out.folder} after the completion of this search. This reciprocal (two-way) search is required because of the heuristics of BLAST.
  
  The \samp{out.folder} is scanned for already existing result files, and \code{\link{blastAllAll}} never overwrites an existing result file. If a file with the name \samp{GID111_vs_GID222.txt} already exists in the \samp{out.folder}, this particular search is skipped. This makes it possible to run multiple jobs in parallell, writing to the same \samp{out.folder}. It also makes it possible to add new genomes, and only BLAST the new combinations without repeating previous comparisons. 
  
  This search can be slow if the genomes contain many proteins and it scales quadratically in the number of input files. It is best suited for the study of a smaller number of genomes (less than say 100). By starting multiple R sessions, you can speed up the search by running \code{\link{blastAllAll}} from each R session, using the same \samp{out.folder} but different integers for the \code{job} option.
  
  The result files are text files, and can be read into R using \code{\link{readBlastTable}}, but more commonly they are used as input to \code{\link{bDist}} to compute distances between sequences for subsequent clustering.
}
\value{
  The function produces \emph{N*N} result files if \samp{in.files} lists \emph{N} sequence files. These result files are located in \code{out.folder}. Existing files are never overwritten by \code{\link{blastAllAll}}, if you want to re-compute something, delete the corresponding result files first.
}
\references{
 Camacho, C., Coulouris, G., Avagyan, V., Ma, N., Papadopoulos, J., Bealer, K., Madden, T.L. (2009). BLAST+: architecture and applications. BMC Bioinformatics, 10:421.
}
\note{
  The BLAST+ software must be installed on the system for this function to work, i.e. the commands \samp{makeblastdb} and \samp{blastp} must be recognized as valid commands if you run them in a terminal window.
}
\author{
  Lars Snipen and Kristian Hovde Liland.
}
\seealso{
  \code{\link{panPrep}}, \code{\link{readBlastTable}}, \code{\link{bDist}}.
}
\examples{
\dontrun{
	# Using FASTA files in this package.
  # We need to uncompress them first...
	extdata.path <- file.path(path.package("micropan"),"extdata")
	filenames <- c("Mpneumoniae_M129_GID1.fsa",
				   "Mpneumoniae_309_GID2.fsa",
				   "Mpneumoniae_FH_GID3.fsa")
  pth <- lapply( file.path( extdata.path, paste( filenames, ".xz", sep="" ) ), xzuncompress )
  
  #...blasting, assuming the BLAST+ software is properly installed
  # NB! This will take some minute(s)!
	blastAllAll(in.files=file.path(extdata.path,filenames),out.folder=".")
  
  # ...and compressing them again...
  pth <- lapply( file.path( extdata.path, filenames ), xzcompress )
}
}