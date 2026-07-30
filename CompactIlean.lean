import Lean.Server.References
open System Lean

/--
Takes the location of an `.ilean` file, generates an `.ilean.mmap` file,
and returns the resulting path.
-/
def convert (ileanPath: FilePath) : IO FilePath := do
  let ilean := ShareCommon.shareCommon' (← Lean.Server.Ilean.load ileanPath)
  let compactedIleanPath := ileanPath.withExtension Lean.Server.Ilean.compactedExt
  let _compactor ← unsafe Lean.CompactedRegion.save compactedIleanPath (ilean.module ++ `ilean.mmap) ilean #[] .none
  return compactedIleanPath

/--
Run `convert` on every ilean in the search path, including the toolchain
-/
def convertEntireSearchPath : IO Unit := do
  initSearchPath (← findSysroot)
  let ileanPaths ← (← searchPathRef.get).findAllWithExt "ilean"

  let mut converted : Std.HashSet FilePath := {}
  for ileanPath in ileanPaths do
    if not <| converted.contains ileanPath then
      let compactedIleanPath ← convert ileanPath
      converted := converted.insert ileanPath
