HA$PBExportHeader$w_validar_auditor.srw
forward
global type w_validar_auditor from window
end type
type st_4 from statictext within w_validar_auditor
end type
type sle_empacador from singlelineedit within w_validar_auditor
end type
type dw_lista from datawindow within w_validar_auditor
end type
type st_3 from statictext within w_validar_auditor
end type
type st_2 from statictext within w_validar_auditor
end type
type sle_ordencorte from singlelineedit within w_validar_auditor
end type
type sle_po from singlelineedit within w_validar_auditor
end type
type sle_codigo from singlelineedit within w_validar_auditor
end type
type cb_cancelar from commandbutton within w_validar_auditor
end type
type cb_aceptar from commandbutton within w_validar_auditor
end type
type st_1 from statictext within w_validar_auditor
end type
type gb_1 from groupbox within w_validar_auditor
end type
type gb_2 from groupbox within w_validar_auditor
end type
end forward

global type w_validar_auditor from window
integer width = 1358
integer height = 1684
boolean titlebar = true
string title = "Autorizaci$$HEX1$$f300$$ENDHEX$$n Auditor"
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
st_4 st_4
sle_empacador sle_empacador
dw_lista dw_lista
st_3 st_3
st_2 st_2
sle_ordencorte sle_ordencorte
sle_po sle_po
sle_codigo sle_codigo
cb_cancelar cb_cancelar
cb_aceptar cb_aceptar
st_1 st_1
gb_1 gb_1
gb_2 gb_2
end type
global w_validar_auditor w_validar_auditor

type variables
Long il_corte
end variables

on w_validar_auditor.create
this.st_4=create st_4
this.sle_empacador=create sle_empacador
this.dw_lista=create dw_lista
this.st_3=create st_3
this.st_2=create st_2
this.sle_ordencorte=create sle_ordencorte
this.sle_po=create sle_po
this.sle_codigo=create sle_codigo
this.cb_cancelar=create cb_cancelar
this.cb_aceptar=create cb_aceptar
this.st_1=create st_1
this.gb_1=create gb_1
this.gb_2=create gb_2
this.Control[]={this.st_4,&
this.sle_empacador,&
this.dw_lista,&
this.st_3,&
this.st_2,&
this.sle_ordencorte,&
this.sle_po,&
this.sle_codigo,&
this.cb_cancelar,&
this.cb_aceptar,&
this.st_1,&
this.gb_1,&
this.gb_2}
end on

on w_validar_auditor.destroy
destroy(this.st_4)
destroy(this.sle_empacador)
destroy(this.dw_lista)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.sle_ordencorte)
destroy(this.sle_po)
destroy(this.sle_codigo)
destroy(this.cb_cancelar)
destroy(this.cb_aceptar)
destroy(this.st_1)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event open;/***********************************************************
SA54608 - Ceiba/jjmonsal - 14-06-2016
Comentario: Creaci$$HEX1$$f300$$ENDHEX$$n de campo para el empacador en la O.C - se adiciona campo sle_empacador.Text
***********************************************************/
This.x = 1
This.y = 1
s_base_parametros lstr_parametros

dw_lista.SetTransObject(sqlca)
dw_lista.InsertRow(0)

sle_ordencorte.SETFOCUS()

lstr_parametros = Message.PowerObjectParm

sle_ordencorte.Text = String(lstr_parametros.entero[1])
sle_po.text = lstr_parametros.cadena[1]

il_corte = lstr_parametros.entero[1]



end event

type st_4 from statictext within w_validar_auditor
integer x = 210
integer y = 416
integer width = 315
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Empacador:"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_empacador from singlelineedit within w_validar_auditor
integer x = 544
integer y = 416
integer width = 512
integer height = 64
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event modified;//String 		ls_empacador 
//Long			ll_filas
//uo_dsbase	lds
//
//ls_empacador = Trim(sle_empacador.Text)
//
//lds = create uo_dsbase
//lds.dataobject='d_gr_sq_validar_usuario'
//lds.settransobject(SQLCA)
//ll_filas = lds.of_Retrieve(ls_empacador)
//
//IF ll_filas <= 0 THEN 
//	MessageBox('Advertencia','El usuario le$$HEX1$$ed00$$ENDHEX$$do no existe en el maestro de usuarios')
//	sle_empacador.Text = ''
//END IF 
end event

type dw_lista from datawindow within w_validar_auditor
integer x = 55
integer y = 644
integer width = 1193
integer height = 552
integer taborder = 50
string title = "none"
string dataobject = "dgr_cpto_validacion_calidad_loteo"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event itemchanged;Long li_concepto
String ls_concepto

