-- Analysis: VM opcode handler, NOT the user program.
function(c, a, k, m, g, j, _)
    local o, l, n, d
    d, l = c[12], 7
    n, o, l = (d - l), 5, c[29]
    d = (l - o)
    j[n] = d
    l, o, n, d = nil, _, nil, g
    return n, d, l, o
end
