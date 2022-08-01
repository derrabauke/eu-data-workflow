#! usr/bin/awk -f

function is_empty(column) {
	return (length(column) == 2)
}

function is_date(column) {
	return column ~ /[0-9]{4}-[0-9]{2}-[0-9]{2}\s[0-9]{2}:[0-9]{2}:[0-9]{2}/
}

function is_url(column) {
	return column ~ /(www|http:|https:)+[^\s]+[\w]/
}

function is_rcn(column) {
	return column ~ /[0-9]{1,3}\.[0-9]+/
}

function is_recent_update(date_string, LR) {
	_date = date_string
	gsub(/"/, "",_date)
	return (LR <= _date)
}

# function correct_index(column, idx, row) {
# 	if (is_url(column)) {
# 		$idx = column = $(idx + 1)
# 		print "corrected column? " $idx
# 	} else if (is_rcn(column)) {
# 		$idx = column = $(idx - 1)
# 	}
# }

BEGIN {
	FS = ","
	dummy = "0000-00-00 00:00:00"
	dummy_length = length(dummy)
	error_rows[0] = "ERROR_ROWS"
}

#main loop
{
	# print headers
	if (NR == 1)
		print;
	else {
		dt = $CUD;
		
		# skip lines with empty update date
		if (is_empty(dt))
			getline;

		# rounds = 0
		# while(! is_date(dt)) {
		# 	rounds++;
		# 	if(rounds > 2){
		# 		break
		# 	}
		# 	correct_index(dt, CUD, $0)
		# }

		if(! is_date(dt)) {
			idx = length(error_rows)
			error_rows[idx] = $0
		} else if(is_recent_update(dt, LR)) {
			print
		}
	}
}

END {
	print error_rows[0] > "error_rows.txt"
	err_length = length(error_rows)
	for(i=1; i<err_length; i++){
		print error_rows[i] >> "error_rows.txt"
	}
}

