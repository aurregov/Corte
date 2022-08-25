HA$PBExportHeader$w_seleccionar_espacio_partir_corte.srw
$PBExportComments$Buscar con la oc los espacios que hay y seleccionar uno (jorodrig)
forward
global type w_seleccionar_espacio_partir_corte from w_base_buscar_lista_parametro
end type
type em_capas from editmask within w_seleccionar_espacio_partir_corte
end type
type st_2 from statictext within w_seleccionar_espacio_partir_corte
end type
type em_trazo_seleccion from editmask within w_seleccionar_espacio_partir_corte
end type
type st_3 from statictext within w_seleccionar_espacio_partir_corte
end type
type em_nombre from editmask within w_seleccionar_espacio_partir_corte
end type
end forward

global type w_seleccionar_espacio_partir_corte from w_base_buscar_lista_parametro
string tag = "Partir Espacio Corte"
integer x = 0
integer y = 0
integer width = 3351
integer height = 1404
string title = "Seleccionar Espacio a Partir"
string menuname = "m_partir_espacios"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
windowtype windowtype = main!
event type long ue_partir_espacio ( long al_orden_corte,  long al_agrupacion,  long al_base_trazos,  long ai_cs_trazo,  long ai_seccion,  long al_pdn,  long al_trazo,  long al_capas_partir )
event ue_sacar_rollos ( )
event ue_sacar_capas ( )
event ue_buscar_rollos ( )
em_capas em_capas
st_2 st_2
em_trazo_seleccion em_trazo_seleccion
st_3 st_3
em_nombre em_nombre
end type
global w_seleccionar_espacio_partir_corte w_seleccionar_espacio_partir_corte

type variables
LONG	il_trazo_crear, il_orden_corte, il_trazo, il_base_trazos
LONG	il_agrupacion, il_pdn
Long	ii_seccion, ii_cs_trazo, ii_bandera_capas, ii_bandera_rollos
DECIMAL	id_porcent_util, ld_largo
end variables

forward prototypes
public function long wf_verificar_espacio_liq (long al_orden_corte, long al_agrupacion, long al_base_trazos, long ai_cs_trazo, long ai_cs_seccion, long ai_cs_pdn)
end prototypes

event ue_sacar_rollos(); 
 ii_bandera_rollos = 1
 ii_bandera_capas = 0
 
  em_nombre.text = 'PROCESO DE SACAR ROLLOS DEL ESPACIO'
end event

event ue_sacar_capas(); ii_bandera_capas = 1
 ii_bandera_rollos = 0
 
 em_nombre.text = 'PROCESO DE SACAR CAPAS A NUEVO ESPACIO'
end event

event ue_buscar_rollos();Long ll_filas, ll_filaactual, ll_insertados, ll_referencia, li_raya
Long	ll_mercada, ll_rollo, ll_ordenpd_pt, ll_co_reftel
Long	li_fabrica, li_linea, ll_registros, ll_regactual, li_sacar_rollo
Long	li_pos_inicial,  li_capas_extendidas, li_capas, li_capas_totales_sacar_enteras
Long	li_resta_capas, li_recti1, li_recti2
Decimal	ld_mts_rollo, ld_mts_extendidos, ld_capas_sacar, ld_capas_totales_sacar
s_base_parametros_seleccionar lstr_parametros
s_base_parametros lstr_parametros_retro

//variable de mensaje del correo
String ls_mensaje
//Long li_codigo_email

n_cts_constantes_tela luo_constantes 
//Dbedocal SA 58356-Mejora envio de Correos automaticos aplicativos
uo_correo luo_correo

luo_correo = create uo_correo

String	ls_usuario, ls_nombre, ls_comentario
//mailSession lms_sesion
//mailReturnCode lmrt_retorno
//mailMessage lmsg_mensaje

lstr_parametros_retro.cadena[1]="Procesando ..."
lstr_parametros_retro.cadena[2]="Espere un momento por favor, esta operacion puede durar unos segundos..."
lstr_parametros_retro.cadena[3]="reloj"

