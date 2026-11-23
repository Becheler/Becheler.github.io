# Build the CV. Run from the repository root with `make -C cv <target>`,
# or from this folder with `make <target>`.
#
#   make           build cv/cv.pdf
#   make publish   build, then copy it to assets/pdfs/cv.pdf (what the site links to)
#   make clean     remove LaTeX build files

PUBLISHED := ../assets/pdfs/cv.pdf

.PHONY: pdf publish clean

pdf:
	latexmk -pdf -interaction=nonstopmode -halt-on-error cv.tex

publish: pdf
	cp cv.pdf $(PUBLISHED)
	@echo "Updated $(PUBLISHED)"

clean:
	latexmk -C cv.tex
