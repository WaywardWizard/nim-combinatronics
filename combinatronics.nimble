# Package

version       = "1.0.0"
author        = "Ben Tomlin"
description   = "Efficiently generate permutations and combinations"
license       = "MIT"
srcDir        = "src"


# Dependencies

requires "nim >= 1.6.14"

task docs, "Generate HTML documentation":
  exec("find *.md | xargs echo md2html --index:only --outdir:htmldocs")
  exec("nim doc --outdir:htmldocs --index:only --project src/*.nim")
  exec("find *.md | xargs nim md2html --index:on --outdir:htmldocs")
  exec("nim doc --outdir:htmldocs --index:on --project src/*.nim")

import std/[pegs,strbasics,strformat]
task nimversion, "Test against other nim versions":
  # set requires to the earliest version you want to test back to
  var versions: seq[string]
  var found = false
  for line in gorgeEx("choosenim --nocolor versions").output.splitLines:
    if line.match(peg"^\s*Installed\:"):
      found = true
      continue
    if found:
      for m in line.findAll(peg"\s{\d+\.\d+\.\d+}(\s/$)"):
        versions.add m.strip

  var bestVersion: string
  for v in versions:
    echo "Testing ", v
    var (output,exit) = gorgeEx &"choosenim {v}; nimble test"
    if exit==0:
      bestVersion = v
    else:
      echo "Failed ", v
      echo output
      break


  echo "Best version ", bestVersion
