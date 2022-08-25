HA$PBExportHeader$w_cargar_datos_make_to_stock.srw
forward
global type w_cargar_datos_make_to_stock from window
end type
type cb_1 from commandbutton within w_cargar_datos_make_to_stock
end type
type cb_salir from commandbutton within w_cargar_datos_make_to_stock
end type
type cb_ingresar from commandbutton within w_cargar_datos_make_to_stock
end type
type cb_borrar_todo from commandbutton within w_cargar_datos_make_to_stock
end type
type cb_borrar_registro from commandbutton within w_cargar_datos_make_to_stock
end type
type cb_make_to_stock from commandbutton within w_cargar_datos_make_to_stock
end type
type cb_validar from commandbutton within w_cargar_datos_make_to_stock
end type
type cb_plano from commandbutton within w_cargar_datos_make_to_stock
end type
type dw_lista from datawindow within w_cargar_datos_make_to_stock
end type
type gb_1 from groupbox within w_cargar_datos_make_to_stock
end type
type gb_2 from groupbox within w_cargar_datos_make_to_stock
end type
type gb_3 from groupbox within w_cargar_datos_make_to_stock
end type
type gb_4 from groupbox within w_cargar_datos_make_to_stock
end type
type gb_5 from groupbox within w_cargar_datos_make_to_stock
end type
end forward

global type w_cargar_datos_make_to_stock from window
integer width = 3141
integer height = 2124
boolean titlebar = true
string title = "Cargar Datos Make To Stock"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
cb_1 cb_1
cb_salir cb_salir
cb_ingresar cb_ingresar
cb_borrar_todo cb_borrar_todo
cb_borrar_registro cb_borrar_registro
cb_make_to_stock cb_make_to_stock
cb_validar cb_validar
cb_plano cb_plano
dw_lista dw_lista
gb_1 gb_1
gb_2 gb_2
gb_3 gb_3
gb_4 gb_4
gb_5 gb_5
end type
global w_cargar_datos_make_to_stock w_cargar_datos_make_to_stock

forward prototypes
public function long of_bajar_datos_plano ()
public function long of_cargar_make_to_stock ()
public function long of_validar_datos ()
end prototypes

public function long of_bajar_datos_plano ();//funcion para bajar desde un archivo plano los datos del archivo make to stock
//jcrm
//octubre 1 de 2008

SetPointer(HourGlass!)
//creacion de variables
string ls_registro, ls_nombre, s_archivo
String docname, named
Long value
Long ll_filas

value = GetFileSaveName("Select File",  docname, named, "DOC", "Text Files (*.TXT),*.TXT,")
SetPointer(HourGlass!)
s_archivo = docname
dw_lista.AcceptText()
ll_filas = dw_lista.ImportFile(s_archivo)
IF ll_filas > 0 THEN
	IF dw_lista.Update() = -1 THEN
		Rollback;
		MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de cargar los datos.',StopSign!)
		Return -1
	ELSE
		Commit;
		Return 0
	END IF
ELSE
	MessageBox('Advertencia','No se encontarron datos a cargar.',StopSign!)
	Return 0
END IF
Return 0
end function

public function long of_cargar_make_to_stock ();//funcion para ejecutar procedimiento que se encarga de subir los datos del archivo make to stock
//al a$$HEX1$$f100$$ENDHEX$$o y semana correspondiente.
//jcrm
//octubre 1 de 2008

//esta pendiente que el procedimiento capture el a$$HEX1$$f100$$ENDHEX$$o, semana contable y actualice ela $$HEX1$$f100$$ENDHEX$$o y semana critica en
//m_constantes, el script esta hecho, pero para la primera prueba se deja asi, solo en la segunda se hara esto automatico.
String ls_error

s_base_parametros lstr_parametros_retro
lstr_parametros_retro.cadena[1]="Procesando ..."
lstr_parametros_retro.cadena[2]="Espere un momento por favor, Procesando datos..."
lstr_parametros_retro.cadena[3]="reloj"


DECLARE maketostock PROCEDURE &
	FOR pr_cargar_criticas_jdt_nuevo();
EXECUTE maketostock;

IF SQLCA.SQLCode = -1 THEN
	ls_error = SQLCA.SQLErrText
	ROLLBACK;
	CLOSE(w_retroalimentacion)
	MessageBox("Error Base Datos","Error al ejecutar el stored procedure, ERROR: "+ ls_error)			
	Return -1
ELSE
	Commit;
	CLOSE(w_retroalimentacion)
	MessageBox("Exito","El proceso termino exitosamente, por favor verificar los datos.")
END IF


CLOSE maketostock;
Return 0
end function

public function long of_validar_datos ();//funcion para realizar una validacion inicial de los datos cargados desde el archivo plano
//se validan que la fabrica, linea y referencia existan en h_preref_pv, y que los valores numeros 
//no sean negativos y los dias cedi no sean mayores de 90.
//todo esto sera solo informativo, para que el usuario tenga la posibilidad de realizar
//la modificacion de la linea que tiene problem
//jcrm
//octubre 2 de 2008


Return 0
end function

