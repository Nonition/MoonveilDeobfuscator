-- Analysis: VM opcode handler, NOT the user program.
function(p, a, k, m, g, j, _)
    local q, l, e, c, h, o, i, n, t, d, r
    h = 23
    repeat
        if (h < 145) then
            if (h <= 23) then
                t, r, l = 190, p[12], 60
                n, q, l = (r - l), 60, p[24]
                r, q = (l - q), 1
                l, i, q = (r - q), (- 1), nil
                h = (((l == i) and 145) or 36)
            else
                h, i = 212, 1
                q = (r - i)
            end
        elseif (h > 145) then
            e, o, i, c, d = g, _, q, n, true
            return i, e, c, o, d
        else
            e, i = 1, (g - n)
            q = (i + e)
            h = (((t <= e) and 145) or 212)
        end
    until false
end
