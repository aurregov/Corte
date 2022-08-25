HA$PBExportHeader$w_mantenimiento_reportes.srw
forward
global type w_mantenimiento_reportes from w_base_tabular
end type
type ddlb_controles from dropdownlistbox within w_mantenimiento_reportes
end type
type dw_lista from datawindow within w_mantenimiento_reportes
end type
type st_2 from statictext within w_mantenimiento_reportes
end type
type cb_abrir_pbl from commandbutton within w_mantenimiento_reportes
end type
type ddlb_ventanas from dropdownlistbox within w_mantenimiento_reportes
end type
type st_3 from statictext within w_mantenimiento_reportes
end type
type cb_1 from commandbutton within w_mantenimiento_reportes
end type
type dw_listaw from datawindow within w_mantenimiento_reportes
end type
end forward

global type w_mantenimiento_reportes from w_base_tabular
integer x = 0
integer y = 0
integer width = 2917
integer height = 1444
string title = "Mantenimiento de Reportes"
string menuname = "m_reportes"
ddlb_controles ddlb_controles
dw_lista dw_lista
st_2 st_2
cb_abrir_pbl cb_abrir_pbl
ddlb_ventanas ddlb_ventanas
st_3 st_3
cb_1 cb_1
dw_listaw dw_listaw
end type
global w_mantenimiento_reportes w_mantenimiento_reportes

type variables
String is_archivo_pbl
end variables

on w_mantenimiento_reportes.create
int iCurrent
call super::create
if IsValid(this.MenuID) then destroy(this.MenuID)
if this.MenuName = "m_reportes" then this.MenuID = create m_reportes
this.ddlb_controles=create ddlb_controles
this.dw_lista=create dw_lista
this.st_2=create st_2
this.cb_abrir_pbl=create cb_abrir_pbl
this.ddlb_ventanas=create ddlb_ventanas
this.st_3=create st_3
this.cb_1=create cb_1
this.dw_listaw=create dw_listaw
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.ddlb_controles
this.Control[iCurrent+2]=this.dw_lista
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.cb_abrir_pbl
this.Control[iCurrent+5]=this.ddlb_ventanas
this.Control[iCurrent+6]=this.st_3
this.Control[iCurrent+7]=this.cb_1
this.Control[iCurrent+8]=this.dw_listaw
end on

on w_mantenimiento_reportes.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.ddlb_controles)
destroy(this.dw_lista)
destroy(this.st_2)
destroy(this.cb_abrir_pbl)
destroy(this.ddlb_ventanas)
destroy(this.st_3)
destroy(this.cb_1)
destroy(this.dw_listaw)
end on

event open;call super::open;String ls_entradas

// CARGA LAS DATAWINDOW
ls_entradas = LibraryDirectory( "c:\ventas\reportes.pbl", DirDataWindow!)
dw_lista.SetRedraw(FALSE)
dw_lista.Reset( )
dw_lista.ImportString(ls_Entradas)
dw_lista.SetRedraw(TRUE)

int	li_posicion, li_numfilas

li_numfilas = dw_lista.RowCount()
for li_posicion = 1 to li_numfilas
	ddlb_controles.insertitem(dw_lista.GetItemString(li_posicion,1), &
										li_posicion)
Next

//CARGA LAS VENTANAS
ls_entradas = LibraryDirectory( "c:\ventas\reportes.pbl", DirWindow!)
dw_listaw.SetRedraw(FALSE)
dw_listaw.Reset( )
dw_listaw.ImportString(ls_Entradas)
dw_listaw.SetRedraw(TRUE)

li_numfilas = dw_listaw.RowCount()
for li_posicion = 1 to li_numfilas
	ddlb_ventanas.insertitem(dw_listaw.GetItemString(li_posicion,1), &
										li_posicion)
Next
This.Width = 2890
This.Height = 1261


end event

event ue_insertar_maestro;Long li_aplicacion
Long ll_fila

ll_fila = dw_maestro.InsertRow(0)
IF ll_fila = -1 THEN
	MessageBox("Error datawindow","No se pudo insertar el registro del maestro",StopSign!,Ok!)
ELSE
	dw_maestro.SetRow(ll_fila)
	dw_maestro.ScrollToRow(ll_fila)
	dw_maestro.SetColumn(1)
	dw_maestro.SelectRow(0,False)
	il_fila_actual_maestro = ll_fila
