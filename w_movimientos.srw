HA$PBExportHeader$w_movimientos.srw
forward
global type w_movimientos from w_base_simple
end type
type dw_1 from datawindow within w_movimientos
end type
type pb_1 from picturebutton within w_movimientos
end type
type dw_2 from datawindow within w_movimientos
end type
end forward

global type w_movimientos from w_base_simple
integer width = 3648
integer height = 1496
string title = "Movimientos por Etapa"
dw_1 dw_1
pb_1 pb_1
dw_2 dw_2
end type
global w_movimientos w_movimientos

type variables
TRANSACTION			itr_tela
DataWindowChild idwc_pdn
DataWindowChild idwc_agruppdn
Long il_fila_actual,il_total
LONG il_fabrica,il_linea,il_referencia,il_color,il_talla,il_concepto,il_subcentro,il_unidades

end variables

on w_movimientos.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.pb_1=create pb_1
this.dw_2=create dw_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.pb_1
this.Control[iCurrent+3]=this.dw_2
end on

on w_movimientos.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.pb_1)
destroy(this.dw_2)
end on

event open;This.width = 3479
This.height = 1404
This.x = 1
This.y = 1

//TRANSACTION			itr_tela
itr_tela 				= 	Create Transaction
itr_tela.DBMS			=	ProfileString(gstr_info_usuario.ruta_ini,"bd aplicacion","DBMS","")
itr_tela.DATABASE		=	ProfileString(gstr_info_usuario.ruta_ini,"bd aplicacion","DATABASE","")
itr_tela.USERID		=	SQLCA.USERID
itr_tela.DBPASS		=	SQLCA.DBPASS
itr_tela.DBPARM		=	"connectstring='DSN="+itr_tela.DATABASE+";UID="+itr_tela.USERID+";PWD="+itr_tela.DBPASS+"'"
itr_tela.ServerName 	= 	ProfileString(gstr_info_usuario.ruta_ini,"bd aplicacion","SERVIDOR","")
itr_tela.Lock 			= 	ProfileString(gstr_info_usuario.ruta_ini,"bd aplicacion","LOCK","Dirty read")

CONNECT USING itr_tela;
IF itr_tela.SQLCODE=-1 THEN
	MessageBox("Error base datos","No pudo conectarse a proceso")
	RETURN 0
ELSE 
END IF


dw_maestro.SetTransObject(SQLCA)
dw_maestro.GetChild('cs_pdn',idwc_pdn)
dw_1.SetTransobject(SQLCA)
dw_2.SetTransobject(SQLCA)

dw_1.visible=false
dw_2.visible=false
pb_1.visible=false
idwc_pdn.SetTransObject(sqlca)
idwc_pdn.Retrieve(0)

end event

