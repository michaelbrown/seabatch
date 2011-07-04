;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
FLAT_FILE_XDIM='766'
FLAT_FILE_YDIM='383'

FLAT_FILE_WEST='-134'
FLAT_FILE_EAST='-132'
FLAT_FILE_NORTH='70'
FLAT_FILE_SOUTH='69'

TIMESERIES_RESOLUTION_AMOUNT='1'
TIMESERIES_RESOLUTION_CLASS='DAY'

TIMESERIES_START_TIME='2007001000000'
TIMESERIES_END_TIME=  '2009365000000'

STATISTIC='MEAN'

TIMESERIES_REGIONS_TEXT_FILE='/home/mike/bin/seabatch/seabatch1.2/sub/scripts/time_series/kugmallit_regions.txt'
TIMESERIES_TEXT_FILE=TIMESERIES_START_TIME + '_to_' + TIMESERIES_END_TIME + '_' + TIMESERIES_RESOLUTION_AMOUNT + TIMESERIES_RESOLUTION_CLASS + '_' + STATISTIC + '_timeseries.txt'
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SEABATCH_SCRIPT_NAME='timeseries.sbf'
SEABATCH_SCRIPT_VERSION='1.0'
SEPARATOR='==========================================================================='

print, ''
print, ''
print, SEPARATOR
print, SEPARATOR
print, 'Running ', SEABATCH_SCRIPT_NAME, ', v', SEABATCH_SCRIPT_VERSION, ' ...'
print, SEPARATOR
print, SEPARATOR
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Define FLOAT_FLAT_FILE_XDIM, FLOAT_FLAT_FILE_YDIM, FLOAT_FLAT_FILE_WEST,
;FLOAT_FLAT_FILE_EAST, FLOAT_FLAT_FILE_NORTH, and FLOAT_FLAT_FILE_SOUTH,
;the results of converting FLAT_FILE_XDIM, FLAT_FILE_YDIM, FLAT_FILE_WEST
;FLAT_FILE_EAST, FLAT_FILE_NORTH, and FLAT_FILE_SOUTH from string variables
;to floating point variables.

FLOAT_FLAT_FILE_XDIM=float(FLAT_FILE_XDIM)
FLOAT_FLAT_FILE_YDIM=float(FLAT_FILE_YDIM)

FLOAT_FLAT_FILE_WEST=float(FLAT_FILE_WEST)
FLOAT_FLAT_FILE_EAST=float(FLAT_FILE_EAST)
FLOAT_FLAT_FILE_NORTH=float(FLAT_FILE_NORTH)
FLOAT_FLAT_FILE_SOUTH=float(FLAT_FILE_SOUTH)

;help, FLOAT_FLAT_FILE_XDIM, FLOAT_FLAT_FILE_YDIM, FLOAT_FLAT_FILE_WEST, FLOAT_FLAT_FILE_EAST, FLOAT_FLAT_FILE_NORTH, FLOAT_FLAT_FILE_SOUTH

;Define INTEGER_TIMESERIES_RESOLUTION_AMOUNT, the result of converting
;TIMESERIES_RESOLUTION_AMOUNT from a string variable to an integer variable.
	
INTEGER_TIMESERIES_RESOLUTION_AMOUNT=fix(TIMESERIES_RESOLUTION_AMOUNT)
	
;help, INTEGER_TIMESERIES_RESOLUTION_AMOUNT
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Define FLAT_FILE_LONGITUDE_RANGE and FLAT_FILE_LATITUDE_RANGE, the 
;longitude and latitude ranges of the flat files.


FLAT_FILE_LONGITUDE_RANGE=FLOAT_FLAT_FILE_EAST - FLOAT_FLAT_FILE_WEST
FLAT_FILE_LATITUDE_RANGE=FLOAT_FLAT_FILE_NORTH - FLOAT_FLAT_FILE_SOUTH

;help, FLAT_FILE_LONGITUDE_RANGE, FLAT_FILE_LATITUDE_RANGE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Define TIMESERIES_START_YEAR, TIMESERIES_START_DAY, TIMESERIES_START_HOUR,
;TIMESERIES_START_MINUTE, TIMESERIES_START_SECOND, the start year, day,
;hour, minute, and second, respectively, of the time-series.

