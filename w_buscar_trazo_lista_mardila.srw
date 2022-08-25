HA$PBExportHeader$w_buscar_trazo_lista_mardila.srw
forward
global type w_buscar_trazo_lista_mardila from w_base_buscar_lista_parametro
end type
type st_2 from statictext within w_buscar_trazo_lista_mardila
end type
type em_linea from editmask within w_buscar_trazo_lista_mardila
end type
type st_3 from statictext within w_buscar_trazo_lista_mardila
end type
type em_referencia from editmask within w_buscar_trazo_lista_mardila
end type
type em_descripcionref from editmask within w_buscar_trazo_lista_mardila
end type
type pb_buscar from picturebutton within w_buscar_trazo_lista_mardila
end type
type em_trazo from editmask within w_buscar_trazo_lista_mardila
end type
type st_4 from statictext within w_buscar_trazo_lista_mardila
end type
type em_molderia from editmask within w_buscar_trazo_lista_mardila
end type
type st_5 from statictext within w_buscar_trazo_lista_mardila
end type
type pb_borrar from picturebutton within w_buscar_trazo_lista_mardila
end type
type st_6 from statictext within w_buscar_trazo_lista_mardila
end type
type ddlb_estado from dropdownlistbox within w_buscar_trazo_lista_mardila
end type
end forward

global type w_buscar_trazo_lista_mardila from w_base_buscar_lista_parametro
integer x = 91
integer y = 112
integer width = 2821
integer height = 2264
string title = "Seleccione un Trazo..."
st_2 st_2
em_linea em_linea
st_3 st_3
em_referencia em_referencia
em_descripcionref em_descripcionref
pb_buscar pb_buscar
em_trazo em_trazo
st_4 st_4
em_molderia em_molderia
st_5 st_5
pb_borrar pb_borrar
st_6 st_6
ddlb_estado ddlb_estado
end type
global w_buscar_trazo_lista_mardila w_buscar_trazo_lista_mardila

type variables
Long ii_borrando=0
end variables

on w_buscar_trazo_lista_mardila.create
int iCurrent
call super::create
this.st_2=create st_2
this.em_linea=create em_linea
this.st_3=create st_3
this.em_referencia=create em_referencia
this.em_descripcionref=create em_descripcionref
this.pb_buscar=create pb_buscar
this.em_trazo=create em_trazo
this.st_4=create st_4
this.em_molderia=create em_molderia
this.st_5=create st_5
this.pb_borrar=create pb_borrar
this.st_6=create st_6
this.ddlb_estado=create ddlb_estado
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_2
this.Control[iCurrent+2]=this.em_linea
this.Control[iCurrent+3]=this.st_3
this.Control[iCurrent+4]=this.em_referencia
this.Control[iCurrent+5]=this.em_descripcionref
this.Control[iCurrent+6]=this.pb_buscar
this.Control[iCurrent+7]=this.em_trazo
this.Control[iCurrent+8]=this.st_4
this.Control[iCurrent+9]=this.em_molderia
this.Control[iCurrent+10]=this.st_5
this.Control[iCurrent+11]=this.pb_borrar
this.Control[iCurrent+12]=this.st_6
this.Control[iCurrent+13]=this.ddlb_estado
end on

on w_buscar_trazo_lista_mardila.destroy
call super::destroy
destroy(this.st_2)
destroy(this.em_linea)
destroy(this.st_3)
destroy(this.em_referencia)
destroy(this.em_descripcionref)
destroy(this.pb_buscar)
destroy(this.em_trazo)
destroy(this.st_4)
destroy(this.em_molderia)
destroy(this.st_5)
destroy(this.pb_borrar)
destroy(this.st_6)
destroy(this.ddlb_estado)
end on

event open;call super::open;//dw_lista.Retrieve(0, 0, 0, '%')

end event

event closequery;ii_borrando=0
end event

type st_1 from w_base_buscar_lista_parametro`st_1 within w_buscar_trazo_lista_mardila
integer y = 20
integer width = 174
string text = "F$$HEX1$$e100$$ENDHEX$$brica:"
end type

type em_dato from w_base_buscar_lista_parametro`em_dato within w_buscar_trazo_lista_mardila
integer x = 219
integer y = 16
integer width = 91
string text = "0"
maskdatatype maskdatatype = numericmask!
end type

