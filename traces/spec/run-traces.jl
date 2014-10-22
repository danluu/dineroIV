#inputs to dineroIV argument. lru, fifo, random, or 2choies
const evict_policies = ["l", "f", "r", "2"]
const maxtrace = "1"

# Missing args: -lN-Trepl, -trname, -maxtrace
# Note: making l1i lru all the time
const base_args = """../../../../dineroIV \\
-l1-iassoc 8 -l1-ibsize 64 -l1-isize 32k -l1-irepl l \\
-l1-dassoc 8 -l1-dbsize 64 -l1-dsize 32k \\
-l2-uassoc 8 -l2-ubsize 64 -l2-usize 256k \\
-l3-uassoc 8 -l3-ubsize 64 -l3-usize 2m \\
-informat s \\
"""

function get_trace_dirs(trace_type::String)
    assert(trace_type == "int" || trace_type == "fp")
    readdir("./$trace_type/")
end

# dineroIV must be run from the directory that includes the trace files
# if we use -trname, which explains some of the oddness here.
function make_dinero_args(base_args::String, evict_policy::String, trname::String, maxtrace::String,
                          out_name::String)
    string(base_args,
  """ -l1-drepl $evict_policy -l2-urepl $evict_policy -l3-urepl $evict_policy \\
      -trname $trname \\
      -maxtrace $maxtrace \\
      > $out_name""")
end

function get_trname_from_dir(dir::String)
    # dir is something like 164.gzip.
    # we want somthing like gzip_m2b
    
    string(split(dir,'.')[2], "_m2b")
end

function run_traces()
    dirs = get_trace_dirs("int")    
    for dir in dirs, evict_policy in evict_policies
        trname = get_trname_from_dir(dir)
        out_name = "../../output/$dir.$evict_policy.out"
        dargs = make_dinero_args(base_args, evict_policy, trname, maxtrace, out_name)
        # It's pretty painful to execute something from julia, and there's a year old bug
        # that's still oustanding that will significantly change things when it's fixed.
        # Furthermore `Cmd` seems to be generally quite buggy in julia.
        # Rather than write something which may encounter more bugs and will break
        # if/when `Cmd` is fixed, I'm writing out a file that some other script can execute.
        script_name = "int/$dir/$dir.$evict_policy.sh"
        f = open(script_name, "w")
        write(f, dargs)
        close(f)
    end
end

println(run_traces())
