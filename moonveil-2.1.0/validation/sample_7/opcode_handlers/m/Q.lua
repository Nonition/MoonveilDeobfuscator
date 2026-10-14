-- Analysis: VM opcode handler, NOT the user program.
function(c, a, k, m, g, j, _)
    local h, l, o, d, n
    h = 178
    repeat
        if (h < 178) then
            d = (l - o)
            j[n] = d
            d, n, l, o = g, nil, nil, _
            return n, d, l, o
        else
            l, d = 18, c[12]
            n, l, h, o = (d - l), c[29], 77, 55
            d = (l - o)
            j[n] = d
            l, d = 21, c[24]
            o, l, n = 24, c[5], (d - l)
        end
    until false
end
