It seems like there's some way to add custom policies, and there's some distinction between built-in and custom policies, but it seems easier to just add another built-in policy.

d4.h: declare added functions (extern).
ref.c: Add a function that implements the actual replacement policy. Model after d4rep_lru, etc.
misc.c: Add a function to initialize data structures for new policy. Like d4init_rep_lru.
misc.c: Add macro to allow policy activation. See code with c->replacement.
cmdargs.c: Add policy to phelp_replacement
cmdargs.c: Add to "allowable replacement polocies"
cmdargs.c: Add to "c->replacementf = ..."

