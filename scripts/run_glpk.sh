#* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
#*                                                                           *
#*            This file is part of the test engine for MIPLIB2010            *
#*                                                                           *
#* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# $Id: run_glpk.sh,v 1.3 2011/07/05 09:28:12 bzfheinz Exp $

SOLVER=$1
BINNAME=$2
NAME=$3
TIMELIMIT=$4
SOLFILE=$5
THREADS=$6
MIPGAP=$7

echo > $SOLFILE

# set threads to given value 
# nothing to be done for GLPK

# turn on feability pump and cuts
PARAMETERS="--fpump --cuts"

# set mipgap to given value
PARAMETERS=$PARAMETERS" --mipgap $MIPGAP"

# set timing to wall-clock time and pass time limit
PARAMETERS=$PARAMETERS" --tmlim $TIMELIMIT"

# use deterministic mode (warning if not possible) 
# nothing to be done for GLPK

# check for lp format 
LP=`echo $NAME | grep "\.lp"`
if test $LP
then
    PARAMETERS=$PARAMETERS" --lp"
fi

# run GLPK
$BINNAME $PARAMETERS $NAME -o $SOLFILE

if test -e $SOLFILE
then
    # translate GLPK solution format into format for solution checker. The
    # SOLFILE format is a very simple format where in each line we have a
    # <variable, value> pair, separated by spaces.  A variable name of
    # =obj= is used to store the objective value of the solution, as
    # computed by the solver. A variable name of =infeas= can be used to
    # indicate that an instance is infeasible.
    awk '
    BEGIN {
       start = 0;
    }
    /^Objective: / {
       printf ("=obj= %s \n", $4);
    }
    /^Integer feasibility conditions:/ {
       exit;
    }
    /^[0-9 ]/{
       if( start )
       {
          if( $3 == "*" )
             printf ("%s %s \n", $2, $4);
          else
             printf ("%s %s \n", $2, $3);
       }
    }
    /Column name/ {
       start = 1;
    }' $SOLFILE > $SOLFILE.tmp

    mv $SOLFILE.tmp $SOLFILE
fi