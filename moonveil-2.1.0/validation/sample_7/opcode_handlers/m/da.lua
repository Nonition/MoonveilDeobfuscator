-- Analysis: VM opcode handler, NOT the user program.
function(p, a, k, m, g, j, _)
    local w, c, r, B, b, n, h, t, z, q, y, e, f, l, v, d, x, i
    z = 34
    repeat
        if (z >= 140) then
            if (z <= 180) then
                if (z >= 152) then
                    if (z >= 154) then
                        if (z > 154) then
                            z = (((d > 0) and (19620 / z)) or (372 - z))
                        else
                            d, x = t, (f - t)
                            z = (((x ~= x) and 140) or (z + 26))
                        end
                    else
                        z, b = 16, b(i, r)
                        B, r, i, h = (# w), w, s[3][3][s[3][2]], (# w)
                        e = (c % h)
                    end
                elseif (z < 141) then
                    z, q = (z + (- 22)), y
                elseif (z <= 141) then
                    f = f(A.i(t))
                    z, y = (z + 6), (y .. f)
                else
                    c = (c + d)
                    z = (((d > 0) and 69) or (z + (- 125)))
                end
            elseif (z < 196) then
                if (z > 192) then
                    i, t, f, b, r = v, s[1][3][s[1][2]], s[2][3][s[2][2]], s[3][3][s[3][2]], 1
                    z, r = (z + (- 41)), (c + r)
                else
                    z = (((d ~= d) and (10752 / z)) or (z + (- 169)))
                end
            elseif (z >= 221) then
                if (z <= 221) then
                    z, t = 141, A.h(t(b, A.i(i)))
                else
                    z, v = (36036 / z), y
                    l[q] = v
                    q, c, y = k[9], 1, (_ + n)
                    v = (y - c)
                    l = q[v]
                    c, v, y = 0, l[20], ""
                    f, t = (# v), 1
                end
            else
                z = (((c < x) and (336 - z)) or 30)
            end
        elseif (z > 34) then
            if (z < 109) then
                if (z <= 56) then
                    z = (((c < x) and (196 - z)) or 193)
                else
                    z = (((c > x) and (209 - z)) or 22)
                end
            elseif (z <= 109) then
                z = (((c > x) and (15260 / z)) or 192)
            else
                l[20] = q
                c, y, q, v = _, nil, nil, g
                return q, v, y, c
            end
        elseif (z < 23) then
            if (z < 21) then
                z, B = 21, (B - e)
            elseif (z <= 21) then
                z, i = 221, A.h(i(r, B))
            else
                z = (((d <= 0) and 196) or 30)
            end
        elseif (z <= 30) then
            if (z > 23) then
                z = (((d ~= d) and 140) or 193)
            else
                z = (((d <= 0) and (79 - z)) or 193)
            end
        else
            l, w = 19, p[12]
            v, l, w, n = 1, k[9], p[20], (w - l)
            y, q, c = {}, (_ - v), 2
            z, y[26] = 234, c
            c = 0
            y[12] = c
        end
    until false
end
