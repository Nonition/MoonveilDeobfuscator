-- Analysis: VM opcode handler, NOT the user program.
function(p, a, k, m, g, j, _)
    local C, e, q, y, z, B, l, t, f, o, b, x, r, u, n, w, c, i, d
    z = 192
    repeat
        if (z >= 109) then
            if (z > 194) then
                if (z <= 233) then
                    if (z >= 197) then
                        if (z > 197) then
                            z, f = (45901 / z), f(A.i(t))
                            e, b, r, t, i = 3, f, w, k[2], 1
                            B = (n + e)
                        else
                            z, e = (332 - z), j
                        end
                    else
                        z, b, t, f = (z + (- 151)), C, q, l
                    end
                else
                    t = 3
                    f = (n + t)
                    j[f] = y
                    t = 4
                    f = (n + t)
                    j[f] = c
                    z, t = 84, 5
                    f = (n + t)
                    j[f] = x
                end
            elseif (z >= 176) then
                if (z >= 192) then
                    if (z <= 192) then
                        w, l = p[12], 21
                        l, q, n = p[24], 9, (w - l)
                        z, l, c, w = 89, j[n], 1, (l - q)
                        y = (n + c)
                        q, c = j[y], 2
                        y = (n + c)
                    else
                        t = p[19]
                        t, f = 59, (_ + t)
                        _ = (f - t)
                        z = (((u > t) and (17072 / z)) or (204 - z))
                    end
                else
                    z, t = (z + 57), A.h(t(b, i))
                end
            elseif (z > 135) then
                f = 3
                z = (((w == f) and (384 - z)) or (216 - z))
            elseif (z > 109) then
                t(b, i, r, B, e)
                y = f[1]
                z = (((u <= o) and (z + (- 51))) or 88)
            else
                t = 3
                f = (n + t)
                j[f] = y
                t = 4
                f = (n + t)
                j[f] = c
                t = 5
                f = (n + t)
                j[f] = x
                z, t = (z + (- 25)), 6
                f = (n + t)
                j[f] = d
            end
        elseif (z < 84) then
            if (z > 45) then
                f = 4
                z = (((w == f) and (182 - z)) or 97)
            elseif (z > 10) then
                f, t, b, i = f(t, b)
                d, c, y, f, x = i, t, f, 2, b
                z = (((w == f) and (450 / z)) or (z + 98))
            elseif (z <= 3) then
                z, f, b, i, t = 176, k[15], q, C, l
            else
                t = 3
                z, f = (840 / z), (n + t)
                j[f] = y
                t = 4
                f = (n + t)
                j[f] = c
            end
        elseif (z >= 89) then
            if (z <= 97) then
                if (z <= 89) then
                    x, y, d, u, f, c, C, o = nil, nil, nil, 99, 4, nil, j[y], 247
                    z = (((w > f) and 3) or (17444 / z))
                else
                    t = 3
                    z, f = (z + (- 13)), (n + t)
                    j[f] = y
                end
            else
                t = p[18]
                f, z, t = (_ + t), (196 - z), 13
                _ = (f - t)
            end
        elseif (z <= 84) then
            t, u = 2, 176
            f = (n + t)
            j[f] = y
            f = nil
            z = (((y == f) and (z + 110)) or 108)
        else
            f, b, i, t = nil, nil, _, g
            return f, t, b, i
        end
    until false
end
