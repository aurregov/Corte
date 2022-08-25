HA$PBExportHeader$w_consultar_ficha_prenda.srw
forward
global type w_consultar_ficha_prenda from w_base_tabular
end type
type p_grafico from picture within w_consultar_ficha_prenda
end type
end forward

global type w_consultar_ficha_prenda from w_base_tabular
integer width = 4242
integer height = 1716
string title = "Consulta Ficha Prenda"
string menuname = "m_vista_previa"
event ue_imprimir ( )
event ue_preliminar ( )
p_grafico p_grafico
end type
global w_consultar_ficha_prenda w_consultar_ficha_prenda

type variables
Long ii_ancho, ii_alto, ii_posx, ii_posy
String is_zoom, is_filtrar
boolean ib_filtro, ib_ordenar_ascendente
Long il_i = 0
string is_columna[]
end variables

event ue_imprimir();dw_maestro.setFocus()
OpenWithParm(w_opciones_impresion, dw_maestro)

end event

event ue_preliminar();SetPointer(HourGlass!)
String ls_resultado

ls_resultado = dw_maestro.Describe("DataWindow.Print.Preview")
if ls_resultado <> 'yes' then
	dw_maestro.Modify("DataWindow.Print.Preview=Yes")
	dw_maestro.Modify("DataWindow.Print.Preview.Rulers=Yes")
else
	dw_maestro.Modify("DataWindow.Print.Preview.Rulers=No")
	dw_maestro.Modify("DataWindow.Print.Preview.Zoom="+is_zoom)	
	dw_maestro.Modify("DataWindow.Print.Preview=No")
end if

SetPointer(Arrow!)
end event

on w_consultar_ficha_prenda.create
int iCurrent
call super::create
if IsValid(this.MenuID) then destroy(this.MenuID)
if this.MenuName = "m_vista_previa" then this.MenuID = create m_vista_previa
this.p_grafico=create p_grafico
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.p_grafico
end on

on w_consultar_ficha_prenda.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.p_grafico)
end on

event open;Long li_fabrica, li_linea, ll_co_talla, ll_co_calidad
long ll_numero_registros, ll_referencia
s_base_parametros lstr_parametros

This.x = 1
This.y = 1


lstr_parametros = Message.PowerObjectParm
li_fabrica = lstr_parametros.entero[1]
li_linea = lstr_parametros.entero[2]
ll_referencia = lstr_parametros.entero[3]

If (Isnull(li_fabrica)     Or li_fabrica = 0) OR &
   (Isnull(li_linea) 		Or li_linea = 0) OR &
	(Isnull(ll_referencia)  Or ll_referencia = 0) Then

//	Open(w_parametros_ficha)
	lstr_parametros = Message.PowerObjectParm
	
	If lstr_parametros.hay_parametros = True Then
		li_fabrica = lstr_parametros.entero[1]
		li_linea = lstr_parametros.entero[2]
		ll_referencia = lstr_parametros.entero[3]
	Else
		Return
	End if
	
End if

IF dw_maestro.settransobject(SQLCA)= -1 THEN
	messagebox("Error Datawindow","No se pudo conectar esta ventana a la base de datos",exclamation!,ok!)
ELSE
	ll_numero_registros = dw_maestro.retrieve(li_fabrica, li_linea, ll_referencia)
	CHOOSE CASE ll_numero_registros 
		CASE -1
			MessageBox("Error datawindow","No pudo traer datos",stopsign!,ok!)
	END CHOOSE
END IF
dw_maestro.modify("dw_lista.readonly=yes")
dw_maestro.setfocus()


end event

type dw_maestro from w_base_tabular`dw_maestro within w_consultar_ficha_prenda
integer y = 20
integer width = 2912
integer height = 1496
string title = "Consultar Ficha de Prenda"
string dataobject = "dtb_consultar_ficha_prenda"
boolean border = true
borderstyle borderstyle = stylelowered!
end type

event dw_maestro::clicked;call super::clicked;Long  li_fab, li_lin, li_talla, li_calidad
LONG		ll_ref, ll_color_pt
Transaction ltr_graficos
String ls_ruta, ls_archivo
s_base_parametros lstr_parametros_retro


IF row > 0 THEN
	//para mostrar ventana de espera  
	lstr_parametros_retro.cadena[1]="Procesando ..."
	lstr_parametros_retro.cadena[2]="Espere un momento por favor, Cargando registros segun su criterio..."
	lstr_parametros_retro.cadena[3]="reloj"
	OpenWithParm(w_retroalimentacion,lstr_parametros_retro)    
	
	li_fab = This.GetItemNumber(row, "co_fabrica")
	li_lin = This.GetItemNumber(row, "co_linea")
	ll_ref = This.GetItemNumber(row, "co_referencia")
	li_talla = This.GetItemNumber(row, "co_talla")
	li_calidad = This.GetItemNumber(row, "co_calidad")
	ll_color_pt = This.GetItemNumber(row, "co_color_pt")
	
	
	// Vamos a consultar el grafico de la prenda.					
		ltr_graficos = Create Transaction
		ltr_graficos.DBMS		=	ProfileString(gstr_info_usuario.ruta_ini,"bd aplicacion","DBMS","")
		ltr_graficos.USERID		=	SQLCA.USERID
		ltr_graficos.DBPASS		=	SQLCA.DBPASS
		ltr_graficos.DBPARM		=	"connectstring='DSN="+ltr_graficos.DATABASE+";UID="+ltr_graficos.USERID+";PWD="+ltr_graficos.DBPASS+"'"
		ltr_graficos.ServerName = 	"vesrs00@hilpro01"
		ltr_graficos.Lock 		= 	ProfileString(gstr_info_usuario.ruta_ini,"bd aplicacion","LOCK","")					
		
		IF li_fab = 2  THEN
			ltr_graficos.DATABASE	=	"system_graf"
		ELSE
			ltr_graficos.DATABASE	=	"system_graf_inf"
		END IF					
		
		CONNECT USING ltr_graficos;
		IF ltr_graficos.SQLCode = -1 THEN
			MessageBox("Error Base Datos","Error al conectarse a la base de datos de gr$$HEX1$$e100$$ENDHEX$$ficos")
		END IF
		
		SELECT de_path, de_archivo
		INTO :ls_ruta, :ls_archivo
		FROM refe_paths
		WHERE co_fabrica    = :li_fab AND
				co_linea      = :li_lin   AND
				co_referencia = :ll_ref   AND
				co_talla      = :li_talla   AND
				co_calidad    = :li_calidad AND
				de_orden      = 'Frente'
		USING ltr_graficos;
				
		IF ltr_graficos.SQLCode = -1 THEN
			MessageBox("Error Base Datos","Error al consultar la ruta del archivo")
			ls_ruta = ''
			ls_archivo = ''
		END IF
		
		DISCONNECT USING ltr_graficos;
		
		p_grafico.PictureName = Trim(ls_ruta) + Trim(ls_archivo)
		Close(w_retroalimentacion)
		
	END IF

end event

type sle_argumento from w_base_tabular`sle_argumento within w_consultar_ficha_prenda
boolean visible = false
end type

type st_1 from w_base_tabular`st_1 within w_consultar_ficha_prenda
boolean visible = false
end type

type p_grafico from picture within w_consultar_ficha_prenda
integer x = 2962
integer y = 20
integer width = 1230
integer height = 1492
boolean bringtotop = true
boolean border = true
boolean focusrectangle = false
end type

