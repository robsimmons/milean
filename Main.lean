import CompactIlean
open System

def main (args : List String) : IO Unit := do
  match args with
  | ["--all"] => convertEntireSearchPath
  | [target] => IO.println (← convert target)
  | _ => throw <| .userError "Exactly one argument required"
