HA$PBExportHeader$w_administracion_porc_permitido_ref.srw
forward
global type w_administracion_porc_permitido_ref from w_base_buscar_lista_parametro
end type
type gb_1 from groupbox within w_administracion_porc_permitido_ref
end type
end forward

global type w_administracion_porc_permitido_ref from w_base_buscar_lista_parametro
integer width = 3470
integer height = 1432
string title = "Porcentaje Maximo Permitido por Referencia para Liberar"
string menuname = "m_mantenimiento_simple"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
windowtype windowtype = main!
event ue_insertar_maestro ( )
event ue_borrar_maestro ( )
event ue_grabar ( )
gb_1 gb_1
end type
global w_administracion_porc_permitido_ref w_administracion_porc_permitido_ref

type variables
DataWindowChild idwc_linea, idwc_ref,idwc_fabrica
end variables

event ue_insertar_maestro();dw_lista.InsertRow(0)
end event

event ue_borrar_maestro();long ll_fila

ll_fila=dw_lista.GetRow()
CHOOSE CASE ll_fila
	CASE -1
		MessageBox("Error de datawindow","No se pudo obtener la fila a borrar del maestro ",StopSign!,Ok!)
	CASE 0
		MessageBox("Advertencia","No se ha seleccionado la fila a borrar del maestro",Exclamation!,Ok!)
	CASE ELSE
		IF (MessageBox("Borrar fila ...","Esta seguro de borrar esta fila del maestro",Question!,YesNo!) = 1) THEN
			IF (dw_lista.DeleteRow(ll_fila) = -1) THEN
				messagebox("Error datawindow","No pudo borrar del maestro",&
				            StopSign!,Ok!)
			ELSE
				This.TriggerEvent("ue_grabar")
   		END IF
		ELSE
		END IF
END CHOOSE


end event

event ue_grabar();
IF dw_lista.AcceptText() = -1 THEN
	Messagebox("Error","No se pudieron realizar los cambios en el maestro" &
	           ,Exclamation!,Ok!)	
ELSE
	IF dw_lista.Update() = -1 THEN
		Messagebox("Error","No se pudo hacer los cambios en el maestro para la base de datos",Exclamation!,Ok!)
		ROLLBACK;
	ELSE
		COMMIT;
	END IF
END IF
	



end event

on w_administracion_porc_permitido_ref.create
int iCurrent
call super::create
if this.MenuName = "m_mantenimiento_simple" then this.MenuID = create m_mantenimiento_simple
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_1
end on

on w_administracion_porc_permitido_ref.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_1)
end on

event open;call super::open;This.x = 1
This.Y = 1
s_base_parametros lstr_parametros

lstr_parametros = Message.PowerObjectParm	

em_dato.Text = String(lstr_parametros.entero[1])

em_dato.TriggerEvent(Modified!)

//dw_lista.retrieve(lstr_parametros.entero[1])

//dw_lista.getchild('co_fabrica_1',idwc_fabrica)
//dw_lista.GetChild('co_linea_1',idwc_linea)
//dw_lista.GetChild('co_referencia_1',idwc_ref)
//
//idwc_fabrica.settransobject(sqlca)
//idwc_linea.SetTransObject(sqlca)
//idwc_ref.SetTransObject(sqlca)
//
//idwc_fabrica.retrieve(2)
//idwc_linea.Retrieve(2)
//idwc_ref.Retrieve(2,1)


end event

type st_1 from w_base_buscar_lista_parametro`st_1 within w_administracion_porc_permitido_ref
integer x = 261
integer y = 24
integer width = 315
string text = "C$$HEX1$$f300$$ENDHEX$$digo Estilo:"
end type

type em_dato from w_base_buscar_lista_parametro`em_dato within w_administracion_porc_permitido_ref
integer x = 585
integer y = 24
string mask = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx!"
end type

event em_dato::modified;Long ll_numero_registros, ll_ref


