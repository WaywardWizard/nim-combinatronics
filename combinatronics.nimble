# Package

version       = "1.0.0"
author        = "Ben Tomlin"
description   = "Efficiently generate permutations and combinations"
license       = "MIT"

include "tasks.nims" # distribute th{is,ese} files or the nimble file breaks

# Select files to distribute here. Use * as a greedy wildcard
# This hack avoids the awful nimble selection logic
let ignoreDirs = ["nimbledeps","tests"]
let installFileSelectors = [(".",@["tasks.nims","*.md","LICENSE"]),("src",@["*.nim"])]

# Locate installation files
if srcDir != "": raise ValueError.newException "srcDir setting interferes with file selection"
proc findfiles(dir: string = ".", ipath: openArray[string] = ["*"]): seq[string] =
  var cmd = "find " & dir
  for i in ignoreDirs: cmd &= " -iname $# -prune -o " % [i]
  for pattern in ipath:
    result.add gorgeEx(cmd & "-ipath '$1/$2' -printf '%P\n'" % [dir, pattern]).output.splitlines()
installFiles = @[]
for (folder,patterns) in installFileSelectors:
  installFiles.add folder.findfiles(patterns)

# Dependencies
requires "nim >= 1.6.14"
