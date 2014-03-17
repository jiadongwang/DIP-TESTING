#* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
#*                                                                           *
#*            This file is part of the test engine for MIPLIB2010            *
#*                                                                           *
#* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# $Id: run_cplex.sh,v 1.6 2011/03/21 13:52:23 bzfgamra Exp $

SOLVER=$1
BINNAME=$2
NAME=$3
TIMELIMIT=$4
SOLFILE=$5
THREADS=$6
MIPGAP=$7

TMPFILE=check.$SOLVER.tmp

echo > $TMPFILE
echo > $SOLFILE
block='.dec' 
#$BINNAME --DECOMP:BlockNumInput 3 --MILP:Instance $NAME
$BINNAME --DECOMP:LimitTime $TIMELIMIT --DECOMP:SolutionOutputFileName $SOLFILE --MILP:Instance $NAME --MILP:BlockFile ${NAME%.*}$block

if test -e $SOLFILE
then
    # translate DIP solution format into format for solution checker.
    #  The SOLFILE format is a very simple format where in each line 
    #  we have a <variable, value> pair, separated by spaces. 
    #  A variable name of =obj= is used to store the objective value 
    #  of the solution, as computed by the solver. A variable name of 
    #  =infeas= can be used to indicate that an instance is infeasible.
    # The nice part of DIP solution format is that it is coded in the way
    # that follows the pattern of solution checker
    if test ! -s $SOLFILE
    then
	# empty file, i.e., no solution given 
	echo "=infeas=" > $SOLFILE
   fi
fi