event ue_buscar;call super::ue_buscar;//s_base_parametros lstr_parametros
//long 					ll_hallados
//datetime				ldt_ano_mes,ldt_fe_movimiento
//Long				li_co_transaccion,li_co_ruta_etapa
//long					ll_cs_dato,ll_cs_movimiento
//
//IF is_cambios = "no" OR is_accion <> "cancelo" THEN
//	Open(w_buscar_inventario)
//	lstr_parametros=message.powerObjectparm
//
//	IF lstr_parametros.hay_parametros THEN
//		
//		ldt_ano_mes			=lstr_parametros.fechahora[1]//=dw_lista.getitemdatetime(il_fila_actual,"ano_mes")
//		ldt_fe_movimiento	=lstr_parametros.fechahora[2]//=dw_lista.getitemdatetime(il_fila_actual,"fe_movimiento")
//		li_co_transaccion	=lstr_parametros.entero[1]//=dw_lista.getitemnumber(il_fila_actual,"co_transaccion")
//		li_co_ruta_etapa	=lstr_parametros.entero[2]//=dw_lista.getitemnumber(il_fila_actual,"co_ruta_etapa")
//		ll_cs_dato			=lstr_parametros.entero[3]//=dw_lista.getitemnumber(il_fila_actual,"cs_dato")
//		ll_cs_movimiento	=lstr_parametros.entero[4]//=dw_lista.getitemnumber(il_fila_actual,"cs_movimiento")
//		
//		ll_hallados = dw_maestro.Retrieve(ldt_ano_mes,ldt_fe_movimiento,li_co_transaccion,li_co_ruta_etapa,ll_cs_dato,ll_cs_movimiento)
//		IF isnull(ll_hallados) THEN
//			MessageBox("Error buscando","parametros nulos",Exclamation!,Ok!)
//		ELSE
//			CHOOSE CASE ll_hallados
//				CASE -1
//					il_fila_actual_maestro = -1
//					MessageBox("Error buscando","Error de la base",StopSign!,&
//                         Ok!)
//				CASE 0
//					il_fila_actual_maestro = 0
//					MessageBox("Sin Datos","No hay datos para su criterio",&
//                         Exclamation!,Ok!)
//				CASE ELSE
//					il_fila_actual_maestro = 1
//					MessageBox("Busqueda ok","registros encontrados: "+&
//             	String(ll_hallados),Information!,Ok!)
//			END CHOOSE
//		END IF
//	ELSE
//	END IF
//ELSE
//END IF
//
end event

event ue_insertar_maestro;///////////////////////////////////////////////////////////////////////
// En este evento se detecta si hubo cambios en el datawindow, para 
// asignar valores a las variables de instancia is_cambio y is_accion.
//
// Ademas, se inserta una nueva linea, se le evalua el insert y si fue
// exitoso, se posiciona en dicha fila,hace el scroll a dicha fila y
// se posiciona en la primera columna de esta fila.
////////////////////////////////////////////////////////////////////////
STRING ls_usuario
long ll_fila
date ld_ano_mes
s_base_parametros	lstr_parametros

CHOOSE CASE wf_detectar_cambios (dw_maestro)
	CASE -1
		is_cambios = "error"
		is_accion = "nada"
		RETURN
	CASE 0
		is_cambios = "no"
		is_accion = "nada"
		//No ejecuta ninguna accion
	CASE 1
		is_cambios = "si"	
		CHOOSE CASE MessageBox("Cambios detectados","Desea grabar los cambios en el maestro",Question!,YesNoCancel!)
			CASE 1
				is_accion = "grabo"
				This.TriggerEvent("ue_grabar")
			CASE 2
				dw_maestro.Reset()
				is_accion = "no grabo"
				// NO GRABA Y SIGUE LA INSERCION
			CASE 3
				is_accion = "cancelo"
				RETURN
		END CHOOSE
END CHOOSE

dw_maestro.Reset()
idwc_pdn.Retrieve(1)
ll_fila = dw_maestro.InsertRow(0)


IF ll_fila = -1 THEN
	MessageBox("Error datawindow","No se pudo insertar el registro del maestro",StopSign!,Ok!)
ELSE
	dw_maestro.SetRow(ll_fila)
	dw_maestro.ScrollToRow(ll_fila)
	dw_maestro.SetColumn(1)
	dw_maestro.SelectRow(0,False)
	il_fila_actual_maestro = ll_fila
	dw_maestro.SetItem(il_fila_actual_maestro,"fe_creacion",f_fecha_servidor())
END IF

ls_usuario= gstr_info_usuario.codigo_usuario


  SELECT DISTINCT cf_user_prod.ano_mes  
    INTO :ld_ano_mes  
    FROM cf_user_prod  
   WHERE cf_user_prod.usuario = :ls_usuario   ;


dw_maestro.SetItem(1,"ano_mes",ld_ano_mes)
dw_maestro.SetItem(1,"fe_movimiento",f_fecha_servidor())
dw_maestro.accepttext()
dw_1.visible=true
dw_2.visible=true
dw_1.Reset()
dw_2.Reset()
il_total=0



