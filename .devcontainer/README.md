# Dev Container

One image with everything needed to rebuild the website and the CV:

- Ruby, Bundler and Jekyll's build dependencies (from `mcr.microsoft.com/devcontainers/jekyll`)
- TeX Live with the packages `cv/cv.tex` needs (including `fontawesome`), plus `latexmk`
- `poppler-utils` (`pdfinfo`, `pdftoppm`) to inspect the generated PDF

The image is defined in [Dockerfile](Dockerfile). The first build takes a few minutes and the image is large (about 5 GB, mostly the TeX Live font collection that provides `fontawesome`); later starts reuse the cached image.

## Using it from VS Code

1. Install [Docker Desktop](https://www.docker.com/products/docker-desktop) and the [Dev Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers).
2. Open the project and run `Dev Containers: Reopen in Container`. If you already had a container from the old configuration, run `Dev Containers: Rebuild Container` instead.
3. `bundle install` runs automatically on first launch.

Then use `Tasks: Run Task`:

| Task | What it does |
|---|---|
| Jekyll: Serve | Site on http://localhost:4000 with live reload |
| Jekyll: Serve (with drafts) | Same, also rendering `my_collections/_drafts` |
| Jekyll: Build | Output in `_site/` |
| CV: Build PDF | Compiles `cv/cv.tex` to `cv/cv.pdf` |
| CV: Build and publish to assets/pdfs/cv.pdf | Compiles, then replaces the PDF the sidebar links to |
| CV: Clean | Removes LaTeX build files |

Or from the container's terminal:

```bash
bundle exec jekyll serve --livereload --host 0.0.0.0
```

```bash
make -C cv publish
```

`_config.yml` is not reloaded by `jekyll serve`; restart the server after editing it.

## Using it without VS Code

Build the image once:

```bash
docker build -t becheler-site-dev .devcontainer
```

Rebuild and publish the CV:

```bash
docker run --rm -v "$PWD":/work -w /work becheler-site-dev make -C cv publish
```

Serve the site:

```bash
docker run --rm -it -p 4000:4000 -p 35729:35729 -v "$PWD":/work -w /work becheler-site-dev bash -lc "bundle install && bundle exec jekyll serve --livereload --host 0.0.0.0"
```

## Notes

- Inside the container, gems are installed in the container itself (`/usr/local/bundle`), not in the repo: the base image points Bundler away from the repo's `.bundle/config`. They survive as long as the dev container does; a throwaway `docker run --rm` needs `bundle install` each time, as in the command above. `vendor/bundle` is only used by a Ruby installed directly on the host.
- `cv/cv.pdf` and the LaTeX build files are gitignored. Only `cv/cv.tex` and the published `assets/pdfs/cv.pdf` are meant to be committed.
- Production is built by GitHub Pages with its own Jekyll version, not by this image. See `CLAUDE.md` for what that implies.
