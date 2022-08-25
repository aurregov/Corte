HA$PBExportHeader$w_reporte_guias_numeracion.srw
forward
global type w_reporte_guias_numeracion from w_preview_de_impresion
end type
type dw_criterio from datawindow within w_reporte_guias_numeracion
end type
type cb_recuperar from commandbutton within w_reporte_guias_numeracion
end type
type cb_adhesivos from commandbutton within w_reporte_guias_numeracion
end type
type sle_espacio from singlelineedit within w_reporte_guias_numeracion
end type
type st_1 from statictext within w_reporte_guias_numeracion
end type
type cb_ordenar from commandbutton within w_reporte_guias_numeracion
end type
type cb_partes from commandbutton within w_reporte_guias_numeracion
end type
type dw_adhesivo from datawindow within w_reporte_guias_numeracion
end type
type cb_otras_rayas from commandbutton within w_reporte_guias_numeracion
end type
type dw_otras_rayas from datawindow within w_reporte_guias_numeracion
end type
type dw_adbolsa from datawindow within w_reporte_guias_numeracion
end type
type dw_adhesivo_partes from datawindow within w_reporte_guias_numeracion
end type
type dw_adhesivos_orden from datawindow within w_reporte_guias_numeracion
end type
type cb_partes_oc from commandbutton within w_reporte_guias_numeracion
end type
type dw_adhesivos_partes_ant from datawindow within w_reporte_guias_numeracion
end type
type cb_1 from commandbutton within w_reporte_guias_numeracion
end type
type dw_1 from datawindow within w_reporte_guias_numeracion
end type
type cb_2 from commandbutton within w_reporte_guias_numeracion
end type
type cb_formato_marcacion_bolsa from commandbutton within w_reporte_guias_numeracion
end type
type cb_rep_partes from commandbutton within w_reporte_guias_numeracion
end type
end forward

global type w_reporte_guias_numeracion from w_preview_de_impresion
integer width = 3575
integer height = 2168
string menuname = "m_vista_guias_numeracion"
event ue_reimpresion ( )
dw_criterio dw_criterio
cb_recuperar cb_recuperar
cb_adhesivos cb_adhesivos
sle_espacio sle_espacio
st_1 st_1
cb_ordenar cb_ordenar
cb_partes cb_partes
dw_adhesivo dw_adhesivo
cb_otras_rayas cb_otras_rayas
dw_otras_rayas dw_otras_rayas
dw_adbolsa dw_adbolsa
dw_adhesivo_partes dw_adhesivo_partes
dw_adhesivos_orden dw_adhesivos_orden
cb_partes_oc cb_partes_oc
dw_adhesivos_partes_ant dw_adhesivos_partes_ant
cb_1 cb_1
dw_1 dw_1
cb_2 cb_2
cb_formato_marcacion_bolsa cb_formato_marcacion_bolsa
cb_rep_partes cb_rep_partes
end type
global w_reporte_guias_numeracion w_reporte_guias_numeracion

type variables
 Long ii_impresion,ii_reimpresion
end variables

forward prototypes
public function string of_letra (long al_num)
public function long of_control_reimpresion (long al_ordencorte, long ai_num_impr, long ai_tipo_impr)
public subroutine of_actualizar_guias (long al_ordencorte, long ai_espacio)
public subroutine wf_generarrepparte ()
end prototypes

event ue_reimpresion();
If ii_impresion = 0 OR isnull(ii_impresion) Then
	ii_impresion = 1
Else
	ii_impresion = 0
End if
end event

public function string of_letra (long al_num);String ls_letra,ls_char1,ls_char2
Long ll_resul,ll_totres,ll_numreal

ll_resul = Round(al_num / 26,0)

IF ll_resul > 1 OR al_num > 26 THEN
	ls_char1 = Char(64 + ll_resul)
	
	IF ll_resul = 1 THEN ll_resul = 2
	ll_totres = (ll_resul -1 ) * 26
	
	ll_numreal = al_num - ll_totres
	
	
	ls_char2 = Char(64 + ll_numreal)
	
ELSE
	
	ls_char1 = Char(64 + al_num)
END IF

ls_letra = ls_char1+ls_char2

Return ls_letra
end function

public function long of_control_reimpresion (long al_ordencorte, long ai_num_impr, long ai_tipo_impr);DateTime ldt_fecha
Long li_concepto
s_base_parametros lstr_parametros

//obtengo la fecha del servidor
ldt_fecha = f_fecha_servidor()

//se debe pedir el concepto de reimpresion
open(w_buscar_concepto)
lstr_parametros = message.PowerObjectParm	

IF lstr_parametros.hay_parametros THEN
	li_concepto = lstr_parametros.entero[1]
ELSE
	Return -1
END IF

//inserto el registro
INSERT INTO mv_reimpresion 
 			  (cs_orden_corte, 
				co_concepto, 
				tipo_impresion, 
				contador_impresion, 
				fe_actualizacion, 
				usuario, 
				instancia)
	VALUES  (:al_ordencorte,
				:li_concepto,
				:ai_tipo_impr,
				:ai_num_impr,
				:ldt_fecha,
				:gstr_info_usuario.codigo_usuario,
				:gstr_info_usuario.instancia);

IF sqlca.sqlcode <> 0 THEN
	MessageBox('Error','No fue posible registrar la reimpresion. '+Sqlca.SqlErrText)
	Return -1
END IF
			
Return 0
end function

public subroutine of_actualizar_guias (long al_ordencorte, long ai_espacio);
//se valida el valor del espacio
IF ai_espacio = 0 THEN
	//se debe actualizar el campo para toda la orden
	UPDATE t_guias_num_prog
	   SET sw_impresion = sw_impresion + 1
	 WHERE cs_orden_corte = :al_ordencorte;

	 
ELSE
	//se actualiza el campo para la orden de corte y espacio especifico
	UPDATE t_guias_num_prog
	   SET sw_impresion = sw_impresion + 1
	 WHERE cs_orden_corte = :al_ordencorte AND
	       cs_espacio = :ai_espacio;
	
END IF
	 
Commit;

end subroutine

public subroutine wf_generarrepparte ();long		li_tipo, li_raya, ll_cs_espacio, ll_cs_orden_corte, ll_cs_base_trazos

IF dw_adhesivo.RowCount() <= 0 THEN RETURN 

dw_criterio.AcceptText()
dw_reporte.setRedraw(False)
dw_reporte.DataObject = 'd_sp_gr_rep_adhesivo_partes'
dw_reporte.SetTransObject(gnv_recursos.of_get_transaccion_sucia())
li_tipo				=	dw_criterio.getitemnumber(1,"tipo")
ll_cs_orden_corte =	dw_criterio.GetItemNumber(1,'ordencorte')
li_raya				=	dw_criterio.GetItemNumber(1,'modelo')
ll_cs_espacio		=	Long(sle_espacio.text)	
ll_cs_base_trazos =	dw_adhesivo.GetitemNumber(1,"cs_base_trazos")

IF li_tipo = 2 THEN
	IF dw_reporte.Retrieve(ll_cs_orden_corte, ll_cs_base_trazos, ll_cs_espacio, 0, " ",li_raya, gstr_info_usuario.codigo_usuario) > 0 THEN
		dw_reporte.setRedraw(True)
	END IF
ELSE
	MessageBox("Advertencia...","El estado seleccionado no permite generar el reporte de los adhesivos",Exclamation!)
END IF
end subroutine

on w_reporte_guias_numeracion.create
int iCurrent
call super::create
if IsValid(this.MenuID) then destroy(this.MenuID)
if this.MenuName = "m_vista_guias_numeracion" then this.MenuID = create m_vista_guias_numeracion
this.dw_criterio=create dw_criterio
this.cb_recuperar=create cb_recuperar
this.cb_adhesivos=create cb_adhesivos
this.sle_espacio=create sle_espacio
this.st_1=create st_1
this.cb_ordenar=create cb_ordenar
this.cb_partes=create cb_partes
this.dw_adhesivo=create dw_adhesivo
this.cb_otras_rayas=create cb_otras_rayas
this.dw_otras_rayas=create dw_otras_rayas
this.dw_adbolsa=create dw_adbolsa
this.dw_adhesivo_partes=create dw_adhesivo_partes
this.dw_adhesivos_orden=create dw_adhesivos_orden
this.cb_partes_oc=create cb_partes_oc
this.dw_adhesivos_partes_ant=create dw_adhesivos_partes_ant
this.cb_1=create cb_1
this.dw_1=create dw_1
this.cb_2=create cb_2
this.cb_formato_marcacion_bolsa=create cb_formato_marcacion_bolsa
this.cb_rep_partes=create cb_rep_partes
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_criterio
this.Control[iCurrent+2]=this.cb_recuperar
this.Control[iCurrent+3]=this.cb_adhesivos
this.Control[iCurrent+4]=this.sle_espacio
this.Control[iCurrent+5]=this.st_1
this.Control[iCurrent+6]=this.cb_ordenar
this.Control[iCurrent+7]=this.cb_partes
this.Control[iCurrent+8]=this.dw_adhesivo
this.Control[iCurrent+9]=this.cb_otras_rayas
this.Control[iCurrent+10]=this.dw_otras_rayas
this.Control[iCurrent+11]=this.dw_adbolsa
this.Control[iCurrent+12]=this.dw_adhesivo_partes
this.Control[iCurrent+13]=this.dw_adhesivos_orden
this.Control[iCurrent+14]=this.cb_partes_oc
this.Control[iCurrent+15]=this.dw_adhesivos_partes_ant
this.Control[iCurrent+16]=this.cb_1
this.Control[iCurrent+17]=this.dw_1
this.Control[iCurrent+18]=this.cb_2
this.Control[iCurrent+19]=this.cb_formato_marcacion_bolsa
this.Control[iCurrent+20]=this.cb_rep_partes
end on

