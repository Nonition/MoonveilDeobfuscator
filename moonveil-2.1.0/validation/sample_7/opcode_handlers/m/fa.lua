-- Analysis: VM opcode handler, NOT the user program.
function(p, a, k, m, g, j, _)
    local d, q, l, n, i, e, h
    h = 29
    repeat
        if (h <= 29) then
            q, l = 40, p[12]
            d = (l - q)
            q, i, n = p[24], 18, j[d]
            h, l = 153, (q - i)
            d, e, i = j[l], 16, p[23]
            q = (i - e)
            l = j[q]
        else
            n[d] = l
            l, n, q, d = nil, nil, _, g
            return n, d, l, q
        end
    until false
end
