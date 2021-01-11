module Types


import Base.string


export Note, Rest, Pitch, Duration, Dots, Slur


struct Pitch
    value::String
end

Pitch(value::Symbol) = Pitch(string(value))
Base.string(pitch::Pitch) = pitch.value

struct Accidental
    value::String
end

Accidental(value::Symbol)

struct Dots
    number::Int
end

struct Duration
    value::String
    dots::Dots
end

struct Rest
    duration::Duration
end

struct Slur
    slured::Bool
end

struct Note
    pitch::Pitch
    accidental::Accidental
    duration::Duration
    dots::Dots
    slur::Slur
end




end  # Types module
