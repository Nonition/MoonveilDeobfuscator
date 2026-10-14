-- Analysis: VM dispatch driver.
function(B, G, x, z)
    local v = a[1][3][a[1][1]]
    local n = B[9]
    local F = B[12]
    local K, L = 1, (- 1)
    while true do
        local y = n[K]
        K = (K + 1)
        local J, E, M, I, N = v[y[17]](x, y, z, G, B, L, K)
        if E then
            return F(G, I, ((I + J) - 1))
        end
        K, L = M, N
    end
end
