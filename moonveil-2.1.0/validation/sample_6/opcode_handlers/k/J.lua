-- Analysis: VM opcode handler, NOT the user program.
function(g, r, A, l, m, s, v)
    local _, u, q, z, y, e, t, o, C, h, k, b, i, x, n, p, j, B, f
    i = 101
    repeat
        if (i >= 132) then
            if (i >= 174) then
                if (i > 221) then
                    if (i < 241) then
                        i, z = 241, z(w.i(f))
                        x, p, f, B = 1, z, m[21], h
                    elseif (i > 241) then
                        z = (o + f)
                        i, l[z] = 36, e
                    else
                        _ = 3
                        _, i, q = l, (304 - i), (o + _)
                    end
                elseif (i < 215) then
                    if (i <= 174) then
                        i, f = (i + (- 42)), w.h(f(p, x))
                    else
                        f = 3
                        z = (o + f)
                        l[z] = C
                        f = 4
                        z = (o + f)
                        i = (((j < f) and (i + (- 160))) or 136)
                    end
                elseif (i <= 215) then
                    y, e, z, k = p, x, 2, f
                    i = (((h == z) and 61) or (i + (- 91)))
                else
                    f = r[13]
                    i, f, z = 7, 10, (v + f)
                    v = (z - f)
                end
            elseif (i > 136) then
                if (i <= 164) then
                    if (i > 160) then
                        k = 2
                        i, C = 75, (o + k)
                        u, k, C = l[C], nil, nil
                    else
                        k, t, h = 1, l[o], (t - n)
                        C = (o + k)
                        n = l[C]
                        i = (((j < k) and (i + (- 24))) or 164)
                    end
                else
                    f = r[24]
                    i, z, f = (i + (- 161)), (v + f), 7
                    v = (z - f)
                end
            elseif (i >= 135) then
                if (i > 135) then
                    l[z] = k
                    f = 5
                    i, z = 36, (o + f)
                    l[z] = y
                else
                    p, f, x, i, z = n, t, u, (i + 39), m[15]
                end
            elseif (i > 132) then
                i, l[z] = (i + (- 97)), k
            else
                i = (i + 91)
            end
        elseif (i > 63) then
            if (i >= 101) then
                if (i <= 119) then
                    if (i <= 101) then
                        h, t, j = r[26], 10, 83
                        o, n, i, t = (h - t), 23, 160, r[14]
                    else
                        f = 3
                        z = (o + f)
                        l[z] = C
                        f = 4
                        z = (o + f)
                        i = (((b < f) and (4284 / i)) or 50)
                    end
                else
                    z, j, b = 3, 199, 175
                    i = (((h == z) and (302 - i)) or 94)
                end
            elseif (i > 94) then
                z, f, p, x = z(f, p)
                C = z
                i = (((j < b) and 215) or 243)
            elseif (i > 75) then
                z = 4
                i = (((h == z) and 119) or 10)
            else
                y, z, e, b, j = nil, 4, nil, 141, 3
                i = (((h > z) and 135) or 18)
            end
        elseif (i <= 36) then
            if (i >= 18) then
                if (i <= 18) then
                    i, f, z, p = 99, n, t, u
                else
                    f = 2
                    z = (o + f)
                    l[z] = C
                    z = nil
                    i = (((C == z) and 168) or 221)
                end
            elseif (i > 7) then
                i, f = 36, 3
                z = (o + f)
                l[z] = C
            else
                z, B, x, p, f = nil, s, nil, v, nil
                return z, f, p, x, B
            end
        elseif (i > 61) then
            f(p, x, B, q, _)
            i, C = 36, z[1]
        elseif (i <= 50) then
            l[z] = k
            f = 5
            i, z = (293 - i), (o + f)
            l[z] = y
            f = 6
        else
            f = 3
            z = (o + f)
            l[z] = C
            i, f = (8113 / i), 4
            z = (o + f)
        end
    until false
end
