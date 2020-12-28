"""
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
"""
module Alda


using JSON


export @p_str, @p!_str,
       executable, alda_executable,
       executable!, alda_executable!,
       history_file, alda_history_file,
       history_file!, alda_history_file!,
       history, alda_history,
       clear_history!, alda_clear_history!,
       alda,
       help, alda_help,
       update, alda_update,
       repl, alda_repl,
       down, alda_down,
       up, alda_up,
       downup, alda_downup,
       list, alda_list,
       status, alda_status,
       version, alda_version,
       stop, alda_stop,
       instruments, alda_instruments,
       parse!, alda_parse,
       export!, alda_export!,
       play, alda_play,
       play!, alda_play!


"Path to the Alda executable."
_ALDA_EXECUTABLE = "alda"

"""
    alda_executable()

Path to the Alda executable.

# Examples

```julia-repl
julia> alda_executable()  # or `executable()`
"alda"
```
"""
alda_executable() = _ALDA_EXECUTABLE


"""
    alda_executable!(path::AbstractString)

Set the path to the Alda executable.

# Examples

```julia-repl
julia> alda_executable!("/path/to/alda")  # or `executable!("/path/to/alda")`
"/path/to/alda"
```
"""
alda_executable!(path::AbstractString) = (global _ALDA_EXECUTABLE = path)


"Path to the default Alda history file used by `play!`."
_HISTORY_FILE = tempname()

"""
    alda_history_file()

Path to the default Alda history file used by `play!`.

# Examples

```julia-repl
julia> alda_history_file()  # or `history_file()`
"/path/to/default/temporary/history/file"
```
"""
alda_history_file() = _HISTORY_FILE


"""
    alda_history_file!(path::AbstractString)

Set the path to the default Alda history file used by `play!`.

# Examples

```julia-repl
julia> alda_history_file!("/new/history/file")  # or `history_file!("/new/history/file")`
"/new/history/file"
```
"""
alda_history_file!(path::AbstractString) = (global _HISTORY_FILE = path)


"""
    alda_history()

A string representing the score so far.

# Examples

```julia-repl
julia> alda_history()  # or `history()`
"piano: c d e f g a b > c\nharmonica:\nc d e f g a b > c\n"
```
"""
function alda_history()::String
    if isfile(history_file())
        open(alda_history_file()) do file
            return read(file, String)
        end
    else
        return ""
    end
end


"""
    alda_clear_history!()

Clear Alda default history used by `play!` by setting a new temporary history
file and returning its path.

# Examples

```julia-repl
julia> alda_clear_history!()  # or `clear_history!()`
"path/to/new/default/temporal/history/file"
```
"""
alda_clear_history!() = history_file!(tempname())


"""
    alda(
        commands::AbstractString...;
        host::AbstractString = "localhost",
        port::Integer = 27713,
        timeout::Integer = 30,
        workers::Integer = 2,
        quiet::Bool = false,
        no_color::Bool = false,
        verbose::Bool = false
    )

Wrapper to the Alda executable.

# Positional arguments

* `args::AbstractString...`: String commands passed to Alda.

# Keyword arguments

* `host::AbstractString = "localhost"`: The hostname of the Alda server.
* `no_color::Bool = false`: Disable color output.
* `port::Integer = 27713`: The port of the alda server/worker.
* `quiet::Bool = false`: Disable non-error messages.
* `timeout::Integer = 30`: The number of seconds to wait for a server to start
                           up or shut down, before giving up.
* `verbose::Bool = false`: Enable verbose output.
* `workers::Integer = 2`: The number of worker processes to start.

# Examples

```julia-repl
julia> alda("play", "-c", "piano: c d e f g a b > c")
[27713] Parsing/evaluating...
[27713] Playing...
```
"""
function alda(
        commands::AbstractString...;
        host::AbstractString = "localhost",
        port::Integer = 27713,
        timeout::Integer = 30,
        workers::Integer = 2,
        quiet::Bool = false,
        no_color::Bool = false,
        verbose::Bool = false
    )

    cmd = [
        alda_executable(),
        "--host", host,
        "--port", port,
        "--timeout", timeout,
        "--workers", workers
    ]

    if quiet
        push!(cmd,"--quiet")
    elseif verbose
        push!(cmd,"--verbose")
    end

    no_color && push!(cmd, "--no-color")

    cmd = `$cmd $commands`
    run(cmd)

    return nothing
