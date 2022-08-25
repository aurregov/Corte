HA$PBExportHeader$u_mes.sru
forward
global type u_mes from u_base_calendario_mesual
end type
end forward

global type u_mes from u_base_calendario_mesual
integer width = 585
integer height = 704
boolean border = false
string facename = "MS Sans Serif"
end type
global u_mes u_mes

type variables


/*
ii_modo_seleccionar puede tomar varios valores seg$$HEX1$$fa00$$ENDHEX$$n lo que se vaya a seleccionar

0 -No seleccion
1 -Festivos
2 -No Laborales
*/

integer  ii_modo_seleccionar

long il_color_barra1,il_color_barra2,il_color_barra3,il_color_festivos,il_color_no_laborales

long il_color_vacaciones, il_color_jornada_especial, il_color_compensatorios
integer ii_Width,ii_Height,ii_WidthMax,ii_HeightMax
//ii_numero_de_selecciones,
end variables

forward prototypes
public function integer of_setmodoseleccionar (integer ai_modo)
public function integer of_pintarbarra1 ()
public function integer of_pintarbarra2 ()
public function integer of_pintarbarra3 ()
public function integer of_borrarbarras ()
public function integer of_setcolorfestivos (long al_color)
public function long of_getcolorfestivos ()
public function integer of_setyear (integer ai_ano)
public function integer of_gettaskbarcount (integer ai_dia)
public function integer of_setcolores (long al_color_festivos, long al_color_no_laborables, long al_color_vacaciones, long al_color_compensatorios, long al_color_jornada_especial)
public function integer of_datepicture (integer ai_dia, integer ai_picture)
public function integer of_borrarbarras (integer ai_dia)
public function integer of_getmodoseleccionar ()
public function integer get_no_dias_mes ()
public function integer of_bloquear_dias_pasados (integer ai_dias)
end prototypes

public function integer of_setmodoseleccionar (integer ai_modo);
ii_modo_seleccionar = ai_modo

Return 1
end function

public function integer of_pintarbarra1 ();This.Of_SetTaskBarColor1(This.Of_GetDay(),il_color_barra1)

return 1
end function

public function integer of_pintarbarra2 ();This.Of_SetTaskBarColor2(This.Of_GetDay(),il_color_barra2)

return 1
end function

public function integer of_pintarbarra3 ();This.Of_SetTaskBarColor3(This.Of_GetDay(),il_color_barra3)

return 1
end function

public function integer of_borrarbarras ();//borra las barras del dia seleccionado
This.Of_SetTaskBarColor1(This.Of_GetDay(),-1)
This.Of_SetTaskBarColor2(This.Of_GetDay(),-1)
This.Of_SetTaskBarColor3(This.Of_GetDay(),-1)

return 1
end function

public function integer of_setcolorfestivos (long al_color);il_color_festivos = al_color
Return 1
end function

public function long of_getcolorfestivos ();//Retorna el color de los festivos
Return il_color_festivos
end function

public function integer of_setyear (integer ai_ano);//pone el calendario en el a$$HEX1$$f100$$ENDHEX$$o que se le pase como argumento
super::Of_SetYear(ai_ano)
This.Object.DateSelected(1,False)
Return 1
end function

public function integer of_gettaskbarcount (integer ai_dia);//
return 1
end function

public function integer of_setcolores (long al_color_festivos, long al_color_no_laborables, long al_color_vacaciones, long al_color_compensatorios, long al_color_jornada_especial);//inicializa los colores en el calendario mes
This.il_color_festivos = al_color_festivos
This.il_color_no_laborales = al_color_no_laborables
THis.il_color_vacaciones = al_color_vacaciones
This.il_color_jornada_especial = al_color_jornada_especial
THis.il_color_compensatorios = al_color_compensatorios
Return 1
end function

public function integer of_datepicture (integer ai_dia, integer ai_picture);This.Object.DatePicture(ai_dia,ai_picture)
Return 1
end function

public function integer of_borrarbarras (integer ai_dia);//borra las barras del dia seleccionado
This.Of_SetTaskBarColor1(ai_dia,-1)
This.Of_SetTaskBarColor2(ai_dia,-1)
This.Of_SetTaskBarColor3(ai_dia,-1)

