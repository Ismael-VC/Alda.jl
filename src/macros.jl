module Macros


using MacroTools


macro var(expr::Expr)
    expr.head == :(=) && expr.args[1] isa Symbol ||
        error("Invalid simple assignement, got $expr")
    name, value = expr.args
    quote
        $name = $value
        string($(Meta.quot(name)), " = ", $value)
    end |> esc
end


function score(block::Expr)
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



macro score(block)
    postwalk(block) do ex
        @capture(ex, some_pattern) || return ex
        return new_x
    end
end


end