end


"""
    alda_help()

Display Alda executable help text.

# Examples

```julia-repl
julia> alda_help()  # or `help()`
Usage: alda [options] [command] [command options]
  Options:
    -h, --help
       Print this help text
       Default: false
    -H, --host
       The hostname of the Alda server
       Default: localhost
    --no-color
       Disable color output.
       Default: false
    -p, --port
       The port of the Alda server/worker
       Default: 27713
    -q, --quiet
       Disable non-error messages
       Default: false
    -t, --timeout
       The number of seconds to wait for a server to start up or shut down,
       before giving up.
       Default: 30
    -v, --verbose
       Enable verbose output
       Default: false
    -w, --workers
       The number of worker processes to start
       Default: 2
  Commands:
    help      Display this help text
      Usage: help [options]

    update      Download and install the latest release of Alda
      Usage: update [options]

    repl      Start an interactive Alda REPL session.
      Usage: repl [options]

    up(start-server,init)      Start the Alda server
      Usage: up(start-server,init) [options]

    down(stop-server)      Stop the Alda server
      Usage: down(stop-server) [options]

    downup(restart-server)      Restart the Alda server
      Usage: downup(restart-server) [options]

    list      List running Alda servers/workers
      Usage: list [options]

    status      Display whether the server is up
      Usage: status [options]

    version      Display the version of the Alda client and server
      Usage: version [options]

    play      Evaluate and play Alda code
      Usage: play [options]
        Options:
          -c, --code
             Supply Alda code as a string
          -f, --file
             Read Alda code from a file
          -F, --from
             A time marking or marker from which to start playback
          -i, --history
             Alda code that can be referenced but will not be played
             Default: <empty string>
          -I, --history-file
             A file containing Alda code that can be referenced but will not be
             played
          -T, --to
             A time marking or marker at which to end playback

    stop(stop-playback)      Stop playback
      Usage: stop(stop-playback) [options]

    parse      Display the result of parsing Alda code
      Usage: parse [options]
        Options:
          -c, --code
             Supply Alda code as a string
          -f, --file
             Read Alda code from a file
          -o, --output
             Return the output as "data" or "events"
             Default: data

    instruments      Display a list of available instruments
      Usage: instruments [options]

    export      Evaluate Alda code and export the score to another format
      Usage: export [options]
        Options:
          -c, --code
             Supply Alda code as a string
          -f, --file
             Read Alda code from a file
          -o, --output
             The output filename
          -F, --output-format
             The output format (options: midi)
```
"""
alda_help() = alda("help")


"""
    alda_update()

Download and install the latest release of Alda.

# Examples

```julia-repl
julia> alda_update()  # or `update()`
Your version of alda (1.4.3) is up to date!
```
"""
alda_update() = alda("update")


"""
    alda_repl()

Start an interactive Alda REPL session.

# Examples

```julia-repl
julia> alda_repl()  # or `repl()`
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

julia>
```
"""
alda_repl() = alda("repl")


"""
    alda_up()

Start the Alda server.

# Examples

```julia-repl
julia> alda_up()  # or `up()`
[27713] Starting Alda server...
[27713] Server up ?
[27713] Starting worker processes...
[27713] Ready ?
```
"""
alda_up() = alda("up")


"""
    alda_down()

Stop the Alda server.

# Examples

```julia-repl
julia> alda_down()  # or `down()`
[27713] Stopping Alda server...
[27713] Server down ?
```
"""
alda_down() = alda("down")


"""
    alda_downup()

Restart the Alda server.

# Examples

```julia-repl
julia> alda_downup()  # or `downup()`
[27713] Stopping Alda server...
[27713] Server down ?

[27713] Starting Alda server...
[27713] Server up ?
[27713] Starting worker processes...
[27713] Ready ?
```
"""
alda_downup() = alda("downup")


"""
    alda_list()

List running Alda servers/workers.

# Examples

```julia-repl
julia> alda_list()  # or `list()`
Sorry -- listing running processes is not currently supported for Windows users.
```
"""
alda_list() = alda("list")


