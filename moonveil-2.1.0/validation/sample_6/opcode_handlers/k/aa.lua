-- Analysis: VM opcode handler, NOT the user program.
function(g, r, j, l, m, s, v)
    local a, i, f, n, k, t, e, h, o, u, p, _
    i = 136
    repeat
        if (i > 136) then
            if (i > 193) then
                k = a[1]
                i = (((k >= o) and (i + (- 16))) or (33022 / i))
            elseif (i <= 160) then
                if (i > 158) then
                    k = 2
                    a[1] = k
                    k = nil
                    j[u] = k
                    i = (((f > p) and 158) or 136)
                else
                    u, a = h(t, n)
                    n = u
                    i = (((n == nil) and 84) or 209)
                end
            else
                e, _ = a[1], a[3]
                i, k = (353 - i), _[e]
                a[2] = k
                a[3] = a
            end
        elseif (i > 125) then
            if (i > 129) then
                t, h = 61, r[26]
                i, o, t, h = 125, (h - t), nil, j
            else
                u, a = nil, s
                return h, t, n, u, a
            end
        elseif (i <= 84) then
            if (i <= 82) then
                t = (n - u)
                i, l[h] = (i + 47), t
                t, h, n = nil, nil, v
            else
                i, n, t = 82, 43, r[14]
                h, n, u = (t - n), r[8], 6
            end
        else
            f, p, n = 222, 37, nil
            h, t, n = b.g(h, t, n)
            u, a = h(t, n)
            n = u
            i = (((n == nil) and 84) or 209)
        end
    until false
end
