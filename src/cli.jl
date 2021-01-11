module CLI


using JSON


export @p_str,
       @p!_str,
       alda_executable,
       alda_executable!,
       alda_history_file,
       alda_history_file!,
       alda_history,
       alda_clear_history!,
       alda,
       alda_help,
       alda_update,
       alda_repl,
       alda_down,
       alda_up,
       alda_downup,
       alda_list,
       alda_status,
       alda_version,
       alda_stop,
       alda_instruments,
       alda_parse,
       alda_export,
       alda_play,
       alda_play!,
       alda_is_up,
       alda_is_down,
       note


"Path to the Alda executable."
_ALDA_EXECUTABLE = "alda"

"""
    alda_executable()::String

The path to the `alda` executable.

The default value is `"alda"`, which will depend on your system `PATH`.

# Examples

```julia-repl
julia> alda_executable()  # or `executable()`
"alda"
```
"""
alda_executable()::String = _ALDA_EXECUTABLE


"""
    alda_executable!(path::AbstractString)::String

Set the path to the Alda executable.

# Examples

```julia-repl
julia> alda_executable!("/path/to/alda")  # or `executable!("/path/to/alda")`
"/path/to/alda"
```
"""
alda_executable!(path::AbstractString)::String = (global _ALDA_EXECUTABLE = string(path))


"Path to the default Alda history file used by `play!`."
_HISTORY_FILE = tempname()

"""
    alda_history_file()::String

Path to the default Alda history file used by `play!`.

# Examples

```julia-repl
julia> alda_history_file()  # or `history_file()`
"/path/to/default/temporary/history/file"
```
"""
alda_history_file()::String = _HISTORY_FILE


"""
    alda_history_file!(path::AbstractString)::String

Set the path to the default Alda history file used by `play!`.

# Examples

```julia-repl
julia> alda_history_file!("/new/history/file")  # or `history_file!("/new/history/file")`
"/new/history/file"
```
"""
alda_history_file!(path::AbstractString)::String = (global _HISTORY_FILE = string(path))


"""
    alda_history()::String

A string representing the score so far. This is used as the value of the
`--history` option for the `alda play` command when calling `alda_play!`.

This provides Alda with context about the score, including which instrument is
active, its current octave, current default note length, etc.

Each time `alda_play!` is successful, the string of code that was played is
appended to the Alda history.

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
    alda_clear_history!()::String

Clear Alda default history used by `play!` by setting a new temporary history
file and returning its path.

# Examples

```julia-repl
julia> alda_clear_history!()  # or `clear_history!()`
"path/to/new/default/temporal/history/file"
```
"""
alda_clear_history!()::String = history_file!(tempname())


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
    )::Int

Wrapper to the Alda executable.

Invokes `alda` at the command line, using `commands` as arguments.

The return value is the exit code of the `alda` process.

If the exit code is non-zero, an ex-info is thrown, including context about the
 result and what command was run.

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
0

julia> alda("foo")
Expected a command, got foo

For usage instructions, see --help.
cmd = `alda --host localhost --port 27713 --timeout 30 --workers 2 foo`
3
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
    )::Int

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

    exitcode = begin
        try
            run(cmd).exitcode
        catch e
            cmd = e.procs[1].cmd
            @show cmd
            e.procs[1].exitcode
        end
    end

    return exitcode
end


"""
    alda_help()::Int

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
0
```
"""
alda_help()::Int = alda("help")


"""
    alda_update()::Int

Download and install the latest release of Alda.

# Examples

```julia-repl
julia> alda_update()  # or `update()`
Your version of alda (1.4.3) is up to date!
0
```
"""
alda_update()::Int = alda("update")


"""
    alda_repl()::Int

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
0

julia>
```
"""
alda_repl()::Int = alda("repl")


"""
    alda_up()::Int

Start the Alda server.

# Examples

```julia-repl
julia> alda_up()  # or `up()`
[27713] Starting Alda server...
[27713] Server up ?
[27713] Starting worker processes...
[27713] Ready ?
0
```
"""
alda_up()::Int = alda("up")


"""
    alda_down()::Int

Stop the Alda server.

# Examples

```julia-repl
julia> alda_down()  # or `down()`
[27713] Stopping Alda server...
[27713] Server down ?
0
```
"""
alda_down()::Int = alda("down")


