-- Analysis: VM opcode handler, NOT the user program.
function(p, a, k, m, g, j, _)
    local q, v, n, o, t, r, c, b, h, d, e, l
    h = 115
    repeat
        if (h <= 92) then
            if (h >= 71) then
                if (h <= 71) then
                    v, e = r(l, q)
                    q = v
                    h = (((q == nil) and 57) or 92)
                else
                    c, b, t = e[2], 245, 228
                    h = (((c >= n) and (h + 104)) or 71)
                end
            else
                q, l, r, v = nil, g, nil, _
                return r, l, q, v
            end
        elseif (h > 115) then
            d, o = e[2], e[3]
            c = o[d]
            e[1] = c
            e[3] = e
            c = 1
            e[2] = c
            c = nil
            a[v] = c
            h = (((t >= b) and (38416 / h)) or (267 - h))
        else
            r, l = p[12], 2
            n, q, l, r = (r - l), nil, nil, a
            r, l, q = u.g(r, l, q)
            v, e = r(l, q)
            q = v
            h = (((q == nil) and 57) or 92)
        end
    until false
end