"""
    alda_status()

Display whether the Alda server is up.

# Examples

```julia-repl
julia> alda_status()  # or `status()`
[27713] Server up (2/2 workers available, backend port: 50235)
```
"""
alda_status() = alda("status")


"""
    alda_version()

Display the version of the Alda client and server.

# Examples

```julia-repl
julia> alda_version()  # or `version()`
Client version: 1.4.3
Server version: [27713] 1.4.3
```
"""
alda_version() = alda("version")


"""
    alda_stop()

Stop playback.

# Examples

```julia-repl
julia> alda_stop()  # or `stop()`
[27713] Stopping playback...
```
"""
alda_stop() = alda("stop")


"""
    alda_instruments()

Return an array of available instruments.

# Examples

```julia-repl
julia> alda_instruments()  # or `instruments()`
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
```
"""
alda_instruments() = readlines(`$(alda_executable()) instruments`)


"""
    alda_parse(
        code::AbstractString;
        file::AbstractString = "",
        output::AbstractString = "data"
    )

Display the result of parsing Alda code.

# Positional arguments

* `code::AbstractString`: String of Alda code.

# Keyword arguments

* `file::Bool = false`: `true` if `code` should be interpreted as the path to
                        read Alda code from a file.
* `output::AbstractString="data"`: Return the output as "data" or "events".

# Examples

```julia-repl
julia> alda_parse("piano: c d e f g a b > c")  # or `parse!("piano: c d e f g a b > c")`
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
```
"""
function alda_parse(
        code::AbstractString;
        file::Bool = false,
        output::AbstractString = "data"
    )

    cmd = []

    foreach(x -> push!(cmd, x), ["--output", output])

    foreach(
        x -> push!(cmd, x),
        file ? ["--file", code] : ["--code", "\"$code\""]
    )

    output_flag, output, code_flag, code = cmd

    return JSON.parse(read(
        `$(alda_executable()) parse $output_flag $output $code_flag $code`,
        String
    ))
end


"""
    alda_export(
        code::AbstractString,
        output::AbstractString;
        file::AbstractString = "",
        output_format::AbstractString = "midi"
    )

Evaluate Alda code and export the score to another format.

# Positional arguments

* `code::AbstractString`: String of Alda code.
* `output::AbstractString`: The output filename.

# Keyword arguments

* `file::Bool = false`: `true` if `code` should be interpreted as the path to
                        read Alda code from a file.
* `output_format::AbstractString = "midi"`: The output format (midi).

# Examples
```julia-repl
julia> alda_export("piano: c d e f g a b > c", output = "out.midi") or `export!(...)`
[27713] Parsing/evaluating...
[27713] Done.
```
"""
function alda_export(
        code::AbstractString,
        output::AbstractString;
        file::Bool = false,
        output_format::AbstractString = "midi"
    )

    cmd = []

    foreach(x -> push!(cmd, x), ["--output", output])
    foreach(x -> push!(cmd, x), ["--output-format", output_format])

    foreach(
        x -> push!(cmd, x),
        file ? ["--file", code] : ["--code", "\"$code\""]
    )

    output_flag, output, format_flag, format, code_flag, code = cmd

    run(
        ```
        $(alda_executable())
        export
        $output_flag $output
        $format_flag $format
        $code_flag $code
        ```
    )

    return nothing
end


