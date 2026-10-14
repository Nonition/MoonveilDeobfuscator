-- Analysis: VM opcode handler, NOT the user program.
function(g, r, j, l, m, s, q)
    local h, i, e, k, o, _, a, n, p, t
    i = 4
    repeat
        if (i > 84) then
            if (i <= 105) then
                p, k, a, e, _ = n, q, true, s, o
                return p, a, k, _, e
            else
                a, i, p = 1, 105, (s - o)
                n = (p + a)
            end
        elseif (i < 68) then
            i, h, t = 84, r[26], 25
            n, t, o = 1, r[14], (h - t)
        elseif (i > 68) then
            h = (t - n)
            t, p, n = (h - n), (- 1), nil
            i = (((t == p) and 227) or 68)
        else
            p = 1
            i, n = 105, (h - p)
        end
    until false
end
