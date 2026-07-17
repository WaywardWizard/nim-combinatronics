# Package
version       = "1.2.0"
author        = "Ben Tomlin"
description   = "Efficiently generate permutations and combinations"
license       = "MIT"
srcDir        = "src"

# Tasks
when fileExists "tasks.nims": # not distributed as nimble package
  include "tasks.nims"

# Dependencies
requires "nim >= 1.6.14"
