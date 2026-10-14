-- Analysis: VM opcode handler, NOT the user program.
function(p, a, k, m, g, j, _)
    local B, q, l, t, b, z, x, c, u, o, n, C, w, e, i, y, d, f, r
    z = 235
    while true do
        if (z > 137) then
            if (z < 232) then
                if (z <= 207) then
                    if (z >= 174) then
                        if (z <= 174) then
                            z = (((c < x) and 118) or (40542 / z))
                        else
                            x, d = (f - t), t
                            z = (((x ~= x) and (24426 / z)) or (319 - z))
                        end
                    else
                        z = (((d <= 0) and (42251 / z)) or 124)
                    end
                elseif (z <= 210) then
                    z, i = 232, A.h(i(r, B))
                else
                    b = b(i, r)
                    i, e, r = s[3][3][s[3][2]], (# w), w
                    e, z, B = 1, 53, (c % e)
                end
            elseif (z <= 235) then
                if (z >= 233) then
                    if (z <= 233) then
                        i, b, f, o, u, r, t = C, s[3][3][s[3][2]], s[2][3][s[2][2]], 25, 59, 1, s[1][3][s[1][2]]
                        z, r = 231, (c + r)
                    else
                        z, l, w = 41, 56, p[12]
                        n, w, C, l = (w - l), p[20], 1, k[9]
                        y, c, q = {}, 0, (_ - C)
                        y[12] = c
                        c = 2
                        y[26] = c
                    end
                else
                    z, t = 62, A.h(t(b, A.i(i)))
                end
            elseif (z > 249) then
                z = (((c < x) and 118) or 124)
            else
                z = (((c > x) and (z + (- 131))) or (z + (- 82)))
            end
        elseif (z > 67) then
            if (z <= 118) then
                if (z <= 112) then
                    if (z > 89) then
                        z = (((d > 0) and 67) or 89)
                    else
                        z = (((d ~= d) and (263 - z)) or 55)
                    end
                else
                    z, q = 20, y
                end
            elseif (z <= 124) then
                z = (((d ~= d) and 118) or (28892 / z))
            else
                c = (c + d)
                z = (((d > 0) and 249) or (z + 30))
            end
        elseif (z <= 55) then
            if (z >= 53) then
                if (z > 53) then
                    z = (((d <= 0) and (229 - z)) or 233)
                else
                    z, B = 210, (B + e)
                end
            elseif (z > 20) then
                C = y
                l[q] = C
                c, z, q, y = 1, (z + 166), k[9], (_ + n)
                C = (y - c)
                l = q[C]
                c, C, y = 0, l[20], ""
                f, t = (# C), 1
            else
                l[20] = q
                q, C, y, c = nil, g, nil, _
                return q, C, y, c
            end
        elseif (z <= 62) then
            f = f(A.i(t))
            y = (y .. f)
            z = (((u > o) and 137) or 118)
        else
            z = (((c > x) and 118) or (5963 / z))
        end
    end
end
