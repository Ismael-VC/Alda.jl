module Alda

"Path to the Alda executable."
const ALDA_EXECUTABLE = "alda"

"Path to the Alda history file."
HISTORY_FILE = tempname()

"Default options used by Alda."
const DEFAULT_ALDA_OPTIONS = Dict(
    :host => "localhost",
    :no_color => false,
    :port => 27713,
    :quiet => false,
    :timeout => 30,
    :verbose => false,
    :workers => 2
)

"""
Wrapper to the `alda` executable.

# Positional arguments

* `args::AbstractString...`: String commands passed to Alda.

# Keyword arguments

* `host::AbstractString = "localhost"`: The hostname of the Alda server.
* `no_color::Bool = false`: Disable color output.
* `port::Integer = 27713`: The port of the alda server/worker.
* `quiet::Bool = false`: Disable non-error messages.
* `timeout::Integer = 30`: The number of seconds to wait for a server to start up or shut down, before giving up.
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

"Display Alda executable help text."
help() = alda("help")

"Download and install the latest release of Alda"
update() = alda("update")

"Start an interactive Alda REPL session."
repl() = alda("repl")

"Start the Alda server."
up() = alda("up")

"Stop the Alda server."
down() = alda("down")

"Restart the Alda server."
downup() = alda("downup")

"List running Alda servers/workers."
list() = alda("list")

"Display whether the server is up."
status() = alda("status")

"Display the version of the Alda client and server."
version() = alda("version")

"Stop playback."
stop() = alda("stop")

"Clear Alda history."
clear!() = (global HISTORY_FILE = tempname())

history_file() = HISTORY_FILE

"Display a list of available instruments."
instruments() = alda("instruments")

"Display the result of parsing Alda code."
function parse()
end
"Evaluate Alda code and export the score to another format."
function export!()
end

"Evaluate and play Alda code."
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

    foreach(x -> push!(cmd, x), file ? ["--file", code] : ["--code", "\"$code\""])

    alda(cmd...)

    return nothing
end

"Evaluate and play Alda code with history."
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
                      HISTORY_FILE
        ]
    )

    !isempty(from) && foreach(x -> push!(cmd, x), ["--from", from])
    !isempty(to) && foreach(x -> push!(cmd, x), ["--to", to])

    foreach(x -> push!(cmd, x), ["--code", code])

    @show history_file cmd
    open(!isempty(history_file) ? history_file : HISTORY_FILE, append = true) do file
        try
            alda(cmd...)
            write(file, code * "\n")
        catch
        end
    end

    return nothing
end


end  # module