event em_dato::modified;//Long		ll_fabrica, ll_linea, ll_referencia
//String	ls_descref
//
//ll_fabrica		=	Long(em_dato.Text)
//ll_linea			=	Long(em_linea.Text)
//ll_referencia	=	Long(em_referencia.Text)
//ls_descref		=	Trim(em_descripcionref.Text) + '%'
//
//IF IsNull(ll_fabrica) 		THEN	ll_fabrica		=	0
//IF IsNull(ll_linea) 			THEN	ll_linea			=	0
//IF IsNull(ll_referencia) 	THEN	ll_referencia	=	0
//IF IsNull(ls_descref) 	THEN	ls_descref	=	'%'
//
//dw_lista.Retrieve( ll_fabrica, ll_linea, ll_referencia, ls_descref)
//


end event

type st_numero_registros from w_base_buscar_lista_parametro`st_numero_registros within w_buscar_trazo_lista_mardila
integer x = 160
integer y = 1920
integer width = 850
end type

type pb_cancelar from w_base_buscar_lista_parametro`pb_cancelar within w_buscar_trazo_lista_mardila
integer x = 1897
integer y = 1880
integer taborder = 100
string picturename = "cancelar.bmp"
end type

type pb_aceptar from w_base_buscar_lista_parametro`pb_aceptar within w_buscar_trazo_lista_mardila
integer x = 1499
integer y = 1880
integer taborder = 90
boolean default = false
string picturename = "ok.bmp"
end type

event pb_aceptar::clicked;call super::clicked;s_base_parametros lstr_parametros
IF ii_borrando=0 THEN
	IF il_fila_actual > 0 THEN
		lstr_parametros.hay_parametros = TRUE
		lstr_parametros.entero[1]=dw_lista.getitemnumber(il_fila_actual,"co_trazo")
		closewithreturn(parent,lstr_parametros)
	ELSE
		lstr_parametros.hay_parametros = FALSE
		CloseWithReturn(parent,lstr_parametros)
	END IF
END IF

end event

type dw_lista from w_base_buscar_lista_parametro`dw_lista within w_buscar_trazo_lista_mardila
integer x = 23
integer y = 192
integer width = 2734
integer height = 1640
integer taborder = 80
string dataobject = "dtb_buscar_trazo_lista"
end type

event dw_lista::clicked;Long	ll_fila

IF row <> 0 AND row <> -1 AND NOT IsNull(row) THEN
	IF KeyDown(KeyShift!) THEN
		IF row > il_fila_actual THEN
			FOR ll_fila = il_fila_actual TO row
				SelectRow(ll_fila, True)					
			NEXT
		ELSE
			FOR ll_fila = row TO il_fila_actual
				SelectRow(ll_fila, True)					
			NEXT
		END IF
	ELSE
		IF KeyDown(KeyControl!) THEN
			IF dw_lista.IsSelected(row) THEN
				selectrow(row, False)
			ELSE
				selectrow(row, True)		
			END IF			
		ELSE
			IF dw_lista.IsSelected(row) THEN
				selectrow(0, False)
			ELSE
				selectrow(0, False)				
				selectrow(row, True)		
			END IF
			il_fila_actual	=	ROW			
		END IF	
	END IF	
END IF
//
//IF row <> 0 AND row <> -1 AND NOT IsNull(row) THEN
//		this.selectrow(row, Not(dw_lista.IsSelected(row)))
//END IF
end event

event dw_lista::doubleclicked;IF row <> 0 AND row <> -1 AND NOT IsNull(row) THEN
	IF dw_lista.IsSelected(row) THEN
		this.selectrow(row, False)
	ELSE
		this.selectrow(row, True)		
	END IF
END IF
end event

event dw_lista::rowfocuschanged;//nada
end event

type st_2 from statictext within w_buscar_trazo_lista_mardila
integer x = 608
integer y = 20
integer width = 261
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
string text = "Referencia:"
boolean focusrectangle = false
end type

type em_linea from editmask within w_buscar_trazo_lista_mardila
integer x = 475
integer y = 16
integer width = 119
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
string mask = "###"
end type

