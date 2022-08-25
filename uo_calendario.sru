HA$PBExportHeader$uo_calendario.sru
$PBExportComments$dropdown calendario para los campos tipo fecha
forward
global type uo_calendario from UserObject
end type
type em_time from editmask within uo_calendario
end type
type cb_next_month from commandbutton within uo_calendario
end type
type cb_next_year from commandbutton within uo_calendario
end type
type cb_prev_month from commandbutton within uo_calendario
end type
type cb_prev_year from commandbutton within uo_calendario
end type
type dw_calendar from datawindow within uo_calendario
end type
end forward

global type uo_calendario from UserObject
int Width=667
int Height=684
long BackColor=79741120
long PictureMaskColor=553648127
long TabTextColor=33554432
long TabBackColor=79741120
event hpk_lose_focus ( )
em_time em_time
cb_next_month cb_next_month
cb_next_year cb_next_year
cb_prev_month cb_prev_month
cb_prev_year cb_prev_year
dw_calendar dw_calendar
end type
global uo_calendario uo_calendario

type prototypes

end prototypes

type variables
Long   		ii_old_column, &
		ii_day, ii_month, ii_year
Date       		id_date_selected
Time		it_time_selected
String 		is_column
DataWindow 	idw
Window		iw_parent
Boolean		ib_help_requested = FALSE

end variables

forward prototypes
public function string of_date_string ()
public function long of_days_in_month (long ai_month, long ai_year)
public subroutine of_enter_day_numbers (long ai_start_day_num, long ai_days_in_month)
public function long of_get_month_number (string as_month)
public function string of_get_month_string (long as_month)
public subroutine of_init_calendar (date ad_start_date)
public subroutine of_draw_month (long ai_year, long ai_month)
public subroutine of_show_calendar (datawindow adw)
public subroutine of_set_position ()
end prototypes

event hpk_lose_focus;PowerObject lpo_object

// If user asked for Help MessageBox, then do not hide calendar
IF ib_help_requested THEN Return
IF KeyDown(KeyTab!) THEN Return

lpo_object = GetFocus()

// If calendar loses focus then hide it
IF  lpo_object <> control[1] &
AND lpo_object <> control[2] &
AND lpo_object <> control[3] &
AND lpo_object <> control[4] &
AND lpo_object <> control[5] &
AND lpo_object <> control[6] THEN Hide()

end event

public function string of_date_string ();/****************************************************************************************
 \\$$HEX1$$cf00$$ENDHEX$$//	Function : 	of_date_string
 (@ @)	Access   : 	Public
  ($$HEX1$$b100$$ENDHEX$$)		Returns  : 	String
 HEPEK	Arguments:  None
-----------------------------------------------------------------------------------------
Description: Builds the Date using year, month and day
-----------------------------------------------------------------------------------------
Copyright $$HEX2$$a9002000$$ENDHEX$$1998 Hepek Corporation. All Rights Reserved.
****************************************************************************************/

Return String(ii_year) + '/' + String(ii_month) + '/'+ String(ii_day)

end function

public function long of_days_in_month (long ai_month, long ai_year);/****************************************************************************************
 \\$$HEX1$$cf00$$ENDHEX$$//	Function : 	of_days_in_month
 (@ @)	Access   : 	Public
  ($$HEX1$$b100$$ENDHEX$$)		Returns  : 	Long
 HEPEK	Arguments:  None
-----------------------------------------------------------------------------------------
Description:  Returns number of days in month
-----------------------------------------------------------------------------------------
Copyright $$HEX2$$a9002000$$ENDHEX$$1998 Hepek Corporation. All Rights Reserved.
****************************************************************************************/

Long	ln_days_in_month
Boolean	lb_leap_year

CHOOSE CASE ai_month
	CASE 1, 3, 5, 7, 8, 10, 12
		ln_days_in_month = 31
	CASE 4, 6, 9, 11
		ln_days_in_month = 30
	CASE 2
		// Check for leap year
		If IsDate(string(ai_year) + '/2/29') Then
			ln_days_in_month = 29
		Else
   		ln_days_in_month = 28
		End If
END CHOOSE

Return ln_days_in_month
end function

