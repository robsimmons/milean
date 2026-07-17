import Lake
import Lean.Server.References

open System Lake DSL

package milean where version := v!"0.1.0"
lean_lib Milean

def createMilean (ileanPath: FilePath) : JobM FilePath := do
  let ilean ← Lean.Server.Ilean.load ileanPath
  let ileanHashPath := ileanPath.addExtension "hash"
  let optHash : Option Hash ← Hash.load? ileanHashPath
  let milean : Lean.Server.Milean := ⟨ilean, optHash.map (·.val)⟩
  let mileanPath := ileanPath.withExtension Lean.Server.Milean.ext
  let _compactor ← unsafe Lean.CompactedRegion.save mileanPath (ilean.module ++ `milean) milean #[] .none
  logVerbose s!"wrote {mileanPath}"
  pure mileanPath

module_facet ilean.mmap mod : System.FilePath := do
  (← mod.ilean.fetch).mapM createMilean

library_facet ilean.mmap lib : Array FilePath := do
  let mods ← (← lib.modules.fetch).await
  return Job.collectArray (← mods.mapM (fetch <| ·.facet `ilean.mmap))

package_facet ilean.mmap _pkg : Array FilePath := do
  let ileanFiles ← Lean.SearchPath.findAllWithExt (← getWorkspace).augmentedLeanPath  "ilean"
  return Job.collectArray (← ileanFiles.mapM (Job.async <| createMilean ·))