"""
    alda_is_up()::Bool

Whether the alda server is down.

# Examples

```julia-repl
julia> alda_is_up()  # or `is_up()`
true
```
"""
alda_is_up()::Bool = occursin("up", read(`$(alda_executable()) status`, String))

"""
    alda_is_down()::Bool

Whether the alda server is down.

# Examples

```julia-repl
julia> alda_is_down()  # or `is_down()`
false
```
"""
alda_is_down()::Bool = occursin("down", read(`$(alda_executable()) status`, String))


"""
    alda_downup()::Int

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
0
```
"""
alda_downup()::Int = alda("downup")


"""
    alda_list()::Int

List running Alda servers/workers.

# Examples

```julia-repl
julia> alda_list()  # or `list()`
Sorry -- listing running processes is not currently supported for Windows users.
0
```
"""
alda_list()::Int = alda("list")


"""
    alda_status()::Int

Display whether the Alda server is up.

# Examples

```julia-repl
julia> alda_status()  # or `status()`
[27713] Server up (2/2 workers available, backend port: 50235)
0
```
"""
alda_status()::Int = alda("status")


"""
    alda_version()::Int

Display the version of the Alda client and server.

# Examples

```julia-repl
julia> alda_version()  # or `version()`
Client version: 1.4.3
Server version: [27713] 1.4.3
0
```
"""
alda_version()::Int = alda("version")


"""
    alda_stop()::Int

Stop playback.

# Examples

```julia-repl
julia> alda_stop()  # or `stop()`
[27713] Stopping playback...
0
```
"""
alda_stop()::Int = alda("stop")


"""
    alda_instruments()::Vector{String}

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
function alda_instruments()::Vector{String}
    return [
        "midi-acoustic-grand-piano",
        "midi-bright-acoustic-piano",
        "midi-electric-grand-piano",
        "midi-honky-tonk-piano",
        "midi-electric-piano-1",
        "midi-electric-piano-2",
        "midi-harpsichord",
        "midi-clavi",
        "midi-celesta",
        "midi-glockenspiel",
        "midi-music-box",
        "midi-vibraphone",
        "midi-marimba",
        "midi-xylophone",
        "midi-tubular-bells",
        "midi-dulcimer",
        "midi-drawbar-organ",
        "midi-percussive-organ",
        "midi-rock-organ",
        "midi-church-organ",
        "midi-reed-organ",
        "midi-accordion",
        "midi-harmonica",
        "midi-tango-accordion",
        "midi-acoustic-guitar-nylon",
        "midi-acoustic-guitar-steel",
        "midi-electric-guitar-jazz",
        "midi-electric-guitar-clean",
        "midi-electric-guitar-palm-muted",
        "midi-electric-guitar-overdrive",
        "midi-electric-guitar-distorted",
        "midi-electric-guitar-harmonics",
        "midi-acoustic-bass",
        "midi-electric-bass-finger",
        "midi-electric-bass-pick",
        "midi-fretless-bass",
        "midi-bass-slap",
        "midi-bass-pop",
        "midi-synth-bass-1",
        "midi-synth-bass-2",
        "midi-violin",
        "midi-viola",
        "midi-cello",
        "midi-contrabass",
        "midi-tremolo-strings",
        "midi-pizzicato-strings",
        "midi-orchestral-harp",
        "midi-timpani",
        "midi-string-ensemble-1",
        "midi-string-ensemble-2",
        "midi-synth-strings-1",
        "midi-synth-strings-2",
        "midi-choir-aahs",
        "midi-voice-oohs",
        "midi-synth-voice",
        "midi-orchestra-hit",
        "midi-trumpet",
        "midi-trombone",
        "midi-tuba",
        "midi-muted-trumpet",
        "midi-french-horn",
        "midi-brass-section",
        "midi-synth-brass-1",
        "midi-synth-brass-2",
        "midi-soprano-saxophone",
        "midi-alto-saxophone",
        "midi-tenor-saxophone",
        "midi-baritone-saxophone",
        "midi-oboe",
        "midi-english-horn",
        "midi-bassoon",
        "midi-clarinet",
        "midi-piccolo",
        "midi-flute",
        "midi-recorder",
        "midi-pan-flute",
        "midi-bottle",
        "midi-shakuhachi",
        "midi-whistle",
        "midi-ocarina",
        "midi-square-lead",
        "midi-saw-wave",
        "midi-calliope-lead",
        "midi-chiffer-lead",
        "midi-charang",
        "midi-solo-vox",
        "midi-fifths",
        "midi-bass-and-lead",
        "midi-synth-pad-new-age",
        "midi-synth-pad-warm",
        "midi-synth-pad-polysynth",
        "midi-synth-pad-choir",
        "midi-synth-pad-bowed",
        "midi-synth-pad-metallic",
        "midi-synth-pad-halo",
        "midi-synth-pad-sweep",
        "midi-fx-rain",
        "midi-fx-soundtrack",
        "midi-fx-crystal",
        "midi-fx-atmosphere",
        "midi-fx-brightness",
        "midi-fx-goblins",
        "midi-fx-echoes",
        "midi-fx-sci-fi",
        "midi-sitar",
        "midi-banjo",
        "midi-shamisen",
        "midi-koto",
        "midi-kalimba",
        "midi-bagpipes",
        "midi-fiddle",
        "midi-shehnai",
        "midi-tinkle-bell",
        "midi-agogo",
        "midi-steel-drums",
        "midi-woodblock",
        "midi-taiko-drum",
        "midi-melodic-tom",
        "midi-synth-drum",
        "midi-reverse-cymbal",
        "midi-guitar-fret-noise",
        "midi-breath-noise",
        "midi-seashore",
        "midi-bird-tweet",
        "midi-telephone-ring",
        "midi-helicopter",
        "midi-applause",
        "midi-gunshot",
        "midi-percussion"
    ]
end


"""
    alda_parse(
        code::AbstractString;
        file::AbstractString = "",
        output::AbstractString = "data"
    )::Dict{String, Any}

