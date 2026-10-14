-- Analysis: VM opcode handler, NOT the user program.
function(p, a, k, m, g, j, _)
    local l, n, q, w, v, b, c, d, e, i, f, o, h
    h = 210
    repeat
        if (h > 196) then
            if (h > 210) then
                e, h, v = 1, (258 - h), (g - w)
                l = (v + e)
            else
                w, l = p[12], 54
                l, q, n = p[24], 60, (w - l)
                v, e, w = p[23], 4, (l - q)
                v, q = 1, (v - e)
                h, v, l = 196, p[7], (q - v)
            end
        elseif (h >= 110) then
            if (h <= 110) then
                o = _
                return v, e, c, o
            else
                i, e, b = 226, 58, 120
                q, v = (v - e), (- 1)
                h = (((l == v) and (h + 52)) or (206 - h))
            end
        elseif (h > 10) then
            v(e, c, o, d, f)
            c, e, v = nil, g, nil
            h = (((b < i) and (7590 / h)) or 210)
        else
            f, c, d, e, v = 1, w, (w + l), j, k[2]
            f, d, h, o = j[n], q, (690 / h), (d - f)
        end
    until false
end
