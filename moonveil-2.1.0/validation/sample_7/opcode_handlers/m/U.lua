-- Analysis: VM opcode handler, NOT the user program.
function(c, a, k, m, g, j, _)
    local n, l, d, o
    d = c[16]
    d, n = 2, (_ + d)
    d, l, _, n = g, nil, (n - d), nil
    o = _
    return n, d, l, o
end