TIMESERIES_START_YEAR=strmid(TIMESERIES_START_TIME, 0, 4)
TIMESERIES_START_DAY=strmid(TIMESERIES_START_TIME, 4, 3)
TIMESERIES_START_HOUR=strmid(TIMESERIES_START_TIME, 7, 2)
TIMESERIES_START_MINUTE=strmid(TIMESERIES_START_TIME, 9, 2)
TIMESERIES_START_SECOND=strmid(TIMESERIES_START_TIME, 11, 2)

;help, TIMESERIES_START_YEAR, TIMESERIES_START_DAY, TIMESERIES_START_HOUR, TIMESERIES_START_MINUTE, TIMESERIES_START_SECOND
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Define YEAR, DAY, HOUR, MINUTE, and SECOND, which are initially set equal
;to TIMESERIES_START_YEAR, TIMESERIES_START_DAY, TIMESERIES_START_HOUR, 
;TIMESERIES_START_MINUTE, and TIMESERIES_START_SECOND, respectively.

YEAR=TIMESERIES_START_YEAR
DAY=TIMESERIES_START_DAY
HOUR=TIMESERIES_START_HOUR
MINUTE=TIMESERIES_START_MINUTE
SECOND=TIMESERIES_START_SECOND

;help, YEAR, DAY, HOUR, MINUTE, SECOND
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Define REGION_DISPLAY, which is initially set equal to YES. 

REGION_DISPLAY='YES'
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Define CONTINUE, which is initially set equal to YES. The following
;WHILE statement will continue performing itterations while CONTINUE is set
;equal to YES. Define WHILE_COUNT, which is initially set equal to 0. 
;For each itteration of the WHILE statement that is performed, WHILE_COUNT
;will be incremented by 1.

CONTINUE='YES'

WHILE_COUNT=0
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
	
openw, TIMESERIES_TEXT_FILE_LUN, TIMESERIES_TEXT_FILE, /get_lun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;

