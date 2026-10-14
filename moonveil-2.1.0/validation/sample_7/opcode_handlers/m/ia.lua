-- Analysis: VM opcode handler, NOT the user program.
function(p, a, k, m, g, j, _)
    local q, c, b, y, l, F, H, f, J, C, A, n, x, h, z, e, d, K, E, r, t, v, w, M, B, u, o, s, G, L
    F = 53
    while true do
        if (F > 111) then
            if (F <= 177) then
                if (F <= 146) then
                    if (F > 137) then
                        if (F < 145) then
                            f, d = 4, 65
                            F = (((w == f) and (F + (- 84))) or (F + (- 44)))
                        elseif (F > 145) then
                            x, L, f, s, l = nil, nil, 4, 70, 231
                            F = (((w > f) and 62) or (35916 / F))
                        else
                            F, M = (31175 / F), B
                        end
                    elseif (F > 129) then
                        b, F, M = t["__iter"], 4, x
                    elseif (F > 115) then
                        t = 2
                        f = (n + t)
                        j[f] = y
                        f = nil
                        F = (((y == f) and 239) or (F + (- 15)))
                    elseif (F > 114) then
                        G, B, H = G(B, H)
                        G, B, H = D.g(G, B, H)
                        h = G(B, H)
                        H = h
                        F = (((H == nil) and (9660 / F)) or (F + 122))
                    else
                        t = p[18]
                        f, t = (_ + t), 40
                        _ = (f - t)
                        F = (((l >= t) and (7980 / F)) or (11514 / F))
                    end
                elseif (F <= 168) then
                    if (F >= 164) then
                        if (F <= 164) then
                            B, F, G = x, (5576 / F), I[2][3][I[2][2]]
                        else
                            h = G(B, H)
                            H = h
                            F = (((H == nil) and (14112 / F)) or 237)
                        end
                    elseif (F > 150) then
                        G = nil
                        b = (M == G)
                        F = ((b and (F + 5)) or 93)
                    else
                        A = A(u, z)
                        F, B = (26550 / F), A
                    end
                elseif (F <= 170) then
                    u = u(z)
                    A, F, v = 4294967295, (F + 16), (A + u)
                else
                    o = H(h, E)
                    E = o
                    F = (((E == nil) and 145) or (9735 / F))
                end
            elseif (F > 217) then
                if (F > 239) then
                    if (F <= 246) then
                        b, F, f, t = C, 21, J, q
                    else
                        t = 3
                        f = (n + t)
                        j[f] = y
                        F, t = (F + (- 123)), 4
                        f = (n + t)
                        j[f] = c
                        t = 5
                        f = (n + t)
                        j[f] = x
                    end
                elseif (F >= 237) then
                    if (F > 237) then
                        t = p[19]
                        t, f = 8, (_ + t)
                        _ = (f - t)
                        F = (((K > t) and 70) or (F + (- 223)))
                    else
                        u, F, o = 43, (40290 / F), I[4][3][I[4][2]]
                        u, z, A = I[3][3][I[3][2]], h, (M * u)
                    end
                else
                    f = 3
                    F = (((w == f) and (F + 32)) or (31240 / F))
                end
            elseif (F <= 194) then
                if (F >= 188) then
                    if (F <= 188) then
                        M = t
                        F = ((M and 79) or (347 - F))
                    else
                        H, h, E = H(h, E)
                        H, h, E = D.g(H, h, E)
                        o = H(h, E)
                        E = o
                        F = (((E == nil) and 145) or 55)
                    end
                elseif (F > 178) then
                    F, o = (354 - F), o(v, A)
                    M = o
                else
                    b = 3379752113
                    F = (((t ~= b) and 46) or (218 - F))
                end
            elseif (F > 215) then
                F, f = (F + (- 17)), f(D.i(t))
                b, G, t, M, H = f, w, k[2], 1, 3
                B = (n + H)
            elseif (F <= 200) then
                F, H = 1, j
            else
                F, G = 93, 859790127
                b = (M == G)
            end
        elseif (F <= 62) then
            if (F > 40) then
                if (F > 58) then
                    if (F <= 61) then
                        F = 115
                    else
                        M, f, t, F, b = C, k[15], J, (161 - F), q
                    end
                elseif (F >= 55) then
                    if (F <= 55) then
                        F, r, A = (F + 56), 127, I[4][3][I[4][2]]
                        e, z, r = o, (B * r), I[3][3][I[3][2]]
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
                        t = 6
                        f = (n + t)
                        j[f] = L
                        F = (((s > t) and 129) or (172 - F))
                    end
                elseif (F > 46) then
                    d, w, J, s = 78, p[12], 60, 72
                    q, J, n = 51, p[24], (w - J)
                    w, q = (J - q), 1
                    J, C = (n + q), 2
                    x, t, F, q = j[n], 1, 20, (n + C)
                else
                    F, b, t = 81, x, I[5][3][I[5][2]]
                end
            elseif (F <= 21) then
                if (F >= 16) then
                    if (F < 20) then
                        F, M, G = 27, t["__iter"], nil
                        b = (M ~= G)
                    elseif (F <= 20) then
                        f = (n + t)
                        L, b = j[f], C
                        t = (n + b)
                        F, b, M, f = 63, I[2][3][I[2][2]], x, j[t]
                    else
                        f, t, b, M = f(t, b)
                        c, y, f, x, L = t, f, 2, b, M
                        F = (((w == f) and (104 - F)) or 220)
                    end
                elseif (F > 1) then
                    b, M, G = b(M)
                    c, C, y = G, b, M
                    F = (((s <= d) and 105) or (956 / F))
                else
                    t(b, M, G, B, H)
                    F, y = 129, f[1]
                end
            elseif (F >= 34) then
                if (F <= 34) then
                    F, G = 194, G(B)
                    E, B, h, H = ".", 65599, G, I[1][3][I[1][2]]
                else
                    c, y, C = f, L, x
                    F = (((K <= l) and (5680 / F)) or (145 - F))
                end
            else
                F = ((b and 137) or (F + 161))
            end
        elseif (F < 84) then
            if (F <= 81) then
                if (F <= 79) then
                    if (F >= 70) then
                        if (F <= 70) then
                            b, f, t, M = nil, nil, g, _
                            return f, t, b, M
                        else
                            F, M = (238 - F), t["__call"]
                        end
                    else
                        F, b = 61, b(M)
                        H, B, G, M = ".", b, I[1][3][I[1][2]], 5381
                    end
                else
                    t = t(b)
                    M = nil
                    b = (t ~= M)
                    F = ((b and (97 - F)) or (2187 / F))
                end
            elseif (F > 82) then
                t = 3
                f = (n + t)
                j[f] = y
                F, t = (10707 / F), 4
                f = (n + t)
                j[f] = c
            else
                b, M, G = b(M)
                F, c, C, y = 105, G, b, M
            end
        elseif (F > 99) then
            if (F < 105) then
                M, F, b = x, (183 - F), I[6][3][I[6][2]]
            elseif (F <= 105) then
                j[n], K = C, 124
                j[J] = y
                F, j[q] = (251 - F), c
                c, J = 1, j[n]
                y = (n + c)
                c, q = 2, j[y]
                y = (n + c)
                c, y, C = nil, nil, j[y]
            else
                r = r(e)
                F, u, z = (16650 / F), (z + r), 4294967295
            end
        elseif (F <= 98) then
            if (F > 93) then
                t = 3
                f = (n + t)
                j[f] = y
                F = (((d < t) and (F + 90)) or (227 - F))
            elseif (F > 84) then
                F = ((b and 101) or 40)
            else
                F, K, l, t = 178, 175, 162, M
            end
        else
            F, t = (316 - F), D.h(t(b, M))
        end
    end
end
