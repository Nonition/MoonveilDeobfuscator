-- Analysis: VM opcode handler, NOT the user program.
function(p, a, k, m, g, j, _)
    local i, t, b, o, q, d, h, f, n, v, w, c, l, e
    h = 194
    while true do
        if (h < 90) then
            if (h < 57) then
                if (h > 25) then
                    h, o = (108 - h), u.h(o(d, f, t))
                elseif (h <= 12) then
                    e = e(u.i(c))
                    h, c = (77 - h), e.n
                else
                    h = ((q and 180) or 86)
                end
            elseif (h < 72) then
                if (h > 57) then
                    o = 0
                    h = (((l == o) and 90) or (h + (- 8)))
                else
                    h, o = (h + 135), 1
                    c = (l - o)
                end
            elseif (h <= 72) then
                h, c = (84 - h), u.h(c(u.i(o)))
            else
                v = 1
                h, q = 180, (w - v)
            end
        elseif (h >= 177) then
            if (h < 192) then
                if (h <= 177) then
                    v = 3
                    v, q, w = 61, p[31], (q - v)
                    l, v = (q - v), 0
                    q = (w == v)
                    h = ((q and (27258 / h)) or 25)
                else
                    v, h, e = j[n], 36, k[15]
                    c, d, o, t = v, j, k[25], 1
                    t, f = (n + q), (n + t)
                end
            elseif (h > 192) then
                w, l = p[12], 31
                v, h, q, n = 5, 177, p[24], (w - l)
                l = (q - v)
                w = j[l]
                j[n] = w
                v, q = 47, p[23]
                n, q = (q - v), p[7]
            else
                t, d, f, b, o, h, i = c, e, 1, n, k[2], 109, j
            end
        elseif (h >= 109) then
            if (h <= 109) then
                o(d, f, t, b, i)
                o, f, t, d = nil, nil, _, g
                return o, d, f, t
            else
                h, q = 25, (g - n)
            end
        else
            o, h, d = (n + c), 192, 1
            g = (o - d)
        end
    end
end
