HA$PBExportHeader$w_devolucion_tela.srw
forward
global type w_devolucion_tela from window
end type
type em_hofinal from editmask within w_devolucion_tela
end type
type em_hoinicial from editmask within w_devolucion_tela
end type
type pb_cancelar from picturebutton within w_devolucion_tela
end type
type pb_aceptar from picturebutton within w_devolucion_tela
end type
type rb_consultar from radiobutton within w_devolucion_tela
end type
type rb_generar from radiobutton within w_devolucion_tela
end type
type em_annomes from editmask within w_devolucion_tela
end type
type st_3 from statictext within w_devolucion_tela
end type
type st_2 from statictext within w_devolucion_tela
end type
type st_1 from statictext within w_devolucion_tela
end type
type em_fefinal from editmask within w_devolucion_tela
end type
type em_feinicial from editmask within w_devolucion_tela
end type
type gb_1 from groupbox within w_devolucion_tela
end type
end forward

global type w_devolucion_tela from window
integer x = 823
integer y = 360
integer width = 1093
integer height = 792
boolean titlebar = true
string title = "Untitled"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 67108864
em_hofinal em_hofinal
em_hoinicial em_hoinicial
pb_cancelar pb_cancelar
pb_aceptar pb_aceptar
rb_consultar rb_consultar
rb_generar rb_generar
em_annomes em_annomes
st_3 st_3
st_2 st_2
st_1 st_1
em_fefinal em_fefinal
em_feinicial em_feinicial
gb_1 gb_1
end type
global w_devolucion_tela w_devolucion_tela

on w_devolucion_tela.create
this.em_hofinal=create em_hofinal
this.em_hoinicial=create em_hoinicial
this.pb_cancelar=create pb_cancelar
this.pb_aceptar=create pb_aceptar
this.rb_consultar=create rb_consultar
this.rb_generar=create rb_generar
this.em_annomes=create em_annomes
this.st_3=create st_3
this.st_2=create st_2
this.st_1=create st_1
this.em_fefinal=create em_fefinal
this.em_feinicial=create em_feinicial
this.gb_1=create gb_1
this.Control[]={this.em_hofinal,&
this.em_hoinicial,&
this.pb_cancelar,&
this.pb_aceptar,&
this.rb_consultar,&
this.rb_generar,&
this.em_annomes,&
this.st_3,&
this.st_2,&
this.st_1,&
this.em_fefinal,&
this.em_feinicial,&
this.gb_1}
end on

on w_devolucion_tela.destroy
destroy(this.em_hofinal)
destroy(this.em_hoinicial)
destroy(this.pb_cancelar)
destroy(this.pb_aceptar)
destroy(this.rb_consultar)
destroy(this.rb_generar)
destroy(this.em_annomes)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.em_fefinal)
destroy(this.em_feinicial)
destroy(this.gb_1)
end on

type em_hofinal from editmask within w_devolucion_tela
integer x = 709
integer y = 176
integer width = 274
integer height = 76
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = timemask!
string mask = "hh:mm:ss"
end type

type em_hoinicial from editmask within w_devolucion_tela
integer x = 709
integer y = 80
integer width = 274
integer height = 76
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = timemask!
string mask = "hh:mm:ss"
end type

type pb_cancelar from picturebutton within w_devolucion_tela
integer x = 690
integer y = 496
integer width = 334
integer height = 144
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "&Cancelar"
string picturename = "c:\graficos\cancelar.bmp"
alignment htextalign = right!
end type

type pb_aceptar from picturebutton within w_devolucion_tela
integer x = 325
integer y = 496
integer width = 334
integer height = 144
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "&Aceptar"
string picturename = "c:\graficos\ok.bmp"
alignment htextalign = right!
end type

event clicked;DateTime ldt_feinicial, ldt_fefinal, ldt_annomes
String 	ls_annomes, ls_error
LONG	li_existen
DATE		ldt_anno_mes_2
s_base_parametros lstr_parametros

ldt_feinicial = DateTime(Date(em_feinicial.Text), Time(em_hoinicial.Text))
ldt_fefinal = DateTime(Date(em_fefinal.Text), Time(em_hofinal.Text))
ls_annomes = em_annomes.Text
ldt_annomes = DateTime(Date('01/' + ls_annomes), Time('00:00:00'))
ldt_anno_mes_2 = date(ldt_annomes)


//verificar si ya tiene ordenes vivas.
SELECT COUNT(*)
  INTO :li_existen
  FROM mv_ordcr_vivas
 WHERE date(ano_mes) = :ldt_anno_mes_2 ;
IF li_existen > 0 THEN
	IF MessageBox("Verificacion", "Ya existen ordenes vivas cargadas en este mes, seguramente se realiz$$HEX2$$f3002000$$ENDHEX$$inventario fisico, desea continuar con estas ordenes que tiene cargadas?, si no es asi cancele(No) este proceso y verifique ", Question!, YesNo!, 2) = 2 THEN
		Return
	END IF
