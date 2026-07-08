# japiirainen.xyz

A tiny static site built with Pandoc, Make, Nix, and KaTeX.

## Development

Enter the dev shell with direnv:

```sh
direnv allow
```

Or without direnv:

```sh
nix develop
```

Build the site:

```sh
make
```

Serve it locally:

```sh
make serve
```

Start a live-reloading development server:

```sh
make dev
```

Clean generated files:

```sh
make clean
```

## Writing

Normal pages live in `content/` and become flat HTML files in `public/`.

Posts live in `content/posts/` and also become flat HTML files in `public/`.

The homepage post list is maintained manually in `content/index.md`.

List posts newest first by creation date. Use the post's front-matter `date`
as the creation date; do not rely on filesystem creation times, since Git does
not preserve them reliably.

## Deployment

GitHub Actions builds the site with Nix and publishes `public/` to GitHub Pages
on every push to `main`.
