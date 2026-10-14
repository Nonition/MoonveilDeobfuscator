-- Analysis: VM opcode handler, NOT the user program.
function(p, a, k, m, g, j, _)
    local h, e, v, q, w, c, l, n, o, d, f, b, i, t
    h = 0
    while true do
        if (h > 81) then
            if (h <= 163) then
                if (h <= 161) then
                    if (h > 134) then
                        f, h, t, b, d, o, i = 1, (26243 / h), c, n, e, k[2], j
                    elseif (h > 113) then
                        e = e(u.i(c))
                        h, c = 204, e.n
                    else
                        h = ((q and 38) or (163 - h))
                    end
                else
                    o(d, f, t, b, i)
                    o, d, f, t = nil, g, nil, _
                    return o, d, f, t
                end
            elseif (h <= 204) then
                o = 0
                h = (((l == o) and 17) or (4692 / h))
            else
                h, c = (356 - h), u.h(c(u.i(o)))
            end
        elseif (h >= 38) then
            if (h > 50) then
                h, o = (h + 141), u.h(o(d, f, t))
            elseif (h <= 46) then
                if (h <= 38) then
                    e, v = k[15], j[n]
                    h, d, t, c, o = (h + 43), j, 1, v, k[25]
                    f, t = (n + t), (n + q)
                else
                    h, q = 113, (g - n)
                end
            else
                v = 1
                h, q = (1900 / h), (w - v)
            end
        elseif (h >= 17) then
            if (h > 17) then
                o = 1
                h, c = (3703 / h), (l - o)
            else
                d, h, o = 1, 161, (n + c)
                g = (o - d)
            end
        else
            q, v = p[12], 41
            q, n, v = p[24], (q - v), 43
            v, q, w = 38, p[23], (q - v)
            v, l = 0, (q - v)
            q = (w == v)
            h = ((q and 46) or 113)
        end
    end
end
