#!/usr/bin/env bash
set -euo pipefail

SITE_URL="${TYPO3_URL:-http://dresdenevents-typo3.ddev.site}"
OUTPUT_DIR="${EXPORT_DIR:-/tmp/typo3-static-export}"
PAGES_REPO="${PAGES_REPO:-https://github.com/dresdenevents/dresdenevents.github.io.git}"
PAGES_SUBFOLDER="${PAGES_SUBFOLDER:-typo3-demo}"
COMMIT_MSG="${COMMIT_MSG:-chore: update TYPO3 static export}"

echo "==> Crawling $SITE_URL ..."
rm -rf "$OUTPUT_DIR"
mkdir -p "$OUTPUT_DIR"

wget \
  --mirror \
  --convert-links \
  --adjust-extension \
  --page-requisites \
  --no-parent \
  --no-verbose \
  --directory-prefix="$OUTPUT_DIR" \
  --reject="*.php,*.cgi,install.php" \
  --exclude-directories="/typo3,/typo3temp,/typo3conf" \
  "$SITE_URL" 2>&1 || true

CRAWLED_DIR="$OUTPUT_DIR/$(echo "$SITE_URL" | sed 's|https\?://||')"
if [ ! -d "$CRAWLED_DIR" ]; then
  echo "ERROR: Crawl output not found at $CRAWLED_DIR"
  exit 1
fi

echo "==> Cloning GitHub Pages repo ..."
PAGES_DIR="/tmp/dresdenevents-pages"
rm -rf "$PAGES_DIR"
git clone --depth=1 "$PAGES_REPO" "$PAGES_DIR"

echo "==> Copying static files to $PAGES_SUBFOLDER/ ..."
rm -rf "$PAGES_DIR/$PAGES_SUBFOLDER"
mkdir -p "$PAGES_DIR/$PAGES_SUBFOLDER"
cp -r "$CRAWLED_DIR/." "$PAGES_DIR/$PAGES_SUBFOLDER/"

echo "==> Committing and pushing ..."
cd "$PAGES_DIR"
git add "$PAGES_SUBFOLDER"
git diff --cached --quiet && echo "Nothing changed." && exit 0

git commit -m "$COMMIT_MSG"
git push origin main

echo "==> Done! Site published at https://dresdenevents.github.io/$PAGES_SUBFOLDER"
