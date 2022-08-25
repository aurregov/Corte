HA$PBExportHeader$w_conexion_asignacion_modulos.srw
forward
global type w_conexion_asignacion_modulos from w_base_conexion
end type
type st_2 from statictext within w_conexion_asignacion_modulos
end type
type st_1 from statictext within w_conexion_asignacion_modulos
end type
end forward

global type w_conexion_asignacion_modulos from w_base_conexion
string title = "Acceso a Asignaci$$HEX1$$f300$$ENDHEX$$n M$$HEX1$$f300$$ENDHEX$$dulos"
st_2 st_2
st_1 st_1
end type
global w_conexion_asignacion_modulos w_conexion_asignacion_modulos

on w_conexion_asignacion_modulos.create
int iCurrent
call super::create
this.st_2=create st_2
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_2
this.Control[iCurrent+2]=this.st_1
end on

on w_conexion_asignacion_modulos.destroy
call super::destroy
destroy(this.st_2)
destroy(this.st_1)
end on

event open;call super::open;////////////////////////////////////////////////////////////////////////
// En la siguiente linea se debe especificar la ruta del archivo .ini 
// de la aplicacion correspondiente
////////////////////////////////////////////////////////////////////////

gstr_info_usuario.ruta_ini="c:\corte\corte.ini"
//This.Title = This.Title + " " + ProfileString(gstr_info_usuario.ruta_ini, "acerca de", "sistema", "")
end event

type dw_1 from w_base_conexion`dw_1 within w_conexion_asignacion_modulos
end type

type st_fabrica from w_base_conexion`st_fabrica within w_conexion_asignacion_modulos
end type

type pb_desconectar from w_base_conexion`pb_desconectar within w_conexion_asignacion_modulos
end type

type pb_conectar from w_base_conexion`pb_conectar within w_conexion_asignacion_modulos
end type

event pb_conectar::clicked;call super::clicked;//revisa si la confifuracion regional esta en espa$$HEX1$$f100$$ENDHEX$$ol-colombia
//de no ser asi informa a usuario como hacer la configuracion manual

//valida que la configuracion regional se colombia
String ls_pais
RegistryGet("HKEY_CURRENT_USER\Control Panel\International","sCountry",RegString!, ls_pais)
IF trim(ls_pais) <> "Colombia" then
	//String ls_regKey
	//ls_regKey = "HKEY_CURRENT_USER\Control Panel\International" 
	//RegistrySET(ls_regKey, "iCountry", "57")
	//RegistrySET(ls_regKey, "iCurrDigits", "2")
	//RegistrySET(ls_regKey, "iCurrency", "0")
	//RegistrySET(ls_regKey, "iDate", "1")
	//RegistrySET(ls_regKey, "iDigits", "2")
	//RegistrySET(ls_regKey, "iLZero", "1")
	//RegistrySET(ls_regKey, "iMeasure", "0")
	//RegistrySET(ls_regKey, "iNegCurr", "1")
	//RegistrySET(ls_regKey, "iTime", "0")
	//RegistrySET(ls_regKey, "iTLZero", "1")
	//RegistrySET(ls_regKey, "Locale", "0000080A")
	//RegistrySET(ls_regKey, "s1159", "a.m.")
	//RegistrySET(ls_regKey, "s2359", "p.m.")
	//RegistrySET(ls_regKey, "sCountry", "Colombia")
	//RegistrySET(ls_regKey, "sCurrency", "$")
	//RegistrySET(ls_regKey, "sDate", "/")
	//RegistrySET(ls_regKey, "sDecimal", ".")
	//RegistrySET(ls_regKey, "sLanguage", "ESM")
	//RegistrySET(ls_regKey, "sList", ",")
	//RegistrySET(ls_regKey, "sLongDate", "dddd, dd' de 'MMMM' del 'yyyy")
	//RegistrySET(ls_regKey, "sShortDate", "dd/MM/yyyy")
	//RegistrySET(ls_regKey, "sThousand", ",")
	//RegistrySET(ls_regKey, "sTime", ":")
	//RegistrySET(ls_regKey, "sTimeFormat", "hh:mm:ss tt")
	//RegistrySET(ls_regKey, "iTimePrefix", "0")
	//RegistrySET(ls_regKey, "sMonDecimalSep", ".")
	//RegistrySET(ls_regKey, "sMonThousandSep", ",")
	//RegistrySET(ls_regKey, "iNegNumber", "1")
	//RegistrySET(ls_regKey, "sNativeDigits", "0123456789")
	//RegistrySET(ls_regKey, "NumShape", "1")
	//RegistrySET(ls_regKey, "iCalendarType", "1")
	//RegistrySET(ls_regKey, "iFirstDayOfWeek", "6")
	//RegistrySET(ls_regKey, "iFirstWeekOfYear","0")
	//RegistrySET(ls_regKey, "sGrouping", "3;0")
	//RegistrySET(ls_regKey, "sMonGrouping", "3;0")
	//RegistrySET(ls_regKey, "sPositiveSign", "")
	//RegistrySET(ls_regKey, "sNegativeSign", "-")
	//else
	messagebox("Aviso Importante","Configuracion Regional no Apropiada.~n"+&
	           "Para configurarla seguir los siguientes pasos:~n"+&
	           "1. Dar click en start(inicio) en el servidor.~n"+&
				  "2. Dar click en panel de control.~n"+&
				  "3. Dar dobleclick en el icono que dice Regional and Language Options,~n"+&
				  "   seleccionar Spanish(Colombia) y donde dice Location seleccionar Colombia,"+&
				  "dar click en OK y volver ingresar a la aplicaci$$HEX1$$f300$$ENDHEX$$n" )
END IF
end event

type sle_password from w_base_conexion`sle_password within w_conexion_asignacion_modulos
end type

type sle_co_usuario from w_base_conexion`sle_co_usuario within w_conexion_asignacion_modulos
end type

type st_password from w_base_conexion`st_password within w_conexion_asignacion_modulos
end type

type st_cousuario from w_base_conexion`st_cousuario within w_conexion_asignacion_modulos
end type

type gb_captura from w_base_conexion`gb_captura within w_conexion_asignacion_modulos
end type

type gb_picture from w_base_conexion`gb_picture within w_conexion_asignacion_modulos
end type

type st_2 from statictext within w_conexion_asignacion_modulos
integer x = 46
integer y = 64
integer width = 901
integer height = 124
boolean bringtotop = true
integer textsize = -13
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Verdana"
boolean italic = true
long textcolor = 134217730
long backcolor = 79741120
string text = "S.I.C.O. "
alignment alignment = center!
boolean focusrectangle = false
end type

type st_1 from statictext within w_conexion_asignacion_modulos
integer x = 46
integer y = 204
integer width = 901
integer height = 124
boolean bringtotop = true
integer textsize = -13
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Verdana"
boolean italic = true
long textcolor = 134217730
long backcolor = 79741120
string text = "MODULO CORTE"
alignment alignment = center!
boolean focusrectangle = false
end type

