.PHONY: vignettes

vignettes:
	R --no-save --slave -e 'library("devtools"); load_all(); build_vignettes()'

readme:
	R --no-save --slave -e 'library("rmarkdown"); render("README.Rmd")'

site:
	R --no-save --slave -e 'load_all(); if (!"pkgdown" %in% rownames(installed.packages())) install_github("hadley/pkgdown"); pkgdown::build_site()'

document:
	R --no-save --slave -e 'load_all(); document()'

install:
	R --no-save --slave -e 'devtools::install()'

test:
	R --no-save --slave -e 'devtools::test()'