public subroutine of_enter_day_numbers (long ai_start_day_num, long ai_days_in_month);/****************************************************************************************
 \\$$HEX1$$cf00$$ENDHEX$$//	Function : 	of_enter_day_numbers
 (@ @)	Access   : 	Public
  ($$HEX1$$b100$$ENDHEX$$)		Returns  : 	None
 HEPEK	Arguments:  first day in month, month
-----------------------------------------------------------------------------------------
Description: Draws month in Calendar
-----------------------------------------------------------------------------------------
Copyright $$HEX2$$a9002000$$ENDHEX$$1998 Hepek Corporation. All Rights Reserved.
****************************************************************************************/

Long	li_count, li_daycount
string	ls_modify, ls_return

// Blank the columns before the first day of the month
FOR li_count = 1 TO ai_start_day_num
	dw_calendar.SetItem(1, li_count,'')
NEXT

// Set the columns for the days to the String of their Day number
FOR li_count = 1 TO ai_days_in_month
	// Use li_daycount to find which column needs to be set
	li_daycount = ai_start_day_num + li_count - 1
	dw_calendar.SetItem(1, li_daycount, String(li_count))
NEXT

// Move to next column
li_daycount = li_daycount + 1

// Blank remainder of columns
FOR li_count = li_daycount TO 42
	dw_calendar.SetItem(1, li_count,'')
NEXT

// If there was an old column turn off the highlight
IF ii_old_column <> 0 THEN
	ls_modify = '#' + string(ii_old_Column) + '.border=6'
	ls_return = dw_calendar.Modify(ls_modify)
	IF ls_return <> '' THEN MessageBox('Modify', ls_return)
	ls_modify = '#' + string(ii_old_Column) + '.Font.Weight=400'
	ls_return = dw_calendar.Modify(ls_Modify)
	IF ls_return <> '' THEN MessageBox('Modify', ls_return)
END IF

ii_old_column = 0

end subroutine

public function long of_get_month_number (string as_month);/****************************************************************************************
 \\$$HEX1$$cf00$$ENDHEX$$//	Function : 	of_get_+month_number
 (@ @)	Access   : 	Public
  ($$HEX1$$b100$$ENDHEX$$)		Returns  : 	Long
 HEPEK	Arguments:  Month name (3 Characters)
-----------------------------------------------------------------------------------------
Description: Returns Number of month in year
-----------------------------------------------------------------------------------------
Copyright $$HEX2$$a9002000$$ENDHEX$$1998 Hepek Corporation. All Rights Reserved.
****************************************************************************************/

Long li_month_number

CHOOSE CASE as_month
	CASE 'Jan'
		li_month_number = 1
	CASE 'Feb'
		li_month_number = 2
	CASE 'Mar'
		li_month_number = 3
	CASE 'Apr'
		li_month_number = 4
	CASE 'May'
		li_month_number = 5
	CASE 'Jun'
		li_month_number = 6
	CASE 'Jul'
		li_month_number = 7
	CASE 'Aug'
		li_month_number = 8
	CASE 'Sep'
		li_month_number = 9
	CASE 'Oct'
		li_month_number = 10
	CASE 'Nov'
		li_month_number = 11
	CASE 'Dec'
		li_month_number = 12
END CHOOSE

Return li_month_number
end function

public function string of_get_month_string (long as_month);/****************************************************************************************
 \\$$HEX1$$cf00$$ENDHEX$$//	Function : 	of_get_month_string
 (@ @)	Access   : 	Public
  ($$HEX1$$b100$$ENDHEX$$)		Returns  : 	String
 HEPEK	Arguments:  Month Number
-----------------------------------------------------------------------------------------
Description: Returns the name of month
-----------------------------------------------------------------------------------------
Copyright $$HEX2$$a9002000$$ENDHEX$$1998 Hepek Corporation. All Rights Reserved.
****************************************************************************************/

String ls_month