return 1
end function

public function integer of_getmodoseleccionar ();Return ii_modo_seleccionar
end function

public function integer get_no_dias_mes ();Long ll_inicio, ll_fin

ll_inicio = this.Object.BaseDate(1)
ll_fin = This.Object.BaseDate(2)

Return (ll_fin - ll_inicio + 1)

end function

public function integer of_bloquear_dias_pasados (integer ai_dias);Integer li_i
Integer no_dias_mes

no_dias_mes = get_no_dias_mes()
Do While li_i <= ai_dias And li_i <= no_dias_mes
	IF li_i <> ai_dias or ai_dias = no_dias_mes Then
		This.of_DateDisabled(li_i,True)
	End IF	
	li_i++
Loop
Return 1
end function

on u_mes.create
call super::create
end on

on u_mes.destroy
call super::destroy
end on

event constructor;call super::constructor;//configuraci$$HEX1$$f300$$ENDHEX$$n del calendario

This.object.TaskBartop = 0
This.Object.TaskBarHeight = 1
This.Object.Day = 1
This.Object.DateSelected(1,False)
This.Object.Font.name ="MS Sans Serif"
This.Object.Font.size = 8
This.Object.MultiSelect = false
This.Object.DatePosition =1
This.Object.DateBorder = 2
This.Object.DayHeader = "D,L,M,M,J,V,S"
This.Object.Weekends = 1
This.Object.BackColor = 16763799
This.Object.BacKColorTo = 16777215
This.Object.BackFillType = 4
This.Object.BorderStyle = 0
This.Object.BorderType = 0 //1
This.Object.ButtonColor = 8388608
This.Object.DateBorder = 1
This.Object.HeaderBackColor = 16763799
This.Object.HeaderBackColorTo = 16777215
This.Object.HeaderBorder = 1
This.Object.HeaderFillType = 7
This.Object.SelectBackColor = 8388608
This.Object.SelectBorder = 3
This.Object.SelectTextColor = 16777215
This.Object.TitleBackColor = 16763799
This.Object.TitleBackColorTo = 16777215
This.Object.TitleBorder = 1
This.Object.TitleFillType = 7
This.Object.TitleTextColor = 8388608
This.Object.TitleType = 0
This.Object.WeekendColor = RGB(255,255,255)

//configuraci$$HEX1$$f300$$ENDHEX$$n para las imagenes
This.Object.UseImageList = True
This.Object.MaskBitMap = True
This.Object.PicAlign = 1
This.Object.PicPosition = 1
This.Object.MaskColor = RGB(255,0,255)
This.Object.PicXOffset = 3
This.Object.PicYOffset = 3



end event

event losefocus;call super::losefocus;/*
Esto es para oculatar el d$$HEX1$$ed00$$ENDHEX$$a seleccionado, ya que es un calendario mensual
y solo se debe ver un d$$HEX1$$ed00$$ENDHEX$$a seleccionado y no doce
*/
This.Object.Dateselected( This.Object.Day,false)
return 1
end event

event datechange;call super::datechange;/*
pinta el dia de un color diferente seg$$HEX1$$fa00$$ENDHEX$$n el modo seleccionar
*/

choose case ii_modo_seleccionar
		case 1
			This.Of_SetDateBackColor(This.Object.Day,il_color_festivos)
			This.Of_BorrarBarras()
		case 2
			This.Of_SetDateBackColor(This.Object.Day,il_color_no_laborales)
			This.Of_BorrarBarras()
		case 3
			This.Of_SetDateBackColor(This.Object.Day,-1)			
		case 4
			This.Of_SetDateBackColor(This.Object.Day,il_color_vacaciones)
			This.Of_BorrarBarras()
		case 5
			This.Of_SetDateBackColor(This.Object.Day,il_color_Compensatorios)
			This.Of_BorrarBarras()
		case 6
			This.Of_SetDateBackColor(This.Object.Day,il_color_jornada_especial)
			This.Of_BorrarBarras()
end choose

Message.StringParm = string(nYear)+"-"+String(nMonth)+"-"+String(nDay)
Parent.TriggerEvent("ue_datechange")


end event

