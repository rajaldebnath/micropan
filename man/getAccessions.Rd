% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/entrez.R
\name{getAccessions}
\alias{getAccessions}
\title{Collecting contig accession numbers}
\usage{
getAccessions(master.record.accession)
}
\arguments{
\item{master.record.accession}{The accession number (single text) to a master record GenBank file having
the WGS entry specifying the accession numbers to all contigs of the WGS genome.}
}
\value{
A character vector where each element is a text listing the accession numbers separated by commas.
Each vector element will contain no more than 500 accession numbers, see \code{\link{entrezDownload}}
for details on this. The vector returned by \code{\link{getAccessions}} is typically used as input to
\code{\link{entrezDownload}}.
}
\description{
Retrieving the accession numbers for all contigs from a master record GenBank file.
}
\details{
In order to download a WGS genome (draft genome) using \code{\link{entrezDownload}} you will
need the accession number of every contig. This is found in the master record GenBank file, which is
available for every WGS genome. \code{\link{getAccessions}} will extract these from the GenBank file and
return them in the apropriate way to be used by \code{\link{entrezDownload}}.
}
\examples{
# The master record accession for the WGS genome Mycoplasma genitalium, strain G37
acc <- getAccessions("AAGX00000000")
# Then we use this to download all contigs and save them
tf <- tempfile(fileext=".fasta")
txt <- entrezDownload(acc,out.file=tf)

# Reading the file to inspect it
genome <- readFasta(tf)
summary(genome)

# ...cleaning...
s <- file.remove(tf)

}
\seealso{
\code{\link{entrezDownload}}.
}
\author{
Lars Snipen and Kristian Liland.
}
