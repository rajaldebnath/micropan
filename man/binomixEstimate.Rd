% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/binomix.R
\name{binomixEstimate}
\alias{binomixEstimate}
\title{Binomial mixture model estimates}
\usage{
binomixEstimate(pan.matrix, K.range = 3:5, core.detect.prob = 1,
  verbose = TRUE)
}
\arguments{
\item{pan.matrix}{A \code{Panmat} object, see \code{\link{panMatrix}} for details.}

\item{K.range}{The range of model complexities to explore. The vector of integers specify the number
of binomial densities to combine in the mixture models.}

\item{core.detect.prob}{The detection probability of core genes. This should almost always be 1.0,
since a core gene is by definition always present in all genomes, but can be set fractionally smaller.}

\item{verbose}{Logical indicating if textual output should be given to monitor the progress of the
computations.}
}
\value{
\code{\link{binomixEstimate}} returns a \code{Binomix} object, which is a small (S3) extension
of a \code{list} with two components. These two components are named \samp{BIC.table} and \samp{Mix.list}.

The \samp{BIC.table} is a matrix listing, in each row, the results for each number of components used,
given by the input \samp{K.range}. The column \samp{Core.size} is the estimated number of core gene families,
the column \samp{Pan.size} is the estimated pan-genome size. The column \samp{BIC} is the Bayesian
Information Criterion (Schwarz, 1978) that should be used to choose the optimal value for \samp{K}.
The number of components where \samp{BIC} is minimized is the optimal. If minimum \samp{BIC} is reached
for the largest \samp{K} value you should extend the \samp{K.range} and re-fit. The function will issue
a \code{warning} to remind you of this.

The \samp{Mix.list} is a list with one element for each number of components tested. The content of each
\samp{Mix.list} element is a matrix describing one particular fitted binomial mixture model. A fitted model
is characterized by two vectors (rows) denoted \samp{Detect.prob} and \samp{Mixing.prop}. \samp{Detect.prob}
are the estimated detection probabilities, sorted in ascending order. The \samp{Mixing.prop} are the
corresponding mixing proportions. A mixing proportion is the proportion of the gene clusters having the
corresponding detection probability.

The generic functions \code{\link{plot.Binomix}} and \code{\link{summary.Binomix}}
are available for \code{Binomix} objects.
}
\description{
Fits binomial mixture models to the data given as a pan-matrix. From the fitted models
both estimates of pan-genome size and core-genome size are available.
}
\details{
A binomial mixture model can be used to describe the distribution of gene clusters across
genomes in a pan-genome. The idea and the details of the computations are given in Hogg et al (2007),
Snipen et al (2009) and Snipen & Ussery (2012).

Central to the concept is the idea that every gene has a detection probability, i.e. a probability of
being present in a genome. Genes who are always present in all genomes are called core genes, and these
should have a detection probability of 1.0. Other genes are only present in a subset of the genomes, and
these have smaller detection probabilities. Some genes are only present in one single genome, denoted
ORFan genes, and an unknown number of genes have yet to be observed. If the number of genomes investigated
is large these latter must have a very small detection probability. 

A binomial mixture model with \samp{K} components estimates \samp{K} detection probabilities from the
data. The more components you choose, the better you can fit the (present) data, at the cost of less
precision in the estimates due to less degrees of freedom. \code{\link{binomixEstimate}} allows you to
fit several models, and the input \samp{K.range} specifies which values of \samp{K} to try out. There no
real point using \samp{K} less than 3, and the default is \samp{K.range=3:5}. In general, the more genomes
you have the larger you can choose \samp{K} without overfitting.  Computations will be slower for larger
values of \samp{K}. In order to choose the optimal value for \samp{K}, \code{\link{binomixEstimate}}
computes the BIC-criterion, see below.

As the number of genomes grow, we tend to observe an increasing number of gene clusters. Once a
\samp{K}-component binomial mixture has been fitted, we can estimate the number of gene clusters not yet
observed, and thereby the pan-genome size. Also, as the number of genomes grows we tend to observe fewer
core genes. The fitted binomial mixture model also gives an estimate of the final number of core gene
clusters, i.e. those still left after having observed \sQuote{infinite} many genomes.

The detection probability of core genes should be 1.0, but can at times be set fractionally smaller.
This means you accept that even core genes are not always detected in every genome, e.g. they may be
there, but your gene prediction has missed them. Notice that setting the \samp{core.detect.prob} to less
than 1.0 may affect the core gene size estimate dramatically.
}
\examples{
# Loading a Panmat object in the micropan package
data(list="Mpneumoniae.blast.panmat",package="micropan")

# Estimating binomial mixture models
bino <- binomixEstimate(Mpneumoniae.blast.panmat,K.range=3:8)  # using 3,4,...,8 components
print(bino$BIC.table) # minimum BIC at 3 components

# Plotting the optimal model, and printing the summary
plot(bino)
summary(bino)

# Plotting the 8-component model as well
plot(bino,ncomp=8)  # clearly overfitted, we do not need this many sectors

# Plotting the distribution in a single genome
plot(bino,type="single")  # completely dominated by core genes

}
\references{
Hogg, J.S., Hu, F.Z, Janto, B., Boissy, R., Hayes, J., Keefe, R., Post, J.C., Ehrlich, G.D. (2007).
Characterization and modeling of the Haemophilus influenzae core- and supra-genomes based on the
complete genomic sequences of Rd and 12 clinical nontypeable strains. Genome Biology, 8:R103.

Snipen, L., Almoy, T., Ussery, D.W. (2009). Microbial comparative pan-genomics using binomial
mixture models. BMC Genomics, 10:385.

Snipen, L., Ussery, D.W. (2012). A domain sequence approach to pangenomics: Applications to
Escherichia coli. F1000 Research, 1:19.

Schwarz, G. (1978). Estimating the Dimension of a Model. The Annals of Statistics, 6(2):461-464.
}
\seealso{
\code{\link{panMatrix}}, \code{\link{chao}}, \code{\link{plot.Binomix}},
\code{\link{summary.Binomix}}.
}
\author{
Lars Snipen and Kristian Hovde Liland.
}
