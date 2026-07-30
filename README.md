# milean

This project adds facets that produce `.ilean.mmap` files corresponding to
`.ilean` files, but allowing memory-mapped load in the LSP watchdog as
implemented in [leanprover/lean4#14421](https://github.com/leanprover/lean4/pull/14421).

- `lake build @mathlib/Mathlib:ilean.mmap`: builds the `Mathlib` library
  target's `.ilean` files and produces `.ilean.mmap` for every one of them.
- `lake build +Mathlib.Data.List.Basic:ilean.mmap`: builds a single
  module's `.ilean` (if necessary) and also the module's `.ilean.mmap`.
- `lake exe compact-ilean --all`: produces `.ilean.mmap` for every previously
  existing `.ilean` on the olean search path, including the Lean distribution 
  itself.