CHOOSE CASE as_month
	CASE 1
		ls_month = 'Enero'
	CASE 2
		ls_month = 'Febrero'
	CASE 3
		ls_month = 'Marzo'
	CASE 4
		ls_month = 'Abril'
	CASE 5
		ls_month = 'Mayo'
	CASE 6
		ls_month = 'Junio'
	CASE 7
		ls_month = 'Julio'
	CASE 8
		ls_month = 'Agosto'
	CASE 9
		ls_month = 'Septiembre'
	CASE 10
		ls_month = 'Octubre'
	CASE 11
		ls_month = 'Noviembre'
	CASE 12
		ls_month = 'Diciembre'
END CHOOSE

Return ls_month
end function

public subroutine of_init_calendar (date ad_start_date);/****************************************************************************************
 \\$$HEX1$$cf00$$ENDHEX$$//	Function : 	of_init_calendar
 (@ @)	Access   : 	Public
  ($$HEX1$$b100$$ENDHEX$$)		Returns  : 	None
 HEPEK	Arguments:  None
-----------------------------------------------------------------------------------------
Description: Initiates calendar and set date to current date 
				 or date of DataWindow Column if column has value
-----------------------------------------------------------------------------------------
Copyright $$HEX2$$a9002000$$ENDHEX$$1998 Hepek Corporation. All Rights Reserved.
****************************************************************************************/

Long	li_first_day_number, li_current_cell, li_days_in_month
String 	ls_year, ls_modify, ls_return
Date 		ld_first_day_in_month

// Set the variables for Day, Month and Year from the date passed to the function																		*/
ii_month = Month(ad_start_date)
ii_year  = Year(ad_start_date)
ii_day   = Day(ad_start_date)

// Find how many days in the relevant month
li_days_in_month = of_days_in_month(ii_month, ii_year)

// Find the date of the first day of this month
ld_first_day_in_month = Date(ii_year, ii_month, 1)

// What day of the week is the first day of the month
li_first_day_number = DayNumber(ld_first_day_in_month)

// Set the starting 'cell' in the datawindow. i.e the column in which
// the first day of the month will be displayed
li_current_cell = li_first_day_number + ii_day - 1

// Set the Title of the calendar with the Month and Year
dw_calendar.Modify("st_year.text   = ~"" + String(ii_year) + "~"")
dw_calendar.Modify("st_month.text = ~""  + of_get_month_string(ii_month) + "~"")

// Enter the numbers of the days
of_enter_day_numbers(li_first_day_number, li_days_in_month)

dw_calendar.SetItem(1, li_current_cell, String(Day(ad_start_date)))

// Display the current day in bold and 3D
ls_modify = '#' + String(li_current_cell) + '.border=5'
ls_return = dw_calendar.Modify(ls_modify)
IF ls_return <> '' THEN MessageBox('Modify', ls_return)
ls_modify = '#' + String(li_current_cell) + '.Font.Weight=700'
ls_return = dw_calendar.Modify(ls_modify)
IF ls_return <> '' THEN MessageBox('Modify', ls_return)

// Set the instance variable i_old_column to hold the current cell,
// so when we change it, we know the old setting
ii_old_column = li_current_cell

end subroutine

public subroutine of_draw_month (long ai_year, long ai_month);/****************************************************************************************
 \\$$HEX1$$cf00$$ENDHEX$$//	Function : 	of_draw_month
 (@ @)	Access   : 	Public
  ($$HEX1$$b100$$ENDHEX$$)		Returns  : 	None
 HEPEK	Arguments:  Year and Month
-----------------------------------------------------------------------------------------
Description:  Draws month in Calendar
-----------------------------------------------------------------------------------------
Copyright $$HEX2$$a9002000$$ENDHEX$$1998 Hepek Corporation. All Rights Reserved.
****************************************************************************************/

Long	li_first_day_number, li_cell, li_days_in_month
Date 		ld_first_day_in_month
String	ls_modify, ls_return

dw_calendar.SetRedraw(FALSE)

ii_month = ai_month
ii_year  = ai_year

// Check if the instance day is valid for month/year.
// Back the day down one if invalid for month ie 31 will become 30
DO WHILE Date(ii_year,ii_month,ii_day) = Date(00,1,1)
	ii_day --
LOOP

// Work out how many days in the month
li_days_in_month = of_days_in_month(ii_month, ii_year)

