#                             Copyright (c) 2018-2018
#            Data Intensive Applications and Systems Laboratory (DIAS)
#                    Ecole Polytechnique Federale de Lausanne
#
#                               All Rights Reserved.
#
#       Permission to use, copy, modify and distribute this software and its
#     documentation is hereby granted, provided that both the copyright notice
#   and this permission notice appear in all copies of the software, derivative
#   works or modified versions, and any portions thereof, and that both notices
#                       appear in supporting documentation.
#
#   This code is distributed in the hope that it will be useful, but WITHOUT ANY
#  WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
#  A PARTICULAR PURPOSE. THE AUTHORS AND ECOLE POLYTECHNIQUE FEDERALE DE LAUSANNE
# DISCLAIM ANY LIABILITY OF ANY KIND FOR ANY DAMAGES WHATSOEVER RESULTING FROM THE
#                              USE OF THIS SOFTWARE.

# Settings are taken in the following order of precedence:
#  1. Shell Environment, or on the command line

#  2. Node-specific settings `settings.local.<Alias>.sh`
if test ! -z "$1" && test -f ./settings.local.$1.sh;
then
	. ./settings.local.$1.sh;
fi

#  3. Federation-specific `settings.local.sh`
if test -f ./settings.local.sh;
then
	. ./settings.local.sh;
fi

#  4. Default settings `settings.default.sh`
if test -f ./settings.default.sh;
then
	. ./settings.default.sh;
fi

if ${SHOW_SETTINGS};
then
	echo "Current settings:"
fi

for v in $(grep '^:' settings.default.sh|cut -c 5- |cut -d: -f1)
do
	eval "export $v=\"\$$v\""
	if ${SHOW_SETTINGS};
	then
		eval "echo $v=\$$v"
	fi
done

if ${SHOW_SETTINGS};
then
	echo
fi
