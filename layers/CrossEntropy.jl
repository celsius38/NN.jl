type CrossEntropyLoss <: LossCriteria
    last_loss  :: Array{Float64}
    last_input :: Array{Float64}
    function CrossEntropyLoss()
        return new(Float64[], Float64[])
    end
end    

function forward(l::CrossEntropyLoss, y::Array{Float64,1}, label::Array{Float64, 1})
    """
    [label]  label[i] == 1 iff the data is classified to class i
    [y]      final input to the loss layer
    """
    local class = convert(Int64,label[1]) + 1
    local ysubt = y - maximum(y)
    local ynorm = (e .^ ysubt) / sum(e .^ ysubt)
    local loss  = (-log(ynorm))[class]
    if loss > e^3
#         print("Loss:$(loss); y=$(y); Y-subtract:$(ysubt); Y-normalized:$(ynorm)")
        loss = e^3
    end
    println("Loss layer:$(loss)")
    return loss
end

function backward(l::CrossEntropyLoss, x::Array{Float64,1}, label::Array{Float64, 1})
    """
    [label]  label[i] == 1 iff the data is classified to class i
    [y]      final input to the loss layer
    """
    local class = convert(Int64,label[1]) + 1
    local t = zeros(length(x))
    t[class] = 1.
    @assert sum(t) == 1 && minimum(t) >= 0
    local max = maximum(x)
    local y = e.^(x-max) / sum(e.^(x-max))
    local dldy = y - t
    return dldy
end
l = CrossEntropyLoss()
println(forward(l, [1.,2.,0.], [2.]))
println(backward(l, [1.,2.,0.], [2.]))