// Find the date of the first day in the month
ld_first_day_in_month = Date(ii_year, ii_month,1)

// Find what day of the week this is
li_first_day_number = DayNumber(ld_first_day_in_month)

// Set the first cell
li_cell = li_first_day_number + ii_day - 1

// If there was an old column turn off the highlight
IF ii_old_column <> 0 THEN
	ls_modify = '#' + string(ii_old_Column) + '.border=6'
	ls_return = dw_calendar.Modify(ls_modify)
	If ls_return <> '' THEN MessageBox('Modify', ls_return)
	ls_modify = '#' + string(ii_old_Column) + '.Font.Weight=400'
	ls_return = dw_calendar.Modify(ls_Modify)
	If ls_return <> '' THEN MessageBox('Modify', ls_return)
END IF

// Set the Title
dw_calendar.Modify("st_year.text   = ~"" + String(ii_year) + "~"")
dw_calendar.Modify("st_month.text = ~""  + of_get_month_string(ii_month) + "~"")

of_enter_day_numbers(li_first_day_number,li_days_in_month)

dw_calendar.SetItem(1, li_cell, String(ii_day))

// Highlight the current date
ls_modify = '#' + string(li_cell) + '.border=5'
ls_return = dw_calendar.Modify(ls_modify)
IF ls_return <> '' THEN MessageBox('Modify',ls_return)
ls_modify = '#' + string(li_cell) + '.Font.Weight=700'
ls_return = dw_calendar.Modify(ls_Modify)
IF ls_return <> '' THEN MessageBox('Modify',ls_return)

// Set the old column for next time
ii_old_column = li_cell

// Reset the pointer and Redraw
SetPointer(Arrow!)
dw_calendar.SetRedraw(TRUE)

end subroutine

public subroutine of_show_calendar (datawindow adw);/****************************************************************************************
 \\$$HEX1$$cf00$$ENDHEX$$//	Function : 	of_show_calendar
 (@ @)	Access   : 	Public
  ($$HEX1$$b100$$ENDHEX$$)		Returns  : 	None
 HEPEK	Arguments:  None
-----------------------------------------------------------------------------------------
Description: Shows calendar
-----------------------------------------------------------------------------------------
Copyright $$HEX2$$a9002000$$ENDHEX$$1998 Hepek Corporation. All Rights Reserved.
****************************************************************************************/

String ls_current_data, ls_date, ls_time, ls_col_type, ls_col_format
Date   ld_date
Time   lt_time
Long li_pos

// Set the instance DW variable
idw = adw

// Reset DataWindow and restore columns borders
dw_calendar.Event hpk_reset()

// Get current field value
ls_current_data = idw.GetText() + ' '
li_pos = Pos(ls_current_data, ' ', 1)
// Determine current column Date and Time if applicable
ls_date = Trim(Left(ls_current_data, li_pos))

// determine column type and hide or show time portion
ls_col_type = Upper(idw.Describe(idw.GetColumnName() + '.ColType'))
IF Match(ls_col_type, 'CHAR') THEN ls_col_type = 'DATE'

// get the column format
ls_col_format = Upper(idw.Describe(idw.GetColumnName() + '.Format'))

IF ls_col_type = 'DATE' THEN
	// do not show time portion of calendar
	em_time.Hide()
ELSE
	// Hide / Show time portion of calendar, depending od format
	IF Match(ls_col_format, 'TIME') OR Match(ls_col_format, 'HH:MM') THEN
		em_time.Show()
	ELSE
		em_time.Hide()
	END IF
END IF

// set date and time to null if no current value
IF ls_date = '' OR NOT IsDate(ls_date) THEN
	SetNull(ld_date)
ELSE
	ld_date = Date(ls_date)
END IF

// Set the time spin control
ls_time = Trim(Right(ls_current_data, Len(ls_current_data) - li_pos))
IF ls_time = '' THEN ls_time = String(Now(), 'HH:MM')
em_time.Text = ls_time
it_time_selected = Time(ls_time)

// Set to today if no value in column
IF IsNull(ld_date) THEN ld_date = Today()

// initialize calendar
of_init_calendar(ld_date)

// position the calendar
of_set_position()