END IF

dw_maestro.SelectRow(il_fila_actual_maestro,FALSE)
il_fila_actual_maestro = dw_maestro.GetRow()

IF ((il_fila_actual_maestro<> -1) and &
     (NOT ISNULL (il_fila_actual_maestro)) and &
	  (il_fila_actual_maestro<>0))THEN
     dw_maestro.SelectRow(il_fila_actual_maestro,TRUE)
ELSE
END IF

li_aplicacion = gstr_info_usuario.codigo_aplicacion
dw_maestro.SetItem(il_fila_actual_maestro,"co_perfil",0)
dw_maestro.SetItem(il_fila_actual_maestro, "co_aplicacion", gstr_info_usuario.codigo_aplicacion)
end event

event resize;call super::resize;dw_maestro.Resize(This.Width - 120, This.Height - 450)
end event

event ue_buscar;s_base_parametros lstr_parametros_retro

CALL w_base_simple::ue_buscar
IF is_cambios = "no" OR is_accion <> "cancelo" THEN
	
	///////////////////////////////////////////////////////////////////
	// Las siguientes tres lineas, estan llenando la estructura 
	// s_base_parametrospara poder asi desplegar en la ventana 
   // de retroalimentacion el mensaje correspondiente a la 
	// accion que se esta ejecutando.
	//
	///////////////////////////////////////////////////////////////////
	
	lstr_parametros_retro.cadena[1]="Cargando datos ..."
	lstr_parametros_retro.cadena[2]="Espere un momento por favor, esta operacion pude durar unos segundos..."
	lstr_parametros_retro.cadena[3]="reloj"

	OpenWithParm(w_retroalimentacion,lstr_parametros_retro)

	CHOOSE CASE dw_maestro.Retrieve(sle_argumento.text+"%", gstr_info_usuario.codigo_aplicacion)
		CASE -1
			Close(w_retroalimentacion)
			MessageBox("Error datawindow","No se pudo cargar datos", &
			            Exclamation!,Ok!)
			 
			////////////////////////////////////////////////////////////////
       	// Las siguientes cinco lineas, estan llenando la estructura 
      	// s_base_parametros 
      	// para poder asi desplegar en la ventana de errores el mensaje
      	// correspondiente al error reportado por el motor de base de 
			// datos.
       	////////////////////////////////////////////////////////////////
			 
			istr_parametros_error.cadena[1]=sqlca.dbms
			istr_parametros_error.entero[1]=sqlca.sqlcode
			istr_parametros_error.cadena[2]=this.classname()
			istr_parametros_error.cadena[3]="modified"
			istr_parametros_error.cadena[4]=""
			istr_parametros_error.cadena[5] = SQLCA.SQLErrText
			OpenWithParm(w_reporte_errores,istr_parametros_error)
			Close(This)
		CASE 0
			Close(w_retroalimentacion)
			MessageBox("Error datawindows","No se hallaron datos", &
			            Exclamation!,Ok!)
		CASE ELSE
			Close(w_retroalimentacion)
			il_fila_actual_maestro = 1
			dw_maestro.SetRow(il_fila_actual_maestro)
			dw_maestro.SelectRow(il_fila_actual_maestro,TRUE)
			dw_maestro.ScrollToRow(il_fila_actual_maestro)
			dw_maestro.SetColumn(1)
			dw_maestro.SetFocus()
	END CHOOSE
ELSE
END IF
end event

type dw_maestro from w_base_tabular`dw_maestro within w_mantenimiento_reportes
integer x = 23
integer y = 332
integer width = 2834
integer height = 648
integer taborder = 40
string dataobject = "dtb_mantenimiento_reportes"
boolean border = true
borderstyle borderstyle = stylelowered!
end type

event dw_maestro::itemchanged;// Se omite el script
end event

type sle_argumento from w_base_tabular`sle_argumento within w_mantenimiento_reportes
integer x = 818
integer y = 16
integer width = 425
integer height = 80
integer taborder = 60
end type

