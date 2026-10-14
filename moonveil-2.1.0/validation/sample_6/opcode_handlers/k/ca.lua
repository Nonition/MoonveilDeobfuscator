-- Analysis: VM opcode handler, NOT the user program.
function(g, r, j, l, m, s, v)
    local e, y, b, o, d, u, a, h, k, p, f, x, n, i, t, q
    i = 39
    repeat
        if (i <= 86) then
            if (i > 41) then
                if (i < 84) then
                    if (i <= 70) then
                        i = (313 - i)
                    else
                        e, i, y = 1, (14475 / i), (o + k)
                        s = (y - e)
                    end
                elseif (i > 84) then
                    u, a = l[o], m[15]
                    y, e, i, k = m[12], l, 104, u
                else
                    i, y = (i + (- 80)), w.h(y(e, d, f))
                end
            elseif (i >= 33) then
                if (i >= 39) then
                    if (i <= 39) then
                        n, u = r[26], 52
                        u, o, i, n = 55, (n - u), 93, r[14]
                    else
                        p, f = s, nil
                        return y, e, d, f, p
                    end
                else
                    i, u = 86, 1
                    n = (h - u)
                end
            elseif (i >= 6) then
                if (i <= 6) then
                    i, x = (i + 238), l
                else
                    y = 1
                    i, k = 193, (t - y)
                end
            else
                i, k = (280 / i), w.h(k(w.i(y)))
            end
        elseif (i > 170) then
            if (i >= 243) then
                if (i > 243) then
                    y(e, d, f, p, x)
                    e, i, y, d = nil, 41, nil, v
                else
                    a = a(w.i(k))
                    k, y = a.n, 0
                    i = (((t == y) and (18225 / i)) or (266 - i))
                end
            else
                y, d, p, f, e = m[21], 1, o, k, a
                i = (((b > d) and 6) or (i + (- 170)))
            end
        elseif (i < 104) then
            if (i > 89) then
                u, h, i, b, n, q = 19, (n - u), 170, 239, r[25], 44
                u, t = 0, (n - u)
            else
                n = (s - o)
                i = (((b < q) and 41) or (i + 30))
            end
        elseif (i < 119) then
            i, b, f = (188 - i), 244, 1
            f, d = (o + n), (o + f)
        elseif (i > 119) then
            n = (h == u)
            i = ((n and 89) or (289 - i))
        else
            i = ((n and (i + (- 33))) or (152 - i))
        end
    until false
end
