-- Analysis: VM opcode handler, NOT the user program.
function(g, r, j, l, m, d, q)
    local o, n, h, i, p, f, a, _
    i = 149
    repeat
        if (i < 96) then
            if (i > 66) then
                i, l[o] = 232, h
                n, f, o, h = nil, q, nil, nil
            else
                n = (p - a)
                f = l[n]
                h = (# f)
                i, l[o] = 96, h
                h = r[25]
            end
        elseif (i < 149) then
            f = 3
            n, f, o = 12, r[8], (h - f)
            h = (f - n)
            i = (((_ <= n) and (i + 136)) or (8160 / i))
        elseif (i <= 149) then
            i, _, h, f = 66, 53, r[26], 44
            o, a, p = (h - f), 25, r[14]
        else
            p = d
            return o, h, f, n, p
        end
    until false
end