END IF

//Si ya existen ordenes cargadas se pregunta al usuario si las va a borrar o va a trabajar con las oc ya leidas jorodrig enero 14 2019
IF li_existen > 0 THEN
	IF MessageBox("Advertencia", "Desea Borrar las Ordenes de Corte que se habian cargado con anterioridad y volver a correr el proceso de carga de ordenes de corte vivas, si responde No se genera el cierre de corte con las ordenes de corte previamente cargadas solamente ", Question!, YesNo!, 2) = 1 THEN
		DELETE FROM mv_ordcr_vivas
		WHERE date(ano_mes) = :ldt_anno_mes_2 ;
		IF SQLCA.SQLCode = -1 THEN
			ROLLBACK;
			MessageBox("Error Base Datos","Error al borrar la informaci$$HEX1$$f300$$ENDHEX$$n ordenes vivas")
			Return
		END IF
	END IF
END IF

//bloquear para que no realicen movimientos durante el cierre
//se pone en el SP porque primero debe actualizar los rollos a fisico 77, y con este control no lo deja hacer.
//UPDATE cf_produc
//   SET sw_cierre = 1
// WHERE co_fabrica = 2
//   AND ano_mes = :ldt_annomes; 
//IF SQLCA.SQLCode = -1 THEN
//	ROLLBACK;
//	MessageBox("Error Base Datos","Se presento un error bloqueando los movimientos")
//	Return
//END IF


IF rb_generar.Checked THEN
	DELETE FROM s_devtel_ordencr
	WHERE ano_mes = :ldt_annomes;
	IF SQLCA.SQLCode = -1 THEN
		ROLLBACK;
		MessageBox("Error Base Datos","Error al borrar la informaci$$HEX1$$f300$$ENDHEX$$n de devolucion tela (s_devtel_ordencr)")
		Return
	END IF
	DELETE FROM s_devtel_ordcr_sin
	WHERE ano_mes = :ldt_annomes;
	IF SQLCA.SQLCode = -1 THEN
		ROLLBACK;
		MessageBox("Error Base Datos","Error al borrar la informaci$$HEX1$$f300$$ENDHEX$$n ordenes fuera")
		Return
	END IF
	
	
	
   DECLARE pr_devolucion PROCEDURE FOR
		pr_dev_tela(:ldt_feinicial, :ldt_fefinal, :ldt_annomes);
	lstr_parametros.cadena[1]="Ejecutando proceso ..."
	lstr_parametros.cadena[2]="Espere un momento por favor, esta operacion pude durar unos segundos..."
	lstr_parametros.cadena[3]="reloj"

	OpenWithParm(w_retroalimentacion,lstr_parametros)
		
	EXECUTE pr_devolucion;
	IF SQLCA.SQLCode = -1 THEN
 		ls_error = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox("Error Base Datos","Error al ejecutar el stored procedure " + ls_error)
		Return
	END IF 
	Close(w_retroalimentacion)
	COMMIT;
END IF
Close(Parent)
lstr_parametros.fechahora[1] = ldt_annomes
OpenSheetWithParm(w_reporte_devolucion_tela, lstr_parametros, w_principal)
end event

type rb_consultar from radiobutton within w_devolucion_tela
integer x = 631
integer y = 368
integer width = 338
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Consultar"
end type

type rb_generar from radiobutton within w_devolucion_tela
integer x = 128
integer y = 368
integer width = 302
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Generar"
boolean checked = true
end type

type em_annomes from editmask within w_devolucion_tela
integer x = 361
integer y = 272
integer width = 229
integer height = 76
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datemask!
string mask = "mm/yyyy"
end type

type st_3 from statictext within w_devolucion_tela
integer x = 91
integer y = 272
integer width = 265
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "A$$HEX1$$f100$$ENDHEX$$o Mes:"
boolean focusrectangle = false
end type

type st_2 from statictext within w_devolucion_tela
integer x = 91
integer y = 176
integer width = 265
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Hora final:"
boolean focusrectangle = false
end type

type st_1 from statictext within w_devolucion_tela
integer x = 91
integer y = 80
integer width = 265
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Hora Inicial:"
boolean focusrectangle = false
end type

type em_fefinal from editmask within w_devolucion_tela
integer x = 361
integer y = 176
integer width = 343
integer height = 76
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datetimemask!
string mask = "dd/mm/yyyy"
end type

type em_feinicial from editmask within w_devolucion_tela
integer x = 361
integer y = 80
integer width = 343
integer height = 76
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datemask!
string mask = "dd/mm/yyyy"
end type

type gb_1 from groupbox within w_devolucion_tela
integer x = 37
integer y = 24
integer width = 992
integer height = 448
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
end type

