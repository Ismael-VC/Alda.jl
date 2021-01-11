module Core

import string, isless, :|, :*

at_marker(name::AbstractString)::String = "@$name"
barline()::String = "|"


const SymStr = Union{Symbol, AbstractString}
const NumStr = Union{Number, AbstractString}
const BoolSymStr = Union{Bool, Symbol, AbstractString}

macro var(expr::Expr)
    quote
        $expr
        return nothing
    end |> esc
end


macro score(block)
    code = []
    for ex in block.args
       isa(ex, LineNumberNode) && continue
       isa(ex, Expr) && ex.head == :vcat ? foreach(x -> push!(code, x), ex.args) : nothing
       push!(code, ex)
       @show code
       # Alda.play!(code)
    end
    # return :(string($code...))
    return :(join(tuple($(code...), " ")))
end

marker(name::String) = "%$name"
macro marker(name); "@$name"; end
volume(value::Int) = string("(volume $value)")
tempo!(value::Int) = string("(tempo! $value)")
Base.:|(sym1::T, sym2::T) where {T <: Symbol} = string(sym1, " | ", sym2)
Base.isless(x::String, y::Symbol) = string(x, " < ", y)
Base.:*(x::Symbol, y::Int) = string(x, " * ", y)
Base.:*(x::String, y::Int) = string(x, " * ", y)


function note(
        ;
        pitch::SymStr = "",
        accidental::SymStr = "",
        duration::NumStr = 0,
        slur::BoolSymStr = false
    )::String

    pitch = lowercase(string(pitch))
    valid_pitch = pitch in ["a", "b", "c", "d", "e", "f", "g", ""]
    pitch = isa(pitch, Symbol) ? string(pitch) : pitch
    pitch = valid_pitch ?
            pitch       :
            throw(ArgumentError("Invalid pitch value: $pitch"))

    accidental = isa(accidental, Symbol) ? string(accidental) : accidental
    accidental = lowercase(accidental)
    valid_accidental = accidental in [
        "flat", "f", "b", "-",
        "sharp", "s", "#", "+",
        ""
    ]
    accidental = valid_accidental ?
                 accidental       :
                 throw(ArgumentError("Invalid accidental value: $accidental"))

    accidental = accidental in ["flat", "f", "b", "-"]   ? "-" :
                 accidental in ["sharp", "s", "#", "+",] ? "+" :
                 ""

    duration = isa(duration, AbstractString) ?
               parse(Float64, duration)      :
               duration

    duration = duration == 0 ? ""       :
               duration > 0  ? duration :
               throw(ArgumentError("Invalid duration value: $duration"))

    slur = string(slur) |> lowercase
    slur = slur in ["~", "s", "slur", "true", "tie", "t", "beam", "b"]   ?
           true                                              :
           throw(ArgumentError("Invalid slur value: $slur"))
    slur = slur ? '~' : ""

    return "$pitch$accidental$duration$slur"
end

note(pitch)::String = note(pitch = pitch)
note(pitch, accidental)::String = note(
    pitch = pitch,
    accidental = accidental
)
note(pitch, accidental, duration)::String = note(
    pitch = pitch,
    accidental = accidental,
    duration = duration
)
note(pitch, accidental, duration, slur)::String = note(
    pitch = pitch,
    accidental = accidental,
    duration = duration,
    slur = slur
)


end  # Core module
