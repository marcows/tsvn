#!/bin/sh

# TortoiseSVN command line client wrapper
#
# This is a wrapper around the 'tortoiseproc' executable. The invocation is
# compatible to the 'svn' command line client.

# No arguments given on command line -> print usage and quit
if test "$#" -eq 0
then
	echo "usage: $0 <command> [PATH...]"
	echo "TortoiseSVN command-line client wrapper."
	echo
	echo "Available subcommands:"
	echo "   blame (praise, annotate, ann)"
	echo "   commit (ci)"
	echo "   diff (di)"
	echo "   help (?, h)"
	echo "   list (ls)"
	echo "   log"
	echo "   proplist (plist, pl)"
	echo "   status (stat, st)"
	echo "   update (up)"
	exit 0
fi

# command mapping for tortoiseproc
case "$1" in
blame|praise|annotate|ann)
	TORTOISECMD=blame;;
commit|ci)
	TORTOISECMD=commit;;
diff|di)
	TORTOISECMD=diff;;
help|\?|h)
	TORTOISECMD=help;;
list|ls)
	TORTOISECMD=repobrowser;;
log)
	TORTOISECMD=log;;
proplist|plist|pl)
	TORTOISECMD=properties;;
status|stat|st)
	TORTOISECMD=repostatus;;
update|up)
	TORTOISECMD=update;;
*)
	# Unknown subcommand -> abort
	echo "Unknown subcommand: '$1'"
	echo "Type '$0' for usage."
	exit 1
	;;
esac

# Shift away $1 (tsvn.sh subcommand) for parameter parsing
shift

# Parse parameters
TORTOISEPATH=
for path in "$@";
do
	# Concatenate path names using the asterisk character '*' as path separator
	TORTOISEPATH="$TORTOISEPATH$path*"
done

# Adapt path parameter for tortoiseproc
if test -z "$TORTOISEPATH"
then
	# No path parameter given on command line -> use the current directory '.' as default
	#TORTOISEPATH=.
	# "." does not work with Unix paths, use absolute path and convert "/c/..." to "C:/..."
	TORTOISEPATH="C:${PWD##/c}"
else
	# Remove trailing asterisk
	TORTOISEPATH="${TORTOISEPATH%%\*}"
fi

set -x
start tortoiseproc /command:$TORTOISECMD /path:"$TORTOISEPATH"