type st_1 from w_base_tabular`st_1 within w_mantenimiento_reportes
integer x = 558
integer y = 20
end type

type ddlb_controles from dropdownlistbox within w_mantenimiento_reportes
integer x = 818
integer y = 116
integer width = 1152
integer height = 660
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long backcolor = 79741120
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event selectionchanged;dw_maestro.SetItem(il_fila_actual_maestro,"de_datawindow", this.text)
end event

type dw_lista from datawindow within w_mantenimiento_reportes
boolean visible = false
integer x = 2464
integer y = 112
integer width = 393
integer height = 92
integer taborder = 10
boolean bringtotop = true
string dataobject = "dtb_lista_controles"
boolean livescroll = true
end type

type st_2 from statictext within w_mantenimiento_reportes
integer x = 55
integer y = 128
integer width = 759
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long backcolor = 81576884
boolean enabled = false
string text = "Asignar Datawindow a Fila Actual :"
boolean focusrectangle = false
end type

type cb_abrir_pbl from commandbutton within w_mantenimiento_reportes
integer x = 1993
integer y = 112
integer width = 453
integer height = 92
integer taborder = 70
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "&Abrir PBL"
end type

event clicked;string ls_nombre_doc, named
String ls_entradas
Long li_valor
Long li_posicion, li_numfilas

li_valor = GetFileOpenName("Seleccione Libreria de Reportes",  &
	+ ls_nombre_doc, named, "PBL",  &
	+ "Librerias Fuente      (*.PBL),*.PBL,"  &
	+ "Librerias Ejecutables (*.PBD),*.PBD")

IF li_valor = 1 THEN 
	li_numfilas = dw_lista.RowCount()	
	for li_posicion = li_numfilas to 1 STEP -1
		ddlb_controles.DeleteItem(li_posicion)
	Next
	is_archivo_pbl = ls_nombre_doc
	ls_entradas = LibraryDirectory( is_archivo_pbl, DirDataWindow!)
	dw_lista.SetRedraw(FALSE)
	dw_lista.Reset( )
	dw_lista.ImportString(ls_Entradas)
	dw_lista.SetRedraw(TRUE)	
	li_numfilas = dw_lista.RowCount()
	for li_posicion = 1 to li_numfilas
		ddlb_controles.insertitem(dw_lista.GetItemString(li_posicion,1), &
										li_posicion)
	Next
END IF
end event

type ddlb_ventanas from dropdownlistbox within w_mantenimiento_reportes
integer x = 818
integer y = 232
integer width = 1152
integer height = 660
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long backcolor = 79741120
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event selectionchanged;dw_maestro.SetItem(il_fila_actual_maestro,"de_wparametros", this.text)
end event

type st_3 from statictext within w_mantenimiento_reportes
integer x = 133
integer y = 236
integer width = 681
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long backcolor = 81576884
boolean enabled = false
string text = "Asignar Ventana a Fila Actual :"
boolean focusrectangle = false
end type

type cb_1 from commandbutton within w_mantenimiento_reportes
integer x = 1993
integer y = 220
integer width = 453
integer height = 92
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "&Abrir PBL"
end type

event clicked;string ls_nombre_doc, named
String ls_entradas
Long li_valor
Long li_posicion, li_numfilas

li_valor = GetFileOpenName("Seleccione Libreria de Reportes",  &
	+ ls_nombre_doc, named, "PBL",  &
	+ "Librerias Fuente      (*.PBL),*.PBL,"  &
	+ "Librerias Ejecutables (*.PBD),*.PBD")

IF li_valor = 1 THEN 
	li_numfilas = dw_listaw.RowCount()	
	for li_posicion = li_numfilas to 1 STEP -1
		ddlb_ventanas.DeleteItem(li_posicion)
	Next
	is_archivo_pbl = ls_nombre_doc
	ls_entradas = LibraryDirectory( is_archivo_pbl, DirWindow!)
	dw_listaw.SetRedraw(FALSE)
	dw_listaw.Reset( )
	dw_listaw.ImportString(ls_Entradas)
	dw_listaw.SetRedraw(TRUE)	
	li_numfilas = dw_listaw.RowCount()
	for li_posicion = 1 to li_numfilas
		ddlb_ventanas.insertitem(dw_listaw.GetItemString(li_posicion,1), &
										li_posicion)
	Next
END IF
end event

type dw_listaw from datawindow within w_mantenimiento_reportes
boolean visible = false
integer x = 2469
integer y = 220
integer width = 393
integer height = 92
integer taborder = 11
boolean bringtotop = true
string dataobject = "dtb_lista_controles"
boolean livescroll = true
end type

