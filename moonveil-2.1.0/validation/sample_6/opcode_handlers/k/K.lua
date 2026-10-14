-- Analysis: VM opcode handler, NOT the user program.
function(g, r, j, l, m, s, v)
    local t, n, k, _, f, a, p, q, i, h, e, o, u, d
    i = 118
    while true do
        if (i >= 140) then
            if (i < 180) then
                if (i <= 159) then
                    if (i < 146) then
                        i, k = (315 - i), w.h(k(w.i(_)))
                    elseif (i <= 146) then
                        n, i, h, u = r[25], 63, (n - u), 40
                        u, t = 0, (n - u)
                    else
                        p, f = 56, r[6]
                        d = (f - p)
                        e = l[d]
                        i, l[_] = 244, e
                    end
                elseif (i > 166) then
                    i = (i + (- 9))
                else
                    a = a(w.i(k))
                    _, k = 0, a.n
                    i = (((t == _) and 214) or 180)
                end
            elseif (i >= 214) then
                if (i > 244) then
                    i, n = (i + (- 174)), (s - o)
                elseif (i <= 214) then
                    _, e = (o + k), 1
                    i, s = (45582 / i), (_ - e)
                else
                    p, e, _, f, d = s, nil, nil, nil, v
                    return _, e, d, f, p
                end
            elseif (i <= 180) then
                i, _ = (i + 33), 1
                k = (t - _)
            else
                p, i, _, e, d, f = o, (257 - i), m[21], a, 1, k
            end
        elseif (i <= 66) then
            if (i > 44) then
                if (i > 63) then
                    i, a, u = 105, m[15], l[o]
                    e, _, k = l, m[12], u
                else
                    n = (h == u)
                    i = ((n and 255) or 81)
                end
            elseif (i >= 31) then
                if (i <= 31) then
                    i, u = 66, 1
                    n = (h - u)
                else
                    i, q = (141 - i), l
                end
            else
                i, _ = 140, w.h(_(e, d, f))
            end
        elseif (i >= 105) then
            if (i <= 105) then
                i, f = 23, 1
                f, d = (o + n), (o + f)
            else
                u, i, n = 28, 146, r[26]
                o, n, u = (n - u), r[14], 47
            end
        elseif (i <= 81) then
            i = ((n and 66) or 31)
        else
            i = 159
            _(e, d, f, p, q)
            d, e = 42, r[30]
            _ = (e - d)
        end
    end
end