ll_filas = dw_lista.RowCount()
ll_insertados = 1
FOR ll_filaactual = 1 TO ll_filas
	IF dw_lista.IsSelected(ll_filaactual) THEN
		ll_insertados = ll_insertados + 1		
		il_orden_corte = dw_lista.GetItemNumber(ll_filaactual, "cs_orden_corte")
		il_trazo = dw_lista.GetItemNumber(ll_filaactual, "co_trazo")
		ii_seccion = dw_lista.GetItemNumber(ll_filaactual, "cs_seccion")
		ii_cs_trazo = dw_lista.GetItemNumber(ll_filaactual, "cs_trazo")
		il_base_trazos = dw_lista.GetItemNumber(ll_filaactual, "cs_base_trazos")
		il_agrupacion = dw_lista.GetItemNumber(ll_filaactual, "cs_agrupacion")
		il_pdn = dw_lista.GetItemNumber(ll_filaactual, "cs_pdn")
		li_fabrica = dw_lista.GetItemNumber(ll_filaactual, "co_fabrica_pt")
		li_linea	= dw_lista.GetItemNumber(ll_filaactual, "co_linea")
		ll_referencia = dw_lista.GetItemNumber(ll_filaactual, "co_referencia")
		ld_largo = dw_lista.GetItemNumber(ll_filaactual, "largo")
		li_capas = dw_lista.GetItemNumber(ll_filaactual, "capas")
		
		//Verificar que no este liquidado el espacio
		IF wf_verificar_espacio_liq(il_orden_corte, il_agrupacion, il_base_trazos, ii_cs_trazo, ii_seccion, il_pdn  ) = 1 THEN
			MessageBox('Advertencia','El espacio seleciconado ya se encuentra liquidado en corte')
			Close(w_retroalimentacion)
			Return
		END IF
		
		//buscar raya de la orden
		SELECT raya
		  INTO :li_raya
		  FROM h_base_trazos
		 WHERE cs_agrupacion = :il_agrupacion
		   AND cs_base_trazos = :il_base_trazos;
		 
		SELECT MAX(cs_mercada)
		  INTO :ll_mercada
		  FROM h_mercada
		 WHERE cs_orden_corte = :il_orden_corte
		   AND co_estado_mercada >= 6;	
			
		//abrir ventana con trazos de la misma referencia
	
		lstr_parametros.entero1[1] = ll_mercada
		lstr_parametros.entero1[2] = li_raya
		
		ld_capas_totales_sacar = 0
		li_resta_capas = 0
		
		OpenWithParm(w_buscar_rollos_x_espacio_x_raya, lstr_parametros)
		lstr_parametros = Message.PowerObjectParm

		IF lstr_parametros.hay_parametros THEN
			ll_registros = lstr_parametros.entero1[1]
		
			FOR ll_regactual = 2 TO ll_registros
           	ll_mercada 				= lstr_parametros.entero1[ll_regactual]
           	ll_rollo 				= lstr_parametros.entero2[ll_regactual]
				li_sacar_rollo 		= lstr_parametros.entero3[ll_regactual]  
				ld_mts_rollo 			= lstr_parametros.decimal1[ll_regactual]  
				ld_mts_extendidos 	= lstr_parametros.decimal2[ll_regactual] 
				IF (li_sacar_rollo = 1) OR (ld_mts_rollo > ld_mts_extendidos) THEN  //el rollo se saca completo
					
					IF MessageBox("Advertencia", "Esta seguro de modificar el espacio con el rollo: " + string(ll_rollo), Question!, YesNo!, 2) = 2 THEN
						messagebox('Cancelo','No modifica el espacio con este rollo')
						//no modifica el espacio con el rollo
					ELSE	
						//realiza la actualizacion
						//este procedimiento saca el rollo o lo modifica, creando uno nuevo con el restante
						DECLARE sp_saca_rollo_esp PROCEDURE FOR
								  pr_saca_rollo_esp(:ll_mercada, :ll_rollo, :li_raya, :ld_mts_rollo, :ld_mts_extendidos, :li_sacar_rollo );
						EXECUTE sp_saca_rollo_esp;
						IF SQLCA.SQLCode = -1 THEN		
							ROLLBACK;
							IF SQLCA.SQLDBCode = -746 THEN
								li_pos_inicial = Pos(SQLCA.SQLErrText, ':', 1)
								MessageBox("Error Base Datos", Mid(SQLCA.SQLErrText, li_pos_inicial + 1, Len(SQLCA.SQLErrText) - (li_pos_inicial + 1)))
								Close(w_retroalimentacion)
								Return;
							ELSE
								MessageBox("Error Base Datos","Error al ejecutar el stored procedure " + SQLCA.SQLErrText)
								Close(w_retroalimentacion)
								Return;
							END IF
						END IF
						
						//Calcular las capas que se dejaron de extender para pasar al procedimiento las 
						//capas reales extendidas 
						li_resta_capas = 1
						IF li_sacar_rollo = 1 THEN
							ld_capas_sacar = ld_mts_rollo  / ld_largo  //son las capas que se dejaron de extender del rollo completo
						ELSE
							ld_capas_sacar = (ld_mts_rollo - ld_mts_extendidos) / ld_largo  //son las capas que se dejaron de extender de la parte del rollo
						END IF
						ld_capas_totales_sacar = ld_capas_totales_sacar + ld_capas_sacar
					END IF
				END IF
			NEXT
			IF li_resta_capas = 1 THEN
				IF ld_capas_totales_sacar > 0 AND ld_capas_totales_sacar < 1 THEN //por si las capas son menores que uno dejo 1
					li_capas_totales_sacar_enteras = 1
				ELSE
					IF ld_capas_totales_sacar  > 1 THEN  //convierto las capas a un valor entrero
						li_capas_totales_sacar_enteras = ld_capas_totales_sacar
					ELSE
						Rollback;
						Close(w_retroalimentacion)
						MessageBox('Advertencia','Las capas que se sacaron son cero, no se procesa nada')
						return
					END IF
				END IF
			//luego de sacar los rollos resta las capas al espacio
				li_capas_extendidas = li_capas - li_capas_totales_sacar_enteras
				DECLARE sp_restar_capas_esp PROCEDURE FOR
						  pr_partir_espacio(:il_orden_corte, :il_agrupacion, :il_base_trazos, :ii_cs_trazo, :ii_seccion, :il_pdn, :il_trazo, :il_trazo_crear, :li_capas_extendidas, :id_porcent_util, 0);
				EXECUTE sp_restar_capas_esp;
				IF SQLCA.SQLCode = -1 THEN		
					ROLLBACK;
					IF SQLCA.SQLDBCode = -746 THEN
						li_pos_inicial = Pos(SQLCA.SQLErrText, ':', 1)
						MessageBox("Error Base Datos", Mid(SQLCA.SQLErrText, li_pos_inicial + 1, Len(SQLCA.SQLErrText) - (li_pos_inicial + 1)))
						Rollback;
						Close(w_retroalimentacion)
						return;
					ELSE
						MessageBox("Error Base Datos","Error al ejecutar el stored procedure " + SQLCA.SQLErrText)
						Close(w_retroalimentacion)
						Rollback;
						Return;
					END IF
				END IF
				COMMIT;
				
			END IF
		END IF
	END IF