on w_reporte_guias_numeracion.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_criterio)
destroy(this.cb_recuperar)
destroy(this.cb_adhesivos)
destroy(this.sle_espacio)
destroy(this.st_1)
destroy(this.cb_ordenar)
destroy(this.cb_partes)
destroy(this.dw_adhesivo)
destroy(this.cb_otras_rayas)
destroy(this.dw_otras_rayas)
destroy(this.dw_adbolsa)
destroy(this.dw_adhesivo_partes)
destroy(this.dw_adhesivos_orden)
destroy(this.cb_partes_oc)
destroy(this.dw_adhesivos_partes_ant)
destroy(this.cb_1)
destroy(this.dw_1)
destroy(this.cb_2)
destroy(this.cb_formato_marcacion_bolsa)
destroy(this.cb_rep_partes)
end on

event open;dw_1.SetTransObject(sqlca)
dw_reporte.SetTransObject(sqlca)
dw_criterio.SetTransObject(sqlca)
dw_adhesivo.SetTransObject(sqlca)
dw_adhesivos_orden.SetTransObject(sqlca)
dw_criterio.insertRow(0)
ii_reimpresion = 1
cb_adhesivos.Enabled = False
IF (f_deshabilitar_opciones(this.classname(),this.menuid)= -1) THEN
	Close(This)
END IF

end event

event resize;dw_reporte.Resize(This.Width - 100, This.Height - 350)
end event

event ue_imprimir;
//si va a imprimir el Formato marcaci$$HEX1$$f300$$ENDHEX$$n bolsa
If dw_reporte.DataObject = 'd_gr_datos_formato_preimpreso_corte' Then
	
	If dw_reporte.RowCount() > 0 Then
		Long ll_n, ll_reg, ll_cont
		
		uo_dsbase lds_impresion
		
		lds_impresion = Create uo_dsbase
		lds_impresion.DataObject = 'd_lb_formato_preimpreso_corte'
		
		If dw_reporte.AcceptText() < 0 Then Return -1
		
		//realiza el ciclo dependiendo de los registro por OC y rata
		For ll_n = 1 to dw_reporte.RowCount()
			//realiza el ciclo dependiendo del n$$HEX1$$f900$$ENDHEX$$mero de adhesivo que se quiera imprimir
			For ll_cont = 1 to dw_reporte.GetItemNumber(ll_n,'adhesivos')
				ll_reg = lds_impresion.InsertRow(0)
				lds_impresion.SetItem(ll_reg,'tanda',String(dw_reporte.GetItemNumber(ll_n,'tanda')))
				lds_impresion.SetItem(ll_reg,'pinta',Trim(dw_reporte.GetItemString(ll_n,'de_pinta')))
				lds_impresion.SetItem(ll_reg,'diametro',String(dw_reporte.GetItemNumber(ll_n,'diametro')))
				lds_impresion.SetItem(ll_reg,'estilo',String(dw_reporte.GetItemNumber(ll_n,'co_referencia')) + '-'+Trim(dw_reporte.GetItemString(ll_n,'de_referencia')))
				lds_impresion.SetItem(ll_reg,'cantidad',String(dw_reporte.GetItemNumber(ll_n,'cantidad')))
				lds_impresion.SetItem(ll_reg,'auditor',Trim(dw_reporte.GetItemString(ll_n,'auditor')))
				lds_impresion.SetItem(ll_reg,'cortador',Trim(dw_reporte.GetItemString(ll_n,'cortador')))
				lds_impresion.SetItem(ll_reg,'obs',Trim(dw_reporte.GetItemString(ll_n,'observacion')))
			Next
		Next
		
		//imprime los adhesivos
		lds_impresion.Print()
		//OpenWithParm(w_opciones_impresion, lds_impresion)
	End if
Else
	dw_reporte.setFocus()
	OpenWithParm(w_opciones_impresion, dw_reporte)
End if
end event