event modified;//Long		ll_fabrica, ll_linea, ll_referencia
//String	ls_descref
//
//ll_fabrica		=	Long(em_dato.Text)
//ll_linea			=	Long(em_linea.Text)
//ll_referencia	=	Long(em_referencia.Text)
//ls_descref		=	Trim(em_descripcionref.Text) + '%'
//
//IF IsNull(ll_fabrica) 		THEN	ll_fabrica		=	0
//IF IsNull(ll_linea) 			THEN	ll_linea			=	0
//IF IsNull(ll_referencia) 	THEN	ll_referencia	=	0
//IF IsNull(ls_descref) 	THEN	ls_descref	=	'%'
//
//dw_lista.Retrieve( ll_fabrica, ll_linea, ll_referencia, ls_descref)
end event

type st_3 from statictext within w_buscar_trazo_lista_mardila
integer x = 329
integer y = 20
integer width = 146
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
string text = "L$$HEX1$$ed00$$ENDHEX$$nea:"
boolean focusrectangle = false
end type

type em_referencia from editmask within w_buscar_trazo_lista_mardila
integer x = 882
integer y = 20
integer width = 251
integer height = 76
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
string text = "00000"
borderstyle borderstyle = stylelowered!
string mask = "######"
end type

event modified;//Long		ll_fabrica, ll_linea, ll_referencia
//String	ls_descref
//
//ll_fabrica		=	Long(em_dato.Text)
//ll_linea			=	Long(em_linea.Text)
//ll_referencia	=	Long(em_referencia.Text)
//ls_descref		=	Trim(em_descripcionref.Text) + '%'
//
//IF IsNull(ll_fabrica) 		THEN	ll_fabrica		=	0
//IF IsNull(ll_linea) 			THEN	ll_linea			=	0
//IF IsNull(ll_referencia) 	THEN	ll_referencia	=	0
//IF IsNull(ls_descref) 	THEN	ls_descref	=	'%'
//
//dw_lista.Retrieve( ll_fabrica, ll_linea, ll_referencia, ls_descref)
end event

type em_descripcionref from editmask within w_buscar_trazo_lista_mardila
integer x = 1147
integer y = 20
integer width = 855
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
maskdatatype maskdatatype = stringmask!
end type

event modified;//Long		ll_fabrica, ll_linea, ll_referencia
//String	ls_descref
//
//ll_fabrica		=	Long(em_dato.Text)
//ll_linea			=	Long(em_linea.Text)
//ll_referencia	=	Long(em_referencia.Text)
//ls_descref		=	Trim(em_descripcionref.Text) + '%'
//
//IF IsNull(ll_fabrica) 		THEN	ll_fabrica		=	0
//IF IsNull(ll_linea) 			THEN	ll_linea			=	0
//IF IsNull(ll_referencia) 	THEN	ll_referencia	=	0
//IF IsNull(ls_descref) 	THEN	ls_descref	=	'%'
//
//dw_lista.Retrieve( ll_fabrica, ll_linea, ll_referencia, ls_descref)
end event

type pb_buscar from picturebutton within w_buscar_trazo_lista_mardila
integer x = 2542
integer y = 4
integer width = 265
integer height = 100
integer taborder = 70
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "Buscar"
boolean default = true
alignment htextalign = left!
end type

event clicked;Long   ll_fabrica,ll_linea,ll_referencia,ll_trazo
String ls_descref, ls_molderia, ls_estado
Long li_estado

ll_trazo       =  Long(em_trazo.Text)
ll_fabrica		=	Long(em_dato.Text)
ll_linea			=	Long(em_linea.Text)
ll_referencia	=	Long(em_referencia.Text)
ls_molderia	   =	Trim(em_molderia.Text) 
ls_estado			=	string(ddlb_estado.text) 
IF ls_estado = 'Pendiente x Definir' THEN
	li_estado = 3
ELSEIF ls_estado = 'Inactivo' THEN
	li_estado = 2
ELSEIF ls_estado = 'Activo' THEN
	li_estado = 1
ELSEIF ls_estado = 'Todos' THEN
	li_estado = 0
ELSE
	li_estado = 0
END If

IF  (ls_molderia = '') THEN

	ls_molderia = ' '
END IF
ls_descref		=	Trim(em_descripcionref.Text) + '%'

