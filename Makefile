.PHONY: vignettes

vignettes:
	Rscript -e 'library("devtools"); build_vignettes()'

readme:
	Rscript -e 'library("rmarkdown"); render("README.Rmd")'