dw_calendar.SetFocus()
Show()

end subroutine

public subroutine of_set_position ();Long li_X, li_Y

li_X = iw_parent.PointerX() - Width + 5
li_Y = iw_parent.PointerY() + 10// 10

// Check if calendar excides frame Width
IF li_X < 0 THEN li_X = li_X + Width
IF li_Y + Height > iw_parent.WorkSpaceHeight() THEN 
	IF (li_Y < Height) THEN 
		li_y=0
	Else
		li_Y -= Height
	End If
End if
// Move calendar to appropriate coordinates
Move(li_X, li_Y)

SetPosition(ToTop!)
BringToTop = TRUE
end subroutine

on uo_calendario.create
this.em_time=create em_time
this.cb_next_month=create cb_next_month
this.cb_next_year=create cb_next_year
this.cb_prev_month=create cb_prev_month
this.cb_prev_year=create cb_prev_year
this.dw_calendar=create dw_calendar
this.Control[]={this.em_time,&
this.cb_next_month,&
this.cb_next_year,&
this.cb_prev_month,&
this.cb_prev_year,&
this.dw_calendar}
end on

on uo_calendario.destroy
destroy(this.em_time)
destroy(this.cb_next_month)
destroy(this.cb_next_year)
destroy(this.cb_prev_month)
destroy(this.cb_prev_year)
destroy(this.dw_calendar)
end on

event constructor;Hide()

iw_parent = GetParent()

end event

type em_time from editmask within uo_calendario
event hpk_changing pbm_enchange
event key pbm_keydown
int X=393
int Y=596
int Width=261
int Height=80
int TabOrder=10
string Tag="AXIXD +19"
Alignment Alignment=Center!
BorderStyle BorderStyle=StyleLowered!
string Mask="hh:mm"
MaskDataType MaskDataType=TimeMask!
boolean Spin=true
string DisplayData=""
double Increment=1
long TextColor=33554432
long BackColor=15793151
int TextSize=-8
int Weight=700
string FaceName="MS Sans Serif"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event hpk_changing;it_time_selected = Time(Text)
end event

event key;IF key = KeyControl! THEN
	dw_calendar.SetFocus()
	idw.SetFocus()
	Return 1
END IF

IF key = KeyEscape! THEN 
	dw_calendar.Event key(key, keyflags)
ELSEIF key = KeyEnter! THEN
	dw_calendar.SetFocus()
	dw_calendar.Event key(key, keyflags)
ELSEIF key = KeyTab! THEN
	dw_calendar.SetFocus()
	Return 1
END IF
end event

event losefocus;dw_calendar.SetFocus()

Parent.Event hpk_lose_focus()

end event

event getfocus;SelectText(1, 2)
end event

event rbuttondown;Tag = String(Long(Tag) + 1)

IF Long(Tag) = 9 THEN 
	Tag = ''
	MessageBox('YVGVB -9 Libraries', 'Copyright $$HEX2$$a9002000$$ENDHEX$$1998 YVGVB -9 Corporation.~rAll Rights Reserved.')
END IF

Return 1

end event

type cb_next_month from commandbutton within uo_calendario
int X=567
int Y=88
int Width=96
int Height=76
string Text="$$HEX1$$f000$$ENDHEX$$"
int TextSize=-16
int Weight=400
string FaceName="Wingdings"
FontCharSet FontCharSet=Symbol!
FontPitch FontPitch=Variable!
end type

event clicked;// Increment the month number, but if its 13, set back to 1 (January)
ii_month ++

IF ii_month = 13 THEN
	ii_month = 1
	ii_year ++
END IF

// check if selected day is no longer valid for new month
IF NOT isdate(of_date_string()) THEN ii_day = 1
	
// Draw the month
of_draw_month(ii_year, ii_month)

id_date_selected = date(ii_year,ii_month,ii_Day)

dw_calendar.SetFocus()

end event

event losefocus;Parent.Event hpk_lose_focus()
end event

type cb_next_year from commandbutton within uo_calendario
int X=567
int Y=12
int Width=96
int Height=76
string Text="$$HEX1$$f000$$ENDHEX$$"
int TextSize=-16
int Weight=400
string FaceName="Wingdings"
FontCharSet FontCharSet=Symbol!
FontPitch FontPitch=Variable!
end type