choose case dwo.name
	case 'concepto'
		li_concepto = Long(Data)
		
		SELECT descripcion
		  INTO :ls_concepto
		  FROM m_conpto_audi_cali
		 WHERE codigo = :li_concepto;
		 
		IF sqlca.sqlcode = -1 Then
			MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de verificar el concepto, ERROR: '+sqlca.SqlErrText,StopSign!)
			Return
		End if
		
		IF sqlca.sqlcode = 100 Then
			MessageBox('Error','El concepto ingresado no existe.',StopSign!)
			Return
		End if
		
		This.SetItem(row,'de_concepto',ls_concepto)
		This.InsertRow(0)
		
end choose

end event

type st_3 from statictext within w_validar_auditor
integer x = 210
integer y = 88
integer width = 315
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Orden Corte:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_2 from statictext within w_validar_auditor
integer x = 210
integer y = 196
integer width = 315
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "P.O."
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_ordencorte from singlelineedit within w_validar_auditor
integer x = 544
integer y = 88
integer width = 512
integer height = 64
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type sle_po from singlelineedit within w_validar_auditor
integer x = 544
integer y = 196
integer width = 512
integer height = 64
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type sle_codigo from singlelineedit within w_validar_auditor
integer x = 544
integer y = 304
integer width = 512
integer height = 64
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean password = true
borderstyle borderstyle = stylelowered!
end type

type cb_cancelar from commandbutton within w_validar_auditor
integer x = 727
integer y = 1356
integer width = 343
integer height = 100
integer taborder = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancelar"
boolean cancel = true
end type

event clicked;s_base_parametros lstr_parametros

lstr_parametros.hay_parametros = False

IF il_corte = 0 THEN
	Close(w_validar_auditor)
ELSE
	CloseWithReturn ( Parent, lstr_parametros )
END IF

end event

type cb_aceptar from commandbutton within w_validar_auditor
integer x = 251
integer y = 1356
integer width = 343
integer height = 100
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Aceptar"
end type

event clicked;/***********************************************************
SA54608 - Ceiba/jjmonsal - 15-06-2016
Comentario: Se adiciona al insert de m_auditor_po la columna de cs_empaca con el valor de empacador
ID530 - stvalen -27-12-2021
comentario Especificaci$$HEX1$$f300$$ENDHEX$$n para la liberaci$$HEX1$$f300$$ENDHEX$$n de calidad en el loteo de OC que contengan PO individuales.
***********************************************************/
long ll_codigo, ll_ordencorte, ll_count, ll_result, ll_empacador, ll_reg, ll_n
String ls_po, ls_empacador
int ll_fila,ll_filas,ll_find, li_concepto, li_existe, li_valida_empacador
DateTime ldt_fecha
s_base_parametros lstr_parametros
n_cts_constantes 			luo_constantes
uo_dsbase lds_po_individuales

//stvalenc 2021-12-27 ID530- Especificaci$$HEX1$$f300$$ENDHEX$$n para la liberaci$$HEX1$$f300$$ENDHEX$$n de calidad en el loteo de OC que contengan PO individuales.
//objeto usado para consultar las po con la orden de corte
lds_po_individuales = Create uo_dsbase
lds_po_individuales.DataObject = 'dgr_buscar_po'
lds_po_individuales.SetTransObject(gnv_recursos.Of_Get_Transaccion_Sucia())

luo_constantes = Create n_cts_constantes
ldt_fecha =f_fecha_servidor()

li_valida_empacador = luo_constantes.of_consultar_numerico('VALIDAR EMPACADOR')
dw_lista.AcceptText()

ll_codigo 		= Long(string(sle_codigo.text))
ll_ordencorte 	= Long(String(sle_ordencorte.text))
ls_po 			= String(sle_po.text)
ls_empacador	= Trim(String(sle_empacador.Text))

//Por el momento no es obligatorio
IF li_valida_empacador = 1 THEN  //esta constante me dice que es obligatorio o no
	IF Len(ls_empacador) = 0 THEN 
		MessageBox('Advertencia','Debe ingresar el Empacador')
		Return 
	END IF 
	
	ll_empacador = LONG(ls_empacador)
	Select count(*) 
	  INTO :li_existe
	  FROM m_empacadores
	 WHERE co_empacador = :ll_empacador
			AND co_tipo = 1;
	IF sqlca.sqlcode = -1 THEN
		MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de consultar si existe el empacador, ERROR: '+sqlca.SqlErrText)
		Return
	END IF
	IF li_existe = 0 THEN
		MessageBox('Error','El c$$HEX1$$f300$$ENDHEX$$digo del Empacador no es valido.')
		Return
	END IF
ELSE
	ll_empacador = 0
