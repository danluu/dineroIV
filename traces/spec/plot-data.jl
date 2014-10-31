# This basically doesn't work due to a Gadfly bug that's been open for more than half a year.

using DataFrames
# using Gadfly

# const levels = [1,2,3]
const levels = [1]
const policies = ["r", "f", "l", "2","b","c"]
# const policies = ["l","2"]
const cache_sizes = 16:25 # 2^16:2^25
# const cache_sizes = 18:25 # 2^18:2^25
const cache_assocs = [4, 8, 16, 32, 64]

function bogus_plots(df)
    ndf = normalize_df(df)

    # this kinda works, but it groups together different cache levels
    plot(df, x="name", y="miss", color="policy", Geom.bar(position=:dodge))
    
    # plot l1s
    plot(df[df[:level].==1,:], x="name", y="miss", color="policy", Geom.bar(position=:dodge))

    plot(ndf[ndf[:level].==1,:], x="name", y="miss_ratio", color="policy")

    # extract miss rate for a single thing
    df[(df[:level].==1) .* (df[:name].=="164.gzip") .* (df[:policy].=="r"),:miss]

    # extract miss rate for a single thing
    ndf[(ndf[:level].==1) .* (ndf[:name].=="164.gzip") .* (ndf[:policy].=="r"),:miss]
end


function normalize_df(df, reference::String)
    miss_ratio = Array(Float64, 0)
    ref = df[df[:policy].==reference,:]
    for row in eachrow(df)
        row_name = row[:name]
        row_level = row[:level]
        row_size = row[:size]
        row_assoc = row[:assoc]
        ref_miss = ref[(ref[:level].==row_level) .* (ref[:name].==row_name) .* (ref[:size].==row_size) .* (ref[:assoc].==row_assoc),:miss][1]
        row_miss = row[:miss]
        push!(miss_ratio, row_miss / ref_miss)
    end
    ndf = df
    ndf[:miss_ratio] = miss_ratio
    ndf
end

function geom_mean(xs::DataArray)
    acc = 0

    # we know we only have 10-ish items, each close to 1.0, 
    # so we don't need to worry about numerical error from summing here.
    for x in xs
        acc += log(x)
    end
    e^(acc/length(xs))
end

function geom_mean(ndf::DataFrame, policy::String, level::Int, size::Int, assoc::Int)    
    miss_ratio = ndf[(ndf[:level].==level) .* (ndf[:policy].==policy)  .* (ndf[:size].==size) .* (ndf[:assoc].==assoc),:miss_ratio]
    geom_mean(miss_ratio)
end

function get_means()
    df = readtable("size-assoc.csv")
    ndf = normalize_df(df, "l") # normalize to LRU
    writetable("size-assocb.csv", ndf)
    for l in levels, p in policies, s in cache_sizes, a in cache_assocs
        println("$l,$p,$s,$a,$(geom_mean(ndf, p, l, s, a))")
    end    
end

get_means()
