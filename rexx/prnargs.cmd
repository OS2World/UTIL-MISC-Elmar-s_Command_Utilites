/* simply print parsed args line by line */
parse arg args; .local~args=args;
call SplitArgs;
args.=.local~argary;

/* args are parsed due to quotation */
/* ^-substitution is performed by cmd: ^< -> <, ^^ -> ^ */
DO i=1 TO args.0
  say args.i
END;

exit

::requires common.rlb