"""
    alda_play(
        code::AbstractString;
        file::Bool = false,
        from::AbstractString = "",
        to::AbstractString = "",
        history::AbstractString = "",
        history_file::AbstractString = ""
    )

Evaluate and play Alda code.

# Positional arguments

* `code::AbstractString`: String of Alda code.

# Keyword arguments

* `file::Bool = false`: `true` if `code` should be interpreted as the path to
                        read Alda code from a file.
* `from::AbstractString = ""`: A time marking or marker from which to start
                               playback.
* `to::AbstractString = ""`: A time marking or marker at which to end playback.
* `history::AbstractString = ""`:  Alda code that can be referenced but will
                                   not be played.
* `history_file::AbstractString = ""`: A file containing Alda code that can be
                                       referenced but will not be played.

# Examples

```julia-repl
julia> alda_play("piano: c d e f g a b > c")  # or `play(...)`
[27713] Parsing/evaluating...
[27713] Playing...
```
"""
function alda_play(
        code::AbstractString;
        file::Bool = false,
        from::AbstractString = "",
        to::AbstractString = "",
        history::AbstractString = "",
        history_file::AbstractString = ""
    )

    cmd = ["play"]

    !isempty(from) && foreach(x -> push!(cmd, x), ["--from", from])
    !isempty(to) && foreach(x -> push!(cmd, x), ["--to", to])

    if !isempty(history)
        foreach(x -> push!(cmd, x), ["--history", history])
    elseif !isempty(history_file)
        foreach(x -> push!(cmd, x), ["--history-file", history_file])
    end

    foreach(
        x -> push!(cmd, x),
        file ? ["--file", code] : ["--code", "\"$code\""]
    )

    alda(cmd...)

    return nothing
end


"""
    alda_play!(
        code::AbstractString;
        from::AbstractString = "",
        to::AbstractString = "",
        history_file::AbstractString = ""
    )

Evaluate, play and save (if successful) Alda code to the default history
if no `history_file` is specified.

# Positional arguments

* `code::AbstractString`: String of Alda code.

# Keyword arguments

* `from::AbstractString = ""`: A time marking or marker from which to start
                               playback.
* `to::AbstractString = ""`: A time marking or marker at which to end playback.
* `history_file::AbstractString = ""`: A file containing Alda code that can be
                                       referenced but will not be played.

# Examples

```julia-repl
julia> alda_play!("piano: c d e f g a b > c")  # C mayor scale on piano.
[27713] Parsing/evaluating...
[27713] Playing...

julia> play!("harmonica:")  # Change instrument to harmonica.
[27713] Parsing/evaluating...
[27713] Done.

julia> play!("c d e f g a b > c")  # Same scale with harmonica.
[27713] Parsing/evaluating...
[27713] Playing...
```
"""
function alda_play!(
        code::AbstractString;
        from::AbstractString = "",
        to::AbstractString = "",
        history_file::AbstractString = ""
    )

    cmd = ["play"]

    foreach(
        x -> push!(cmd, x),
        [
            "--history-file",
            !isempty(history_file) ?
                      history_file :
                      _HISTORY_FILE
        ]
    )

    !isempty(from) && foreach(x -> push!(cmd, x), ["--from", from])
    !isempty(to) && foreach(x -> push!(cmd, x), ["--to", to])

    foreach(x -> push!(cmd, x), ["--code", code])

    open(
            !isempty(history_file) ? history_file : _HISTORY_FILE,
            append = true
        ) do file
        try
            alda(cmd...)
            write(file, code * "\n")
        catch
        end
    end

    return nothing
end


"""
    @p_str(code)

Alda `play` (with defaults) non standard string macro literal.

# Examples

```julia-repl
julia> p"piano: c d e f g a b > c"
[27713] Parsing/evaluating...
[27713] Playing...
```
"""
macro p_str(code)
    play(code)
end


"""
    @p!_str(code)

Alda `play!` (with defaults) non standard string macro literal.

History can still be specified by setting:

* `alda_history!("path/to/new/default/history_file")`

# Examples

```julia-repl
julia> p!"piano: c d e f g a b > c"
[27713] Parsing/evaluating...
[27713] Playing...

julia> p!"harmonica:"
[27713] Parsing/evaluating...
[27713] Done.

julia> p!"c d e f g a b > c"
[27713] Parsing/evaluating...
[27713] Playing...
```
"""
macro p!_str(code)
    play!(code)
end


const executable = alda_executable
const executable! = alda_executable!
const history_file = alda_history_file
const history_file! = alda_history_file!
const history = alda_history
const clear_history! = alda_clear_history!
const help = alda_help
const update = alda_update
const repl = alda_repl
const down = alda_down
const up = alda_up
const downup = alda_downup
const list = alda_list
const status = alda_status
const version = alda_version
const stop = alda_stop
const instruments = alda_instruments
const parse! = alda_parse
const export! = alda_export
const play = alda_play
const play! = alda_play!


end  # module
