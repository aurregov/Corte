HA$PBExportHeader$w_cargar_preparacion.srw
forward
global type w_cargar_preparacion from window
end type
type dw_lista from datawindow within w_cargar_preparacion
end type
type cb_cancelar from commandbutton within w_cargar_preparacion
end type
type cb_aceptar from commandbutton within w_cargar_preparacion
end type
type gb_1 from groupbox within w_cargar_preparacion
end type
end forward

global type w_cargar_preparacion from window
integer width = 1088
integer height = 752
boolean titlebar = true
string title = "Cargar a Preparaci$$HEX1$$f300$$ENDHEX$$n"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
dw_lista dw_lista
cb_cancelar cb_cancelar
cb_aceptar cb_aceptar
gb_1 gb_1
end type
global w_cargar_preparacion w_cargar_preparacion

type variables
Long	ii_ctro_fisico
end variables

on w_cargar_preparacion.create
this.dw_lista=create dw_lista
this.cb_cancelar=create cb_cancelar
this.cb_aceptar=create cb_aceptar
this.gb_1=create gb_1
this.Control[]={this.dw_lista,&
this.cb_cancelar,&
this.cb_aceptar,&
this.gb_1}
end on

on w_cargar_preparacion.destroy
destroy(this.dw_lista)
destroy(this.cb_cancelar)
destroy(this.cb_aceptar)
destroy(this.gb_1)
end on

event open;This.x = 1
This.y = 1

dw_lista.SetTransObject(sqlca)
dw_lista.InsertRow(0)
dw_lista.SetFocus()
end event

type dw_lista from datawindow within w_cargar_preparacion
integer x = 91
integer y = 132
integer width = 846
integer height = 160
integer taborder = 10
string title = "none"
string dataobject = "dff_cargar_preproduccion"
boolean border = false
boolean livescroll = true
end type

type cb_cancelar from commandbutton within w_cargar_preparacion
integer x = 553
integer y = 468
integer width = 343
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancelar"
end type

event clicked;Close(Parent)
end event

type cb_aceptar from commandbutton within w_cargar_preparacion
integer x = 105
integer y = 468
integer width = 343
integer height = 100
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Aceptar"
end type

event clicked;String ls_oc, ls_modulo, ls_de_modulo
Long ll_oc, ll_modulo, ll_count
Long li_extendido, li_preparacion, li_subcentro, li_fabrica, li_planta, li_tipo, li_centro
DateTime ldt_fecha
s_base_parametros lstr_parametros
n_cst_modulo lpo_modulo
n_cts_constantes lpo_constantes

ldt_fecha = f_fecha_servidor()
lpo_constantes = Create n_cts_constantes

dw_lista.AcceptText()

ls_modulo = dw_lista.GetItemString(1,'modulo')
ls_oc = dw_lista.GetItemString(1,'orden_corte')

If isnull(ls_oc) or isnull(ls_modulo) or ls_oc = '' or ls_modulo = '' Then
	MessageBox('Advertencia','Deben completarse los datos en pantalla.')
	Return
End if

ll_oc = Long(mid(ls_oc,1,6))
li_fabrica = Long(mid(ls_modulo,1,2))
li_planta = Long(mid(ls_modulo,3,2))
ll_modulo = Long(mid(ls_modulo,5))


//Javier pide que se quite la validacion del auditor y se deje solo al momento de lotear
//realiza jorodrig agosto 31 - 2011
//SELECT count(*) 
//  INTO :ll_count
//  FROM m_auditor_po
// WHERE cs_orden_corte = :ll_oc;
//	
//IF ll_count > 0 THEN
//	//se deja pasar ya que el auditor ya dio el visto bueno.
//ELSE
//	MessageBox('Error','Falta el visto bueno del auditor de calidad.')
//	Return
//END IF
//

//se traen las constantes de extendido y preparacion
li_extendido = lpo_constantes.of_consultar_numerico('SUBCENTRO EXTENDIDO')
IF li_extendido = -1 THEN
	Return 
END IF

li_preparacion = lpo_constantes.of_consultar_numerico('SUBCENTRO PREPARACIO')
IF li_preparacion = -1 THEN
	Return 
END IF

li_tipo = lpo_constantes.of_consultar_numerico('PRENDAS')
IF li_tipo = -1 THEN
	Return 
END IF

li_centro = lpo_constantes.of_consultar_numerico('CENTRO CORTE')
IF li_centro = -1 THEN
	Return 
END IF

//se valida la existencia del modulo ingresado
IF lpo_modulo.of_descripcion_modulo(ls_modulo,li_tipo,li_centro,li_preparacion,ls_de_modulo, ii_ctro_fisico) = -1 THEN
	Return
END IF

//se captura el subcentro actual de la orden de corte
SELECT Distinct co_subcentro_pdn
  INTO :li_subcentro
  FROM dt_kamban_corte
 WHERE cs_orden_corte 	= :ll_oc and
       co_tipoprod 		= :li_tipo and
		 co_centro_pdn 	= :li_centro and
 		 fe_inicial 		is not null and
		 fe_final 			is null; 
		 
IF sqlca.sqlcode = -1 Then
	MessageBox('Error','Ocurrio un error al momento de validar el subcentro')
	Return
END IF

IF li_subcentro = li_extendido THEN
	//se extrae del subcentro de extendido para preparacion
	UPDATE dt_kamban_corte
	   SET fe_final = :ldt_fecha
	 WHERE cs_orden_corte 	= :ll_oc AND
	 		 co_tipoprod 		= :li_tipo and
		    co_centro_pdn 	= :li_centro and	
	 		 co_subcentro_pdn = :li_subcentro;
	
	IF sqlca.sqlcode = -1 Then
		Rollback;
		MessageBox('Error','Ocurrio un error al momento de actualizar el subcentro de Extendido')
		Return
	END IF
			  
	UPDATE dt_kamban_corte
	   SET fe_inicial 			= :ldt_fecha,
		    co_fabrica_planta 	= :li_fabrica,
			 co_planta 				= :li_planta,
			 co_modulo 				= :ll_modulo
	 WHERE cs_orden_corte 	= :ll_oc AND
	 		 co_tipoprod 		= :li_tipo and
		    co_centro_pdn 	= :li_centro and
	       co_subcentro_pdn = :li_preparacion;
	
	IF sqlca.sqlcode = -1 Then
		Rollback;
		MessageBox('Error','Ocurrio un error al momento de actualizar el subcentro de Preparaci$$HEX1$$f300$$ENDHEX$$m')
		Return
	END IF
	//termino con exito
	Commit;
ELSE
	//el subcentro de origen no es valido
	MessageBox('Error','La O.C. no se encuentra en Extendido, por favor verifique.')
	Return
END IF

dw_lista.Reset()
dw_lista.InsertRow(0)
dw_lista.SetFocus()

MessageBox('Exito','La orden ya fua cargada al subcentro de preparaci$$HEX1$$f300$$ENDHEX$$n')


end event

type gb_1 from groupbox within w_cargar_preparacion
integer x = 73
integer y = 76
integer width = 882
integer height = 248
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

