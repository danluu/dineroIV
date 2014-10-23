# This basically doesn't work due to a Gadfly bug that's been open for more than half a year.

using DataFrames
using Gadfly

df = readtable("sandy-bridge.csv")

# this kinda works, but it groups together different cache levels
plot(df, x="name", y="miss", color="policy", Geom.bar(position=:dodge))

# plot l1s
plot(df[df[:level].==1,:], x="name", y="miss", color="policy", Geom.bar(position=:dodge))

plot(ndf[ndf[:level].==1,:], x="name", y="miss_ratio", color="policy")

# extract miss rate for a single thing
df[(df[:level].==1) .* (df[:name].=="164.gzip") .* (df[:policy].=="r"),:miss]

# extract miss rate for a single thing
ndf[(ndf[:level].==1) .* (ndf[:name].=="164.gzip") .* (ndf[:policy].=="r"),:miss]


function normalize_df(df)
    miss_ratio = Array(Float64, 0)
    ref = df[df[:policy].=="r",:]
    for row in eachrow(df)
        row_name = row[1]
        row_level = row[3]
        ref_miss = ref[(ref[:level].==row_level) .* (ref[:name].==row_name),:miss][1]
        row_miss = row[4]
        push!(miss_ratio, row_miss / ref_miss)
    end
    println(length(miss_ratio))
    ndf = df
    ndf[:miss_ratio] = miss_ratio
end