type dw_reporte from w_preview_de_impresion`dw_reporte within w_reporte_guias_numeracion
integer x = 27
integer y = 232
integer width = 3442
integer height = 1616
integer taborder = 50
string dataobject = "drp_reporte_numeracion"
end type

type dw_criterio from datawindow within w_reporte_guias_numeracion
integer x = 27
integer y = 16
integer width = 1509
integer height = 124
integer taborder = 10
boolean bringtotop = true
string title = "none"
string dataobject = "d_parametros_guias_numeracion"
boolean border = false
boolean livescroll = true
end type

event itemchanged;Long ll_ordencorte
n_cts_ocfabrica luo_oc


//choose case dwo.name
//	case 'ordencorte'
//		ll_ordencorte = Long(Data)
//		
//		IF luo_oc.of_validarocfabrica(ll_ordencorte) = -1 THEN
//			dw_criterio.Reset()
//			dw_criterio.InsertRow(0)
//			dw_criterio.SetFocus()
//			Return
//		End if
//		
//end choose

end event

type cb_recuperar from commandbutton within w_reporte_guias_numeracion
integer x = 1984
integer y = 32
integer width = 288
integer height = 92
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "Recuperar"
boolean default = true
end type

event clicked;string ls_sqlerr,ls_letra,ls_let, ls_find
long ll_cs_orden_corte,ll_result,i, ll_found
Long li_raya,li_tipo,li_cs_espacio,li_cs_orden_espacio,li_raya2
Long li_espacio_anterior,li_seccion_anterior,li_talla_anterior,li_paquete_anterior
Long li_espacio_ciclo,li_seccion_ciclo,li_talla_ciclo,li_paquete_ciclo,li_numero_letra,li_cs_orden
Long li_cs_base_trazos,j,li_cs_pdn_ciclo,li_pdn,li_cs_ordenpdn, li_impresion
long	  ll_capas,ll_capas_ciclo,ll_inicio,ll_fin,ll_tra,ll_talla1,ll_i,ll_ord,ll_agr,ll_bas,ll_esp,ll_sec
long    ll_tal,ll_pdn,ll_capa,ll_finfd,li_cs_pdn_liquida,li_capas_liquida
datetime ldt_fe_creacion,ldt_fe_actualizacion
Long	li_fab1, li_lin1, li_fabrica, li_linea, li_result, li_seccion_escala, li_escala, li_seccion_escala_ant
Long		ll_ref1, ll_pdn1, ll_referencia, li_cs_agrupacion, ll_cs_unir_oc	

DataStore lds_num,lds_sort, lds_imp
n_cst_orden_corte luo_orden_corte
TRANSACTION			itr_tela


dw_reporte.DataObject = 'drp_reporte_numeracion'
dw_reporte.SetTransObject(SQLCA)

itr_tela 				=  Create Transaction
itr_tela.DBMS			=	ProfileString(gstr_info_usuario.ruta_ini,"bd aplicacion","DBMS","")
itr_tela.DATABASE		=	ProfileString(gstr_info_usuario.ruta_ini,"bd aplicacion","DATABASE","")
itr_tela.USERID		=	SQLCA.USERID
itr_tela.DBPASS		=	SQLCA.DBPASS
itr_tela.DBPARM		=	"connectstring='DSN="+itr_tela.DATABASE+";UID="+itr_tela.USERID+";PWD="+itr_tela.DBPASS+"'"
itr_tela.ServerName  = 	ProfileString(gstr_info_usuario.ruta_ini,"bd aplicacion","SERVIDOR","")
itr_tela.Lock 			= 	ProfileString(gstr_info_usuario.ruta_ini,"bd aplicacion","LOCK","Dirty read")

CONNECT USING itr_tela;
IF itr_tela.SQLCODE = -1 THEN
   MessageBox("ERROR....","La conexi$$HEX1$$f300$$ENDHEX$$n para abrir esta ventana (dr)" +sqlca.sqlerrtext,Stopsign!,OK!)
   Return
END IF

dw_criterio.AcceptText()

dw_adhesivo.SetTransobject(itr_tela)
lds_num = Create DataStore
lds_sort = Create DataStore
lds_imp = Create DataStore

//definir oc , raya, tipo y espacio
ll_cs_orden_corte=dw_criterio.getitemnumber(1,"ordencorte")
li_raya=dw_criterio.getitemnumber(1,"raya")
li_tipo=dw_criterio.getitemnumber(1,"tipo")
li_cs_espacio=Long(sle_espacio.text)

lds_sort.DataObject = 'd_reporte_numeracion_sort'
lds_imp.DataObject = 'ds_guias_numeracion'

choose case li_tipo
	case 1
		//data store de programaci$$HEX1$$f300$$ENDHEX$$n
		lds_num.DataObject = 'd_lista_guias_numeracion_copia'
	case 2
		//se debe validar que si la orden es de duo o conjunto se validen las unidades preliquidadas que sean iguales o con la diferencia
		
		ll_cs_unir_oc = luo_orden_corte.of_duo_conjunto(ll_cs_orden_corte)		
		IF ll_cs_unir_oc > 1 THEN
			li_result = luo_orden_corte.of_valida_unid_duo_liquidacion(ll_cs_unir_oc)
			IF li_result <> 1 THEN
				
				//se debe pedir contrase$$HEX1$$f100$$ENDHEX$$a  aun n o rea ha realizado porque se puso informativo
				MessageBox('Advertencia','No se pueden generar los datos')
				Close(parent)
			END IF
				
		END IF
		//data store de liquidaci$$HEX1$$f300$$ENDHEX$$n
		lds_num.DataObject = 'd_lista_guias_num_liquida_copia'
	case 0
		MessageBox('Advertencia','Se debe ingresar el estado del que se quiere conocer la guias de numeraci$$HEX1$$f300$$ENDHEX$$n')
		Return
end choose
	
lds_sort.SetTransObject(itr_tela)
lds_num.SetTransObject(itr_tela)
lds_imp.SetTransObject(itr_tela)
	
ll_result = lds_num.Retrieve(ll_cs_orden_corte,li_raya)
	
//si hay datos arranca proceso
if ll_result > 0 then
	//se conservan los datos para no perder el historico de impresion
   lds_imp.Retrieve(ll_cs_orden_corte)
	
	//inicializa tabla de guias
	delete from t_guias_num_prog
	where cs_orden_corte = :ll_cs_orden_corte;
	
	If Sqlca.SqlCode = -1 Then
			ls_sqlerr = Sqlca.SqlErrText
			rollback ;
			MessageBox("Advertencia!","No se pudo borrar la temporal para el reporte.~n~n~n" + ls_sqlerr)
			Return
	Else
			commit ;
	End If	
	
	//recorrer dw en el orden correcto por espacio
	li_espacio_anterior = lds_num.getitemnumber(1,"cs_trazo")
	li_seccion_anterior = 0
	li_talla_anterior = -1
	li_paquete_anterior = -1
	li_numero_letra = 0
	li_seccion_escala_ant = -1
			
	for i=1 to lds_num.Rowcount()
		li_espacio_ciclo	= lds_num.getitemnumber(i,"cs_trazo")
		li_seccion_ciclo	= lds_num.getitemnumber(i,"cs_sec_ext")
		li_talla_ciclo		= lds_num.getitemnumber(i,"co_talla")
		li_paquete_ciclo	= lds_num.getitemnumber(i,"paquetes")
		li_cs_agrupacion 	= lds_num.GetItemNumber(i,'cs_agrupacion')
		li_seccion_escala = lds_num.GetItemNumber(i,'cs_seccion')
		li_escala			= lds_num.GetItemNumber(i,'escala')  //si tiene valor 1 es porque el trazo es en escala
		li_cs_orden 		= lds_num.GetItemNumber(i,'cs_orden_espacio')
		IF IsNull(li_cs_orden) THEN
			li_cs_orden = li_espacio_ciclo
		END IF
				
		if li_espacio_ciclo <> li_espacio_anterior then
			li_espacio_anterior=li_espacio_ciclo
			IF li_seccion_escala = li_seccion_escala_ant AND li_escala = 1 THEN
				//en este caso continua con la numeracion que lleva, pues es un trazo en escala, jorodrig mayo  27 - 2011
			ELSE
				li_numero_letra=0
			END IF
			li_talla_anterior=-1
		end if
		li_seccion_escala_ant = li_seccion_escala
		
		if li_seccion_ciclo<>li_seccion_anterior then
			li_seccion_anterior=li_seccion_ciclo
			li_talla_anterior=-1
		end if
				
		if li_talla_ciclo <> li_talla_anterior  then
			li_talla_anterior=li_talla_ciclo
			//aqui
			for j=1 to li_paquete_ciclo
				li_numero_letra += 1
				//buscar letra
				SELECT m_numero_letras.letra  
				 INTO :ls_letra  
				 FROM m_numero_letras  
				WHERE m_numero_letras.numero = :li_numero_letra;
				
				if sqlca.sqlcode=-1 then
					messagebox("error bd","no pudo buscar numero letra")
					return
				end if
				
				//busque lotes
				if li_tipo=1 then
					declare cur_lotes cursor for 
					SELECT DISTINCT dt_unidadesxtrazo.cs_pdn,dt_unidadesxtrazo.capas,dt_trazosxoc.cs_ordenpdn,
										dt_trazosxoc.cs_base_trazos	
					 FROM dt_unidadesxtrazo,   
							dt_trazosxoc,
							h_base_trazos
					WHERE ( dt_trazosxoc.cs_orden_corte 			= dt_unidadesxtrazo.cs_orden_corte ) and  
							( dt_trazosxoc.cs_agrupacion 				= dt_unidadesxtrazo.cs_agrupacion ) and  
							( dt_trazosxoc.cs_base_trazos 			= dt_unidadesxtrazo.cs_base_trazos ) and  
							( dt_trazosxoc.cs_trazo 					= dt_unidadesxtrazo.cs_trazo ) and  
							( dt_trazosxoc.cs_seccion 					= dt_unidadesxtrazo.cs_seccion ) and  
							( dt_trazosxoc.cs_pdn 						= dt_unidadesxtrazo.cs_pdn ) and  
							( dt_trazosxoc.co_modelo 					= dt_unidadesxtrazo.co_modelo ) and  
							( dt_trazosxoc.co_fabrica_tela 			= dt_unidadesxtrazo.co_fabrica_tela ) and  
							( dt_trazosxoc.co_reftel 					= dt_unidadesxtrazo.co_reftel ) and  
							( dt_trazosxoc.co_caract 					= dt_unidadesxtrazo.co_caract ) and  
							( dt_trazosxoc.diametro 					= dt_unidadesxtrazo.diametro ) and  
							( dt_trazosxoc.co_color_te 				= dt_unidadesxtrazo.co_color_te ) and  
							( dt_unidadesxtrazo.cs_orden_corte 		= :ll_cs_orden_corte ) AND  
							( dt_unidadesxtrazo.cs_agrupacion 		= :li_cs_agrupacion ) AND  
							( dt_trazosxoc.cs_agrupacion 				= h_base_trazos.cs_agrupacion ) and
							( dt_trazosxoc.cs_base_trazos				= h_base_trazos.cs_base_trazos ) and
							( h_base_trazos.raya 						= :li_raya ) and
							( dt_unidadesxtrazo.cs_trazo 				= :li_espacio_ciclo ) AND  
							( dt_trazosxoc.cs_sec_ext 					= :li_seccion_ciclo ) AND   
							( dt_unidadesxtrazo.co_talla 				= :li_talla_ciclo )    
							order by dt_trazosxoc.cs_ordenpdn ;
						
					open cur_lotes;
						
					fetch cur_lotes  INTO :li_cs_pdn_ciclo,:ll_capas_ciclo,:li_cs_ordenpdn,:li_raya2;
					
					do while sqlca.sqlcode=0
						ldt_fe_creacion = f_fecha_servidor()
						ldt_fe_actualizacion = ldt_fe_creacion
						
						ls_find = "cs_orden_corte = " +String(ll_cs_orden_corte)+" and cs_agrupacion = "+String(li_cs_agrupacion) &
						          +" and cs_base_trazos = "+String(li_raya2)+" and cs_espacio = "+String(li_espacio_ciclo) &
									 +" and cs_sec_ext = "+String(li_seccion_ciclo)+" and co_talla = "+String(li_talla_ciclo) &
									 +" and cs_pdn = "+String(li_cs_pdn_ciclo)+ " and letra = '"+ls_letra+"'" +" and tipo = "+String(li_tipo)

						ll_found = lds_imp.Find(ls_find,1,lds_imp.RowCount())
						
						IF ll_found = 0 THEN
							li_impresion = 0
						ELSE
							li_impresion = lds_imp.GetItemNumber(ll_found,'sw_impresion')
						END IF	
							
						INSERT INTO t_guias_num_prog  
						( cs_orden_corte,					cs_agrupacion,   			cs_base_trazos,   			cs_espacio,   
						  cs_sec_ext,   					co_talla,   				cs_pdn,   						letra,   
						  tipo,   							codigo_barras,   			ca_paquetes,   				capas,   
						  valor_inicial,   				valor_final,   			fe_creacion,   				fe_actualizacion,   
						  usuario,   						instancia,   				ca_liquidada,   				ca_loteada,   
						  cs_orden,							sw_impresion )  
						VALUES ( 
						  :ll_cs_orden_corte,   		:li_cs_agrupacion,   	:li_raya2,   					:li_espacio_ciclo,   
						  :li_seccion_ciclo,   			:li_talla_ciclo,   		:li_cs_pdn_ciclo,   			:ls_letra,   
						  :li_tipo,   						0,   							:li_paquete_ciclo,   		:ll_capas_ciclo,   
						  1,   								1,   							:ldt_fe_creacion,   			:ldt_fe_actualizacion,   
						  user,   							sitename,   				0,   								0,   
						  :li_cs_orden,					:li_impresion )  ;
					
						if sqlca.sqlcode=-1 then
							rollback;
							messagebox("error bd","no pudo insertar en tabla de guias, ERROR: "+sqlca.sqlerrtext)
							return
						end if
							//insert into t_guias_num_prog
						fetch cur_lotes  INTO :li_cs_pdn_ciclo,:ll_capas_ciclo,:li_cs_ordenpdn,:li_raya2;
					loop
					close cur_lotes;
					
				elseif li_tipo = 2 Then
					
					declare cur_liquida cursor for
					SELECT dt_liq_unixespacio.cs_pdn,dt_liq_unixespacio.capas,dt_trazosxoc.cs_ordenpdn,
								dt_trazosxoc.cs_base_trazos
						
						 FROM dt_liq_unixespacio,   
								dt_trazosxoc,
								h_base_trazos
						WHERE ( dt_liq_unixespacio.cs_orden_corte 			= dt_trazosxoc.cs_orden_corte ) and  
								( dt_liq_unixespacio.cs_agrupacion 				= dt_trazosxoc.cs_agrupacion ) and  
								( dt_liq_unixespacio.cs_base_trazos 			= dt_trazosxoc.cs_base_trazos ) and  
								( dt_liq_unixespacio.cs_trazo 					= dt_trazosxoc.cs_trazo ) and  
								( dt_liq_unixespacio.cs_seccion 					= dt_trazosxoc.cs_seccion ) and  
								( dt_liq_unixespacio.cs_pdn 						= dt_trazosxoc.cs_pdn ) and  
								( 	( dt_liq_unixespacio.cs_orden_corte 		= :ll_cs_orden_corte ) AND  
								( dt_liq_unixespacio.cs_agrupacion 				= :li_cs_agrupacion ) AND  
								( dt_liq_unixespacio.cs_trazo 					= :li_espacio_ciclo ) AND  
								( dt_trazosxoc.cs_sec_ext 							= :li_seccion_ciclo ) AND  
								( dt_liq_unixespacio.co_talla 					= :li_talla_ciclo )   ) AND
								( h_base_trazos.cs_agrupacion						= dt_liq_unixespacio.cs_agrupacion ) AND
								( h_base_trazos.cs_base_trazos					= dt_liq_unixespacio.cs_base_trazos ) and
								( h_base_trazos.raya 								= :li_raya ) 
								order by dt_trazosxoc.cs_ordenpdn ;
						
					open cur_liquida;
					
					fetch cur_liquida INTO :li_cs_pdn_liquida,:li_capas_liquida,:li_cs_ordenpdn,:li_raya2 ;
						
					do while sqlca.sqlcode=0
						
						ldt_fe_creacion = f_fecha_servidor()
						ldt_fe_actualizacion = ldt_fe_creacion
						
						ls_find = "cs_orden_corte = " +String(ll_cs_orden_corte)+" and cs_agrupacion = "+String(li_cs_agrupacion) &
						          +" and cs_base_trazos = "+String(li_raya2)+" and cs_espacio = "+String(li_espacio_ciclo) &
									 +" and cs_sec_ext = "+String(li_seccion_ciclo)+" and co_talla = "+String(li_talla_ciclo) &
									 +" and cs_pdn = "+String(li_cs_pdn_liquida)+ " and letra = '"+ls_letra+"'"+" and tipo = "+String(li_tipo)
												
						ll_found = lds_imp.Find(ls_find,1,lds_imp.RowCount())
						
						IF ll_found = 0 THEN
							li_impresion = 0
						ELSE
							li_impresion = lds_imp.GetItemNumber(ll_found,'sw_impresion')
						END IF	
												
						INSERT INTO t_guias_num_prog  
						( cs_orden_corte,					cs_agrupacion,   			cs_base_trazos,   			cs_espacio,   
						  cs_sec_ext,   					co_talla,   				cs_pdn,   						letra,   
						  tipo,   							codigo_barras,   			ca_paquetes,   				capas,   
						  valor_inicial,   				valor_final,   			fe_creacion,   				fe_actualizacion,   
						  usuario,   						instancia,   				ca_liquidada,   				ca_loteada,   
						  cs_orden,							sw_impresion )  
						VALUES ( 
						  :ll_cs_orden_corte,   		:li_cs_agrupacion,   	:li_raya2,   					:li_espacio_ciclo,   
						  :li_seccion_ciclo,   			:li_talla_ciclo,   		:li_cs_pdn_liquida,   		:ls_letra,   
						  :li_tipo,   						0,   							:li_paquete_ciclo,   		:li_capas_liquida,   
						  1,   								1,   							:ldt_fe_creacion,   			:ldt_fe_actualizacion,   
						  user,   							sitename,   				0,   								0,   
						  :li_cs_orden,					:li_impresion )  ;
					
						if sqlca.sqlcode=-1 then
							rollback;
							messagebox("error bd","no pudo insertar en tabla de guias, ERROR: "+sqlca.sqlerrtext)
							return
						end if
						
						fetch cur_liquida INTO :li_cs_pdn_liquida,:li_capas_liquida,:li_cs_ordenpdn,:li_raya2 ;
					loop
			
					close cur_liquida;
				end if
			next
		end if
		

	next
else
	messagebox("Advertencia","no hay datos")
	return
end if

Commit;
	
//genera la numeracion
ll_result = lds_sort.retrieve(ll_cs_orden_corte,li_raya2)
If ll_result > 0 Then
		ll_inicio = 1
		ll_fin = 0
		ll_tra = lds_sort.GetItemNumber(1,'cs_espacio')
		ll_talla1 = lds_sort.GetItemNumber(1,'co_talla')
		li_fab1 = lds_sort.GetItemNumber(1,'co_fabrica_pt')
		li_lin1 = lds_sort.GetItemNumber(1,'co_linea')
		ll_ref1 = lds_sort.GetItemNumber(1,'co_referencia')
		ll_pdn1 = lds_sort.GetItemNumber(1,'cs_pdn')
End if
			
For ll_i = 1 To ll_result
		ll_ord 	= lds_sort.GetItemNumber(ll_i,'cs_orden_corte')
		ll_agr 	= lds_sort.GetItemNumber(ll_i,'cs_agrupacion')
		ll_bas 	= lds_sort.GetItemNumber(ll_i,'cs_base_trazos')
		ll_esp 	= lds_sort.GetItemNumber(ll_i,'cs_espacio')
		ll_sec 	= lds_sort.GetItemNumber(ll_i,'cs_sec_ext')
		ll_tal 	= lds_sort.GetItemNumber(ll_i,'co_talla')
		ll_pdn 	= lds_sort.GetItemNumber(ll_i,'cs_pdn')
		ls_let 	= lds_sort.GetItemString(ll_i,'letra')
		ll_capa 	= lds_sort.GetItemNumber(ll_i,'capas')	
		li_fabrica	= lds_sort.GetItemNumber(ll_i,'co_fabrica_pt')
		li_linea		= lds_sort.GetItemNumber(ll_i,'co_linea')
		ll_referencia	= lds_sort.GetItemNumber(ll_i,'co_referencia')
		
		If ll_talla1 <> ll_tal OR li_fab1 <> li_fabrica OR li_lin1 <> li_linea OR ll_ref1 <> ll_referencia Then

			ll_inicio = 0
			ll_fin = 0
			ll_talla1 = ll_tal
			li_fab1 = li_fabrica
			li_lin1 = li_linea
			ll_ref1 = ll_referencia
			ll_pdn1 = ll_pdn
			
			select max(valor_final)  
			  into :ll_finfd  
			  from t_guias_num_prog  
			 where cs_orden_corte 	= :ll_cs_orden_corte and
					cs_base_trazos 	= :li_raya2 and
					co_talla 			= :ll_tal and
					cs_pdn				= :ll_pdn;
			
				If Sqlca.SqlCode = -1 Then
					ls_sqlerr = Sqlca.SqlErrText
					Rollback ;
					MessageBox("Advertencia!","No se pudo buscar la cantidad final de la talla.~n~n~n" + ls_sqlerr)
					Return
				ElseIf IsNull(ll_finfd) Or ll_finfd = 0 Then
					ll_inicio = 1
					ll_fin    = ll_capa
				Else
					If ll_finfd = 1 Then ll_finfd = 0
					ll_inicio 	= ll_finfd + 1
					ll_fin    	= ll_finfd + ll_capa
				End if
		Else
			ll_inicio = ll_fin + 1
			ll_fin 	 += ll_capa
			
		End If
			
			update t_guias_num_prog  
			  set valor_inicial 	= :ll_inicio,   
					valor_final 	= :ll_fin
			where	cs_orden_corte = :ll_ord and
					cs_agrupacion 	= :ll_agr and
					cs_base_trazos = :ll_bas and
					cs_sec_ext 		= :ll_sec and
					co_talla 		= :ll_tal and
					cs_pdn 			= :ll_pdn and
					letra 			= :ls_let and
					cs_espacio     = :ll_esp;
			if sqlca.sqlcode=-1 then
				ls_sqlerr = Sqlca.SqlErrText
				Rollback ;
				MessageBox("Advertencia!","No se pudo buscar la cantidad final de la talla.~n~n~n" + ls_sqlerr)
				Return
			else
			end if
Next
//end if //ll_cs_orden_corte <> 26295	
//antes de salir
Commit;

Destroy lds_num
Destroy lds_sort
Destroy lds_imp
//sle_espacio

dw_reporte.SetTransObject(sqlca)
dw_criterio.SetTransObject(sqlca)
dw_adhesivo.SetTransObject(sqlca)
dw_adhesivos_orden.SetTransObject(sqlca)


dw_reporte.Retrieve(ll_cs_orden_corte,li_raya2,li_cs_espacio,li_tipo)
dw_adhesivo.Retrieve(ll_cs_orden_corte,li_raya2,li_cs_espacio)

If li_tipo = 1 Then
	cb_adhesivos.Enabled = False
Elseif li_tipo = 2 Then
	cb_adhesivos.Enabled = True
End if

DISCONNECT USING itr_tela ;
IF itr_tela.SQLCODE = -1 THEN
   MessageBox("ERROR....","La desconexi$$HEX1$$f300$$ENDHEX$$n para abrir esta ventana (dr)" +sqlca.sqlerrtext,Stopsign!,OK!)
   Return
END IF


end event

type cb_adhesivos from commandbutton within w_reporte_guias_numeracion
integer x = 2277
integer y = 32
integer width = 425
integer height = 92
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "Adhesivos Bolsas"
end type

event clicked;long  ll_hallados, ll_fila, respuesta,ll_llamar,ll_cs_bolsa, ll_co_fabrica_pt,ll_co_linea,ll_co_referencia,ll_co_talla,ll_cs_base_trazos
long ll_cs_orden_corte,ll_cs_espacio,ll_cantidad, ll_cs_pdn, ll_cs_agrupacion, ll_seccion, ll_cs_sec_ext, ll_co_color_pt
Long li_tipo, li_marca_imp, li_co_fab_propiet, li_result
String ls_de_talla,ls_de_referencia,ls_capas,ls_numeracion, ls_seccion, ls_mensaje
string ls_lote, ls_grupo,ls_letra,ls_cs_orden_corte,ls_cs_espacio,ls_cs_bolsa,ls_bolsa_guardada,ls_po,ls_cut
n_cst_loteo_bongo luo_loteo
n_cst_bolsa luo_corte
ll_fila=1

dw_adhesivo.SetTransobject(SQLCA)
dw_adbolsa.SetTransobject(SQLCA)
dw_adhesivo_partes.SetTransobject(SQLCA)
ll_hallados =dw_adhesivo.RowCount()
li_tipo=dw_criterio.getitemnumber(1,"tipo")

IF li_tipo = 2 THEN
	respuesta = MessageBox("Advertencia", 'Desea Imprimir Adhesivos. ',Exclamation!, YesNo!, 2)
	IF respuesta = 1 AND ll_hallados > 0  THEN
		
		ll_cs_sec_ext = dw_adhesivo.GetitemNumber(1,"cs_sec_ext")
		IF ll_cs_sec_ext = 0 THEN
			Rollback;
			MessageBox('Advertencia','Falta el criterio de ordenaci$$HEX1$$f300$$ENDHEX$$n de extendido.')
			Return
		End if
		
		FOR ll_fila = 1 TO  ll_hallados
			 ls_de_talla 			= dw_adhesivo.GetitemString(ll_fila,"de_talla")
			 ls_de_referencia		= dw_adhesivo.GetitemString(ll_fila,"de_referencia")
			 ls_capas 				= String(dw_adhesivo.GetitemNumber(ll_fila,"capas"))
			 ll_cantidad 			= dw_adhesivo.GetitemNumber(ll_fila,"capas")
			 ls_numeracion 		= string(dw_adhesivo.Getitemnumber(ll_fila,"valor_inicial")) +" AL " + string(dw_adhesivo.Getitemnumber(ll_fila,"valor_final"))
			 ls_lote 				= string(dw_adhesivo.GetitemString(ll_fila,"lote"))
			 ls_cs_orden_corte 	= String(dw_adhesivo.GetitemNumber(ll_fila,"cs_orden_corte"))
			 ll_cs_orden_corte 	= dw_adhesivo.GetitemNumber(ll_fila,"cs_orden_corte")
			 ls_letra 				= string(dw_adhesivo.GetitemString(ll_fila,"letra"))
			 ls_cs_espacio 		= String(dw_adhesivo.GetitemNumber(ll_fila,"cs_espacio"))
			 ll_cs_espacio 		= dw_adhesivo.GetitemNumber(ll_fila,"cs_espacio")
			 ll_cs_pdn 				= dw_adhesivo.GetitemNumber(ll_fila,"cs_pdn")
			 ll_cs_agrupacion 	= dw_adhesivo.GetitemNumber(ll_fila,"cs_agrupacion")
			 ll_co_fabrica_pt 	= dw_adhesivo.GetitemNumber(ll_fila,"co_fabrica_pt")
			 ll_co_linea 			= dw_adhesivo.GetitemNumber(ll_fila,"co_linea")
			 ll_co_referencia 	= dw_adhesivo.GetitemNumber(ll_fila,"co_referencia")
			 ll_co_talla 			= dw_adhesivo.GetitemNumber(ll_fila,"co_talla")
			 ll_co_color_pt 		= dw_adhesivo.GetitemNumber(ll_fila,"dt_agrupa_pdn_co_color_pt")
			 ls_bolsa_guardada 	= " "
			 ls_po					= dw_adhesivo.GetitemString(ll_fila,'po')
			 ls_cut					= dw_adhesivo.GetitemString(ll_fila,'nu_cut')
 			 li_co_fab_propiet	= dw_adhesivo.GetitemNumber(ll_fila,"co_fab_propietario")
			 ls_grupo 				= 'SIN GRUPO'

			//*********************************************inicio*******************************************
			//se verifica que la orden de corte no se encuentre loteada, modificacion pedida por Carlos Posada
			//noviembre de 2005, realizada por Juan Carlos Restrepo Medina
			IF luo_loteo.of_validar_oc_loteada(ll_cs_orden_corte,ll_co_fabrica_pt,ll_co_linea,ll_co_referencia) = -1 THEN
				MessageBox('Error','La orden de corte ya fue loteada.')
				Return 
			END IF
			//fin modificacion 
			//***********************************************fin********************************************* 
			 IF ll_cantidad > 0 THEN
				CHOOSE CASE f_validar_existencia_bolsa(ll_cs_orden_corte,ll_cs_espacio,ll_co_talla,trim(ls_letra),ll_co_referencia, ll_cs_pdn, ls_bolsa_guardada)
					CASE 1
						// existen bolsas creadas y debo actualizar los datos
						//*********esto quiere decir que la bolsa ya fue impresa una vez, por lo tanto se debe bloquear
						//el intento de impresion hasta verificar que el usuario tiene habilitada la opcion
						//para reimprimir.
						
//						IF ii_impresion = 1 THEN
							//coloco marca para saber que se trata de una reimpresion
//							li_marca_imp = 1
													
							UPDATE dt_canasta_corte
							SET	//ca_actual = :ll_cantidad,
									usuario = User,
									fe_actualizacion = Current,
									instancia = SiteName
							WHERE cs_canasta = :ls_bolsa_guardada;
							IF SQLCA.SQLCode = -1 THEN
								MessageBox("Error Base Datos","Error al actualizar la cantidad de la bolsa")
								ROLLBACK;
							ELSE
								COMMIT;
							END IF	
//						ELSE
//							MessageBox('Advertencia','Los adhesivos ya fueron impresos, debe activar el permiso de reimpresi$$HEX1$$f300$$ENDHEX$$n.')
//							Return
//						END IF
					CASE 0
						// No existe la bolsa se debe crear	
						DO WHILE TRUE
							
							ll_cs_bolsa = f_crear_bolsa()
							ii_reimpresion = 0
							IF ll_cs_bolsa = -1 THEN Return
							ls_cs_bolsa = string(ll_cs_bolsa)
							ll_llamar = f_crea_cabecera_bolsa(ll_cs_bolsa,trim(ls_grupo),trim(ls_lote),li_co_fab_propiet)
							IF ll_llamar = -1 THEN Return
							ll_llamar = f_crea_detalle_bolsa(ls_cs_bolsa,ll_co_fabrica_pt,ll_co_linea,ll_co_referencia,ll_co_talla,1, &
												 ll_co_color_pt,ll_cs_orden_corte, ll_cs_espacio,1,ll_cantidad,trim(ls_letra),ll_cs_pdn,&
												 ll_cs_agrupacion,ls_po,ls_cut,ls_grupo)
							IF ll_llamar = -1 THEN Return
							IF ll_llamar = 0 THEN Exit
							
						
						LOOP
						IF ll_llamar = -1 THEN Return
					CASE -1
						Return
				END CHOOSE
			END IF
		NEXT
		
		//es una reimpresion y controlo que se pueda llevar bitacora de esta	
		//se coloca en comentario por problemas de lentitud de la maquina agosto 22 07   jorodrig -  jcrestme
//		IF li_marca_imp = 1 THEN
//			IF of_control_reimpresion(ll_cs_orden_corte,ll_hallados,1) = -1 THEN
//				Return
//			END IF
//		END IF
		ll_cs_base_trazos = dw_adhesivo.GetitemNumber(1,"cs_base_trazos")
		ll_cs_espacio=Long(sle_espacio.text)		
		dw_adbolsa.Retrieve(ll_cs_orden_corte,ll_cs_base_trazos,ll_cs_espacio,ll_seccion)
		ll_hallados =dw_adbolsa.RowCount()
		//si la orden de corte se corta en la calle no se imprimen los adhesivos, a menos que el usuario
		//desee imprimirlos
		//return 92, esto se hace a peticion de Edwin Serna
		//jcrm
		//mayo 2 de 2008
		li_result = luo_corte.of_validar_centro_corte(ll_cs_orden_corte,ls_mensaje)
		IF li_result = 92 THEN
			li_result = MessageBox('Pregunta','Orden cortada en terceros, desea imprimir adhesivos de bolsas. ',Exclamation!, YesNo!, 2)
			IF li_result = 1 THEN
				dw_adbolsa.print()
			END IF
		ELSE		
			dw_adbolsa.print()
			//ya se imprimio se debe actualizar sw_impresion en t_guias_num_prog
		END IF
	END IF
ELSE
	MessageBox("Advertencia...","El estado seleccionado no permite generar los adhesivos",StopSign!)
END IF


end event

type sle_espacio from singlelineedit within w_reporte_guias_numeracion
integer x = 1801
integer y = 44
integer width = 169
integer height = 72
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
string text = "0"
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within w_reporte_guias_numeracion
integer x = 1536
integer y = 48
integer width = 251
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Espacio:"
boolean focusrectangle = false
end type

type cb_ordenar from commandbutton within w_reporte_guias_numeracion
boolean visible = false
integer x = 1650
integer y = 156
integer width = 55
integer height = 48
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "Ordenar"
end type

event clicked;Long ll_orden,ll_raya,ll_espacio,ll_tipo

s_base_parametros lstr_parametros

ll_espacio	=Long(sle_espacio.TEXT)
ll_orden = dw_criterio.GetItemNumber(1,'ordencorte')
ll_raya = dw_criterio.GetItemNumber(1,'raya')
ll_tipo = dw_criterio.GetItemNumber(1,'tipo')

lstr_parametros.entero[1] = ll_orden
lstr_parametros.entero[2] = ll_raya

OpenWithParm(w_par_sort_guias_numeracion,lstr_parametros)

dw_reporte.Retrieve(ll_orden,ll_raya,ll_espacio,ll_tipo)
end event

type cb_partes from commandbutton within w_reporte_guias_numeracion
integer x = 2711
integer y = 32
integer width = 503
integer height = 92
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "Adhesivos Partes"
end type

event clicked;long  ll_hallados, ll_fila, respuesta,ll_llamar,ll_cs_bolsa, ll_co_fabrica_pt,ll_co_linea,ll_co_referencia,ll_co_talla,ll_cs_base_trazos
long ll_cs_orden_corte,ll_cs_espacio,ll_cantidad, ll_cs_pdn, ll_cs_agrupacion, ll_co_color_pt
Long li_tipo, li_reimpresion, li_marca_imp, li_raya, li_result
String ls_de_talla,ls_de_referencia,ls_capas,ls_numeracion, ls_mensaje
string ls_lote, ls_grupo,ls_letra,ls_cs_orden_corte,ls_cs_espacio,ls_cs_bolsa,ls_bolsa_guardada
n_cst_loteo_bongo luo_loteo
n_cst_bolsa luo_corte
ll_fila=1

dw_adhesivo.SetTransobject(SQLCA)
dw_adbolsa.SetTransobject(SQLCA)
dw_adhesivo_partes.SetTransobject(SQLCA)
dw_adhesivos_partes_ant.SetTransobject(SQLCA)
ll_hallados =dw_adhesivo.RowCount()

dw_criterio.AcceptText()

li_tipo=dw_criterio.getitemnumber(1,"tipo")
li_raya = dw_criterio.GetItemNumber(1,'modelo')

IF IsNull(li_raya) THEN
	MessageBox('Error','Debe ingresar la raya.',StopSign!)
	Return
END IF

IF li_tipo = 2 THEN
	respuesta = MessageBox("Advertencia", 'Desea Imprimir Adhesivos Partes de Prenda',Exclamation!, YesNo!, 2)
	IF respuesta = 1 AND ll_hallados > 0  THEN
		ls_de_talla 			= dw_adhesivo.GetitemString(ll_fila,"de_talla")
		ls_de_referencia		= dw_adhesivo.GetitemString(ll_fila,"de_referencia")
		ls_capas 				= String(dw_adhesivo.GetitemNumber(ll_fila,"capas"))
		ll_cantidad 			= dw_adhesivo.GetitemNumber(ll_fila,"capas")
		ls_numeracion 			= string(dw_adhesivo.Getitemnumber(ll_fila,"valor_inicial")) +" AL " + string(dw_adhesivo.Getitemnumber(ll_fila,"valor_final"))
		ls_lote 					= string(dw_adhesivo.GetitemString(ll_fila,"lote"))
		ls_cs_orden_corte 	= String(dw_adhesivo.GetitemNumber(ll_fila,"cs_orden_corte"))
		ll_cs_orden_corte 	= dw_adhesivo.GetitemNumber(ll_fila,"cs_orden_corte")
		ls_letra 				= string(dw_adhesivo.GetitemString(ll_fila,"letra"))
		ls_cs_espacio 			= String(dw_adhesivo.GetitemNumber(ll_fila,"cs_espacio"))
		ll_cs_espacio 			= dw_adhesivo.GetitemNumber(ll_fila,"cs_espacio")
		ll_cs_pdn 				= dw_adhesivo.GetitemNumber(ll_fila,"cs_pdn")
		ll_cs_agrupacion 		= dw_adhesivo.GetitemNumber(ll_fila,"cs_agrupacion")
		ll_co_fabrica_pt 		= dw_adhesivo.GetitemNumber(ll_fila,"co_fabrica_pt")
		ll_co_linea 			= dw_adhesivo.GetitemNumber(ll_fila,"co_linea")
		ll_co_referencia 		= dw_adhesivo.GetitemNumber(ll_fila,"co_referencia")
		ll_co_talla 			= dw_adhesivo.GetitemNumber(ll_fila,"co_talla")
		ll_co_color_pt 		= dw_adhesivo.GetitemNumber(ll_fila,"dt_agrupa_pdn_co_color_pt")
		ll_cs_base_trazos 	= dw_adhesivo.GetitemNumber(1,"cs_base_trazos")
		
		//*********************************************inicio*******************************************
		//se verifica que la orden de corte no se encuentre loteada, modificacion pedida por Carlos Posada
		//noviembre de 2005, realizada por Juan Carlos Restrepo Medina
//		IF luo_loteo.of_validar_oc_loteada(ll_cs_orden_corte,ll_co_fabrica_pt,ll_co_linea,ll_co_referencia) = -1 THEN
//			MessageBox('Error','La orden de corte ya fue loteada.')
//			Return 
//		END IF
//		//fin modificacion 
		//***********************************************fin********************************************* 
		
		
		//debemos saber si se trata de una reimpresion
//		li_reimpresion = dw_adhesivo.GetItemNumber(ll_fila,'sw_impresion')
//		
//		IF li_reimpresion = 0 THEN
//			//no hacemos nada ya que se trata de la primera vez que imprimen estas partes
//		ELSE
//			//se trata de una reimpresion
//			IF ii_impresion = 1 THEN
//				li_marca_imp = 1
//			ELSE
//				MessageBox('Advertencia','Los adhesivos ya fueron impresos, debe activar el permiso de reimpresi$$HEX1$$f300$$ENDHEX$$n.')
//				Return
//			END IF
//		END IF
		
		// Reporte de adhesivos de partes de prenda
		ll_cs_espacio=Long(sle_espacio.text)		
		IF dw_adhesivo_partes.Retrieve(ll_cs_orden_corte, ll_cs_base_trazos, ll_cs_espacio, 0, " ",li_raya, gstr_info_usuario.codigo_usuario) > 0 THEN
			ll_hallados =dw_adhesivo_partes.RowCount()
			//si se trata de reimpresion se cdontrola esta antes dce imprimir
			IF li_marca_imp = 1 THEN
				IF of_control_reimpresion(ll_cs_orden_corte,ll_hallados,2) = -1 THEN
					Return
				END IF
			END IF
			li_result = luo_corte.of_validar_centro_corte(ll_cs_orden_corte,ls_mensaje)
			IF li_result = 92 THEN
				li_result = MessageBox('Advertencia','Orden cortada en terceros, desea generar adhesivos de partes. ',Exclamation!, YesNo!,2)
				IF li_result = 1 THEN
					dw_adhesivo_partes.print()
				END IF
			ELSE			
			   dw_adhesivo_partes.print()
			END IF
			//ya se imprimio se debe actualizar sw_impresion en t_guias_num_prog
			of_actualizar_guias(ll_cs_orden_corte,ll_cs_espacio)
		ELSE 
			messagebox('Advertencia','Por favor comunicarse con ficha t$$HEX1$$e900$$ENDHEX$$cnica para ingresar las partes de la referencia '+String(ll_co_referencia)+' '+String(ls_de_referencia)) 
//			dw_adhesivo_partes.Retrieve(ll_cs_orden_corte, ll_cs_base_trazos, ll_cs_espacio, 0, " ",li_raya, gstr_info_usuario.codigo_usuario)
			//si se trata de reimpresion se cdontrola esta antes dce imprimir
//			IF li_marca_imp = 1 THEN
//				IF of_control_reimpresion(ll_cs_orden_corte,ll_hallados,2) = -1 THEN
//					Return
//				END IF
//			END IF
//			li_result = luo_corte.of_validar_centro_corte(ll_cs_orden_corte,ls_mensaje)
//			IF li_result = 92 THEN
//				li_result = MessageBox('Advertencia','Orden cortada en terceros, desea generar adhesivos de partes. ',Exclamation!, YesNo!,2)
//				IF li_result = 1 THEN
//					dw_adhesivo_partes.print()
//				END IF
//			ELSE		
//				dw_adhesivo_partes.print()
//			END IF
			//ya se imprimio se debe actualizar sw_impresion en t_guias_num_prog
//			of_actualizar_guias(ll_cs_orden_corte,ll_cs_espacio)
		END IF
	END IF
ELSE
	MessageBox("Advertencia...","El estado seleccionado no permite generar los adhesivos",Exclamation!)
END IF

end event

type dw_adhesivo from datawindow within w_reporte_guias_numeracion
boolean visible = false
integer x = 1545
integer y = 132
integer width = 64
integer height = 92
string title = "none"
string dataobject = "d_reporte_numeracion"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cb_otras_rayas from commandbutton within w_reporte_guias_numeracion
boolean visible = false
integer x = 613
integer y = 136
integer width = 462
integer height = 92
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
boolean enabled = false
string text = "Adhes. Otras rayas"
end type

event clicked;long  ll_hallados, ll_fila, respuesta,ll_llamar,ll_cs_bolsa, ll_co_fabrica_pt,ll_co_linea,ll_co_referencia,ll_co_talla,ll_cs_base_trazos
long ll_cs_orden_corte,ll_cs_espacio,ll_cantidad, ll_cs_pdn, ll_cs_agrupacion, ll_co_color_pt

String ls_de_talla,ls_de_referencia,ls_capas,ls_numeracion
string ls_lote, ls_grupo,ls_letra,ls_cs_orden_corte,ls_cs_espacio,ls_cs_bolsa,ls_bolsa_guardada
ll_fila=1

dw_adhesivo.SetTransobject(SQLCA)
dw_adbolsa.SetTransobject(SQLCA)
dw_otras_rayas.SetTransobject(SQLCA)
ll_hallados =dw_adhesivo.RowCount()

respuesta = MessageBox("Advertencia", 'Desea Imprimir Adhesivos Otras Rayas',Exclamation!, YesNo!, 2)
IF respuesta = 1 AND ll_hallados > 0  THEN
	ls_de_talla = dw_adhesivo.GetitemString(ll_fila,"de_talla")
	ls_de_referencia= dw_adhesivo.GetitemString(ll_fila,"de_referencia")
   ls_capas =String(dw_adhesivo.GetitemNumber(ll_fila,"capas"))
	ll_cantidad =dw_adhesivo.GetitemNumber(ll_fila,"capas")
	ls_numeracion = string(dw_adhesivo.Getitemnumber(ll_fila,"valor_inicial")) +" AL " + string(dw_adhesivo.Getitemnumber(ll_fila,"valor_final"))
	ls_lote = string(dw_adhesivo.GetitemString(ll_fila,"lote"))
	ls_cs_orden_corte = String(dw_adhesivo.GetitemNumber(ll_fila,"cs_orden_corte"))
	ll_cs_orden_corte = dw_adhesivo.GetitemNumber(ll_fila,"cs_orden_corte")
	ls_grupo    = string(dw_adhesivo.GetitemString(ll_fila,"gpa"))
	ls_letra = string(dw_adhesivo.GetitemString(ll_fila,"letra"))
	ls_cs_espacio = String(dw_adhesivo.GetitemNumber(ll_fila,"cs_espacio"))
	ll_cs_espacio = dw_adhesivo.GetitemNumber(ll_fila,"cs_espacio")
	ll_cs_pdn = dw_adhesivo.GetitemNumber(ll_fila,"cs_pdn")
	ll_cs_agrupacion = dw_adhesivo.GetitemNumber(ll_fila,"cs_agrupacion")
	ll_co_fabrica_pt = dw_adhesivo.GetitemNumber(ll_fila,"co_fabrica_pt")
 	ll_co_linea = dw_adhesivo.GetitemNumber(ll_fila,"co_linea")
 	ll_co_referencia = dw_adhesivo.GetitemNumber(ll_fila,"co_referencia")
	ll_co_talla = dw_adhesivo.GetitemNumber(ll_fila,"co_talla")
	ll_co_color_pt = dw_adhesivo.GetitemNumber(ll_fila,"dt_agrupa_pdn_co_color_pt")
   ll_cs_base_trazos = dw_adhesivo.GetitemNumber(1,"cs_base_trazos")
	// Reporte de adhesivos de otras rayas
	dw_otras_rayas.Retrieve(ll_cs_orden_corte,ll_cs_base_trazos,ll_cs_espacio)
	ll_hallados =dw_otras_rayas.RowCount()
	dw_otras_rayas.print()	
END IF

end event

type dw_otras_rayas from datawindow within w_reporte_guias_numeracion
boolean visible = false
integer x = 1358
integer y = 132
integer width = 64
integer height = 92
integer taborder = 60
boolean bringtotop = true
string title = "none"
string dataobject = "dtb_adhesivo_partes_prenda_otras_rayas"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_adbolsa from datawindow within w_reporte_guias_numeracion
boolean visible = false
integer x = 1449
integer y = 132
integer width = 64
integer height = 92
integer taborder = 30
boolean bringtotop = true
string title = "none"
string dataobject = "dtb_adhesivo_bolsas"
borderstyle borderstyle = stylelowered!
end type

type dw_adhesivo_partes from datawindow within w_reporte_guias_numeracion
boolean visible = false
integer x = 1088
integer y = 132
integer width = 64
integer height = 92
integer taborder = 30
boolean bringtotop = true
string title = "none"
string dataobject = "dtb_adhesivo_partes_prenda_final"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_adhesivos_orden from datawindow within w_reporte_guias_numeracion
boolean visible = false
integer x = 1271
integer y = 132
integer width = 64
integer height = 92
integer taborder = 70
boolean bringtotop = true
string title = "none"
string dataobject = "dtb_adhesivos_partes_ordencorte"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cb_partes_oc from commandbutton within w_reporte_guias_numeracion
integer x = 2711
integer y = 132
integer width = 503
integer height = 92
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "Adhesivos Partes OC"
end type

event clicked;long ll_cs_orden_corte, ll_fila
Long li_respuesta, li_tipo
String	ls_password,ls_password_ingresado, ls_password2
s_base_parametros lstr_parametros
n_cts_constantes_corte lpo_const_corte

ll_fila=1

li_tipo=dw_criterio.getitemnumber(1,"tipo")


//por solicitud de JAvier Garcia Agosto 26 2010 no se deja reimprimir adhesivos de sesgos para evitar errores en la lectura
//se coloca que cuando crea la bolsa pone la bandera ii_reimpresion = 0, de lo contrario esta en 1, realiza jorodrig
IF ii_reimpresion = 1 THEN
	MessageBox('Advertencia','Solo personal Autorizado puede reimprimir adhesivos.')
	ls_password = Trim(lpo_const_corte.of_consultar_texto('PASSWORD REIMPRIMIR ADHESIVO'))
	ls_password2 = Trim(lpo_const_corte.of_consultar_texto('PASSWORD REIMPRIMIR ADHESIVO_NICOL'))
	
	//abro ventana para pedir password de autorizaci$$HEX1$$f300$$ENDHEX$$n
	Open(w_password_trazos)
	lstr_parametros = message.PowerObjectParm
	
	If lstr_parametros.hay_parametros = true Then
		ls_password_ingresado = Trim(lstr_parametros.cadena[1])
					
		If (ls_password_ingresado = ls_password) OR (ls_password_ingresado = ls_password2) Then
		Else
			MessageBox('Error','Password, no valido.')
			Return 2
		End if
	Else
		Return 2
	End if
END IF
//fin control jorodrig agosto 26 - 2010


IF li_tipo = 2 THEN
	li_respuesta = MessageBox("Advertencia", 'Desea Imprimir Adhesivos Partes de Prenda de Orden Corte',Exclamation!, YesNo!, 2)
	IF li_respuesta = 1 THEN
		ll_cs_orden_corte = dw_adhesivo.GetitemNumber(ll_fila,"cs_orden_corte")
		dw_adhesivos_orden.Retrieve(ll_cs_orden_corte)
		dw_adhesivos_orden.Print()
	END IF
ELSE
	MessageBox("Advertencia...","El estado seleccionado no permite generar los adhesivos")	
END IF

end event

type dw_adhesivos_partes_ant from datawindow within w_reporte_guias_numeracion
boolean visible = false
integer x = 1157
integer y = 132
integer width = 64
integer height = 92
integer taborder = 70
boolean bringtotop = true
string title = "none"
string dataobject = "dtb_adhesivo_partes_prenda"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cb_1 from commandbutton within w_reporte_guias_numeracion
boolean visible = false
integer x = 50
integer y = 124
integer width = 503
integer height = 92
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Adhesivos Sesgos"
end type

event clicked;Long ll_ordencorte, ll_agrupacion, ll_referencia
Long li_fabrica, li_linea, li_registros
String ls_error

dw_criterio.AcceptText()

ll_ordencorte =dw_criterio.GetItemNumber(1,"ordencorte")

If IsNull(ll_ordencorte) Then
	MessageBox('Advertencia','Debe Ingresar una orden de corte.',StopSign!)
	Return
End if

SELECT DISTINCT cs_agrupacion
  INTO :ll_agrupacion
  FROM dt_trazosxoc
 WHERE cs_orden_corte = :ll_ordencorte;
 
IF sqlca.sqlcode = -1 Then
	ls_error = sqlca.sqlerrtext
	Rollback;
	MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de identificar la agrupaci$$HEX1$$f300$$ENDHEX$$n, ERROR: ' +ls_error)
	Return
End if

IF sqlca.sqlcode = 100 Then
	MessageBox('Error','La orden de corte no es valida, por favor verifique sus datos.')
	Return
End if

SELECT DISTINCT co_fabrica,
		 co_linea,
		 co_referencia
  INTO :li_fabrica,
  		 :li_linea,
		 :ll_referencia
  FROM dt_kamban_corte
 WHERE cs_orden_corte = :ll_ordencorte;
 
IF sqlca.sqlcode = -1 Then
	ls_error = sqlca.sqlerrtext
	Rollback;
	MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de identificar los datos de la orden de corte, ERROR: ' +ls_error)
	Return
End if


li_registros = dw_1.Retrieve(li_fabrica, li_linea, ll_referencia, ll_agrupacion, ll_ordencorte )
If li_registros > 0 Then
	dw_1.Print()
Else
	MessageBox('Advertencia','No se generaron adhesivos de sesgos. ', Exclamation!)
End if

end event

type dw_1 from datawindow within w_reporte_guias_numeracion
boolean visible = false
integer x = 1728
integer y = 132
integer width = 64
integer height = 92
integer taborder = 30
boolean bringtotop = true
string title = "none"
string dataobject = "dtb_adhesivos_partes_ordencorte_osw"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cb_2 from commandbutton within w_reporte_guias_numeracion
integer x = 3323
integer y = 144
integer width = 73
integer height = 80
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
end type

event clicked;long ll_cs_orden_corte, ll_fila
Long li_respuesta, li_tipo

ll_fila=1

li_tipo=dw_criterio.getitemnumber(1,"tipo")

IF li_tipo = 2 THEN
	li_respuesta = MessageBox("Advertencia", 'Desea Imprimir Adhesivos Partes de Prenda de Orden Corte',Exclamation!, YesNo!, 2)
	IF li_respuesta = 1 THEN
		ll_cs_orden_corte = dw_adhesivo.GetitemNumber(ll_fila,"cs_orden_corte")
		dw_1.Retrieve(ll_cs_orden_corte)
		dw_1.Print()
	END IF
ELSE
	MessageBox("Advertencia...","El estado seleccionado no permite generar los adhesivos")	
END IF

end event

type cb_formato_marcacion_bolsa from commandbutton within w_reporte_guias_numeracion
integer x = 2089
integer y = 132
integer width = 599
integer height = 92
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Formato marcaci$$HEX1$$f300$$ENDHEX$$n bolsa"
end type

event clicked;
Long ll_ordencorte
Long li_raya

dw_criterio.AcceptText()

//toma la orden de corte
ll_ordencorte =dw_criterio.GetItemNumber(1,"ordencorte")

If IsNull(ll_ordencorte) Then
	MessageBox('Advertencia','Debe Ingresar una orden de corte.',StopSign!)
	Return
End if

//toma la raya
li_raya = dw_criterio.GetItemNumber(1,'modelo')

IF IsNull(li_raya) THEN
	MessageBox('Advertencia','Debe ingresar la raya.',StopSign!)
	Return
END IF


dw_reporte.DataObject = 'd_gr_datos_formato_preimpreso_corte'
dw_reporte.SetTransObject(gnv_recursos.of_get_transaccion_sucia())

If dw_reporte.Retrieve(ll_ordencorte, li_raya) > 0 Then
Else
	MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n','No se encontraron datos para la OC ' + String(ll_ordencorte) + ' raya ' + String(li_raya) )
	Return 1
End if

Return 1
end event

type cb_rep_partes from commandbutton within w_reporte_guias_numeracion
integer x = 3223
integer y = 28
integer width = 288
integer height = 100
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Rep Partes"
end type

event clicked;/***********************************************************
SA53209 - Ceiba/JJ - 22-07-2015
Comentario: Se valida que el usuario ingrese la contrase$$HEX1$$f100$$ENDHEX$$a correcta y 
si es correcta genera pergmite generar un reporte con la informacion de 
la orden de corte y la informacion que tiene el codigo de barras con el digito de chequeo 
***********************************************************/
STRING					ls_clave
s_base_parametros		lstr_parametros
n_cst_orden_corte		luo_orden_corte

//Abrir ventana que solicita clave
OPEN(w_password_trazos)
lstr_parametros = message.PowerObjectParm

IF lstr_parametros.hay_parametros = TRUE THEN
	//Toma la clave digitada y valida seguridad
	ls_clave = lstr_parametros.cadena[1]
	IF luo_orden_corte.of_validar_seguridad_oc(ls_clave) THEN
		Try
			//Generarr el reporte 
			wf_GenerarRepParte()
		Catch(Exception le_error)
			MessageBox("Error", le_error.getMessage(), StopSign!)
			Return 
		End try
	ELSE 
		MessageBox('Advertencia','Clave Invalida')
	END IF
ELSE
	//No hay Parametros
END IF

end event