while (CONTINUE eq 'YES') do begin & $


	

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;Define TIME, the result of concatenating YEAR, DAY, HOUR, MINUTE,
	;and SECOND, respectively.
	
	TIME=YEAR + DAY + HOUR + MINUTE + SECOND & $
	
	print, '' & $
	print, '' & $
	print, SEPARATOR & $
	print, SEPARATOR & $
	print, 'Time: ', TIME & $
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	


	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;If TIME is equal to TIMESERIES_END_TIME then set CONTINUE equal to 
	;NO. This itteration of the WHILE loop will be completed, after 
	;which the WHILE loop will be exited.
	
	if TIME eq TIMESERIES_END_TIME then CONTINUE='NO' & $
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	
	
	
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;Define TIME_FLAT_FILE_PATTERN, the pattern (dependent on TIME) to
	;which a flat file in the current directory must correspond.
	
	case TIMESERIES_RESOLUTION_CLASS of & $
	
		'SECOND': TIME_FLAT_FILE_PATTERN='[A-Z]' + YEAR + DAY + HOUR + MINUTE + SECOND + '*.flat' & $
		'MINUTE': TIME_FLAT_FILE_PATTERN='[A-Z]' + YEAR + DAY + HOUR + MINUTE + '*.flat' & $
		'HOUR': TIME_FLAT_FILE_PATTERN='[A-Z]' + YEAR + DAY + HOUR + '*.flat' & $
		'DAY': TIME_FLAT_FILE_PATTERN='[A-Z]' + YEAR + DAY + '*.flat' & $
		'MONTH': TIME_FLAT_FILE_PATTERN='[A-Z]' + YEAR + DAY + '*.flat' & $
		'YEAR': TIME_FLAT_FILE_PATTERN='[A-Z]' + YEAR + '*.flat' & $
	
	endcase & $
	
	print, '' & $
	print, '' & $
	print, 'Flat file pattern: ', TIME_FLAT_FILE_PATTERN & $
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;Define TIME_FLAT_FILE_EXIST, which is initially set equal to NO.

	TIME_FLAT_FILE_EXIST='NO' & $
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;Define TIME_FLAT_FILE, the name of the flat file in the current 
	;directory corresponding to TIME_FLAT_FILE_PATTERN.

	TIME_FLAT_FILE=file_search(TIME_FLAT_FILE_PATTERN) & $
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 	;If the first element of TIME_FLAT_FILE is not null then a flat 
	;file whose name corresponds to TIME_FLAT_FILE_PATTERN exists in 
	;the current directory. If this is the case then set 
	;TIME_FLAT_FILE_EXIST equal to YES.

	if TIME_FLAT_FILE(0) ne '' then TIME_FLAT_FILE_EXIST='YES' & $
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	if TIME_FLAT_FILE_EXIST eq 'NO' then begin & $

		print, '' & $
		print, '' & $
		print, 'No corresponding flat file exists!' & $

	endif & $

	if TIME_FLAT_FILE_EXIST eq 'YES' then begin & $
		
		print, '' & $
		print, '' & $
		print, 'Corresponding flat file: ', TIME_FLAT_FILE & $

	endif & $
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	
	
	
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;Open TIMESERIES_REGIONS_TEXT_FILE and define REGION_AMOUNT, the 
	;number of regions within TIME_FLAT_FILE for which to construct 
	;data points.
	
	openr, TIMESERIES_REGIONS_TEXT_FILE_LUN, TIMESERIES_REGIONS_TEXT_FILE, /get_lun & $

	NULL_VARIABLE='' & $

	readf, TIMESERIES_REGIONS_TEXT_FILE_LUN, NULL_VARIABLE & $
	readf, TIMESERIES_REGIONS_TEXT_FILE_LUN, REGION_AMOUNT & $
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	
	
	
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;
	
	TIMESERIES_STATISTIC_RECORD=fltarr(REGION_AMOUNT, 1) & $
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	



	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;

	if TIME_FLAT_FILE_EXIST eq 'YES' then begin & $




		;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		;Define TIME_ARRAY, a floating point array with x/y
		;dimensions corresponding to FLOAT_FLAT_FILE_XDIM and 
		;FLOAT_FLAT_FILE_YDIM, respectively. Read TIME_FLAT_FILE
		;into TIME_ARRAY. 

		TIME_ARRAY=fltarr(FLOAT_FLAT_FILE_XDIM, FLOAT_FLAT_FILE_YDIM) & $

		openr, FLAT_FILE_LUN, TIME_FLAT_FILE, /get_lun & $
		readu, FLAT_FILE_LUN, TIME_ARRAY & $
		free_lun, FLAT_FILE_LUN & $
		;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




		;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		;Define INTEGER_REGION_AMOUNT, the result of converting
		;REGION_AMOUNT from a floating point variable to an integer
		;variable. Define STRING_INTEGER_REGION_AMOUNT, the result
		;of converting INTEGER_REGION_AMOUNT from an integer 
		;variable to a string variable.
		
		INTEGER_REGION_AMOUNT=fix(REGION_AMOUNT) & $
		STRING_INTEGER_REGION_AMOUNT=strcompress(string(INTEGER_REGION_AMOUNT), /remove_all) & $

		print, '' & $		
		print, '' & $
		print, 'Region amount: ', STRING_INTEGER_REGION_AMOUNT & $
		;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		
		
		

		;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		for A=1, REGION_AMOUNT do begin & $




			;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
			;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
			;Define STRING_A, the result of converting A from
			;an integer variable to a string variable.

			STRING_A=strcompress(string(A), /remove_all) & $
			;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
			;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




			;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
			;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
			;Define REGION, the Ath region within 
			;TIME_FLAT_FILE for which a data point will be
			;constructed.			
			
			REGION='Region' + STRING_A & $
			;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
			;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




			;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
			;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
			;Define REGION_LATLON_AMOUNT, the number of
			;latitude and longitude boundaries that define
			;REGION.

			readf, TIMESERIES_REGIONS_TEXT_FILE_LUN, NULL_VARIABLE & $
			readf, TIMESERIES_REGIONS_TEXT_FILE_LUN, NULL_VARIABLE & $
			readf, TIMESERIES_REGIONS_TEXT_FILE_LUN, REGION_LATLON_AMOUNT & $
			;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
			;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




			;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
			;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
			;Define REGION_LATITUDES and REGION_LONGITUDES, the
			;floating point arrays that will contain the
			;latitude and longitude boundaries that define
			;REGION.

			REGION_LATITUDES=fltarr(REGION_LATLON_AMOUNT) & $
			REGION_LONGITUDES=fltarr(REGION_LATLON_AMOUNT) & $

			readf, TIMESERIES_REGIONS_TEXT_FILE_LUN, NULL_VARIABLE & $
			readf, TIMESERIES_REGIONS_TEXT_FILE_LUN, NULL_VARIABLE & $

			for B=0, REGION_LATLON_AMOUNT - 1 do begin & $
	
				readf, TIMESERIES_REGIONS_TEXT_FILE_LUN, LATITUDE & $
				
				REGION_LATITUDES(B)=LATITUDE & $

			endfor & $
			
			readf, TIMESERIES_REGIONS_TEXT_FILE_LUN, NULL_VARIABLE & $
			readf, TIMESERIES_REGIONS_TEXT_FILE_LUN, NULL_VARIABLE & $

			for C=0, REGION_LATLON_AMOUNT - 1 do begin & $
	
				readf, TIMESERIES_REGIONS_TEXT_FILE_LUN, LONGITUDE & $
				
				REGION_LONGITUDES(C)=LONGITUDE & $

			endfor & $
			
			print, '' & $
			print, '' & $	
			print, REGION, ' latitudes:' & $
			print, REGION_LATITUDES & $
			print, '' & $
			print, '' & $
			print, REGION, ' longitudes:' & $
			print, REGION_LONGITUDES & $
			;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
			;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




			;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
			;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
			;Define REGION_X_INDICES and REGION_Y_INDICES, the
			;result of converting REGION_LONGITUDES and 
			;REGION_LATITUDES to matrix indices.
			
			REGION_X_INDICES=round((-FLOAT_FLAT_FILE_WEST + REGION_LONGITUDES)*((FLOAT_FLAT_FILE_XDIM - 1)/FLAT_FILE_LONGITUDE_RANGE)) & $
			REGION_Y_INDICES=round((FLOAT_FLAT_FILE_NORTH - REGION_LATITUDES)*((FLOAT_FLAT_FILE_YDIM - 1)/FLAT_FILE_LATITUDE_RANGE)) & $
			
			;print, REGION_X_INDICES, REGION_Y_INDICES & $
			;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
			;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




			;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
			;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
			;Define REGION_INDICES.

			REGION_INDICES=polyfillv(REGION_X_INDICES, REGION_Y_INDICES, FLOAT_FLAT_FILE_XDIM, FLOAT_FLAT_FILE_YDIM) & $
			;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
			;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




			;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
			;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
			;Define REGION_ARRAY.

			REGION_ARRAY=TIME_ARRAY(REGION_INDICES) & $
			;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
			;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




			;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
			;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
			;

			if STATISTIC eq 'MEAN' or STATISTIC eq 'BOTH' then begin & $
				REGION_STATISTIC=mean(REGION_ARRAY, /NAN) & $
			endif & $

			;if STATISTIC eq 'VARIANCE' then blahh

			print, '' & $
			print, '' & $
			print, REGION, ' ', STATISTIC, ':', REGION_STATISTIC & $
			;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
			;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




			;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
			;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
			;
			
			TIMESERIES_STATISTIC_RECORD(A - 1)=REGION_STATISTIC & $
			;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
			;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
			



			;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
			;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
			;

			if REGION_DISPLAY eq 'YES' then begin & $




				;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
				;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
				;Define REGION_DISPLAY_ARRAY, a floating 
				;point array whose x/y dimensions 
				;correspond to FLOAT_FLAT_FILE_XDIM and 
				;FLOAT_FLAT_FILE_YDIM, respectively.

				REGION_DISPLAY_ARRAY=fltarr(FLOAT_FLAT_FILE_XDIM, FLOAT_FLAT_FILE_YDIM) & $
				REGION_DISPLAY_ARRAY(REGION_INDICES)=1 & $
				;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
				;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



				;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
				;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
				;Image REGION_DISPLAY_ARRAY and overlay a 
				;coastline.

				window, 0, xsize=FLOAT_FLAT_FILE_XDIM, ysize=FLOAT_FLAT_FILE_YDIM & $
				tvscl, REGION_DISPLAY_ARRAY, /o & $

				MAP_SET, /CYLINDRICAL, /NOBORDER, XMARGIN=0, YMARGIN=0, /NOERASE, /ISOTROPIC, LIMIT=[FLOAT_FLAT_FILE_SOUTH, FLOAT_FLAT_FILE_WEST, FLOAT_FLAT_FILE_NORTH, FLOAT_FLAT_FILE_EAST] & $
				MAP_CONTINENTS, /COASTS, COLOR=!D.TABLE_SIZE-1, /HIRES & $
				;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
				;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




				;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
				;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
				;Define REGION_DISPLAY_PNG_NAME, the name 
				;of the png file to which 
				;REGION_DISPLAY_ARRAY will be written out. 
				;Write out REGION_DISPLAY_ARRAY to 
				;REGION_DISPLAY_PNG_NAME.

				REGION_DISPLAY_PNG_NAME=REGION + '.png' & $

				write_png, REGION_DISPLAY_PNG_NAME, tvrd(/true) & $
				;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
				;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
				
				
				
				
				;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
				;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
				;Set REGION_DISPLAY equal to 'NO'
				
				if A eq REGION_AMOUNT then REGION_DISPLAY='NO' & $
				;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
				;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




			endif & $
			;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
			;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	



		endfor & $
		;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	



	endif & $
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;Close TIMESERIES_REGIONS_TEXT_FILE

	free_lun, TIMESERIES_REGIONS_TEXT_FILE_LUN & $
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	
	
	
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;Define INTEGER_SECOND, INTEGER_MINUTE, INTEGER_HOUR, INTEGER_DAY, 
	;and INTEGER_YEAR, the results of converting SECOND, MINUTE, HOUR, 
	;DAY, and YEAR from string variables to integer variables.
	
	INTEGER_SECOND=fix(SECOND) & $
	INTEGER_MINUTE=fix(MINUTE) & $
	INTEGER_HOUR=fix(HOUR) & $
	INTEGER_DAY=fix(DAY) & $
	INTEGER_YEAR=fix(YEAR) & $
	
	;help, INTEGER_SECOND, INTEGER_MINUTE, INTEGER_HOUR, INTEGER_DAY, INTEGER_YEAR & $
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	
	
	
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;
	
	case TIMESERIES_RESOLUTION_CLASS of & $
	
		'SECOND': begin & $
			TIMESERIES_TIME_RECORD=[YEAR, DAY, HOUR, MINUTE, SECOND, WHILE_COUNT] & $
			TIMESERIES_RECORD_FORMAT='(I, X, I, X, I, X, I, X, I, X, I, ' & $
		end & $
		
		'MINUTE': begin & $
			TIMESERIES_TIME_RECORD=[YEAR, DAY, HOUR, MINUTE, WHILE_COUNT] & $
			TIMESERIES_RECORD_FORMAT='(I, X, I, X, I, X, I, X, I, ' & $
		end & $
		
		'HOUR': begin & $
			TIMESERIES_TIME_RECORD=[YEAR, DAY, HOUR, WHILE_COUNT] & $
			TIMESERIES_RECORD_FORMAT='(I, X, I, X, I, X, I, ' & $
		end & $
		
		'DAY': begin & $
		
			if WHILE_COUNT eq 0 then DAYORMONTH_NUMBER=((INTEGER_DAY - 1)/(INTEGER_TIMESERIES_RESOLUTION_AMOUNT)) + 1 & $
		
			TIMESERIES_TIME_RECORD=[YEAR, DAYORMONTH_NUMBER, WHILE_COUNT] & $
			TIMESERIES_RECORD_FORMAT='(I, X, I, X, I, ' & $
			
		end & $
		
		'MONTH': begin & $
		
			MONTH_NUMBER='blah' & $
		
			TIMESERIES_TIME_RECORD=[YEAR, DAYORMONTH_NUMBER, WHILE_COUNT] & $
			TIMESERIES_RECORD_FORMAT='(I, X, I, X, I, ' & $
			
		end & $
		
		'YEAR': begin & $
			TIMESERIES_TIME_RECORD=[YEAR, WHILE_COUNT] & $
			TIMESERIES_RECORD_FORMAT='(I, X, I, ' & $
		end & $
		
	endcase & $
	
	for D=1, REGION_AMOUNT do begin & $
	
		if D ne REGION_AMOUNT then TIMESERIES_RECORD_FORMAT=TIMESERIES_RECORD_FORMAT + 'X, F7.3, ' & $
		if D eq REGION_AMOUNT then TIMESERIES_RECORD_FORMAT=TIMESERIES_RECORD_FORMAT + 'X, F7.3)' & $
		
	endfor & $
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	
	
	
	
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;
	
	printf, TIMESERIES_TEXT_FILE_LUN, TIMESERIES_TIME_RECORD, TIMESERIES_STATISTIC_RECORD, format=TIMESERIES_RECORD_FORMAT & $
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	
	
		
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;If TIMESERIES_RESOLUTION_CLASS is set equal to SECOND then 
	;increment INTEGER_SECOND by an amount equal to
	;INTEGER_TIMESERIES_RESOLUTION_AMOUNT.
	
	if TIMESERIES_RESOLUTION_CLASS eq 'SECOND' then INTEGER_SECOND=INTEGER_SECOND + INTEGER_TIMESERIES_RESOLUTION_AMOUNT & $
	
	;help, INTEGER_SECOND & $
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	
	
	
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;If INTEGER_SECOND is greater than 60 then re-set it and increment 
	;INTEGER_MINUTE by 1.
	
	if INTEGER_SECOND gt 60 then begin & $
	
		INTEGER_SECOND=INTEGER_SECOND - 60 & $
			
		INTEGER_MINUTE=INTEGER_MINUTE + 1 & $
			
	endif & $
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	
	
	
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;If TIMESERIES_RESOLUTION_CLASS is set equal to MINUTE then 
	;increment INTEGER_MINUTE by an amount equal to 
	;INTEGER_TIMESERIES_RESOLUTION_AMOUNT.
	
	if TIMESERIES_RESOLUTION_CLASS eq 'MINUTE' then INTEGER_MINUTE=INTEGER_MINUTE + INTEGER_TIMESERIES_RESOLUTION_AMOUNT & $
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	
	
	
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;If INTEGER_MINUTE is greater than 59 then re-set it and increment 
	;INTEGER_MINUTE by 1.
	
	if INTEGER_MINUTE gt 59 then begin & $
		
		INTEGER_MINUTE=INTEGER_MINUTE - 60 & $
			
		INTEGER_HOUR=INTEGER_HOUR + 1 & $
			
	endif & $
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	
	
	
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;If TIMESERIES_RESOLUTION_CLASS is set equal to HOUR then 
	;increment INTEGER_HOUR by an amount equal to 
	;INTEGER_TIMESERIES_RESOLUTION_AMOUNT.
	
	if TIMESERIES_RESOLUTION_CLASS eq 'HOUR' then INTEGER_HOUR=INTEGER_HOUR + INTEGER_TIMESERIES_RESOLUTION_AMOUNT & $
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	
	
	
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;If INTEGER_HOUR is greater than 23 then re-set it and increment 
	;INTEGER_DAY by 1.
	
	if INTEGER_HOUR gt 23 then begin & $
		
		INTEGER_HOUR=INTEGER_HOUR - 24 & $
			
		INTEGER_DAY=INTEGER_DAY + 1 & $
			
	endif & $
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	
	
	
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
	if TIMESERIES_RESOLUTION_CLASS eq 'MONTH' or TIMESERIES_RESOLUTION_CLASS eq 'DAY' then begin & $
	
		if TIMESERIES_RESOLUTION_CLASS eq 'MONTH' then begin & $
	
			;fill in later & $
			
		endif & $
		
		if TIMESERIES_RESOLUTION_CLASS eq 'DAY' then begin & $
	
			ADDITIONAL_DAY_AMOUNT=INTEGER_TIMESERIES_RESOLUTION_AMOUNT & $
			NEXT_ADDITIONAL_DAY_AMOUNT=INTEGER_TIMESERIES_RESOLUTION_AMOUNT & $
			NEXT_END_DAY=INTEGER_DAY + ADDITIONAL_DAY_AMOUNT + (NEXT_ADDITIONAL_DAY_AMOUNT - 1) & $
			
		endif & $
		
		INTEGER_DAY=INTEGER_DAY + ADDITIONAL_DAY_AMOUNT & $
	
		DAYORMONTH_NUMBER=DAYORMONTH_NUMBER + 1 & $
		
	endif & $
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	
	
			
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;If INTEGER_YEAR is not evenly divisible by 4 then it is a normal 
	;year (ie. not a leap year). Define YEAR_TYPE, the type of year 
	;(NORMAL or LEAP). Define YEAR_DAY_AMOUNT, the number of days in 
	;INREGER_YEAR (365 for normal years and 366 for leap years).

	if INTEGER_YEAR MOD 4 ne 0 then begin & $
		YEAR_TYPE='NORMAL' & $
		YEAR_DAY_AMOUNT=365 & $
	endif & $

	if INTEGER_YEAR MOD 4 eq 0 then begin & $
		YEAR_TYPE='LEAP' & $
		YEAR_DAY_AMOUNT=366 & $
	endif & $

	;help, YEAR_TYPE, YEAR_DAY_AMOUNT & $
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;

	RESET_YEAR='NO' & $

	if TIMESERIES_RESOLUTION_CLASS eq 'MONTH' or TIMESERIES_RESOLUTION_CLASS eq 'DAY' then begin & $

		if NEXT_END_DAY gt YEAR_DAY_AMOUNT then RESET_YEAR='YES' & $

	endif else begin & $

		if INTEGER_DAY gt YEAR_DAY_AMOUNT then RESET_YEAR='YES' & $

	endelse & $

	if RESET_YEAR eq 'YES' then begin & $
			
		INTEGER_DAY=1 & $
				
		INTEGER_YEAR=INTEGER_YEAR + 1 & $
		
		DAYORMONTH_NUMBER=1 & $
				
	endif & $
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	
	
	
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;
	
	if TIMESERIES_RESOLUTION_CLASS eq 'YEAR' then INTEGER_YEAR=INTEGER_YEAR + INTEGER_TIMESERIES_RESOLUTION_AMOUNT & $
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	
	
	
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;
	
	if INTEGER_SECOND lt 10 then SECOND='0' + strcompress(string(INTEGER_SECOND), /remove_all) & $
	if INTEGER_SECOND ge 10 then SECOND=strcompress(string(INTEGER_SECOND), /remove_all) & $
	
	if INTEGER_MINUTE lt 10 then MINUTE='0' + strcompress(string(INTEGER_MINUTE), /remove_all) & $
	if INTEGER_MINUTE ge 10 then MINUTE=strcompress(string(INTEGER_MINUTE), /remove_all) & $
	
	if INTEGER_HOUR lt 10 then HOUR='0' + strcompress(string(INTEGER_HOUR), /remove_all) & $
	if INTEGER_HOUR ge 10 then HOUR=strcompress(string(INTEGER_HOUR), /remove_all) & $
	
	if INTEGER_DAY lt 10 then DAY='00' + strcompress(string(INTEGER_DAY), /remove_all) & $
	if INTEGER_DAY ge 10 and INTEGER_DAY lt 100 then DAY='0' + strcompress(string(INTEGER_DAY), /remove_all) & $
	if INTEGER_DAY ge 100 then DAY=strcompress(string(INTEGER_DAY), /remove_all) & $
	
	YEAR=strcompress(string(INTEGER_YEAR), /remove_all) & $
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;Increment WHILE_COUNT by 1.

	WHILE_COUNT=WHILE_COUNT + 1 & $
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	print, SEPARATOR & $
	print, SEPARATOR & $
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	

	
endwhile
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
free_lun, TIMESERIES_TEXT_FILE_LUN
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
