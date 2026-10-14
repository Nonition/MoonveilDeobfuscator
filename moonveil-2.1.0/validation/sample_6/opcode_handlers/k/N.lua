-- Analysis: VM opcode handler, NOT the user program.
function(g, r, j, l, m, s, v)
    local n, f, b, d, a, x, o, k, _, e, h, u, t, i, p
    i = 255
    while true do
        if (i > 121) then
            if (i <= 201) then
                if (i < 167) then
                    if (i <= 155) then
                        i = ((n and (6045 / i)) or (i + 46))
                    else
                        i, _ = (i + (- 36)), w.h(_(e, d, f))
                    end
                elseif (i >= 178) then
                    if (i > 178) then
                        i, u = (240 - i), 1
                        n = (h - u)
                    else
                        i, n = 155, (s - o)
                    end
                else
                    f = 1
                    d, i, f = (o + f), (324 - i), (o + n)
                end
            elseif (i <= 241) then
                if (i <= 238) then
                    if (i > 232) then
                        f, d, e, p, _ = k, 1, a, o, m[21]
                        i = (((b >= d) and (303 - i)) or (5712 / i))
                    else
                        u = 50
                        u, t = 0, (n - u)
                        n = (h == u)
                        i = ((n and 178) or (387 - i))
                    end
                else
                    a = a(w.i(k))
                    k, _ = a.n, 0
                    i = (((t == _) and (340 - i)) or 68)
                end
            else
                i, h, t = 100, r[26], 15
                u, o, n = 19, (h - t), r[14]
            end
        elseif (i < 65) then
            if (i < 39) then
                if (i > 12) then
                    i, b = 241, 92
                else
                    i = (744 / i)
                    _(e, d, f, p, x)
                    d, _, e = v, nil, nil
                end
            elseif (i <= 43) then
                if (i > 39) then
                    o, i, u, n = (n - u), 232, 40, r[30]
                    h, n = (n - u), r[6]
                else
                    a, u = m[15], l[o]
                    i, k, e, _ = 167, u, l, m[12]
                end
            else
                f, p = nil, s
                return _, e, d, f, p
            end
        elseif (i > 99) then
            if (i > 100) then
                i, k = (145 - i), w.h(k(w.i(_)))
            else
                i, t = 43, (n - u)
                h = l[t]
                l[o] = h
                n, u = r[25], 8
            end
        elseif (i <= 68) then
            if (i > 65) then
                i, _ = (306 - i), 1
                k = (t - _)
            else
                i, x = 12, l
            end
        else
            i, e, _ = (23562 / i), 1, (o + k)
            s = (_ - e)
        end
    end
end