Display the result of parsing Alda code.

# Positional arguments

* `code::AbstractString`: String of Alda code.

# Keyword arguments

* `file::Bool = false`: `true` if `code` should be interpreted as the path to
                        read Alda code from a file.
* `output::AbstractString="data"`: Return the output as "data" or "events".

# Examples

```julia-repl
julia> alda_parse("piano: c d e f g a b > c")  # or `parse!(...)`
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
    )::Dict{String, Any}

    cmd = [
        alda_executable(),
        "parse",
        "--output", output,
    ]

    foreach(
        x -> push!(cmd, x),
        file ? ["--file", code] : ["--code", "\"$code\""]
    )

    cmd = `$cmd`

    return JSON.parse(read(cmd, String))
end


"""
    alda_export(
        code::AbstractString,
        output::AbstractString;
        file::AbstractString = "",
        output_format::AbstractString = "midi"
    )::Int

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
    )::Int

    cmd = [
        "export",
        "--output", output,
        "--output-format", output_format,
    ]

    foreach(
        x -> push!(cmd, x),
        file ? ["--file", code] : ["--code", "\"$code\""]
    )

    return alda(cmd...)
end


"""
    alda_play(
        code::AbstractString;
        file::Bool = false,
        from::AbstractString = "",
        to::AbstractString = "",
        history::AbstractString = "",
        history_file::AbstractString = ""
    )::Int

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
    )::Int

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

    return alda(cmd...)
end


"""
    alda_play!(
        code::AbstractString;
        from::AbstractString = "",
        to::AbstractString = "",
        history_file::AbstractString = ""
    )::Int

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
    )::Int

    cmd = ["play"]

    foreach(
        x -> push!(cmd, x),
        [
            "--history-file",
            !isempty(history_file) ?
                     history_file  :
                     alda_history_file()
        ]
    )

    !isempty(from) && foreach(x -> push!(cmd, x), ["--from", from])
    !isempty(to) && foreach(x -> push!(cmd, x), ["--to", to])

    foreach(x -> push!(cmd, x), ["--code", code])

    exitcode = 0

    open(
            !isempty(history_file) ? history_file : alda_history_file(),
            append = true
        ) do file

        exitcode = begin
            try
                ex_code = alda(cmd...)
                write(file, code * "\n")
                ex_code
            catch e
                cmd = e.procs[1].cmd
                @show cmd
                e.procs[1].exitcode
            end
        end
    end

    return exitcode
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


end  # CLI module
