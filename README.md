# Alda.jl

Julia bindings for the Alda API,

Alda is a text-based programming language for music composition.

## Installation

```julia
julia> using Pkg  # Install the first time, make sure to have alda in your PATH.

julia> Pkg.add("https://github.com/SalchiPapa/Alda.jl")
 ⋮
```

## Updating

```julia
julia> using Pkg

julia> Pkg.update("Alda")
 ⋮
```

## Usage

The package module has to be loaded first.

```julia
julia> using Alda  # The first time it will compile.

julia> using Alda: alda, alda_play

julia> const a = Alda  # Alias the module (starting from Julia v1.6 will be: `using Alda as a`)
Alda
```

CLI wrapper functionality:

```julia
julia> executable()  # or alda_executable, Alda.executable
"alda"

julia> executable!("/path/to/alda")  # or alda_executable!, Alda.executable!
"/path/to/alda"

julia> alda_executable()
"/path/to/alda"

julia> alda_executable!("alda")
"alda"

julia> history_file()  # or alda_history_file, Alda.history_file
"/path/to/default/temporary/history/file"

julia> history_file!("/path/to/new/default/history/file")  # or alda_history_file, Alda.history_file
"/path/to/new/default/history/file"

julia> history()  # or alda_history, Alda.history
"piano: c d e f g a b > c\nharmonica:\nc d e f g a b > c\n"

julia> clear_history!()  # or alda_clear_history, Alda.clear_history
"path/to/new/default/temporal/history/file"

julia> alda("play", "-c", "piano: c d e f g a b > c")
[27713] Parsing/evaluating...
[27713] Playing...

julia> help()  # or alda_help, Alda.help
Usage: alda [options] [command] [command options]
  Options:
    -h, --help
       Print this help text
       Default: false
    -H, --host
 ⋮

julia> update()  # or alda_update, Alda.update
Your version of alda (1.4.3) is up to date!

julia> repl()  # or alda_repl, Alda.repl
 ?????? ???     ???????  ??????
???????????     ????????????????
???????????     ???  ???????????
???????????     ???  ???????????
???  ??????????????????????  ???
???  ?????????????????? ???  ???

             1.4.3
         repl session

Type :help for a list of available commands.

> piano: c d e f g a b > c
p> harmonica:
h> c d e f g a b > c
h>
You have unsaved changes. Are you sure you want to quit?
(y)es, (n)o

julia> down()  # or alda_down, Alda.down
[27713] Stopping Alda server...
[27713] Server down ?

julia> up()  # or alda_up, Alda.up
[27713] Starting Alda server...
[27713] Server up ?
[27713] Starting worker processes...
[27713] Ready ?

julia> downup()  # or alda_downup, Alda.downup
[27713] Stopping Alda server...
[27713] Server down ?

[27713] Starting Alda server...
[27713] Server up ?
[27713] Starting worker processes...
[27713] Ready ?

julia> list()  # or alda_list, Alda.list
Sorry -- listing running processes is not currently supported for Windows users.

julia> status()  # or alda_status, Alda.status
[27713] Server up (2/2 workers available, backend port: 50235)

julia> version()  # or alda_version, Alda.version
Client version: 1.4.3
Server version: [27713] 1.4.3

julia> stop()  # or alda_stop, Alda.stop()
[27713] Stopping playback...

julia> instruments()  # or alda_instruments, Alda.instruments
129-element Array{String,1}:
 "midi-acoustic-grand-piano"
 "midi-bright-acoustic-piano"
 "midi-electric-grand-piano"
 "midi-honky-tonk-piano"
 "midi-electric-piano-1"
 ⋮
 "midi-telephone-ring"
 "midi-helicopter"
 "midi-applause"
 "midi-gunshot"
 "midi-percussion"

julia> parse!("piano: c d e f g a b > c")  # or alda_parse, Alda.parse!
Dict{String,Any} with 11 entries:
  "current-instruments" => Any["piano-qSHe5"]
  "chord-mode"          => false
  "instruments"         => Dict{String,Any}("piano-qSHe5"=>Dict{String,Any}("...
  "tempo/values"        => Dict{String,Any}("0"=>120)
  "events"              => Any[Dict{String,Any}("duration"=>450.0,"volume"=>1...
  "markers"             => Dict{String,Any}("start"=>0)
  "beats-tally-default" => nothing
  "global-attributes"   => Dict{String,Any}()
  "beats-tally"         => nothing
  "cram-level"          => 0
  "nicknames"           => Dict{String,Any}()

julia> export!("piano: c d e f g a b > c", output = "out.midi")  # or alda_export, Alda.export!
[27713] Parsing/evaluating...
[27713] Done.

julia> Alda.play("piano: c d e f g a b > c")  # or alda_play, Alda.play
[27713] Parsing/evaluating...
[27713] Playing...

julia> play!("piano: c d e f g a b > c")  # Using default history file (or alda_play!, Alda.play!)
[27713] Parsing/evaluating...
[27713] Playing...

julia> play!("harmonica:")  # Change instrument to harmonica.
[27713] Parsing/evaluating...
[27713] Done.

julia> play!("c d e f g a b > c")  # Same scale with harmonica.
[27713] Parsing/evaluating...
[27713] Playing...

julia> p"piano: c d e f g a b > c"  # alda_play string  macro
[27713] Parsing/evaluating...
[27713] Playing...

julia> p!"piano: c d e f g a b > c"    # alda_play! string macro
[27713] Parsing/evaluating...
[27713] Playing...

julia> p!"harmonica:"
[27713] Parsing/evaluating...
[27713] Done.

julia> p!"c d e f g a b > c"
[27713] Parsing/evaluating...
[27713] Playing...
```
