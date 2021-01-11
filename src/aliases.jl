module Aliases


using Alda, Alda.Core, Alda.CLI, Alda.REPL


       # CLI
export executable,
       executable!,
       history_file,
       history_file!,
       history,
       clear_history!,
       help,
       update,
       repl,
       down,
       up,
       downup,
       list,
       status,
       version,
       stop,
       instruments,
       parse!,
       export!,
       play,
       play!,
       is_up,
       is_down,

       # REPL
       mode,

       # Core
       n


include("_aliases.jl")


end  # Aliases module
