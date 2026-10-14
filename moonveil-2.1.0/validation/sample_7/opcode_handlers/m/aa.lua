-- Analysis: VM opcode handler, NOT the user program.
function(p, a, k, m, g, j, _)
    local r, t, d, b, n, o, f, w, x, c, y, l, C, q, e, h, i, z, u
    z = 184
    repeat
        if (z <= 149) then
            if (z <= 116) then
                if (z < 69) then
                    if (z <= 2) then
                        if (z <= 1) then
                            z = (((d > 0) and (z + 111)) or (z + 126))
                        else
                            z = (((d ~= d) and (247 - z)) or (466 / z))
                        end
                    else
                        z, r = (5088 / z), {}
                        r[2] = b
                        r[3] = j
                        i = r
                        a[b] = i
                    end
                elseif (z > 112) then
                    b = f[24]
                    r, i = nil, a[b]
                    z = (((i == r) and 32) or (z + 43))
                elseif (z <= 80) then
                    if (z <= 69) then
                        y = 3
                        C, y, z, q, c = s[1][3][s[1][2]], n, (10281 / z), (C - y), l
                    else
                        c = (c + d)
                        z = (((d > 0) and (269 - z)) or 211)
                    end
                else
                    z = (((c > x) and (357 - z)) or 127)
                end
            elseif (z >= 135) then
                if (z < 137) then
                    z = (((c < x) and (z + 110)) or 2)
                elseif (z > 137) then
                    C = C(y, c)
                    j[q] = C
                    C, q, x, z, y, c = _, k[9], w, 154, k[11], 1
                else
                    z = (((c < x) and 245) or (370 - z))
                end
            elseif (z <= 121) then
                z = (((d <= 0) and (16577 / z)) or 233)
            else
                z = (((d ~= d) and (264 - z)) or (248 - z))
            end
        elseif (z >= 205) then
            if (z > 233) then
                if (z > 245) then
                    c, y, C, q = _, nil, g, nil
                    return q, C, y, c
                else
                    _ = C
                    z = (((e > h) and (z + (- 213))) or (61250 / z))
                end
            elseif (z < 211) then
                z, l = 69, l(q)
                C = p[12]
            elseif (z <= 211) then
                z = (((d <= 0) and 135) or (422 / z))
            else
                f, t = q[C], 1
                t, C, b = f[12], (C + t), 1
                z = (((t == b) and 116) or 151)
            end
        elseif (z < 159) then
            if (z > 151) then
                o, e, d, u, h = 57, 101, c, 143, 251
                z = (((x ~= x) and (37730 / z)) or 1)
            else
                i = f[24]
                b = y[i]
                l[c] = b
                z = (((u < o) and 184) or (231 - z))
            end
        elseif (z <= 184) then
            if (z > 159) then
                q, C, w = p[23], 46, k[4]
                z, l = 205, (q - C)
                l, q, n = p[24], 9, w[l]
                w, l = (l - q), k[28]
                q = w
            else
                z, l[c] = (239 - z), i
            end
        else
            z = (((c > x) and 245) or (z + 22))
        end
    until false
end
