#!/usr/bin/env bash
# 把站点打包到 _site/，供 GitHub Pages 发布；本地也可运行后用 `python3 -m http.server -d _site` 预览。
# index.html 按 Artifact 规范书写（没有 doctype / html / head），这里补上页面骨架与基础重置样式。
set -euo pipefail
cd "$(dirname "$0")/.."

OUT=_site
rm -rf "$OUT"
mkdir -p "$OUT"

{
  cat <<'HEAD'
<!doctype html>
<html lang="zh-CN">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">
<meta name="color-scheme" content="light dark">
<style>
  :root{padding-top:env(safe-area-inset-top,0px);padding-bottom:env(safe-area-inset-bottom,0px)}
  body{margin:0}
  img{max-width:100%}
  [hidden]{display:none!important}
</style>
HEAD
  cat index.html
  printf '\n</html>\n'
} > "$OUT/index.html"

# 内容与图片；源文件（规格书 PDF、原始表格等）不发布
rsync -a \
  --exclude '.DS_Store' \
  --exclude '*.pdf' \
  --exclude '*.xlsx' \
  content/ "$OUT/content/"

touch "$OUT/.nojekyll"
echo "Built $OUT: $(find "$OUT" -type f | wc -l | tr -d ' ') files, $(du -sh "$OUT" | cut -f1)"
