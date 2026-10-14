-- Analysis: VM opcode handler, NOT the user program.
function(p, a, k, m, g, j, _)
    local q, v, l, n, c, h, b, f, o, e, d, r
    h = 139
    repeat
        if (h >= 139) then
            if (h < 155) then
                b, v, q, r = 212, 51, p[24], k[11]
                l = (q - v)
                q, l, n = 53, p[12], r[l]
                q, v, h, r = n[3], n[2], 165, (l - q)
                l = q[v]
                j[r] = l
            elseif (h > 155) then
                l, q = p[23], 50
                v, q, r = 20, p[7], (l - q)
                v, l = 1, (q - v)
                e, q, v = (- 1), (l - v), nil
                h = (((q == e) and 126) or (25575 / h))
            else
                h, e = 105, 1
                v = (l - e)
            end
        elseif (h <= 105) then
            e, d, o, c, f = v, _, r, g, true
            return e, c, o, d, f
        else
            c, e = 1, (g - r)
            v = (e + c)
            h = (((b > c) and 105) or (h + 39))
        end
    until false
end
