-- Analysis: VM opcode handler, NOT the user program.
function(p, a, k, m, g, j, _)
    local l, q, n, i, r, h, e, c
    h = 93
    repeat
        if (h >= 93) then
            l, h, r = 12, 1, p[12]
            i, n, e = p[24], (r - l), 23
            q = (i - e)
            c, l, e = 61, j[q], p[23]
            i = (e - c)
            q = j[i]
            r = (l + q)
        else
            j[n] = r
            n, r, l, q = nil, g, nil, _
            return n, r, l, q
        end
    until false
end
