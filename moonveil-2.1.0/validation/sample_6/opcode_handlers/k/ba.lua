-- Analysis: VM opcode handler, NOT the user program.
function(g, r, A, l, m, s, v)
    local b, i, a, x, _, y, o, e, t, n, f, u, h, k, d, z, p
    i = 94
    while true do
        if (i <= 113) then
            if (i >= 78) then
                if (i < 94) then
                    if (i < 85) then
                        i = (((k < y) and 143) or (14742 / i))
                    elseif (i <= 85) then
                        i = (7650 / i)
                    else
                        t = t(n)
                        a, u = 7, r[26]
                        i, n, u = 188, (u - a), c[1][3][c[1][1]]
                    end
                elseif (i >= 101) then
                    if (i > 101) then
                        a, k, y, u = m[18], 1, h, v
                        e = k
                        i = (((y ~= y) and 143) or 248)
                    else
                        p = z[14]
                        b, x = nil, A[p]
                        i = (((x == b) and 205) or 227)
                    end
                elseif (i <= 94) then
                    h, d, u, _, n = m[3], 134, 17, 241, r[25]
                    i, t = 19, (n - u)
                    o = h[t]
                else
                    i = (((e <= 0) and (4410 / i)) or 74)
                end
            elseif (i <= 45) then
                if (i < 32) then
                    if (i > 9) then
                        n, t = 59, r[14]
                        h, t = (t - n), m[22]
                        i, n = 85, h
                    else
                        i = (((k > y) and (i + 134)) or 152)
                    end
                elseif (i > 32) then
                    i = (((k < y) and (188 - i)) or 74)
                else
                    i = (((k > y) and 143) or 98)
                end
            elseif (i <= 50) then
                k = (k + e)
                i = (((e > 0) and 32) or 98)
            else
                i = (((e ~= e) and (217 - i)) or 189)
            end
        elseif (i < 189) then
            if (i >= 152) then
                if (i >= 181) then
                    if (i > 181) then
                        a, i, k = o, 247, t
                    else
                        a, k, y, u, n = v, nil, s, nil, nil
                        return n, u, a, k, y
                    end
                else
                    i = (((e ~= e) and 78) or 139)
                end
            elseif (i <= 139) then
                i = (((e <= 0) and (10842 / i)) or (i + 50))
            else
                i, v = 181, u
            end
        elseif (i < 227) then
            if (i <= 193) then
                if (i > 189) then
                    x = z[14]
                    p = a[x]
                    i, t[k] = (243 - i), p
                else
                    z, f = n[u], 1
                    u, f, p = (u + f), z[26], 1
                    i = (((f == p) and 101) or (36477 / i))
                end
            else
                b = {}
                b[1] = p
                i, b[3] = 227, l
                x = b
                A[p] = x
            end
        elseif (i > 247) then
            i = (((e > 0) and (257 - i)) or 152)
        elseif (i > 227) then
            i, u = 113, u(a, k)
            l[n] = u
            n = m[9]
        else
            t[k] = x
            i = (((_ >= d) and (i + (- 177))) or (416 - i))
        end
    end
end