NEXT

//se manda correo al programador informando que modificaron la orden de corte
IF li_resta_capas = 1 THEN
	
	//SA56209 - Ceiba/reariase - 30-01-2017
	//envio de correo
	//li_codigo_email = luo_constantes.of_consultar_numerico("EMAIL_COR_ENVIO") //41=integracion_tono_ppl
	//if li_codigo_email <> -1 then 
		ls_mensaje = 'A la orden de corte: ' + STRING(il_orden_corte) + ' Se le descontaron las siguientes capas ' + string(li_capas_totales_sacar_enteras) + '~r~n~r~n' + 'Porque no se extendieron, usuario que realizo la modificacion: ' + string(gstr_info_usuario.codigo_usuario)
		try
			//Dbedocal: luo_correo.of_enviar_correo("Orden de Corte modificada los mts extendidos", ls_mensaje, li_codigo_email,'')
			luo_correo.of_enviar_correo( "Orden de Corte modificada los mts extendidos", ls_mensaje, "integracion_tono_ppl")
		catch(	Exception ex)
			Messagebox("Error", ex.getmessage())
		end try 
	//end if
	//Fin SA56209
END IF
	
Close(w_retroalimentacion)

String ls_datocon
Long ll_numero_registros, ll_datocon



//Constantes de tipo de tela para no tomar los espacios con telas rectilineas
SELECT numerico
INTO :li_recti1
FROM m_constantes
WHERE var_nombre = 'RECTILINEO 1';

SELECT numerico
INTO :li_recti2
FROM m_constantes
WHERE var_nombre = 'RECTILINEO 2';

