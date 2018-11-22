module C = Configurator.V1

let flags_for_dir lib_dir =
  [ Printf.sprintf "-Wl,-R%s" lib_dir
  ; Printf.sprintf "-L%s" lib_dir
  ]

let () =
  let tensorflow_flags =
    match Sys.getenv_opt "LIBTENSORFLOW" with
    | Some lib_dir -> flags_for_dir lib_dir
    | None ->
      match Sys.getenv_opt "OPAM_SWITCH_PREFIX" with
      | None -> []
      | Some prefix ->
        let lib_dir = Filename.concat (Filename.concat prefix "lib") "tensorflow" in
        if Sys.file_exists (Filename.concat lib_dir "libtensorflow.so")
        then flags_for_dir lib_dir
        else []
  in
  C.main ~name:"tensorflow-config" (fun _c ->
      C.Flags.write_sexp "c_library_flags.sexp" tensorflow_flags)
