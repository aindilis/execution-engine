# # trap 'execution-engine --bash $BASH_COMMAND' DEBUG

export EXECUTION_ENGINE=1

# give credit to https://github.com/postmodern/chruby/issues/189
function preexec_invoke_exec () {
	[ -n "$COMP_LINE" ] && return
	[ "$BASH_COMMAND" = "$PROMPT_COMMAND" ] && return
	[ ! "$EXECUTION_ENGINE" ] && return
	execution_engine_filter
}

function execution_engine_filter () {
    /var/lib/myfrdcsa/codebases/minor/execution-engine/scripts/execution-engine --bash $BASH_COMMAND
    if [ $? -eq 1 ]; then
	echo "Execution-Engine: cancelled: $BASH_COMMAND" >&2
	return 1
    fi
    return 0
}

function execution_engine_filter_debug() {
    /var/lib/myfrdcsa/codebases/minor/execution-engine/scripts/execution-engine --bash $BASH_COMMAND
    return 1
}

shopt -s extdebug
trap preexec_invoke_exec DEBUG

# trap execution_engine_filter DEBUG


# https://www.gnu.org/software/bash/manual/bash.html#The-Shopt-Builtin-1

# trap 'myHandler' DEBUG

# You can, just enable extdebug and return a non-zero code (See the
# description of extdebug option) from myHandler:

# function myHandler() {
#     if [[ $SKIP = "true" ]]; then return 1; fi;
#     echo 'myHandler execute'
# }

# $ trap 'myHandler' DEBUG
# $ shopt -s extdebug
# $ echo 1
# myHandler execute
# 1
# $ SKIP=true
# myHandler execute
# $ echo 1

# # This will run before any command is executed.
# function PreCommand() {
#   if [ -z "$AT_PROMPT" ]; then
#       return
#         fi
# 	  unset AT_PROMPT

#   # Do stuff.
#     echo "Running PreCommand"
#     }
#     trap "PreCommand" DEBUG

# # This will run after the execution of the previous full command line.  We don't
# # want it PostCommand to execute when first starting a bash session (i.e., at
# # the first prompt).
# FIRST_PROMPT=1
# function PostCommand() {
#   AT_PROMPT=1

#   if [ -n "$FIRST_PROMPT" ]; then
#       unset FIRST_PROMPT
#           return
# 	    fi

#   # Do stuff.
#     echo "Running PostCommand"
#     }
# PROMPT_COMMAND="PostCommand"