ll_numero_registros = dw_lista.Retrieve(il_orden_corte, li_recti1, li_recti2)
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
end event

public function long wf_verificar_espacio_liq (long al_orden_corte, long al_agrupacion, long al_base_trazos, long ai_cs_trazo, long ai_cs_seccion, long ai_cs_pdn);Long	li_liquidado

SELECT COUNT(*)
  INTO :li_liquidado
  FROM dt_liquidaxespacio
 WHERE cs_orden_corte = :al_orden_corte
   AND cs_agrupacion = :al_agrupacion
   AND cs_base_trazos = :al_base_trazos
	AND cs_trazo = :ai_cs_trazo;
IF li_liquidado > 0 THEN
	return 1
ELSE
	return 0
END IF
	

end function

on w_seleccionar_espacio_partir_corte.create
int iCurrent
call super::create
if this.MenuName = "m_partir_espacios" then this.MenuID = create m_partir_espacios
this.em_capas=create em_capas
this.st_2=create st_2
this.em_trazo_seleccion=create em_trazo_seleccion
this.st_3=create st_3
this.em_nombre=create em_nombre
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.em_capas
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.em_trazo_seleccion
this.Control[iCurrent+4]=this.st_3
this.Control[iCurrent+5]=this.em_nombre
end on

on w_seleccionar_espacio_partir_corte.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.em_capas)
destroy(this.st_2)
destroy(this.em_trazo_seleccion)
destroy(this.st_3)
destroy(this.em_nombre)
end on

event open;call super::open;This.X = 1
This.Y = 1
il_trazo_crear = 0 
em_capas.text = string(0)
em_nombre.text = 'SELECCIONE EL ICONO DEL PROCESO A REALIZAR'

IF (f_deshabilitar_opciones(this.classname(),this.menuid)= -1) THEN
	Close(This)
END IF


end event

type st_1 from w_base_buscar_lista_parametro`st_1 within w_seleccionar_espacio_partir_corte
integer x = 46
integer y = 20
integer width = 261
integer weight = 700
string text = "Ord. Cte:"
end type

type em_dato from w_base_buscar_lista_parametro`em_dato within w_seleccionar_espacio_partir_corte
integer x = 325
integer y = 8
integer width = 375
integer height = 88
integer textsize = -9
maskdatatype maskdatatype = numericmask!
string mask = "##########"
end type

event em_dato::modified;String ls_datocon
Long ll_numero_registros, ll_datocon
Long	li_recti1, li_recti2


//Constantes de tipo de tela para no tomar los espacios con telas rectilineas
SELECT numerico
INTO :li_recti1
FROM m_constantes
WHERE var_nombre = 'RECTILINEO 1';

SELECT numerico
INTO :li_recti2
FROM m_constantes
WHERE var_nombre = 'RECTILINEO 2';

ls_datocon = em_dato.Text
IF Not IsNull(ls_datocon) THEN
	ll_datocon = LONG(ls_datocon)

	ll_numero_registros = dw_lista.Retrieve(ll_datocon, li_recti1, li_recti2)
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

type st_numero_registros from w_base_buscar_lista_parametro`st_numero_registros within w_seleccionar_espacio_partir_corte
integer x = 2482
integer y = 1028
integer width = 805
alignment alignment = center!
end type

type pb_cancelar from w_base_buscar_lista_parametro`pb_cancelar within w_seleccionar_espacio_partir_corte
boolean visible = false
integer x = 1966
integer y = 1084
integer height = 144
integer taborder = 40
end type

event pb_cancelar::clicked;call super::clicked;close(parent)
end event

