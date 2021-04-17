#!/bin/awk -f

BEGIN {
	RS = ":"
	HOME = "/home/mmmchris"
	BITMAPS = HOME"/""Images/bitmaps"
	SEP = BITMAPS"/fn26/tri/mid_right_tri_stripe.xbm"
	DIFFSEP = BITMAPS"/fn26/tri/mid_right_tri_outline.xbm"
	FORE = "#ffffff"
	BACK = "#303030"
	# OK = occupied
	OKCOL = "#303030"
	UNOKCOL = "#505050"
	EMPTYCOL = "#707070"
	LAYOUTCOL = "#44aabb"
	TITLECOL = "#800080"
	SEPCOL = "#000000"
	PREVCOL = ""
	STR = ""
}

function tagTransition( curbg, txt ){
	
	if ( STR == "" ) {
		aux = sprintf("^fg()^bg(%s) %s ^fg()^bg()", curbg, txt)
	} else if ( PREVCOL == curbg ) {
		aux = sprintf("^fg()^bg(%s) %s^fg(%s)^bg(%s)^i(%s)^fg()^bg()", \
		    curbg, txt, SEPCOL, curbg, DIFFSEP)
	} else  {
		aux = sprintf("^fg()^bg(%s) %s^fg(%s)^bg(%s)^i(%s)^fg()^bg()", \
		    curbg, txt, PREVCOL, curbg, SEP)
	}

	TMPSTR = sprintf("%s:%s", STR, aux)
	STR = TMPSTR
	PREVCOL = curbg

	return 0
}

function prependSep( curbg, txt ) {
	TMPSTR = sprintf("%s:^fg()^bg(%s) %s^fg(%s)^bg(%s)^i(%s)", \
	       STR, curbg, txt, PREVCOL, curbg, SEP)
	STR = TMPSTR
	PREVCOL = curbg
}

## SKIPPING
# skip empty fields, skip empty tags, skip monitor number
/^$/ || /^%e .+ %f$/ || /^[0-9][ \t\n]*$/ {
	next
}

## TAGS
# focused & empty
/^%E .* %f/ {
	tagTransition( EMPTYCOL, $2 )
	next
}

# unfocused & occupied
/^%o [1-9] %f/ {
	tagTransition( UNOKCOL, $2 )
	next
}
# focused & occupied
/^%O .* %f/ {
	tagTransition( OKCOL, $2 )
	next
}

## LAYOUT
/^...$/ {
	prependSep( LAYOUTCOL, $0 )
	next
}

## TITLE (only thing left)
{
	n = split($0, arr)
	prependSep( TITLECOL, arr[n] )
	next
}

END {
	gsub("\n", "", STR)
	TMPSTR = sprintf("%s:^fg(%s)^bg(%s)^i(%s)", STR, PREVCOL, BACK, SEP)
	STR = TMPSTR
	n = split(STR, arr, ":")

	# Print backwards
	for( i = n; i > 0; i-- ) {
		printf "%s", arr[i]
	}
	printf "\n"
	exit 0
}
