% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/bdist.R
\name{bDist}
\alias{bDist}
\title{Computes distances between sequences based on BLAST results}
\usage{
bDist(blast.files, e.value = 1, verbose = TRUE)
}
\arguments{
\item{blast.files}{A text vector of filenames.}

\item{e.value}{A threshold E-value to immediately discard (very) poor BLAST alignments. Default is 1.0.}

\item{verbose}{A logical indicating if textual output should be given to monitor the progress.}
}
\value{
The function returns a \samp{data.frame} with columns \samp{Sequence.A}, \samp{Sequence.B}
and \samp{Distance}. Each row corresponds to a pair of sequence having at least one BLAST hit between
them. All pairs \emph{not} listed in the output have distance 1.0 between them.
}
\description{
Reads a complete set of result files from a BLAST search and
computes distance between all sequences based on the BLAST bit-score.
}
\details{
Each input file must be a BLAST result file where all proteins of one genome have been
queried against a database of all proteins from another genome. The result files must all have
12 columns of results, i.e. have been produced by the option \samp{-outfmt 6} in the BLAST+ software.
The filenames must have the format \samp{GID111_vs_GID222.txt} and are typically produced by
\code{\link{blastAllAll}}.

Setting a small \samp{e.value} threshold can speed up the computation and reduce the size of the
output, but you may loose some alignments that could produce smallish distances for short sequences.

The distance computed is a relative score. If an alignment of query A against hit B has a bit-score
of S(A;B), we compute an intermediate distance D(A;B)=1-S(A;B)/S(A;A) where S(A;A) is the bit-score
of aligning A against itself. Reversing the search, we also get D(B;A)=1-S(B;A)/S(B;B), where B has
been used as query and A is the hit. The final distance is D(A,B)=(D(A;B)+D(B;A))/2. A distance of
0.0 means A and B are identical. The maximum possible distance is 1.0, meaning there is no BLAST hit
found either way. 

This distance should not be interpreted as lack of identity. A distance of 0.0 means 100\% identity,
but a distance of 0.25 does \emph{not} mean 75\% identity. It has some resemblance to an evolutinary
(raw) distance, but since it is based on protein alignments, the type of mutations plays a significant
role, not only the number of mutations.
}
\examples{
# Using BLAST result files in this package...
prefix <- c("GID1_vs_GID1.txt",
            "GID1_vs_GID2.txt",
            "GID1_vs_GID3.txt",
            "GID2_vs_GID1.txt",
            "GID2_vs_GID2.txt",
            "GID2_vs_GID3.txt",
            "GID3_vs_GID1.txt",
            "GID3_vs_GID2.txt",
            "GID3_vs_GID3.txt")
xpth <- file.path(path.package("micropan"),"extdata")
blast.files <- file.path(xpth,paste(prefix,".xz",sep=""))

# We need to uncompress them first...
tf <- tempfile(pattern=prefix,fileext=".xz")
s <- file.copy(blast.files,tf)
tf <- unlist(lapply(tf,xzuncompress))

# Computing pairwise distances
blast.distances <- bDist(tf)

# ...and cleaning...
s <- file.remove(tf)

# See also example for blastAllAll

}
\seealso{
\code{\link{blastAllAll}}, \code{\link{readBlastTable}}, \code{\link{bClust}}, 
\code{\link{isOrtholog}}.
}
\author{
Lars Snipen and Kristian Hovde Liland.
}
