-- Analysis: VM opcode handler, NOT the user program.
function(g, r, A, l, m, s, v)
    local h, x, z, t, y, p, b, e, o, _, f, i, u, a, d, n, k
    i = 192
    repeat
        if (i > 123) then
            if (i <= 177) then
                if (i > 161) then
                    if (i > 163) then
                        i = (((k < y) and (36108 / i)) or 206)
                    else
                        i, k, a = (i + (- 37)), t, m[1]
                    end
                elseif (i < 153) then
                    if (i > 126) then
                        u, n, a, k, y = nil, nil, v, nil, s
                        return n, u, a, k, y
                    else
                        i, u = (203 - i), u(a, k)
                        l[n] = u
                        n = m[9]
                    end
                elseif (i <= 153) then
                    i = (((e > 0) and 12) or (i + (- 98)))
                else
                    b = {}
                    b[1] = p
                    b[3] = l
                    x = b
                    A[p] = x
                    i = (((_ < d) and (i + (- 95))) or (i + (- 120)))
                end
            elseif (i >= 206) then
                if (i > 241) then
                    i = (((e <= 0) and 111) or 58)
                elseif (i > 206) then
                    i = (18798 / i)
                else
                    f, _, d, z = 1, 137, 18, n[u]
                    p, u, f = 1, (u + f), z[26]
                    i = (((f == p) and (13596 / i)) or (i + (- 83)))
                end
            elseif (i > 192) then
                i, v = (30192 / i), u
            else
                u, _, h, n = 59, 215, m[19], r[25]
                t = (n - u)
                i, o = 0, h[t]
            end
        elseif (i <= 77) then
            if (i > 55) then
                if (i < 66) then
                    i = (((e ~= e) and 204) or (11948 / i))
                elseif (i > 66) then
                    y, a, k, u = h, m[18], 1, v
                    e = k
                    i = (((y ~= y) and 204) or (230 - i))
                else
                    p = z[14]
                    b, x = nil, A[p]
                    i = (((x == b) and 161) or 41)
                end
            elseif (i >= 41) then
                if (i <= 41) then
                    i, t[k] = 94, x
                else
                    i = (((e ~= e) and (i + 122)) or 106)
                end
            elseif (i <= 0) then
                t, n = r[14], 2
                h, t = (t - n), m[22]
                i, n = (241 - i), h
            else
                i = (((k > y) and (i + 192)) or 55)
            end
        elseif (i >= 106) then
            if (i < 111) then
                i = (((e <= 0) and 177) or 206)
            elseif (i > 111) then
                x = z[14]
                i, p = (217 - i), a[x]
                t[k] = p
            else
                i = (((k < y) and (i + 93)) or (i + (- 53)))
            end
        elseif (i > 88) then
            k = (k + e)
            i = (((e > 0) and 88) or 246)
        elseif (i <= 78) then
            t = t(n)
            u, a = r[26], 31
            u, n = o, (u - a)
            i = (((_ <= a) and 161) or (12714 / i))
        else
            i = (((k > y) and 204) or 246)
        end
    until false
end
