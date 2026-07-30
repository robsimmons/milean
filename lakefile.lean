import Lake
open System Lake DSL
package CompactIlean where version := v!"0.1.0"

lean_lib CompactIlean

@[default_target]
lean_exe «compact-ilean» where
  root := `Main

module_facet ilean.mmap mod : FilePath := do
  let exeJob ← «compact-ilean».fetch
  let ileanJob ← mod.ilean.fetch
  exeJob.bindM fun exe =>
    ileanJob.mapM fun ilean => do
      addLeanTrace
      let compactIleanPath := ilean.addExtension "mmap"
      buildFileUnlessUpToDate' compactIleanPath <|
        proc {
          cmd := exe.toString
          args := #[ilean.toString]
          env := ← getAugmentedEnv
        }
      return compactIleanPath

library_facet ilean.mmap lib : Array FilePath := do
  let mods ← (← lib.modules.fetch).await
  return Job.collectArray (← mods.mapM (fetch <| ·.facet `ilean.mmap))
