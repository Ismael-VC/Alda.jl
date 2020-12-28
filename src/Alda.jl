"""
Julia bindings for the Alda API,

Alda is a text-based programming language for music composition.
"""
module Alda


"Path to the Alda executable."
_ALDA_EXECUTABLE = "alda"

"""
    alda_executable()

Path to the Alda executable.

# Examples

```julia-repl
julia> Alda.alda_executable()
"alda"
```
"""
alda_executable() = _ALDA_EXECUTABLE

"""
    alda_executable!(path::AbstractString)

Set the path to the Alda executable.

# Examples

```julia-repl
julia> Alda.alda_executable!("/path/to/alda")
"/path/to/alda"
```
"""
alda_executable!(path::AbstractString) = (global _ALDA_EXECUTABLE = path)

"Path to the default Alda history file used by `play!`."
_HISTORY_FILE = tempname()

"""
    history_file()

Path to the default Alda history file used by `play!`.

# Examples

```julia-repl
julia> Alda.history_file()
"/path/to/default/history/file"
```
"""
history_file() = _HISTORY_FILE

"""
    history_file!(path::AbstractString)

Set the path to the default Alda history file used by `play!`.

# Examples

```julia-repl
julia> Alda.history_file!("/path/to/new/default/history/file")
"/path/to/new/default/history/file"
```
"""
history_file!(path::AbstractString) = (global _HISTORY_FILE = path)

"""
    alda_history()

A string representing the score so far.

# Examples

```julia-repl
julia> Alda.alda_history()
"piano: c d e f g a b > c\nharmonica:\nc d e f g a b > c\n"
```
"""
function alda_history()::String
    open(_HISTORY_FILE) do file
        return read(file, String)
    end
end

"""
    clear_history!()

Clear Alda default history used by `play!` by setting a new temporary history
file and returning its path.

# Examples

```julia-repl
julia> Alda.clear_history!()
"path/to/new/default/temporal/history/file"
```
"""
clear_history!() = history_file!(tempname())

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
        ALDA_EXECUTABLE,
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
    help()

Display Alda executable help text.

# Examples

```julia-repl
julia> Alda.help()
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
help() = alda("help")

"""
    update()

Download and install the latest release of Alda.

# Examples

```julia-repl
julia> Alda.update()
Your version of alda (1.4.3) is up to date!
```
"""
update() = alda("update")

"""
    repl()

Start an interactive Alda REPL session.

# Examples

```julia-repl
julia> Alda.repl()
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
repl() = alda("repl")

"""
    up()

Start the Alda server.

# Examples

```julia-repl
julia> Alda.up()
[27713] Starting Alda server...
[27713] Server up ?
[27713] Starting worker processes...
[27713] Ready ?
```
"""
up() = alda("up")

"""
    down()

Stop the Alda server.

# Examples

```julia-repl
julia> Alda.down()
[27713] Stopping Alda server...
[27713] Server down ?
```
"""
down() = alda("down")

"""
    downup()

Restart the Alda server.

# Examples

```julia-repl
julia> Alda.downup()
[27713] Stopping Alda server...
[27713] Server down ?

[27713] Starting Alda server...
[27713] Server up ?
[27713] Starting worker processes...
[27713] Ready ?
```
"""
downup() = alda("downup")

"""
    list()

List running Alda servers/workers.

# Examples

```julia-repl
julia> Alda.list()
Sorry -- listing running processes is not currently supported for Windows users.
```
"""
list() = alda("list")

"""
    status()

Display whether the Alda server is up.

# Examples

```julia-repl
julia> Alda.status()
[27713] Server up (2/2 workers available, backend port: 50235)
```
"""
status() = alda("status")

"""
    version()

Display the version of the Alda client and server.

# Examples

```julia-repl
julia> Alda.version()
Client version: 1.4.3
Server version: [27713] 1.4.3
```
"""
version() = alda("version")

"""
    stop()

Stop playback.

# Examples

```julia-repl
julia> Alda.stop()
[27713] Stopping playback...
```
"""
stop() = alda("stop")

"""
    instruments()

Return an array of available instruments.

# Examples

```julia-repl
julia> Alda.instruments()
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
instruments() = readlines(`$(alda_executable()) instruments`)

"Display the result of parsing Alda code."
function parse()
end
"Evaluate Alda code and export the score to another format."
function export!()
end

"""
    play(
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
julia> Alda.play("piano: c d e f g a b > c")
[27713] Parsing/evaluating...
[27713] Playing...```
"""
function play(
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
    play!(
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
julia> Alda.play!("piano: c d e f g a b > c")  # C mayor scale on piano.
[27713] Parsing/evaluating...
[27713] Playing...

julia> Alda.play!("harmonica:")  # Change instrument to harmonica.
[27713] Parsing/evaluating...
[27713] Done.

julia> Alda.play!("c d e f g a b > c")  # Same scale with harmonica.
[27713] Parsing/evaluating...
[27713] Playing...
```
"""
function play!(
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


end  # module
