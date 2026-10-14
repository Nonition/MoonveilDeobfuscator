-- Analysis: VM opcode handler, NOT the user program.
function(c, a, k, m, g, j, _)
    local d, h, n, o, l
    h = 117
    repeat
        if (h >= 117) then
            d, h, l = c[12], 68, 47
            n, o, l = (d - l), c[20], k[17]
            d = l[o]
            j[n] = d
            d, l = c[24], 33
            n, l = (d - l), {}
            d = l
        else
            j[n] = d
            n, d, o, l = nil, g, _, nil
            return n, d, l, o
        end
    until false
end
