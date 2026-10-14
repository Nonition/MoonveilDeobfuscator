-- Analysis: VM opcode handler, NOT the user program.
function(g, r, A, l, m, s, v)
    local q, z, h, j, f, e, b, y, u, C, n, p, x, t, _, i, B, o, k
    i = 50
    repeat
        if (i <= 111) then
            if (i > 62) then
                if (i <= 98) then
                    if (i >= 92) then
                        if (i > 92) then
                            z = z(w.i(f))
                            i, C = 100, (C .. z)
                        else
                            i, t[16] = (5704 / i), n
                            k, C, u, n = nil, v, nil, nil
                        end
                    elseif (i > 80) then
                        i = (((k > y) and 232) or (149 - i))
                    else
                        i = (((e ~= e) and 21) or 175)
                    end
                elseif (i <= 100) then
                    k = (k + e)
                    i = (((e > 0) and 88) or (6100 / i))
                else
                    i, f = (i + (- 13)), w.h(f(p, x, B))
                end
            elseif (i <= 51) then
                if (i < 30) then
                    if (i <= 21) then
                        i = (((k < y) and (i + 211)) or 125)
                    else
                        i, k, z, f, C = (167 - i), 0, (# u), 1, ""
                        y = (z - f)
                    end
                elseif (i >= 50) then
                    if (i > 50) then
                        j, C, k = 31, (v + o), 1
                        u = (C - k)
                        t = n[u]
                        i, u = (78 - i), t[16]
                    else
                        t, j, h = 39, 238, r[26]
                        t, h, i, o = m[9], r[16], 141, (h - t)
                    end
                else
                    i = (((k < y) and 232) or 200)
                end
            elseif (i <= 61) then
                if (i > 53) then
                    i = (((e <= 0) and (1830 / i)) or (261 - i))
                else
                    i, B = 159, (k + B)
                end
            else
                y = s
                return n, u, C, k, y
            end
        elseif (i >= 161) then
            if (i >= 200) then
                if (i >= 232) then
                    if (i <= 232) then
                        i, n = 92, C
                    else
                        i = (((k > y) and (485 - i)) or (i + (- 173)))
                    end
                elseif (i <= 200) then
                    i = (((e ~= e) and 232) or 125)
                else
                    k = 0
                    C[26] = k
                    u = C
                    t[n] = u
                    n = m[9]
                    i = (((b >= k) and (i + (- 151))) or (5454 / i))
                end
            elseif (i < 175) then
                _, q = 1, (k % _)
                i, q = (i + (- 15)), (q + _)
            elseif (i > 175) then
                i = (((e > 0) and (438 - i)) or (i + (- 105)))
            else
                i = (((e <= 0) and 21) or 125)
            end
        elseif (i >= 141) then
            if (i <= 146) then
                if (i <= 141) then
                    b, u = 199, 1
                    k, C, n = u, {}, (v - u)
                    C[17] = k
                    i = (((j <= u) and 141) or (i + 61))
                else
                    x = x(B, q)
                    B = 256
                    i = (((j >= B) and 100) or (17958 / i))
                end
            else
                i, p = (320 - i), p(x, B)
                x, _, B = c[1][3][c[1][1]], (# h), h
            end
        elseif (i > 125) then
            e = f
            i = (((y ~= y) and (32480 / i)) or (325 - i))
        elseif (i <= 123) then
            i, B = 111, (k % B)
        else
            z, p, B, f, i, x = c[2][3][c[2][1]], c[1][3][c[1][1]], 1, c[3][3][c[3][1]], (i + (- 72)), u
        end
    until false
end
