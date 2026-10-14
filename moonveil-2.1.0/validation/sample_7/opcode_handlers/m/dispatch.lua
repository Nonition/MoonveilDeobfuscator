-- Analysis: VM dispatch driver.
function(z, G, A, y)
    local v = a[1][3][a[1][2]]
    local n = z[9]
    local F = z[25]
    local K, L = 1, (- 1)
    while true do
        local x = n[K]
        K = (K + 1)
        local J, N, I, M, E = v[x[26]](x, y, z, A, L, G, K)
        if E then
            return F(G, I, ((I + J) - 1))
        end
        K, L = M, N
    end
end