END IF

 
 //stvalenc 2021-12-27 ID530- Especificaci$$HEX1$$f300$$ENDHEX$$n para la liberaci$$HEX1$$f300$$ENDHEX$$n de calidad en el loteo de OC que contengan PO individuales.
//validamos que existan PO para la orden de corte
// y traemos todas las po que contienen la orden de corte

ll_reg = lds_po_individuales.Retrieve(ll_ordencorte)

if ll_reg > 0 then
	// creamos el registro de auditoria para cada una de las po contenidas por la orden de corte
	for ll_n = 1 to ll_reg
		ls_po =  trim(lds_po_individuales.GetItemstring(ll_n,"po"))
		//se valida que la orden de corte existan y que el auditor sea valido
		SELECT count(*)
		  INTO :ll_count
		  FROM m_user_auditor
		 WHERE estado = 1
		 AND auditor = :ll_codigo 
			AND co_fabrica_pro = :gstr_info_usuario.co_planta_pro ;
		IF sqlca.sqlcode = -1 THEN
			MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de consultar la orden de corte, ERROR: '+sqlca.SqlErrText)
			Return
		END IF
		IF ll_count > 0 THEN
			//se validad la existencia de la orden de corte-po en dt_canasta_corte
			SELECT count(*)
			  INTO :ll_count
			  FROM dt_canasta_corte
			 WHERE cs_orden_corte = :ll_ordencorte AND
					 po				 = :ls_po;
					
			IF ll_count > 0 THEN
				
			ELSE
				MessageBox('Error','la orden de corte - P.O. no es validad. '+sqlca.sqlerrtext)
				Return
			END IF
					 
		ELSE
			MessageBox('Error','El c$$HEX1$$f300$$ENDHEX$$digo del auditor no es valido.')
			Return
		END IF
		//se graba en la tabla de aceptaci$$HEX1$$f300$$ENDHEX$$n del auditor
		
		SELECT count(*)
		  INTO :ll_count
		  FROM m_auditor_po
		 WHERE auditor 			= :ll_codigo AND
				 cs_orden_corte 	= :ll_ordencorte AND
				 po 					= :ls_po and
				 co_fabrica_pro 	= :gstr_info_usuario.co_planta_pro ;
				 
		IF ll_count > 0 THEN
			
		ELSE
			ll_result = dw_lista.RowCount()
			IF ll_result > 0 THEN
				FOR ll_fila = 1 TO ll_result
					
					li_concepto = dw_lista.GetItemNumber(ll_fila,'concepto')
					
					INSERT INTO m_auditor_po
								(auditor,
								cs_orden_corte,
								po,
								fe_creacion,
								fe_actualizacion,
								usuario,
								instancia,
								concepto,
								co_fabrica_pro,
								cs_empaca,
								co_empacador)
					VALUES
								(:ll_codigo,
								:ll_ordencorte,
								:ls_po,
								:ldt_fecha,
								:ldt_fecha,
								:gstr_info_usuario.codigo_usuario,
								:gstr_info_usuario.instancia,
								:li_concepto,
								:gstr_info_usuario.co_planta_pro,
								'',
								:ll_empacador);
				
					 IF sqlca.sqlcode = -1 THEN
						 Rollback;
						 MessageBox('Error','Ocurrio un error al momento de intentar generar la validaci$$HEX1$$f300$$ENDHEX$$n.')
						 Return
					 ELSE
						  //COMMIT;	
						//  MessageBox('Exito','La validaci$$HEX1$$f300$$ENDHEX$$n fue grabada exitosamente.')
						 // lstr_parametros.hay_parametros = True	
					 END IF
				NEXT
			ELSE
				MessageBox('Error','Es necesario ingresar al menos un concepto de auditoria.',StopSign!)
				Return
			END IF
		END IF
	next
	//stvalenc  guardamos los datos si se pudo insertar los registros para cada una de las po de la orden de corte
	COMMIT;	
	MessageBox('Exito','La validaci$$HEX1$$f300$$ENDHEX$$n fue grabada exitosamente.')
	lstr_parametros.hay_parametros = True
else
	MessageBox('Error','No se encontro registros con la orden de corte: '+ string(ll_ordencorte),StopSign!)
	Return
end if

IF il_corte = 0 THEN
	Close(w_validar_auditor)
ELSE
	CloseWithReturn ( Parent, lstr_parametros )
END IF



end event

type st_1 from statictext within w_validar_auditor
integer x = 210
integer y = 304
integer width = 315
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Auditor:"
alignment alignment = right!
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_validar_auditor
integer x = 160
integer y = 20
integer width = 960
integer height = 540
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
end type

type gb_2 from groupbox within w_validar_auditor
integer x = 37
integer y = 608
integer width = 1239
integer height = 644
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
end type