event clicked;ii_year ++

// check if selected day is no longer valid
IF NOT isdate(of_date_string()) THEN ii_day = 1
	
// Draw the month
of_draw_month(ii_year, ii_month)

id_date_selected = Date(ii_year,ii_month,ii_Day)

dw_calendar.SetFocus()

end event

event losefocus;Parent.Event hpk_lose_focus()
end event

type cb_prev_month from commandbutton within uo_calendario
int X=14
int Y=88
int Width=96
int Height=76
string Text="$$HEX1$$ef00$$ENDHEX$$"
int TextSize=-16
int Weight=400
string FaceName="Wingdings"
FontCharSet FontCharSet=Symbol!
FontPitch FontPitch=Variable!
end type

event clicked;// Decrement the month, if 0, set to 12 (December)
ii_month --

IF ii_month = 0 THEN
	ii_month = 12
	ii_year --
END IF

// check if selected day is no longer valid for new month
IF NOT isdate(of_date_string()) THEN ii_day = 1

// Draw the month
of_draw_month ( ii_year, ii_month )

id_date_selected = date(ii_year,ii_month,ii_Day)

dw_calendar.SetFocus()

end event

event losefocus;Parent.Event hpk_lose_focus()
end event

type cb_prev_year from commandbutton within uo_calendario
int X=14
int Y=12
int Width=96
int Height=76
string Text="$$HEX1$$ef00$$ENDHEX$$"
int TextSize=-16
int Weight=400
string FaceName="Wingdings"
FontCharSet FontCharSet=Symbol!
FontPitch FontPitch=Variable!
end type

event clicked;ii_year --

// check if selected day is no longer valid
IF NOT isdate(of_date_string()) THEN ii_day = 1
	
// Draw the month
of_draw_month(ii_year, ii_month)

id_date_selected = Date(ii_year,ii_month,ii_Day)

dw_calendar.SetFocus()

end event

event losefocus;Parent.Event hpk_lose_focus()
end event

type dw_calendar from datawindow within uo_calendario
event key pbm_dwnkey
event type boolean hpk_set_day ( long ai_clicked_column )
event hpk_return_date_time ( )
event hpk_reset ( )
int Width=667
int Height=684
int TabOrder=20
string Tag="TQBQW +12"
string DataObject="d_calendario"
BorderStyle BorderStyle=StyleRaised!
boolean LiveScroll=true
end type

event key;IF key = KeyControl! THEN
	idw.SetFocus()
	Return 1
END IF

IF key = KeyEscape! THEN 
	Parent.Hide()
ELSEIF key = KeyEnter! THEN
	// Make shore that old column has some value
	IF Long(GetItemString(1, ii_old_column)) > 0 THEN
		Event hpk_set_day(ii_old_column)
		Event hpk_return_date_time()
	END IF
ELSEIF key = KeyLeftArrow! THEN
	IF keyflags = 0 THEN  // Shift not pressed
		// make shore that old column is not first column
		IF ii_old_column > 1 THEN Event hpk_set_day(ii_old_column - 1)
	ELSEIF keyflags = 1 THEN
		// User Pressed Shift key - move to previous month
		cb_prev_month.Event clicked()
	END IF
ELSEIF key = KeyRightArrow! THEN 
	IF keyflags = 0 THEN  // Shift not pressed
		// make shore that old column is not first column
		IF ii_old_column < 42 THEN Event hpk_set_day(ii_old_column + 1)
	ELSEIF keyflags = 1 THEN
		// User Pressed Shift key - move to next month
		cb_next_month.Event clicked()
	END IF
ELSEIF key = KeyUpArrow! THEN
	// move to next year
	cb_next_year.Event clicked()
ELSEIF key = KeyDownArrow! THEN
	// move to previous year
	cb_prev_year.Event clicked()
ELSEIF key = KeyTab! THEN
	SetRedraw(FALSE)
	idw.SetRedraw(FALSE)

	IF em_time.Visible THEN
		em_time.POST SetFocus()
	ELSE
		POST SetFocus()
	END IF

	idw.POST SetRedraw(TRUE)
	POST SetRedraw(TRUE)

	Return 1
