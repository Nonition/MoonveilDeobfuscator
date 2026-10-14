-- Analysis: VM opcode handler, NOT the user program.
function(p, a, k, m, g, j, _)
    local d, e, q, l, h, n, i
    h = 65
    repeat
        if (h <= 65) then
            d, l = p[12], 2
            n, i, e = (d - l), p[24], 43
            q = (i - e)
            h, l = 103, j[q]
            d = (# l)
            j[n] = d
            d, l = p[23], 59
            n = (d - l)
        else
            q, l = 6, p[29]
            d = (l - q)
            j[n] = d
            q, d, n, l = _, g, nil, nil
            return n, d, l, q
        end
    until false
end
