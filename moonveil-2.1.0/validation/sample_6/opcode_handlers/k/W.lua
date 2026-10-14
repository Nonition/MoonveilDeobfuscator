-- Analysis: VM opcode handler, NOT the user program.
function(g, r, A, l, m, s, v)
    local C, t, z, j, n, h, B, q, x, b, e, f, _, p, y, k, i, o, u
    i = 170
    while true do
        if (i <= 128) then
            if (i <= 35) then
                if (i >= 25) then
                    if (i <= 30) then
                        if (i <= 28) then
                            if (i > 25) then
                                i, f = 249, 1
                                z, f = (o + f), (o + n)
                            else
                                n = (s - o)
                                i = (((j < b) and (i + 152)) or 38)
                            end
                        else
                            e, y = 1, (o + k)
                            s = (y - e)
                            i = (((j > e) and 101) or (6540 / i))
                        end
                    else
                        y(e, z, f, p, x)
                        e, z = r[30], 62
                        i, y = (i + 178), (e - z)
                    end
                elseif (i <= 11) then
                    if (i <= 9) then
                        f, p = nil, (- 1)
                        i = (((z == p) and 67) or 177)
                    else
                        u, i, C, j = l[o], 28, m[15], 127
                        y, e, k = m[12], l, u
                    end
                else
                    i, k = (239 - i), w.h(k(w.i(y)))
                end
            elseif (i <= 101) then
                if (i <= 67) then
                    if (i > 38) then
                        p, x = (s - y), 1
                        i, f = (295 - i), (p + x)
                    else
                        i = ((n and (418 / i)) or (194 - i))
                    end
                else
                    z, e, i, y, f, p = 1, C, 189, m[21], k, o
                end
            elseif (i <= 102) then
                n = (h == u)
                i = ((n and (2550 / i)) or (140 - i))
            else
                y = 1
                i, k = 101, (t - y)
            end
        elseif (i <= 213) then
            if (i >= 177) then
                if (i < 189) then
                    p = 1
                    i, f = 228, (e - p)
                elseif (i <= 189) then
                    i, x = 35, l
                else
                    z, f = r[6], 56
                    i, f, e = (1917 / i), 1, (z - f)
                    z = (e - f)
                end
            elseif (i >= 156) then
                if (i > 156) then
                    j, u, b, n = 123, 35, 11, r[26]
                    u, i, o, n = 56, 221, (n - u), r[14]
                else
                    i, u = 11, 1
                    n = (h - u)
                end
            else
                C = C(w.i(k))
                y, k = 0, C.n
                i = (((t == y) and (i + (- 125))) or 128)
            end
        elseif (i > 228) then
            i, y = 21, w.h(y(e, z, f))
        elseif (i <= 221) then
            if (i > 218) then
                h, n, u = (n - u), r[25], 13
                t, i, u = (n - u), (323 - i), 0
            else
                i = (33790 / i)
            end
        else
            x, B, q, _, p = true, v, y, s, f
            return p, x, B, q, _
        end
    end
end
