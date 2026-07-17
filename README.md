# milean

This project adds facets that produce `.ilean.mmap` files corresponding to
`.ilean` files, but allowing memory-mapped load in the LSP watchdog as
implemented in [leanprover/lean4#14421](https://github.com/leanprover/lean4/pull/14421).

- `lake build :ilean.mmap`: produces `.ilean.mmap` for every previously
  existing `.ilean` on the olean search path, including the Lean distribution 
  itself.
- `lake build @mathlib/Mathlib:ilean.mmap`: builds `Mathlib` package's `.ilean` files
  and produces `.ilean.mmap` for every one of them.
- `lake build +Mathlib.Data.List.Basic:ilean.mmap`: builds a single
  module's `.ilean` (if necessary) and also the module's `.ilean.mmap`.

Note: as of July 2026, if you include this project in your lakefile and don't
remove it after creating mileans, you will likely trigger
[leanprover/lean4#3826](https://github.com/leanprover/lean4/issues/3826)
(unless every dependency also has the same lakefile imports as this one),
which means each `lake` process will have a higher startup cost AND possibly
use an extra gig(!) of memory. You probably want to delete the `milean`
dependency from the lakefile after generating the `.ilean.mmap` files. (TODO:
move the generation of actual `.mmap.ilean` files into a separate executable
and avoid this issue altogether.)