ll_ref = Long(em_dato.Text)
IF Not IsNull(ll_ref) THEN
	//ls_datocon = ls_datocon + '%'
	ll_numero_registros = dw_lista.Retrieve(ll_ref)
	CHOOSE CASE ll_numero_registros 
		CASE -1
			MessageBox("Error datawindow","No pudo traer datos",stopsign!,ok!)
		CASE 0
			il_fila_actual = 0
			st_numero_registros.text=string(ll_numero_registros) + " registros recuperados"
		CASE ELSE
			st_numero_registros.text = String(ll_numero_registros) + " registros recuperados"
			dw_lista.setrow(1)
			dw_lista.selectrow(1,true)
			il_fila_actual = 1
	END CHOOSE
END IF
end event

type st_numero_registros from w_base_buscar_lista_parametro`st_numero_registros within w_administracion_porc_permitido_ref
integer x = 910
integer y = 1140
end type

type pb_cancelar from w_base_buscar_lista_parametro`pb_cancelar within w_administracion_porc_permitido_ref
boolean visible = false
integer x = 937
integer y = 1268
end type

type pb_aceptar from w_base_buscar_lista_parametro`pb_aceptar within w_administracion_porc_permitido_ref
boolean visible = false
integer x = 379
integer y = 1268
end type

type dw_lista from w_base_buscar_lista_parametro`dw_lista within w_administracion_porc_permitido_ref
integer x = 14
integer y = 128
integer width = 3369
integer height = 968
string dataobject = "dtb_porc_permitido"
boolean vscrollbar = false
boolean border = false
borderstyle borderstyle = stylebox!
end type

event dw_lista::itemchanged;call super::itemchanged;Long	li_fab, li_linea, li_tope, li_unid, li_porc
Long		ll_referencia
string 	de_fab, de_linea, de_ref, ls_cod_autorizacion, ls_cod_ingreso
decimal{3}	ldc_porc_liberar, ldc_porc_maximo
n_cts_constantes_tela luo_constantes
s_base_parametros lstr_parametros
//This.AcceptText()

//choose case GetColumnName()
IF DWO.NAME = "co_fabrica" THEN
	li_fab = Long(DATA)		
	
		SELECT m_fabricas.de_fabrica  
		 INTO :de_fab  
		 FROM m_fabricas  
		WHERE m_fabricas.co_fabrica = :li_fab;
		
	   This.setitem(Row,'de_fabrica',de_fab)
END IF

IF DWO.NAME = "co_linea" THEN
	li_linea = Long(DATA)			
   
	li_fab = This.GetItemNumber(Row,'co_fabrica')
	 
	 SELECT m_lineas.de_linea  
	 INTO :de_linea  
	 FROM m_lineas  
	 WHERE m_lineas.co_fabrica = :li_fab
		AND m_lineas.co_linea = :li_linea;

	 This.setitem(Row,'de_linea',de_linea)
END IF
	
IF DWO.NAME = "co_referencia" THEN
		ll_referencia = Long(DATA)		
		
		li_fab = This.GetItemNumber(this.getrow(),'co_fabrica')
		li_linea = This.GetItemNumber(this.getrow(),'co_linea')
		
		 SELECT h_preref_pv.de_referencia  
		 INTO :de_ref  
		 FROM h_preref_pv  
		WHERE ( h_preref_pv.co_fabrica = :li_fab ) AND  
				( h_preref_pv.co_linea = :li_linea ) AND
 				(Cast(:ll_referencia as char(15) ) = h_preref_pv.co_referencia ) and
				( h_preref_pv.co_tipo_ref = 'P' ) ;
				
	   This.setitem(Row,'de_referencia',de_ref)		
END IF