on w_cargar_datos_make_to_stock.create
this.cb_1=create cb_1
this.cb_salir=create cb_salir
this.cb_ingresar=create cb_ingresar
this.cb_borrar_todo=create cb_borrar_todo
this.cb_borrar_registro=create cb_borrar_registro
this.cb_make_to_stock=create cb_make_to_stock
this.cb_validar=create cb_validar
this.cb_plano=create cb_plano
this.dw_lista=create dw_lista
this.gb_1=create gb_1
this.gb_2=create gb_2
this.gb_3=create gb_3
this.gb_4=create gb_4
this.gb_5=create gb_5
this.Control[]={this.cb_1,&
this.cb_salir,&
this.cb_ingresar,&
this.cb_borrar_todo,&
this.cb_borrar_registro,&
this.cb_make_to_stock,&
this.cb_validar,&
this.cb_plano,&
this.dw_lista,&
this.gb_1,&
this.gb_2,&
this.gb_3,&
this.gb_4,&
this.gb_5}
end on

on w_cargar_datos_make_to_stock.destroy
destroy(this.cb_1)
destroy(this.cb_salir)
destroy(this.cb_ingresar)
destroy(this.cb_borrar_todo)
destroy(this.cb_borrar_registro)
destroy(this.cb_make_to_stock)
destroy(this.cb_validar)
destroy(this.cb_plano)
destroy(this.dw_lista)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.gb_3)
destroy(this.gb_4)
destroy(this.gb_5)
end on

event open;This.x = 1
This.y = 1

dw_lista.SetTransObject(sqlca)
dw_lista.retrieve()
dw_lista.SetFocus()
end event

event key;IF key = KeyF2! THEN
	cb_ingresar.TriggerEvent (Clicked! )
END IF
end event

type cb_1 from commandbutton within w_cargar_datos_make_to_stock
integer x = 2546
integer y = 304
integer width = 530
integer height = 100
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Grabar Registros"
end type

event clicked;IF dw_lista.Update() = -1 THEN
	Rollback;
	MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de cargar los datos.')
	Return -1
END IF
end event

type cb_salir from commandbutton within w_cargar_datos_make_to_stock
integer x = 2546
integer y = 1664
integer width = 530
integer height = 100
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Salir"
end type

event clicked;Close(Parent)
end event

type cb_ingresar from commandbutton within w_cargar_datos_make_to_stock
integer x = 2546
integer y = 64
integer width = 530
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Ingresar Registro"
end type

event clicked;Long ll_fila_nueva

ll_fila_nueva = dw_lista.InsertRow(0)
dw_lista.ScrollToRow(ll_fila_nueva)
end event

type cb_borrar_todo from commandbutton within w_cargar_datos_make_to_stock
integer x = 2546
integer y = 824
integer width = 530
integer height = 100
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Borrar Todo"
end type

event clicked;String ls_error
Long Net

Net = MessageBox("Advertencia", 'Esta seguro que desea borrar todos los registros en pantalla.', Exclamation!, OKCancel!, 2)

IF Net = 1 THEN
	delete from t_criticas_cedi_jdt;

	IF sqlca.Sqlcode = -1 THEN
		ls_error = sqlca.sqlerrtext
		Rollback;
		dw_lista.retrieve()
		MessageBox('Error','Ocurrio un error al momento de borrar los datos, ERROR: '+ls_error)
		Return
	ELSE
		Commit;
		dw_lista.retrieve()
	END IF
END IF


end event

type cb_borrar_registro from commandbutton within w_cargar_datos_make_to_stock
integer x = 2546
integer y = 184
integer width = 530
integer height = 100
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Borrar registro"
end type

event clicked;Long ll_fila

ll_fila = dw_lista.GetRow()

IF ll_fila > 0 THEN
	dw_lista.DeleteRow(ll_fila)
ELSE
	MessageBox('Error','La fila seleccionada no es valida.')
	return
END IF
end event

type cb_make_to_stock from commandbutton within w_cargar_datos_make_to_stock
integer x = 2546
integer y = 1264
integer width = 530
integer height = 100
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cargar make To Stock"
end type

event clicked;of_cargar_make_to_stock()
end event

type cb_validar from commandbutton within w_cargar_datos_make_to_stock
integer x = 2546
integer y = 696
integer width = 530
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "validar Datos"
end type

event clicked;of_validar_datos()
end event

type cb_plano from commandbutton within w_cargar_datos_make_to_stock
integer x = 2546
integer y = 568
integer width = 530
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "bajar Datos plano"
end type

event clicked;//se invoca funcion para cargar los datos del archivo plano a la tabla t_criticas_cedi_jdt
//que es la tabla intermedia antes de ejecutar el procedimiento para cargar al archivo de criticas
//t_criticas_cedi, que es con el que liberan la s referencias make to stock
//jcrm
//octubre 1 de 2008
of_bajar_datos_plano()

end event

type dw_lista from datawindow within w_cargar_datos_make_to_stock
integer x = 55
integer y = 64
integer width = 2391
integer height = 1848
integer taborder = 10
string title = "none"
string dataobject = "dgr_cargar_make_to_stock"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event clicked;This.SelectRow(0, FALSE)

This.SelectRow(row, TRUE)
end event

type gb_1 from groupbox within w_cargar_datos_make_to_stock
integer x = 18
integer width = 2464
integer height = 1996
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "datos "
end type

type gb_2 from groupbox within w_cargar_datos_make_to_stock
integer x = 2519
integer y = 20
integer width = 585
integer height = 416
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
end type

type gb_3 from groupbox within w_cargar_datos_make_to_stock
integer x = 2519
integer y = 532
integer width = 585
integer height = 428
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
end type

type gb_4 from groupbox within w_cargar_datos_make_to_stock
integer x = 2519
integer y = 1224
integer width = 585
integer height = 164
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
end type

type gb_5 from groupbox within w_cargar_datos_make_to_stock
integer x = 2519
integer y = 1624
integer width = 585
integer height = 164
integer taborder = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
end type