IF IsNull(ll_fabrica) 		THEN	ll_fabrica		=	0
IF IsNull(ll_linea) 			THEN	ll_linea			=	0
IF IsNull(ll_referencia) 	THEN	ll_referencia	=	0
IF IsNull(ls_descref) 	THEN	ls_descref	=	'%'
IF IsNull(ll_trazo) 		THEN	ll_trazo		=	0
IF IsNull(li_estado) 		THEN	li_estado		=	0

IF ll_fabrica = 0 AND ll_linea = 0 AND ll_referencia = 0 AND ll_trazo = 0 AND li_estado = 0 AND ls_molderia = ' ' AND ls_descref = '%' THEN
	Messagebox('Advertencia','Debe ingresar algun parametro para buscar')
ELSE
	dw_lista.Retrieve( ll_fabrica, ll_linea, ll_referencia, ls_descref, ll_trazo, ls_molderia,li_estado)
END If



end event

type em_trazo from editmask within w_buscar_trazo_lista_mardila
integer x = 2190
integer y = 16
integer width = 338
integer height = 76
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
string text = "00000"
borderstyle borderstyle = stylelowered!
string mask = "######"
end type

type st_4 from statictext within w_buscar_trazo_lista_mardila
integer x = 2025
integer y = 24
integer width = 160
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Trazo:"
boolean focusrectangle = false
end type

type em_molderia from editmask within w_buscar_trazo_lista_mardila
integer x = 485
integer y = 104
integer width = 375
integer height = 76
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
string mask = "########"
end type

type st_5 from statictext within w_buscar_trazo_lista_mardila
integer x = 274
integer y = 108
integer width = 206
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Molderia:"
boolean focusrectangle = false
end type

type pb_borrar from picturebutton within w_buscar_trazo_lista_mardila
integer x = 2313
integer y = 1880
integer width = 366
integer height = 144
integer taborder = 110
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "Borrar"
string picturename = "p:\ordencorte\boton radar.bmp"
alignment htextalign = right!
end type

event clicked;Long 						ll_filas, ll_filaactual, ll_borrados
s_base_parametros 	lstr_parametros
	ii_borrando=1
	ll_filas = dw_lista.RowCount()
	ll_borrados = 0
	IF (MessageBox("Borrar Trazos ...","Esta seguro de borrar estos trazos seleccionados?",Question!,YesNo!) = 1) THEN
		FOR ll_filaactual = 1 TO ll_filas
			IF dw_lista.IsSelected(ll_filaactual) THEN
				ll_borrados = ll_borrados + 1		
				lstr_parametros.entero[1] = dw_lista.GetItemNumber(ll_filaactual, "co_trazo")
	
				IF ISNULL(lstr_parametros.entero[1]) THEN
	
					MessageBox("Error Datos","Existen datos Nulos en la selecci$$HEX1$$f300$$ENDHEX$$n No borrar$$HEX2$$e1002000$$ENDHEX$$ning$$HEX1$$fa00$$ENDHEX$$n trazo, por favor verifique")
					ll_borrados=0
					ll_filaactual=ll_filas + 1
				ELSE
					
				END IF
				
				UPDATE h_trazos  
				  SET co_estado_trazo = 2  
				WHERE h_trazos.co_trazo = :lstr_parametros.entero[1] ;
	
				IF SQLCA.SQLCODE=-1 THEN
					MessageBox("Error Base datos","No pudo Desactivar los trazos")
					RETURN
				ELSE
				END IF
			END IF
		NEXT
	ELSE
		
	END IF
	

IF ll_borrados > 0 THEN
	
	COMMIT;
ELSE
	
	ROLLBACK;
END IF
lstr_parametros.hay_parametros = False	
CloseWithReturn(Parent, lstr_parametros)

end event

type st_6 from statictext within w_buscar_trazo_lista_mardila
integer x = 965
integer y = 124
integer width = 178
integer height = 52
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Estado:"
boolean focusrectangle = false
end type

type ddlb_estado from dropdownlistbox within w_buscar_trazo_lista_mardila
integer x = 1175
integer y = 108
integer width = 411
integer height = 324
integer taborder = 70
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
string item[] = {"Activo","Inactivo","Pendiente x Definir","Todos"}
borderstyle borderstyle = stylelowered!
end type

