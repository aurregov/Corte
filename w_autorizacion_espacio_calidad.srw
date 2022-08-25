HA$PBExportHeader$w_autorizacion_espacio_calidad.srw
forward
global type w_autorizacion_espacio_calidad from window
end type
type st_2 from statictext within w_autorizacion_espacio_calidad
end type
type st_1 from statictext within w_autorizacion_espacio_calidad
end type
type em_auditor from singlelineedit within w_autorizacion_espacio_calidad
end type
type em_espacio from singlelineedit within w_autorizacion_espacio_calidad
end type
type cb_cancelar from commandbutton within w_autorizacion_espacio_calidad
end type
type cb_aceptar from commandbutton within w_autorizacion_espacio_calidad
end type
type gb_1 from groupbox within w_autorizacion_espacio_calidad
end type
end forward

global type w_autorizacion_espacio_calidad from window
integer width = 974
integer height = 860
boolean titlebar = true
string title = "Autorizaci$$HEX1$$f300$$ENDHEX$$n Auditor"
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
st_2 st_2
st_1 st_1
em_auditor em_auditor
em_espacio em_espacio
cb_cancelar cb_cancelar
cb_aceptar cb_aceptar
gb_1 gb_1
end type
global w_autorizacion_espacio_calidad w_autorizacion_espacio_calidad

type variables
Long il_ordencorte, il_agrupacion, il_basetrazo, il_trazo 
end variables

on w_autorizacion_espacio_calidad.create
this.st_2=create st_2
this.st_1=create st_1
this.em_auditor=create em_auditor
this.em_espacio=create em_espacio
this.cb_cancelar=create cb_cancelar
this.cb_aceptar=create cb_aceptar
this.gb_1=create gb_1
this.Control[]={this.st_2,&
this.st_1,&
this.em_auditor,&
this.em_espacio,&
this.cb_cancelar,&
this.cb_aceptar,&
this.gb_1}
end on

on w_autorizacion_espacio_calidad.destroy
destroy(this.st_2)
destroy(this.st_1)
destroy(this.em_auditor)
destroy(this.em_espacio)
destroy(this.cb_cancelar)
destroy(this.cb_aceptar)
destroy(this.gb_1)
end on

event open;em_espacio.SetFocus()
end event

type st_2 from statictext within w_autorizacion_espacio_calidad
integer x = 73
integer y = 280
integer width = 233
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

type st_1 from statictext within w_autorizacion_espacio_calidad
integer x = 73
integer y = 124
integer width = 233
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Espacio:"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_auditor from singlelineedit within w_autorizacion_espacio_calidad
integer x = 329
integer y = 252
integer width = 549
integer height = 92
integer taborder = 20
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

type em_espacio from singlelineedit within w_autorizacion_espacio_calidad
integer x = 329
integer y = 112
integer width = 549
integer height = 92
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

type cb_cancelar from commandbutton within w_autorizacion_espacio_calidad
integer x = 544
integer y = 544
integer width = 343
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancelar"
boolean cancel = true
end type

event clicked;Close(Parent)
end event

type cb_aceptar from commandbutton within w_autorizacion_espacio_calidad
integer x = 101
integer y = 544
integer width = 343
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Aceptar"
end type

event clicked;String ls_espacio, ls_error
Long li_registros
Long ll_auditor, ll_count

ll_auditor = Long(em_auditor.Text)
ls_espacio = em_espacio.Text

IF Len(ls_espacio) > 0 THEN
	IF Len(ls_espacio) = 15 THEN
		il_ordencorte = Long(Mid(ls_espacio, 1, 6))
		il_agrupacion = Long(Mid(ls_espacio, 7, 5))
		il_basetrazo  = Long(Mid(ls_espacio, 12, 2))
		il_trazo      = Long(Mid(ls_espacio, 14, 15))
	ELSE
		il_ordencorte = Long(Mid(ls_espacio, 1, 6))
		il_agrupacion = Long(Mid(ls_espacio, 7, 4))
		il_basetrazo  = Long(Mid(ls_espacio, 11, 2))
		il_trazo      = Long(Mid(ls_espacio, 13, 14))
	END IF
END IF

//se debe validar el auditor y el espacio adem$$HEX1$$e000$$ENDHEX$$s este no puede estar preliquidado.
SELECT count(*)
  INTO :ll_count
  FROM m_user_auditor
 WHERE auditor = :ll_auditor AND
 		 estado = 1; 
 
IF ll_count > 0 THEN
// el auditor es valido, se determina la valides del espacio	
	SELECT Count(*)
	INTO :li_registros
	FROM dt_trazosxoc
	WHERE cs_orden_corte = :il_ordencorte AND
			cs_agrupacion 	= :il_agrupacion AND
			cs_base_trazos = :il_basetrazo AND
			cs_trazo 		= :il_trazo;

	IF SQLCA.SQLCode = -1 THEN
		MessageBox("Error Base Datos","Error al validar existencia del espacio para liquidar. " + SQLCA.SQLErrText,StopSign!)
		Return 
	END IF
	
	IF li_registros <= 0 THEN
		MessageBox("Advertencia...","El espacio no es valido",Exclamation!)
		Return 
	ELSE
		//el espacio existe, se validad que el espacio no se encuentre liquidado
		SELECT Count(*)
		INTO :li_registros
		FROM dt_liquidaxespacio
		WHERE cs_orden_corte = :il_ordencorte AND
				cs_agrupacion 	= :il_agrupacion AND
				cs_base_trazos = :il_basetrazo AND
				cs_trazo 		= :il_trazo;
				
		IF SQLCA.SQLCode = -1 THEN
			MessageBox("Error Base Datos","Error al validar existencia de liquidaci$$HEX1$$f300$$ENDHEX$$n. " + SQLCA.SQLErrText,StopSign!)
			Return 
		END IF
		
		IF li_registros > 0 THEN
			MessageBox("Advertencia...","Este espacio ya tiene liquidaci$$HEX1$$f300$$ENDHEX$$n.",Exclamation!)
			Return 
		ELSE
			//el espacio existe y no sea liquidado se graba en la tabla par poder tener control del espacio auditado
			INSERT INTO mv_pre_espacio_auditor  
							( cs_orden_corte,   
							  cs_agrupacion,   
							  cs_base_trazos,   
							  cs_trazo,   
							  auditor )  
				  VALUES ( :il_ordencorte,   
							  :il_agrupacion,   
							  :il_basetrazo,   
							  :il_trazo,   
							  :ll_auditor)  ;
							  
			IF sqlca.sqlcode = -1 THEN
				ls_error = sqlca.SqlErrText
				Rollback;
				MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de marcar el auditar el c$$HEX1$$f300$$ENDHEX$$digo, ERROR: '+ls_error)
				Return
			END IF
			Commit;
		END IF
	END IF
ELSE
	MessageBox('Error','El c$$HEX1$$f300$$ENDHEX$$digo del auditor no es valido.',StopSign!)
	Return
END IF


Close(Parent)

end event

type gb_1 from groupbox within w_autorizacion_espacio_calidad
integer x = 46
integer y = 32
integer width = 873
integer height = 408
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
end type

