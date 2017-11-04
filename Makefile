.PHONY: vignettes

vignettes:
	Rscript -e 'library("devtools"); load_all(); build_vignettes()'

readme:
	Rscript -e 'library("rmarkdown"); render("README.Rmd")'

site:
	Rscript -e 'load_all(); if (!"pkgdown" %in% rownames(installed.packages())) install_github("hadley/pkgdown"); pkgdown::build_site()'

document:
	Rscript -e 'load_all(); document()'