type pb_aceptar from w_base_buscar_lista_parametro`pb_aceptar within w_seleccionar_espacio_partir_corte
boolean visible = false
integer x = 1408
integer y = 1084
integer height = 144
integer taborder = 20
integer weight = 700
end type

event pb_aceptar::clicked;call super::clicked;Long ll_filas, ll_filaactual, ll_insertados, ll_referencia
Long	  li_fabrica, li_linea

s_base_parametros lstr_parametros
s_base_parametros_seleccionar lstr_parametros_seleccionar

ll_filas = dw_lista.RowCount()
ll_insertados = 1
FOR ll_filaactual = 1 TO ll_filas
	IF dw_lista.IsSelected(ll_filaactual) THEN
		ll_insertados = ll_insertados + 1		
		il_orden_corte = dw_lista.GetItemNumber(ll_filaactual, "cs_orden_corte")
		il_trazo = dw_lista.GetItemNumber(ll_filaactual, "co_trazo")
		ii_seccion = dw_lista.GetItemNumber(ll_filaactual, "cs_seccion")
		ii_cs_trazo = dw_lista.GetItemNumber(ll_filaactual, "cs_trazo")
		il_base_trazos = dw_lista.GetItemNumber(ll_filaactual, "cs_base_trazos")
		il_agrupacion = dw_lista.GetItemNumber(ll_filaactual, "cs_agrupacion")
		il_pdn = dw_lista.GetItemNumber(ll_filaactual, "cs_pdn")
		li_fabrica = dw_lista.GetItemNumber(ll_filaactual, "co_fabrica_pt")
		li_linea	= dw_lista.GetItemNumber(ll_filaactual, "co_linea")
		ll_referencia = dw_lista.GetItemNumber(ll_filaactual, "co_referencia")
		
		//abrir ventana con trazos de la misma referencia
		
			lstr_parametros_seleccionar.entero1[1] = li_fabrica
			lstr_parametros_seleccionar.entero1[2] = li_linea
			lstr_parametros_seleccionar.entero1[3] = ll_referencia
			lstr_parametros_seleccionar.entero1[4] = il_trazo
			OpenWithParm(w_seleccionar_trazosmodeloordencorte, lstr_parametros_seleccionar)
			lstr_parametros = Message.PowerObjectParm
			IF lstr_parametros.hay_parametros THEN
				il_trazo_crear	=	lstr_parametros.entero[1]
				id_porcent_util = lstr_parametros.decimal[1]
				em_trazo_seleccion.text = STRING(il_trazo_crear)
			END IF

	END IF
NEXT
IF ll_insertados > 1 THEN
	lstr_parametros_seleccionar.entero1[1] = ll_insertados
	lstr_parametros_seleccionar.hay_parametros = True
ELSE
	lstr_parametros_seleccionar.hay_parametros = False
END IF

CloseWithReturn(Parent, lstr_parametros_seleccionar)

end event

type dw_lista from w_base_buscar_lista_parametro`dw_lista within w_seleccionar_espacio_partir_corte
integer y = 116
integer width = 3264
integer height = 876
integer taborder = 30
string dataobject = "dct_seleccionar_espacio_partir"
end type

event dw_lista::doubleclicked;
IF  ii_bandera_capas = 1 OR ii_bandera_rollos = 1 THEN
ELSE
	MessageBox('Advertencia','No ha seleccionado el proceso a realizar, Seleccione el Icono de partir espacio o sacar rollos')
	Return;
END IF


IF row <> 0 AND row <> -1 AND NOT IsNull(row) THEN
	il_fila_actual = row
	this.selectrow(il_fila_actual,false)
	
	this.selectrow(il_fila_actual,false)
	il_fila_actual=this.getrow()
	this.setrow(il_fila_actual)
	this.selectrow(il_fila_actual,true)

	IF ii_bandera_capas = 1 THEN
		pb_aceptar.triggerevent(clicked!)
	ELSE
		parent.triggerevent('ue_buscar_rollos')
	END IF
ELSE
END IF
end event

type em_capas from editmask within w_seleccionar_espacio_partir_corte
string tag = "Ingresar Capas a Partir"
integer x = 869
integer y = 1040
integer width = 297
integer height = 88
integer taborder = 50
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "#####0"
end type

event modified;Long	li_capas_trazo_actual, li_capas_extendidas, li_pos_inicial
LONG	ll_trazo_utilizar, ll_numero_registros, ll_datocon
Long	li_recti1, li_recti2
s_base_parametros lstr_parametros_retro



IF il_trazo_crear > 0 THEN
ELSE
	MessageBox('Advertencia','Primero debe seleccionar el trazo a utilizar, dando doble clic en el espacio a cortar')
	em_capas.text = string(0)
	Return
END IF

IF len(trim(em_capas.text)) = 0 THEN
	li_capas_extendidas = 0
ELSE
	li_capas_extendidas = Long(em_capas.text)
END IF