ELSE
	// IF Shift is pressed, do not display help
	IF keyflags <> 0 THEN Return
	// Help Keys, first set instance variable to prevent calendar from hiding
	ib_help_requested = TRUE
	Beep(1)
	Messagebox('Calendar Help Keys', 'Accept Date' 		+ '~tEnter~r' 						+ &
												'Next Day' 			+ '~t~tRight Arrow~r' 			+ &
												'Previous Day' 	+ '~tLeft Arrow~r' 				+ &
												'Next Month' 		+ '~tShift + Right Arrow~r' 	+ &
												'Previous Month' 	+ '~tShift + Left Arrow~r' 	+ &
												'Next Year' 		+ '~t~tUp Arrow~r' 				+ &
												'Previous Year' 	+ '~tDown Arrow~r' 				+ &
												'Cancel' 			+ '~t~tEscape~r')
	ib_help_requested = FALSE
END IF
end event

event hpk_set_day;String ls_day, ls_modify, ls_return

// Set Day to the text of the clicked column. 
ls_day = GetItemString(1, ai_clicked_column)
// Check If user clicked on an empty column
IF ls_day = '' OR IsNull(ls_day) THEN Return FALSE

// Convert to a number and place in Instance variable
ii_day = Long(ls_day)

// Reset properties for old column back to normal
If ii_old_column <> 0 then
	ls_modify = '#' + String(ii_old_column) + '.border=6'
	ls_return = Modify(ls_modify)
	If ls_return <> '' then MessageBox('Modify',ls_return)
	ls_modify = '#' + string(ii_old_column) + '.Font.Weight=400'
	ls_return = dw_calendar.Modify(ls_Modify)
	If ls_return <> '' then MessageBox('Modify',ls_return)
End If

// Highlight chosen day
ls_modify = '#' + String(ai_clicked_column) + '.border=5'
ls_return = Modify(ls_modify)
If ls_return <> '' then MessageBox('Modify',ls_return)
ls_modify = '#' + string(ai_clicked_column) + '.Font.Weight=700'
ls_return = dw_calendar.Modify(ls_Modify)
If ls_return <> '' then MessageBox('Modify',ls_return)

// Set the chosen date
id_date_selected = Date(ii_year, ii_month, ii_day)

ii_old_column = ai_clicked_column

Return TRUE
end event

event hpk_return_date_time;String ls_return

ls_return = String(id_date_selected)

IF em_time.Visible = TRUE THEN
	// add time portion if needed
	ls_return = ls_return + ' ' + String(it_time_selected, 'HH:MM')
END IF

// Set the date value in current field and Accept Text
idw.SetText(ls_return)
idw.AcceptText()
idw.SetFocus()

end event

event hpk_reset;Long 	li_cnt
String 	ls_modify, ls_return

// Reset the instance variables
ii_day			= 0
ii_month			= 0
ii_year			= 0
ii_old_column	= 0

FOR li_cnt = 1 TO 42
	ls_modify = '#' + string(li_cnt) + '.border=6'
	ls_return = Modify(ls_modify)
	IF ls_return <> '' THEN MessageBox('Modify', ls_return)
	ls_modify = '#' + string(li_cnt) + '.Font.Weight=400'
	ls_return = Modify(ls_Modify)
	IF ls_return <> '' THEN MessageBox('Modify', ls_return)
NEXT
end event

event clicked;Long	li_clicked_column

// check clicked object
IF dwo.Type <> 'column' THEN Return 1
IF li_clicked_column < 0  THEN Return 1

li_clicked_column = Long(dwo.ID)

// Set the chossen Date
IF NOT Event hpk_set_day(li_clicked_column) THEN Return

// Set the date value in current field and Accept Text
Event hpk_return_date_time()

end event

event losefocus;Object.DataWindow.Color = 79741120

Parent.Event hpk_lose_focus()

end event

event constructor;//SetRowFocusIndicator(FocusRect!)
InsertRow(1)
end event

event getfocus;Object.DataWindow.Color = 15780518

end event