end event

event closequery;call super::closequery;DISCONNECT USING itr_tela ;
IF itr_tela.SQLCODE=-1 THEN
	MessageBox("Error base datos","No pudo desconectar de proceso")
	RETURN 0
ELSE 
END IF

end event

type dw_maestro from w_base_simple`dw_maestro within w_movimientos
integer x = 23
integer y = 0
integer width = 3543
integer height = 520
integer taborder = 10
boolean titlebar = true
string title = "Datos Generales para el ajuste del Kardes"
string dataobject = "dtb_mv_inventa_etapa"
boolean hscrollbar = false
boolean vscrollbar = false
boolean hsplitscroll = false
boolean livescroll = false
end type

event dw_maestro::doubleclicked;call super::doubleclicked;s_base_parametros lstr_parametros

choose case GetColumnName()
	case 'co_transaccion'
		Open(w_rutas_etapas)
		
		lstr_parametros = message.powerObjectparm
		
		If lstr_parametros.cadena[1] = 'SI' Then
			dw_maestro.SetItem(row,'co_transaccion',lstr_parametros.entero[1])
			dw_maestro.SetItem(row,'co_ruta_etapa',lstr_parametros.entero[2])
			dw_maestro.SetItem(row,'co_transaccion_1',lstr_parametros.cadena[2])
		End if
end choose


end event

event dw_maestro::itemchanged;call super::itemchanged;Long ll_ordencorte,ll_agrupacion,ll_cs_dato,ll_pdn,ll_unidades
Long li_co_ruta_etapa,li_co_transaccion,li_co_tipo_etapa,li_cs_max_mov
datetime ldt_ano_mes
string ls_bongo
s_base_parametros lstr_parametros

dw_maestro.AcceptText()
choose case GetColumnName()
	case 'cs_orden_corte'
		ll_ordencorte = Long(Data)
		
		 SELECT DISTINCT dt_agrupa_pdn.cs_agrupacion
		 INTO :ll_agrupacion
		 FROM dt_agrupa_pdn,   
				dt_pdnxmodulo  
		WHERE ( dt_agrupa_pdn.co_fabrica_exp = dt_pdnxmodulo.co_fabrica_exp ) and  
				( dt_pdnxmodulo.pedido = dt_agrupa_pdn.pedido ) and  
				( dt_agrupa_pdn.cs_liberacion = dt_pdnxmodulo.cs_liberacion ) and  
				( dt_pdnxmodulo.po = dt_agrupa_pdn.po ) and  
				( dt_agrupa_pdn.co_fabrica_pt = dt_pdnxmodulo.co_fabrica_pt ) and  
				( dt_pdnxmodulo.co_linea = dt_agrupa_pdn.co_linea ) and  
				( dt_agrupa_pdn.co_referencia = dt_pdnxmodulo.co_referencia ) and  
				( dt_pdnxmodulo.co_color_pt = dt_agrupa_pdn.co_color_pt ) and  
				( dt_agrupa_pdn.tono = dt_pdnxmodulo.tono ) and  
				( dt_pdnxmodulo.cs_estilocolortono = dt_agrupa_pdn.cs_estilocolortono ) and  
				( dt_agrupa_pdn.cs_particion = dt_pdnxmodulo.cs_particion ) and  
				( ( dt_pdnxmodulo.cs_asignacion = :ll_ordencorte )   
				) USING itr_tela  ;
				
		
		If sqlca.sqlcode = -1 Then
			MessageBox('Error de Base de Datos','Ocurrio un error al momento de consultar la agrupacion ')
			Return
		End if
		
		This.SetItem(row,'cs_agrupacion',ll_agrupacion)		
		idwc_pdn.Retrieve(ll_agrupacion)
		
	case 'cs_pdn'
		li_co_ruta_etapa = this.getitemnumber(row,"co_ruta_etapa")
		ldt_ano_mes=this.getitemdatetime(row,"ano_mes")
		li_co_transaccion=this.getitemnumber(row,"co_transaccion")
		ll_ordencorte=this.getitemnumber(row,"cs_orden_corte")
		ls_bongo=string(this.getitemnumber(row,"co_transaccion"))
		ll_agrupacion=this.getitemnumber(row,"cs_agrupacion")
		ll_pdn= Long(data) //this.getitemnumber(row,"cs_pdn")	
		SELECT max( mv_inventa_etapa.cs_dato)  
		 INTO :ll_cs_dato  
		 FROM mv_inventa_etapa  
		WHERE ( mv_inventa_etapa.ano_mes 			=:ldt_ano_mes  ) AND  
				( mv_inventa_etapa.co_transaccion 	=:li_co_transaccion  ) AND  
				( mv_inventa_etapa.co_ruta_etapa 	=:li_co_ruta_etapa  )   and
				( mv_inventa_etapa.cs_orden_corte 	=:ll_ordencorte  ) 				;
		If sqlca.sqlcode = -1 Then
			MessageBox('Error de Base de Datos','Ocurrio un error al momento de consultar el dato para el mov. ')
			Return
		End if

		if isnull(ll_cs_dato) then
			ll_cs_dato=0
		else
		end if
		
		ll_cs_dato=ll_cs_dato+1
		
		SELECT max( mv_inventa_etapa.cs_movimiento)  
		 INTO :li_cs_max_mov  
		 FROM mv_inventa_etapa  
		WHERE ( mv_inventa_etapa.ano_mes 			= :ldt_ano_mes ) AND  
				( mv_inventa_etapa.co_transaccion 	= :li_co_transaccion ) AND  
				( mv_inventa_etapa.co_ruta_etapa 	= :li_co_ruta_etapa ) AND  
				( mv_inventa_etapa.cs_dato 			= :ll_cs_dato )   ;
				
		If sqlca.sqlcode = -1 Then
			MessageBox('Error de Base de Datos','Ocurrio un error al momento de consultar el dato para el mov. ')
			Return
		End if
		if isnull(li_cs_max_mov) then
			li_cs_max_mov=0
		else
		end if
		
		li_cs_max_mov=li_cs_max_mov+1
		
		This.SetItem(row,'cs_dato',ll_cs_dato)		
		This.SetItem(row,'cs_movimiento',li_cs_max_mov)	
      dw_1.Retrieve(ll_agrupacion,ll_pdn)
		idwc_agruppdn.SetTransObject(SQLCA)
		idwc_agruppdn.Retrieve(ll_agrupacion,ll_pdn)
		
	case 'ca_movimiento'
		ll_unidades = dw_maestro.GetitemNumber(1,"ca_movimiento")
		dw_maestro.setitem(il_fila_actual_maestro,"ca_unidades",ll_unidades )
		dw_maestro.AcceptText()
end choose



end event

type dw_1 from datawindow within w_movimientos
integer x = 23
integer y = 520
integer width = 2071
integer height = 752
integer taborder = 20
boolean bringtotop = true
boolean titlebar = true
string title = "Digite las unidades y haga doble click sobre el registro"
string dataobject = "dtb_estilo_para_ajsute"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event clicked;//// Se evalua si se hizo click sobre una fila valida

IF row <> 0 AND row <> -1 AND NOT IsNull(row) THEN
	this.selectrow(il_fila_actual,false)
	il_fila_actual = row
ELSE
END IF


end event

event rowfocuschanged;this.selectrow(il_fila_actual,false)
il_fila_actual=this.getrow()
this.setrow(il_fila_actual)
this.selectrow(il_fila_actual,true)


end event

event doubleclicked;Long ll_fila,ll_contador

il_unidades= 0
// Se evalua si se hizo click sobre una fila valida//
IF row <> 0 AND row <> -1 AND NOT IsNull(row) THEN
	This.SelectRow(il_fila_actual_maestro,FALSE)
	il_fila_actual_maestro = row
ELSE
END IF

il_unidades	= dw_1.GetItemNumber(il_fila_actual_maestro, "unidades")
IF il_unidades = 0 THEN
	Messagebox("Error","Debe digitar las unidades para hacer el ajuste",Exclamation!,Ok!)	
ELSE
	
	il_fabrica			= dw_1.GetItemNumber(il_fila_actual_maestro, "dt_agrupa_pdn_co_fabrica_pt")
	il_linea 			= dw_1.GetItemNumber(il_fila_actual_maestro, "dt_agrupa_pdn_co_linea")
	il_referencia 		= dw_1.GetItemNumber(il_fila_actual_maestro, "dt_agrupa_pdn_co_referencia")
	il_color 			= dw_1.GetItemNumber(il_fila_actual_maestro, "dt_agrupa_pdn_co_color_pt")
	il_talla				= dw_1.GetItemNumber(il_fila_actual_maestro, "dt_agrupaescalapdn_co_talla")
	il_concepto 		= dw_maestro.GetItemNumber(1, "co_concepto")
	il_subcentro 		= dw_maestro.GetItemNumber(1, "co_subcentro")
	
	ll_fila = dw_2.InsertRow(0)
	IF ll_fila = -1 THEN
		MessageBox("Error datawindow","No se pudo insertar el registro del maestro",StopSign!,Ok!)
	ELSE
		dw_2.SetRow(ll_fila)
		dw_2.ScrollToRow(ll_fila)
		dw_2.SetColumn(1)
		dw_2.SelectRow(0,False)
		il_fila_actual = ll_fila
	END IF
	
	dw_2.SelectRow(il_fila_actual,FALSE)
	il_fila_actual = dw_2.GetRow()
	  
	
	IF ((il_fila_actual<> -1) and &
		  (NOT ISNULL (il_fila_actual)) and &
		  (il_fila_actual>0))THEN
		   dw_2.SelectRow(il_fila_actual,TRUE)
			dw_2.SetItem(il_fila_actual, "fabrica", il_fabrica)
			dw_2.SetItem(il_fila_actual, "linea", il_linea)
			dw_2.SetItem(il_fila_actual, "referencia", il_referencia)
			dw_2.SetItem(il_fila_actual, "color", il_color)
			dw_2.SetItem(il_fila_actual, "talla", il_talla)
			dw_2.SetItem(il_fila_actual, "co_concepto", il_concepto)
			dw_2.SetItem(il_fila_actual, "co_subcentro", il_subcentro)
			dw_2.SetItem(il_fila_actual, "unidades", il_unidades)
			il_total= il_total + il_unidades
			pb_1.visible=true
	ELSE
	END IF
END IF
	

end event

type pb_1 from picturebutton within w_movimientos
integer x = 2798
integer y = 132
integer width = 389
integer height = 160
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "Procesar"
string picturename = "Custom038!"
alignment htextalign = right!
end type

event clicked;LONG ll_total,ll_unidades
ll_unidades = dw_maestro.GetItemNumber(1, "ca_movimiento")

IF ll_unidades <> il_total THEN
	Messagebox("Error","la cantidad es diferente a la sumatoria de unidades a procesar ",Exclamation!,Ok!)		
ELSE
	IF dw_2.UPDATE() > 0 THEN
		COMMIT;
		Messagebox("PROCESO EXITOSO","El proceso termin$$HEX2$$f3002000$$ENDHEX$$bien. ",Exclamation!,Ok!)		
	ELSE
	END IF
END IF
end event

type dw_2 from datawindow within w_movimientos
integer x = 2103
integer y = 520
integer width = 1472
integer height = 752
integer taborder = 30
boolean bringtotop = true
boolean titlebar = true
string title = "Registros para procesar"
string dataobject = "dtg_estilotalla_ajustar"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

