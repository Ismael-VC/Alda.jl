module REPL


using Alda.Core: alda_play!
using ReplMaker: initrepl


export alda_mode


function alda_mode()
    initrepl(
        alda_play!,
        prompt_text = "alda> ",
        prompt_color = :blue,
        start_key = ",",
        mode_name = "Alda Mode"
    )
)


end  # REPL module
