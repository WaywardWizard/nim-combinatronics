# Package

version       = "1.0.0"
author        = "Ben Tomlin"
description   = "Efficiently generate permutations and combinations"
license       = "MIT"
srcDir        = "src"


# Dependencies

requires "nim >= 2.2.6"

task docs, "Generate HTML documentation":
  exec("find *.md | xargs echo md2html --index:only --outdir:htmldocs")
  exec("nim doc --outdir:htmldocs --index:only --project src/*.nim")
  exec("find *.md | xargs nim md2html --index:on --outdir:htmldocs")
  exec("nim doc --outdir:htmldocs --index:on --project src/*.nim")