IF li_capas_extendidas >= 0 AND (il_trazo_crear > 0) THEN	
	li_capas_trazo_actual = dw_lista.GetItemNumber(il_fila_actual, "capas")
	
	IF li_capas_extendidas >= li_capas_trazo_actual THEN
		MessageBox('Advertencia','Las Capas a Crear deben ser inferiores a las que tiene el espacio')
		em_capas.text = string(0)
		Return
	ELSE
		IF MessageBox("Advertencia", "Este proceso carga un nuevo espacio con el Trazo y las capas seleccionas, esta seguro de continuar", Question!, YesNo!, 2) = 2 THEN
			em_capas.text = string(0)
			il_trazo_crear = 0 
			Return(1)
		ELSE
			//Verificar que no este liquidado el espacio
			IF wf_verificar_espacio_liq(il_orden_corte, il_agrupacion, il_base_trazos, ii_cs_trazo, ii_seccion, il_pdn  ) = 1 THEN
				MessageBox('Advertencia','El espacio seleciconado ya se encuentra liquidado en corte')
				em_capas.text = string(0)
				il_trazo_crear = 0 
				Return
			ELSE
				// no se ha liquidado el espacio, cargar el proceso
				
				lstr_parametros_retro.cadena[1]="Procesando ..."
				lstr_parametros_retro.cadena[2]="Espere un momento por favor, esta operacion puede durar unos segundos..."
				lstr_parametros_retro.cadena[3]="reloj"
					
				OpenWithParm(w_retroalimentacion,lstr_parametros_retro)			
				DECLARE sp_partir_espacio PROCEDURE FOR
						  pr_partir_espacio(:il_orden_corte, :il_agrupacion, :il_base_trazos, :ii_cs_trazo, :ii_seccion, :il_pdn, :il_trazo, :il_trazo_crear, :li_capas_extendidas, :id_porcent_util, 1);
				EXECUTE sp_partir_espacio;
				IF SQLCA.SQLCode = -1 THEN		
					ROLLBACK;
					IF SQLCA.SQLDBCode = -746 THEN
						li_pos_inicial = Pos(SQLCA.SQLErrText, ':', 1)
						MessageBox("Error Base Datos", Mid(SQLCA.SQLErrText, li_pos_inicial + 1, Len(SQLCA.SQLErrText) - (li_pos_inicial + 1)))
						em_capas.text = string(0)
						il_trazo_crear = 0
						Close(w_retroalimentacion)
					ELSE
						MessageBox("Error Base Datos","Error al ejecutar el stored procedure " + SQLCA.SQLErrText)
						em_capas.text = string(0)
						il_trazo_crear = 0
						Close(w_retroalimentacion)
					END IF
				END IF
				COMMIT;
				Close(w_retroalimentacion)
				MessageBox('O.K.','Se creo exitosamente el espacio')
				
				em_capas.text = string(0)
				ll_datocon = LONG(em_dato.Text)
				il_trazo_crear = 0
	
	
					//Constantes de tipo de tela para no tomar los espacios con telas rectilineas
				SELECT numerico
				INTO :li_recti1
				FROM m_constantes
				WHERE var_nombre = 'RECTILINEO 1';
				
				SELECT numerico
				INTO :li_recti2
				FROM m_constantes
				WHERE var_nombre = 'RECTILINEO 2';

				ll_numero_registros = dw_lista.Retrieve(ll_datocon, li_recti1, li_recti2)
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
		
		END IF
	END IF
END IF


end event

type st_2 from statictext within w_seleccionar_espacio_partir_corte
integer x = 23
integer y = 1056
integer width = 837
integer height = 56
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 81576884
string text = "Capas Extendidas en el Espacio:"
boolean focusrectangle = false
end type

type em_trazo_seleccion from editmask within w_seleccionar_espacio_partir_corte
integer x = 1947
integer y = 1028
integer width = 379
integer height = 72
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "none"
alignment alignment = center!
borderstyle borderstyle = stylelowered!
string mask = "########"
end type

type st_3 from statictext within w_seleccionar_espacio_partir_corte
integer x = 1563
integer y = 1032
integer width = 379
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long backcolor = 81576884
string text = "Trazo a Utilizar:"
alignment alignment = center!
boolean focusrectangle = false
end type

type em_nombre from editmask within w_seleccionar_espacio_partir_corte
integer x = 1239
integer y = 24
integer width = 1435
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 12639424
boolean border = false
maskdatatype maskdatatype = stringmask!
string mask = "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
end type

