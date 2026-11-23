# Dev image for becheler.github.io: Jekyll site + LaTeX CV.
#
# Base image ships Ruby (3.4 at the time of writing), Bundler and Jekyll's native
# build dependencies. Gems are installed by `bundle install` (postCreateCommand)
# into the container's /usr/local/bundle, not into the repo.
# Pinned by digest (multi-arch index: amd64 + arm64) so the environment does not
# change silently. To update: run
#   docker buildx imagetools inspect mcr.microsoft.com/devcontainers/jekyll:2-bookworm
# and paste the new top-level Digest here, then regenerate Gemfile.lock.
FROM mcr.microsoft.com/devcontainers/jekyll:2-bookworm@sha256:eafdb79372a9ee8bf87c15d99c465d3839f172836856a147e0ab00942d665577

# LaTeX for cv/cv.tex.
#   texlive-latex-recommended : setspace, hyperref, geometry
#   texlive-fonts-extra       : fontawesome (large, but the only packaged source of it)
#   latexmk                   : reruns pdflatex as needed
#   poppler-utils             : pdfinfo / pdftoppm to inspect the result
RUN apt-get update \
 && export DEBIAN_FRONTEND=noninteractive \
 && apt-get install -y --no-install-recommends \
      texlive-latex-base \
      texlive-latex-recommended \
      texlive-fonts-recommended \
      texlive-fonts-extra \
      latexmk \
      poppler-utils \
      make \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*
