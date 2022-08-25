HA$PBExportHeader$w_cargar_fisobras.srw
forward
global type w_cargar_fisobras from window
end type
type pb_cancelar from picturebutton within w_cargar_fisobras
end type
type pb_aceptar from picturebutton within w_cargar_fisobras
end type
type st_1 from statictext within w_cargar_fisobras
end type
type em_annomes from editmask within w_cargar_fisobras
end type
type gb_1 from groupbox within w_cargar_fisobras
end type
end forward

global type w_cargar_fisobras from window
integer x = 823
integer y = 360
integer width = 699
integer height = 468
boolean titlebar = true
string title = "Cargar"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 79741120
pb_cancelar pb_cancelar
pb_aceptar pb_aceptar
st_1 st_1
em_annomes em_annomes
gb_1 gb_1
end type
global w_cargar_fisobras w_cargar_fisobras

on w_cargar_fisobras.create
this.pb_cancelar=create pb_cancelar
this.pb_aceptar=create pb_aceptar
this.st_1=create st_1
this.em_annomes=create em_annomes
this.gb_1=create gb_1
this.Control[]={this.pb_cancelar,&
this.pb_aceptar,&
this.st_1,&
this.em_annomes,&
this.gb_1}
end on

on w_cargar_fisobras.destroy
destroy(this.pb_cancelar)
destroy(this.pb_aceptar)
destroy(this.st_1)
destroy(this.em_annomes)
destroy(this.gb_1)
end on

type pb_cancelar from picturebutton within w_cargar_fisobras
integer x = 343
integer y = 208
integer width = 293
integer height = 144
integer taborder = 30
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

type pb_aceptar from picturebutton within w_cargar_fisobras
integer x = 46
integer y = 204
integer width = 274
integer height = 144
integer taborder = 20
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

event clicked;DateTime ldt_annomes
String ls_annomes
Long li_respuesta
s_base_parametros lstr_parametros

ls_annomes = em_annomes.Text
ldt_annomes = DateTime(Date('01/' + ls_annomes), Time('00:00:00'))
li_respuesta = MessageBox("Advertencia...","Este proceso borra la informaci$$HEX1$$f300$$ENDHEX$$n primero la " + &
					"informaci$$HEX1$$f300$$ENDHEX$$n de la tabla devoluci$$HEX1$$f300$$ENDHEX$$n proporciones tela para el a$$HEX1$$f100$$ENDHEX$$o mes indicado, desea continuar", Question!, YesNo!)
IF li_respuesta = 1 THEN
//	DELETE FROM mv_fis_sobras
//	WHERE ano_mes = :ldt_annomes;
//	IF SQLCA.SQLCode = -1 THEN
//		MessageBox("Error Base Datos","Error al borrar la informaci$$HEX1$$f300$$ENDHEX$$n")
//		Return
//	END IF
	DECLARE pr_cargar PROCEDURE FOR
		pr_carga_fisobras(:ldt_annomes);
	lstr_parametros.cadena[1]="Ejecutando proceso ..."
	lstr_parametros.cadena[2]="Espere un momento por favor, esta operacion pude durar unos segundos..."
	lstr_parametros.cadena[3]="reloj"
	
	OpenWithParm(w_retroalimentacion,lstr_parametros)
		
	EXECUTE pr_cargar;
	IF SQLCA.SQLCode = -1 THEN
		ROLLBACK;
		MessageBox("Error Base Datos","Error al ejecutar el stored procedure " + SQLCA.SQLErrText)
		Return
	END IF 
	COMMIT;
	Close(w_retroalimentacion)
END IF
end event

type st_1 from statictext within w_cargar_fisobras
integer x = 114
integer y = 72
integer width = 247
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

type em_annomes from editmask within w_cargar_fisobras
integer x = 357
integer y = 72
integer width = 219
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
string mask = "mm/yyyy"
end type

type gb_1 from groupbox within w_cargar_fisobras
integer x = 64
integer y = 12
integer width = 562
integer height = 176
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
end type