IF DWO.NAME = "m_porc_permitido_tope_min_unid" OR DWO.NAME = "m_porc_permitido_unid_adicionar" THEN
	ls_cod_autorizacion = luo_constantes.of_consultar_texto("PASSWORD INCREMENTO")
	IF len(ls_cod_autorizacion) > 0 THEN
		
	ELSE
		MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de verificar la necesidad de autorizaci$$HEX1$$f300$$ENDHEX$$n.',StopSign!)
	END IF
	MessageBox('Advertencia','Para cambiar estos parametros es necesaria autorizaci$$HEX1$$f300$$ENDHEX$$n.')
	Open(w_porcentaje)
	lstr_parametros = message.PowerObjectParm
	
	If lstr_parametros.hay_parametros = True Then
		ls_cod_ingreso = lstr_parametros.cadena[1]
		//se compara el password de las constantes con el digitado por el usuario
		If Trim(ls_cod_autorizacion) <> Trim(ls_cod_ingreso) Then
			MessageBox('Error','El Password ingresado no es valido.',StopSign!)
			li_tope = This.getItemNumber(Row,'m_porc_permitido_tope_min_unid')
			li_unid = This.getItemNumber(Row,'m_porc_permitido_unid_adicionar')
			This.SetItem(Row,'m_porc_permitido_tope_min_unid',li_tope)
			This.SetItem(Row,'m_porc_permitido_unid_adicionar',li_unid)
			Return 2
		End if
	Else
		li_tope = This.getItemNumber(Row,'m_porc_permitido_tope_min_unid')
		li_unid = This.getItemNumber(Row,'m_porc_permitido_unid_adicionar')
		This.SetItem(Row,'m_porc_permitido_tope_min_unid',li_tope)
		This.SetItem(Row,'m_porc_permitido_unid_adicionar',li_unid)
		Return 2
	End if
	
END IF


IF DWO.NAME = "porc_maximo"  THEN
	ls_cod_autorizacion = luo_constantes.of_consultar_texto("PASSWORD INCREMENTO")
	IF len(ls_cod_autorizacion) > 0 THEN
		
	ELSE
		MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de verificar la necesidad de autorizaci$$HEX1$$f300$$ENDHEX$$n.',StopSign!)
	END IF
	MessageBox('Advertencia','Para cambiar estos parametros es necesaria autorizaci$$HEX1$$f300$$ENDHEX$$n.')
	Open(w_porcentaje)
	lstr_parametros = message.PowerObjectParm
	
	If lstr_parametros.hay_parametros = True Then
		ls_cod_ingreso = lstr_parametros.cadena[1]
		//se compara el password de las constantes con el digitado por el usuario
		If Trim(ls_cod_autorizacion) <> Trim(ls_cod_ingreso) Then
			MessageBox('Error','El Password ingresado no es valido.',StopSign!)
			li_porc = This.getItemNumber(Row,'porc_maximo')
			This.SetItem(Row,'porc_maximo',li_porc)
			Return 2
		End if
	Else
    	li_porc = This.getItemNumber(Row,'porc_maximo')
		This.SetItem(Row,'porc_maximo',li_porc)
		Return 2
	End if
	
END IF


IF DWO.NAME = "porc_liberar"  THEN
	
	ldc_porc_liberar = DEC(DATA)
	ldc_porc_maximo = This.getItemNumber(Row,'porc_maximo')
	IF ldc_porc_liberar > ldc_porc_maximo THEN
		
		ls_cod_autorizacion = luo_constantes.of_consultar_texto("PASSWORD INCREMENTO")
		IF len(ls_cod_autorizacion) > 0 THEN
		ELSE
			MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de verificar la necesidad de autorizaci$$HEX1$$f300$$ENDHEX$$n.',StopSign!)
		END IF
		MessageBox('Advertencia','Para cambiar estos parametros es necesaria autorizaci$$HEX1$$f300$$ENDHEX$$n.')
		Open(w_porcentaje)
		lstr_parametros = message.PowerObjectParm
		
		If lstr_parametros.hay_parametros = True Then
			ls_cod_ingreso = lstr_parametros.cadena[1]
			//se compara el password de las constantes con el digitado por el usuario
			If Trim(ls_cod_autorizacion) <> Trim(ls_cod_ingreso) Then
				MessageBox('Error','El Password ingresado no es valido.',StopSign!)
				li_porc = This.getItemNumber(Row,'porc_liberar')
				This.SetItem(Row,'porc_liberar',li_porc)
				Return 2
			End if
		Else
   	 	li_porc = This.getItemNumber(Row,'porc_liberar')
			This.SetItem(Row,'porc_liberar',li_porc)
			Return 2
		End if


	END IF
	
END IF

dw_lista.AcceptText();		

end event

type gb_1 from groupbox within w_administracion_porc_permitido_ref
integer y = 88
integer width = 3419
integer height = 1032
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

