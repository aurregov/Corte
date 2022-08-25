HA$PBExportHeader$w_actualizar_unidades_cuellos.srw
forward
global type w_actualizar_unidades_cuellos from w_base_simple
end type
type em_ficho from editmask within w_actualizar_unidades_cuellos
end type
type st_1 from statictext within w_actualizar_unidades_cuellos
end type
type cb_buscar from commandbutton within w_actualizar_unidades_cuellos
end type
type cb_mover from commandbutton within w_actualizar_unidades_cuellos
end type
type em_concepto from editmask within w_actualizar_unidades_cuellos
end type
type em_destino from editmask within w_actualizar_unidades_cuellos
end type
type st_2 from statictext within w_actualizar_unidades_cuellos
end type
type st_3 from statictext within w_actualizar_unidades_cuellos
end type
type cb_consulta from commandbutton within w_actualizar_unidades_cuellos
end type
type cb_act_recti from commandbutton within w_actualizar_unidades_cuellos
end type
end forward

global type w_actualizar_unidades_cuellos from w_base_simple
integer width = 3707
integer height = 1820
string title = "Actualizar Unidades Cuellos"
string menuname = "m_principal_asignacion_modulos"
em_ficho em_ficho
st_1 st_1
cb_buscar cb_buscar
cb_mover cb_mover
em_concepto em_concepto
em_destino em_destino
st_2 st_2
st_3 st_3
cb_consulta cb_consulta
cb_act_recti cb_act_recti
end type
global w_actualizar_unidades_cuellos w_actualizar_unidades_cuellos

type variables
datastore ids_rollos, ids_tanda, ids_proceso_tandanueva, ids_proceso_tandavieja

Long	ii_tipo_tanda
end variables

forward prototypes
public function long of_validar_tipo_tanda (long al_cs_tanda, long ai_secundario)
public function long of_validar_tanda_en_despacho (long al_tanda, long ai_secundario, long ai_ruta)
public function long of_cerrar_proceso (long al_tanda, long ai_secundario, long ai_proceso, long al_reftel)
public function long of_traer_constante (string as_nombre_constante)
end prototypes

public function long of_validar_tipo_tanda (long al_cs_tanda, long ai_secundario);//buscar informaci$$HEX1$$f300$$ENDHEX$$n de la tanda
If ids_tanda.Retrieve(al_cs_tanda,ai_secundario) <= 0 Then
	Messagebox("Atenci$$HEX1$$f300$$ENDHEX$$n","No se encontr$$HEX2$$f3002000$$ENDHEX$$informaci$$HEX1$$f300$$ENDHEX$$n relacionada con la tanda leida",StopSign!)
	Return -1
End If

//si la tanda es del sistema nuevo busca si esta en despacho en la tabla dt_procesos_tanda
ii_tipo_tanda = ids_tanda.GetItemNumber(1,"co_tipo_tanda") 

Return ii_tipo_tanda

end function

public function long of_validar_tanda_en_despacho (long al_tanda, long ai_secundario, long ai_ruta);/*------------------------------------------------ of_validar_tanda_despacho()--------------------------------
Funci$$HEX1$$f300$$ENDHEX$$n para validar si una tanda se encuentra en Despacho.
en el sistema nuevo se valida  que este le$$HEX1$$ed00$$ENDHEX$$do el proceso # 136 en dt_procesos_tanda  
y por sistema viejo que este le$$HEX1$$ed00$$ENDHEX$$do el tipoprod 2, centro_pdn = 3 y subcentro_pdn 9
, en ambos se mira que el proceso tenga fe_ingreso.

si la tanda se encuentra en despacho retorna 1, en caso contrario retorna 0, error -1
----------------------------------------------------------------------------------------------------------------------*/
/* modificacion jorodrig julio 2 - 2008 pedida por ingenieria 
se va a permitir ingresar la tanda nueva a terminado estando en pruebas laboratorio
los rollos se dejan con estado 1 pendiente por calidad hasta que calidad
apruebe la tanda, en ese momento los rollos se pasan a estado 2,  la tanda sigue activa

*/
Long	li_fila_despacho

//buscar informaci$$HEX1$$f300$$ENDHEX$$n de la tanda
of_validar_tipo_tanda(al_tanda,ai_secundario) 

If ii_tipo_tanda = 6 Then
	If ids_proceso_tandanueva.Retrieve(al_tanda,ai_secundario,ai_ruta) >0 Then
		
		//la tanda nueva est$$HEX2$$e1002000$$ENDHEX$$en despacho.
		li_fila_despacho = ids_proceso_tandanueva.Find("co_proceso=136 AND (Not IsNull(fe_ingreso)) AND IsNull(fe_fin) ",1,ids_proceso_tandanueva.RowCount())
		If li_fila_despacho > 0 Then
			Return 1
		Else
			If ids_proceso_tandavieja.Retrieve(al_tanda,ai_secundario) >0 Then
				li_fila_despacho = ids_proceso_tandavieja.Find("co_tipoprod= 2 AND co_centro_pdn = 3 AND (co_subcentro_pdn =  9 OR co_subcentro_pdn =  99 ) AND  (Not IsNull(fe_ingreso)) ",1,ids_proceso_tandavieja.RowCount())
				If  li_fila_despacho > 0 Then
					Return 1
				Else
					MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","La tanda "+ String(al_tanda)+" del sistema viejo no se encuentra en despacho")
					Return 0
				End If
			Else
				MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","La tanda: " + String(al_tanda)+" del sistema viejo no se encuentra en despacho")
				Return -1
			End If
		END IF

	Else
		MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","La tanda: " + String(al_tanda)+" del sistema nuevo no se encuentra en despacho")
		Return -1
	End If

			
			

Else //sino en la tabla dt_procesosxlote las tandas viejas.
	 //se pasa al retrieve tanda, secundario
	If 	ids_proceso_tandavieja.Retrieve(al_tanda,ai_secundario) >0 Then
		
		li_fila_despacho = ids_proceso_tandavieja.Find("co_tipoprod= 2 AND co_centro_pdn = 3 AND (co_subcentro_pdn =  9 OR co_subcentro_pdn =  99 ) AND  (Not IsNull(fe_ingreso)) ",1,ids_proceso_tandavieja.RowCount())
		If  li_fila_despacho > 0 Then
			Return 1
		Else
			MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","La tanda "+ String(al_tanda)+" del sistema viejo no se encuentra en despacho")
			Return 0
		End If
	Else
		MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","La tanda: " + String(al_tanda)+" del sistema viejo no se encuentra en despacho")
		Return -1
	End If
End If

Return 0
end function

public function long of_cerrar_proceso (long al_tanda, long ai_secundario, long ai_proceso, long al_reftel);
DATETIME	ldt_fe_hoy
STRING	ls_usuario	

ls_usuario =  gstr_info_usuario.codigo_usuario

UPDATE dt_procesos_tanda
   SET (fe_fin, fe_actualizacion, usuario)
	  = (current, current, :ls_usuario)
 WHERE cs_tanda      = :al_tanda
   AND cs_secundario = :ai_secundario
	AND co_reftel     = :al_reftel
	AND co_proceso    = :ai_proceso
	AND fe_ingreso    IS NOT NULL
	AND fe_fin        IS NULL;
IF SQLCA.SQLCODE <> 0 THEN
	ROLLBACK;
	MessageBox('Error Base Datos','Error al cerrar proceso de kamban')
	RETURN 0
END IF

	
Return 1	
end function

public function long of_traer_constante (string as_nombre_constante);//traer un valor de la tabla de constantes
Long	li_valor

Select numerico
  Into :li_valor
  From m_constant_tela
 Where var_nombre = :as_nombre_constante;
If sqlca.sqlcode <> 0 Then
	Return -1
End if
 
 Return li_valor;
end function

on w_actualizar_unidades_cuellos.create
int iCurrent
call super::create
if IsValid(this.MenuID) then destroy(this.MenuID)
if this.MenuName = "m_principal_asignacion_modulos" then this.MenuID = create m_principal_asignacion_modulos
this.em_ficho=create em_ficho
this.st_1=create st_1
this.cb_buscar=create cb_buscar
this.cb_mover=create cb_mover
this.em_concepto=create em_concepto
this.em_destino=create em_destino
this.st_2=create st_2
this.st_3=create st_3
this.cb_consulta=create cb_consulta
this.cb_act_recti=create cb_act_recti
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.em_ficho
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.cb_buscar
this.Control[iCurrent+4]=this.cb_mover
this.Control[iCurrent+5]=this.em_concepto
this.Control[iCurrent+6]=this.em_destino
this.Control[iCurrent+7]=this.st_2
this.Control[iCurrent+8]=this.st_3
this.Control[iCurrent+9]=this.cb_consulta
this.Control[iCurrent+10]=this.cb_act_recti
end on

on w_actualizar_unidades_cuellos.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.em_ficho)
destroy(this.st_1)
destroy(this.cb_buscar)
destroy(this.cb_mover)
destroy(this.em_concepto)
destroy(this.em_destino)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.cb_consulta)
destroy(this.cb_act_recti)
end on

event open;call super::open;dw_maestro.Retrieve()

This.width = 3177
This.height = 1860
This.X = 1
This.Y = 1
return

ids_tanda = Create datastore
ids_tanda.DataObject = "ds_gr_h_tandas"
ids_tanda.SetTransObject(SQLCA)

ids_proceso_tandanueva = Create datastore
ids_proceso_tandanueva.DataObject = "ds_gr_proceso_actual_tandanueva"
ids_proceso_tandanueva.SetTransObject(SQLCA)

ids_proceso_tandavieja = Create datastore
ids_proceso_tandavieja.DataObject = "ds_gr_proceso_actual_tandavieja"
ids_proceso_tandavieja.SetTransObject(SQLCA)


end event

event ue_grabar;Long		  li_tot_filas, posi, li_co_caract, li_ya_inserto
Long		li_diametro,   li_co_fabrica, li_co_talla, li_unidades_prog_rollo
LONG			ll_co_reftel, ll_ordenpd_pt, ll_lote, ll_cs_rollo, ll_co_color_pt, ll_co_color
DECIMAL{3}	ld_kg
Long		li_unid_real, li_unid_ant, li_difer
STRING		ls_usuario, ls_instancia


dw_maestro.Accepttext()
ls_usuario = gstr_info_usuario.codigo_usuario
ls_instancia = 	gstr_info_usuario.instancia

li_tot_filas = dw_maestro.RowCount()
//
FOR posi = 1 TO li_tot_filas

	ll_co_reftel = dw_maestro.GetItemNumber(posi, "co_reftel_act")
	li_co_caract = dw_maestro.GetItemNumber(posi, "co_caract_act")
	ll_co_color = dw_maestro.GetItemNumber(posi, "co_color_act")
	li_diametro = dw_maestro.GetItemNumber(posi, "diametro_act")
	ll_ordenpd_pt = dw_maestro.GetItemNumber(posi, "m_rollo_cs_orden_pr_act")
	ll_lote = dw_maestro.GetItemNumber(posi, "m_rollo_lote")
	ll_cs_rollo = dw_maestro.GetItemNumber(posi, "cs_rollo")
	ld_kg = dw_maestro.GetItemNumber(posi, "m_rollo_ca_kg")
	li_co_fabrica = dw_maestro.GetItemNumber(posi, "m_rollo_co_fabrica_act")
	ll_co_color_pt = dw_maestro.GetItemNumber(posi, "m_rollo_co_color_pt")
	li_co_talla = dw_maestro.GetItemNumber(posi, "co_talla")

	SELECT ca_unidades
	  INTO :li_unidades_prog_rollo
	  FROM m_rollo
	 WHERE cs_rollo = :ll_cs_rollo; 
   IF SQLCA.SQLCODE <> 0 THEN
		ROLLBACK;
		MessageBox('Error Base Datos','Error al buscar unidades programadas en cuellos')
		RETURN 1
	END IF


   li_unid_real = dw_maestro.GetItemNumber(posi, "ca_unidades")
	li_unid_ant = dw_maestro.GetItemNumber(posi, "m_rollo_ca_unidades")
	li_difer = li_unid_real - li_unid_ant
	
	IF li_difer > 100 OR li_difer < -100 THEN
		MessageBox('Advertencia','Verifique las cantidades, pues tiene mucha diferencia con las unidades programadas')
	END IF
	SELECT COUNT(*)
	  INTO :li_ya_inserto
	  FROM dt_act_rectilin
	 WHERE cs_rollo = :ll_cs_rollo
	  ;
	IF li_ya_inserto > 0 THEN
		UPDATE dt_act_rectilin
		   SET ( ca_unidades_prog, ca_unidades_act, ca_unidades_mal, fe_actualizacion, usuario) =
			    ( :li_unidades_prog_rollo, :li_unid_real, :li_difer, current, :ls_usuario )
		 WHERE cs_rollo = :ll_cs_rollo
		 ;
	   IF SQLCA.SQLCODE <> 0 THEN
			ROLLBACK;
			MessageBox('Error Base Datos','Error al actualizar unidades kardex cuellos')
			RETURN 1
		END IF

	ELSE
		INSERT INTO dt_act_rectilin(cs_rollo, cs_ordenpd_pt, lote, co_fabrica, co_reftel, co_caract,
   	            diametro, co_color_te, co_talla, co_color_pt, co_tipo, ca_unidades_prog,
					   ca_unidades_act, ca_unidades_mal, ca_kilos, observacion, fe_creacion,
						fe_actualizacion, usuario, instancia)
			 VALUES (:ll_cs_rollo, :ll_ordenpd_pt, :ll_lote, :li_co_fabrica, :ll_co_reftel, :li_co_caract,
			         :li_diametro, :ll_co_color, :li_co_talla, :ll_co_color_pt, 0, :li_unidades_prog_rollo,
						:li_unid_real, :li_difer, :ld_kg, '', current, current, :ls_usuario, :ls_instancia);		 
	   IF SQLCA.SQLCODE <> 0 THEN
			ROLLBACK;
			MessageBox('Error Base Datos','Error al insertar kardex')
			RETURN 1
		END IF
	END IF

END FOR

/////////////////////////////////////////////////////////////////////
// En este evento se realiza el ACCEPTTEXT para llevar los
// datos al buffer. El UPDATE() para preparar los datos a grabar y
// el COMMIT, para grabar los cambios en la base de datos
/////////////////////////////////////////////////////////////////////

IF dw_maestro.AcceptText() = -1 THEN
	is_accion = "no accepttext"
	Messagebox("Error","No se pudieron realizar los cambios en el maestro" &
	           ,Exclamation!,Ok!)	
	RETURN
ELSE
	IF dw_maestro.Update() = -1 THEN
		is_accion = "no update"
		ROLLBACK;
	   RETURN
	ELSE
		is_accion = "si update"
		COMMIT;
		IF SQLCA.SQLCode = -1 THEN
			is_grabada = "no"
			Messagebox("Error","No se pudo hacer los cambios en el maestro para la base de datos",Exclamation!,Ok!)	
		ELSE
			is_grabada = "si"
		END IF
	END IF
END IF
	

end event

type dw_maestro from w_base_simple`dw_maestro within w_actualizar_unidades_cuellos
integer x = 0
integer y = 192
integer width = 3643
integer height = 1388
integer taborder = 60
string dataobject = "dtb_actualizar_unidades_cuellos"
boolean border = true
borderstyle borderstyle = stylelowered!
end type

event dw_maestro::itemchanged;STRING	ls_ubicacion, ls_ubicacion_ant
Long	li_temp, li_perfil, li_centro
LONG		ll_unidades_acaba, ll_cs_rollo, ll_unidades_rollo
DECIMAL{2}	ld_porcent_mayor,  ld_porcent_menor


li_perfil = gstr_info_usuario.codigo_perfil


li_temp = 0
IF DWO.NAME = "ubicacion" THEN
	ls_ubicacion	=	string(DATA)
	ls_ubicacion_ant = dw_maestro.GetitemString(row,'ubicacion')
	SELECT count(*)  
     INTO :li_temp  
     FROM m_ubicaciones  
    WHERE co_ubicacion = :ls_ubicacion  ;
	 
	 IF li_temp = 0 THEN
			MessageBox("Advertencia","La ubicacion no existe consulte con la bodega de terminado")
			dw_maestro.SetItem(Row, "ubicacion", ls_ubicacion_ant)
			Return 1
	 END IF

END IF

IF DWO.NAME = "ca_unidades" THEN
	ll_unidades_acaba = LONG(DATA)
	
	li_centro = dw_maestro.GetitemNumber(row,'co_centro')
	IF (li_perfil = 1) OR (li_perfil =  6) OR (li_perfil = 17) OR (li_perfil = 13) OR (li_perfil = 29)  THEN //Perfiles especiales que pueden cambiar las unidades de los rectilineos
	ELSE
		SELECT numerico
			INTO :ld_porcent_mayor
			FROM m_constantes
		  WHERE var_nombre = 'MAYOR_RECTI_ACAB'	;
			
		ll_cs_rollo = dw_maestro.GetitemNumber(row,'cs_rollo')
		SELECT ca_unidades
			INTO :ll_unidades_rollo
			FROM m_rollo
		 WHERE cs_rollo = :ll_cs_rollo;	
		IF ll_unidades_rollo < 50 THEN
			SELECT numerico
			  INTO :ld_porcent_menor   //para menos de 50 unidades
			  FROM m_constantes
			 WHERE var_nombre = 'MENOR_RECTI_ACAB_2'	;
		ELSE
			SELECT numerico
			  INTO :ld_porcent_menor   //% permitido para ingreso de menos unidades
			  FROM m_constantes
			 WHERE var_nombre = 'MENOR_RECTI_ACAB'	;
		END IF
		
		IF ll_unidades_acaba > (ll_unidades_rollo * ld_porcent_mayor) THEN
			MessageBox("Advertencia","No puede ingresar mas de un 5 % de las unidades tejidas,Verifique...")
			dw_maestro.SetItem(Row, "ca_unidades", ll_unidades_rollo)
			Return 1
		ELSE
			IF (ll_unidades_acaba < (ll_unidades_rollo * ld_porcent_menor)) AND li_centro <> 73 THEN
				MessageBox("Advertencia","No puede ingresar menos unidades de las unidades tejidas,Verifique con el programador...")
				dw_maestro.SetItem(Row, "ca_unidades", ll_unidades_rollo)
				Return 1
			END IF
		END IF
	END IF
	
END IF
end event

type em_ficho from editmask within w_actualizar_unidades_cuellos
boolean visible = false
integer x = 338
integer y = 28
integer width = 343
integer height = 84
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
string text = "none"
borderstyle borderstyle = stylelowered!
string mask = "######"
end type

type st_1 from statictext within w_actualizar_unidades_cuellos
boolean visible = false
integer x = 91
integer y = 28
integer width = 242
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "FICHO:"
boolean focusrectangle = false
end type

type cb_buscar from commandbutton within w_actualizar_unidades_cuellos
integer x = 37
integer y = 12
integer width = 407
integer height = 168
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "&Buscar"
end type

event clicked;//SetPointer(HourGlass!)
DISCONNECT;
SQLCA.Lock = "DIRTY READ"
CONNECT USING SQLCA;
dw_maestro.SetTransObject(SQLCA)
//
dw_maestro.visible = true
dw_maestro.Retrieve()
SetPointer(Arrow!)

end event

type cb_mover from commandbutton within w_actualizar_unidades_cuellos
string tag = "Mover los rollos al 15"
integer x = 2053
integer y = 28
integer width = 448
integer height = 136
integer taborder = 50
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "&Mover .15."
boolean cancel = true
end type

event clicked;Long		li_concepto, li_destino, li_tot_filas, posi, li_co_caract, li_ruta, li_proceso
Long		li_diametro, li_origen, li_maquina, li_co_fabrica, li_co_talla, li_result, li_centro
LONG			ll_co_reftel, ll_ordenpd_pt, ll_lote, ll_cs_rollo, ll_cs_tanda, li_unidades_prog_rollo, ll_tela_ant, ll_co_color_pt, ll_co_color
DECIMAL{3}	ld_kg, ld_ancho_rollo
Long		li_unid_real, li_unid_ant, li_difer, li_ya_mostro_mensaje, li_ya_inserto, li_existe, li_sec, li_recti_x_preparar
STRING		ls_usuario, ls_instancia, ls_tono
DATETIME		ldt_fe_hoy
s_base_parametros lstr_parametros_retro

IF MessageBox("Advertencia", "Este seguro de grabar?", Question!, YesNo!, 2) = 2 THEN
	Return(1)
END IF



//para mostrar ventana de espera  
lstr_parametros_retro.cadena[1]="Procesando ..."
lstr_parametros_retro.cadena[2]="Espere un momento por favor, Moviendo Rollos"
lstr_parametros_retro.cadena[3]="reloj"
OpenWithParm(w_retroalimentacion,lstr_parametros_retro)    

dw_maestro.Accepttext()

Parent.Triggerevent('ue_grabar')

//w_actualizar_unidades_cuellos.TriggerEvent("ue_grabar")

li_concepto = Long(em_concepto.text)
IF ISNULL(li_concepto) THEN
	MessageBox('Error','Debe ingresar el concepto')
	Return
END IF
li_destino = Long(em_destino.text)
IF ISNULL(li_destino) THEN
	MessageBox('Error','Debe ingresar el concepto')
	Return 
END IF

ls_usuario = gstr_info_usuario.codigo_usuario
ls_instancia = 	gstr_info_usuario.instancia
ldt_fe_hoy =  Datetime(f_fecha_servidor())


li_tot_filas = dw_maestro.RowCount()
ll_tela_ant = 0
li_ya_mostro_mensaje = 0
li_recti_x_preparar = 12


FOR posi = 1 TO li_tot_filas

	ll_co_reftel = dw_maestro.GetItemNumber(posi, "co_reftel_act")
	li_co_caract = dw_maestro.GetItemNumber(posi, "co_caract_act")
	ll_co_color = dw_maestro.GetItemNumber(posi, "co_color_act")
	li_diametro = dw_maestro.GetItemNumber(posi, "diametro_act")
	li_origen = dw_maestro.GetItemNumber(posi, "co_centro")
	li_maquina = dw_maestro.GetItemNumber(posi, "m_rollo_co_maquina_tej")
	ll_ordenpd_pt = dw_maestro.GetItemNumber(posi, "m_rollo_cs_orden_pr_act")
	ll_lote = dw_maestro.GetItemNumber(posi, "m_rollo_lote")
	ll_cs_rollo = dw_maestro.GetItemNumber(posi, "cs_rollo")
	ld_kg = dw_maestro.GetItemNumber(posi, "m_rollo_ca_kg")
	li_co_fabrica = dw_maestro.GetItemNumber(posi, "m_rollo_co_fabrica_act")
	ll_co_color_pt = dw_maestro.GetItemNumber(posi, "m_rollo_co_color_pt")
	li_co_talla = dw_maestro.GetItemNumber(posi, "co_talla")
	ld_ancho_rollo = dw_maestro.GetItemNumber(posi, "ancho_tub_term")
	ll_cs_tanda = dw_maestro.GetItemNumber(posi, "cs_tanda")
	ls_tono = dw_maestro.GetItemstring(posi, "co_tono")
	li_sec = dw_maestro.GetItemNumber(posi, "cs_secundario")
	li_ruta = dw_maestro.GetItemNumber(posi, "nu_ruta_pdn")
	li_centro = dw_maestro.GetItemNumber(posi, "co_centro")
	IF li_centro <> 10 THEN
		Continue;
	END IF
	
	
	IF ls_tono = 'A ' OR ls_tono= 'B ' OR ls_tono = 'C ' THEN
	ELSE
	   ROLLBACK;
      MessageBox('Advertencia','Rollo sin tono, debe ingresar el tono: ' + string(ll_cs_rollo))
		Close(w_retroalimentacion)
		RETURN 0
	END IF
	dw_maestro.SetItem(posi, "ubicacion", '5000')
	
	
	//Validar que los datos tengan las normas de calidad de acabados
	//validadacion solicitada por Edwin Serna  sep 27/2005 jorodrig
	
	SELECT count(*)
	  INTO :li_existe
	  FROM m_norma_cal
	 WHERE cs_tanda = :ll_cs_tanda
		AND co_reftel = :ll_co_reftel
		AND lote =  :ll_lote;
   IF li_existe > 0 THEN
   ELSE
	   ROLLBACK;
      MessageBox('Advertencia','Lote sin chequeo calidad  tela: ' + string(ll_co_reftel) + ' Lote: ' + string(ll_lote) + ' Rollo: '+string(ll_cs_rollo))
		Close(w_retroalimentacion)
      ROLLBACK;
		RETURN 0
   END IF
		
		
	SELECT ca_unidades
	  INTO :li_unidades_prog_rollo
	  FROM m_rollo
	 WHERE cs_rollo = :ll_cs_rollo; 
 	IF SQLCA.SQLCODE <> 0 THEN
		ROLLBACK;
		MessageBox('Error Base Datos','Error al buscar unidades programadas en cuellos')
		Close(w_retroalimentacion)
		RETURN 1
	END IF

   IF li_destino <> li_origen THEN
		//Graba la entrada en el kardex
		IF f_graba_en_h_kardex(li_concepto, li_origen, li_destino, li_co_caract, ll_co_reftel, ll_co_color, &
		  li_diametro, ll_lote, ll_ordenpd_pt, ll_cs_rollo, ld_kg, ll_cs_tanda )   = 1 THEN
			COMMIT;
		ELSE
			ROLLBACK;
			Close(w_retroalimentacion)
			RETURN 0
		END IF
	ELSE
		IF li_ya_mostro_mensaje = 0 THEN
			Messagebox('Advertencia','Origen igual a Destino en rollo: '+string(ll_cs_rollo)+', Se continua con los demas rollos')
			li_ya_mostro_mensaje = 1
		END IF
	END IF
	
	IF ld_ancho_rollo > 0 THEN
	ELSE
		ld_ancho_rollo = 0
	END IF
	dw_maestro.SetItem(posi, "ancho_tub_term",ld_ancho_rollo)
	dw_maestro.SetItem(posi, "fe_actualizacion",ldt_fe_hoy)
	dw_maestro.SetItem(posi, "usuario",ls_usuario)
	
//Insertar en tabla de movimientos de unidades por rollo
   li_unid_real = dw_maestro.GetItemNumber(posi, "ca_unidades")
	li_unid_ant = dw_maestro.GetItemNumber(posi, "m_rollo_ca_unidades")
	li_difer = li_unid_real - li_unid_ant
	
	
//	SELECT COUNT(*)
//	  INTO :li_ya_inserto
//	  FROM dt_act_rectilin
//	 WHERE cs_rollo = :ll_cs_rollo;
//	IF li_ya_inserto > 0 THEN
//		UPDATE dt_act_rectilin
//		   SET (ca_unidades_prog, ca_unidades_act, ca_unidades_mal, fe_actualizacion, usuario) =
//			    (:li_unidades_prog_rollo, :li_unid_real, :li_difer, current, :ls_usuario )
//		 WHERE cs_rollo = :ll_cs_rollo;
//	   IF SQLCA.SQLCODE <> 0 THEN
//			ROLLBACK;
//			Close(w_retroalimentacion)
//			MessageBox('Error Base Datos','Error al actualizar unidades kardex cuellos')
//			RETURN 1
//		END IF
//	ELSE
//		
//		INSERT INTO dt_act_rectilin(cs_rollo, cs_ordenpd_pt, lote, co_fabrica, co_reftel, co_caract,
//      	         diametro, co_color_te, co_talla, co_color_pt, co_tipo, ca_unidades_prog,
//					   ca_unidades_act, ca_unidades_mal, ca_kilos, observacion, fe_creacion,
//						fe_actualizacion, usuario, instancia)
//			 VALUES (:ll_cs_rollo, :ll_ordenpd_pt, :ll_lote, :li_co_fabrica, :ll_co_reftel, :li_co_caract,
//		         	:li_diametro, :ll_co_color, :li_co_talla, :ll_co_color_pt, 0, :li_unidades_prog_rollo,
//						:li_unid_real, :li_difer, :ld_kg, '', current, current, :ls_usuario, :ls_instancia);		 
//   	IF SQLCA.SQLCODE <> 0 THEN
//			ROLLBACK;
//			Close(w_retroalimentacion)
//			MessageBox('Error Base Datos','Error al insertar kardex')
//			RETURN 1
//		END IF
//	END IF

	IF ll_co_reftel <> ll_tela_ant THEN
		
		IF li_ruta > 0 THEN
		ELSE
			Rollback;
			Close(w_retroalimentacion)
			MessageBox('Error','Se present$$HEX2$$f3002000$$ENDHEX$$un error cargando la ruta de la tela')
			Return 0
		END IF
		//validar que la tanda este en despachos	
		li_result = of_validar_tanda_en_despacho(ll_cs_tanda, li_sec, li_ruta) 
		IF li_result = 1 THEN  //la tanda esta en despachos
		ELSE
			Rollback;
			Close(w_retroalimentacion)
			Return 0
		END IF

		li_proceso = 136  //proceso de despacho
		//es necesario cerrar el proceso de despacho en la tanda - tela
		IF of_cerrar_proceso(ll_cs_tanda, li_sec, li_proceso, ll_co_reftel) = 0 THEN
			Return 1		
		END IF

	END IF
	ll_tela_ant = ll_co_reftel
	
END FOR


IF dw_maestro.AcceptText() = -1 THEN
	is_accion = "no accepttext"
	Messagebox("Error","No se pudieron realizar los cambios en el maestro" &
	           ,Exclamation!,Ok!)	
 	Close(w_retroalimentacion)
	RETURN
ELSE
	IF dw_maestro.Update() = -1 THEN
		is_accion = "no update"
		Close(w_retroalimentacion)
		ROLLBACK;
	   RETURN
	ELSE
		is_accion = "si update"
		COMMIT;
		MessageBox('O.K.','Se grabo correctamente los datos')
		IF SQLCA.SQLCode = -1 THEN
			is_grabada = "no"
			Messagebox("Error","No se pudo hacer los cambios en el maestro para la base de datos",Exclamation!,Ok!)	
		ELSE
			is_grabada = "si"
		END IF
	END IF
END IF

Close(w_retroalimentacion)	
//Return 1
end event

type em_concepto from editmask within w_actualizar_unidades_cuellos
integer x = 1810
integer y = 8
integer width = 206
integer height = 80
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
string text = "12"
alignment alignment = center!
borderstyle borderstyle = stylelowered!
string mask = "#####"
end type

type em_destino from editmask within w_actualizar_unidades_cuellos
integer x = 1810
integer y = 100
integer width = 206
integer height = 80
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
string text = "15"
alignment alignment = center!
borderstyle borderstyle = stylelowered!
string mask = "#####"
end type

type st_2 from statictext within w_actualizar_unidades_cuellos
integer x = 1481
integer y = 12
integer width = 329
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Concepto:"
boolean focusrectangle = false
end type

type st_3 from statictext within w_actualizar_unidades_cuellos
integer x = 1545
integer y = 108
integer width = 261
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Destino:"
boolean focusrectangle = false
end type

type cb_consulta from commandbutton within w_actualizar_unidades_cuellos
boolean visible = false
integer x = 485
integer y = 92
integer width = 343
integer height = 92
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "&Consultar"
end type

event clicked;OpenSheet(w_reporte_actualizacion_rectilineas, w_principal, 1, Layered!)
end event

type cb_act_recti from commandbutton within w_actualizar_unidades_cuellos
boolean visible = false
integer x = 2542
integer y = 28
integer width = 640
integer height = 136
integer taborder = 60
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "Rectilineas Listas"
end type

event clicked;Long	li_tot_filas, posi
String	ls_usuario
Datetime	ldt_fe_hoy
s_base_parametros lstr_parametros_retro


IF MessageBox("Advertencia", "Este seguro de grabar?", Question!, YesNo!, 2) = 2 THEN
	Return(1)
END IF


//para mostrar ventana de espera  
lstr_parametros_retro.cadena[1]="Procesando ..."
lstr_parametros_retro.cadena[2]="Espere un momento por favor, Moviendo Rollos"
lstr_parametros_retro.cadena[3]="reloj"
OpenWithParm(w_retroalimentacion,lstr_parametros_retro)    


ls_usuario = gstr_info_usuario.codigo_usuario
ldt_fe_hoy =  Datetime(f_fecha_servidor())

li_tot_filas = dw_maestro.RowCount()

For posi = 1 TO li_tot_filas
	dw_maestro.SetItem(posi, "co_estado_rollo",2)
	dw_maestro.SetItem(posi, "fe_actualizacion",ldt_fe_hoy)
	dw_maestro.SetItem(posi, "usuario",ls_usuario)

Next

IF dw_maestro.AcceptText() = -1 THEN
	is_accion = "no accepttext"
	Messagebox("Error","No se pudieron realizar los cambios en el maestro" &
	           ,Exclamation!,Ok!)	
 	Close(w_retroalimentacion)
	RETURN
ELSE
	IF dw_maestro.Update() = -1 THEN
		is_accion = "no update"
		Close(w_retroalimentacion)
		ROLLBACK;
	   RETURN
	ELSE
		is_accion = "si update"
		COMMIT;
		MessageBox('O.K.','Se grabo correctamente los datos')
		IF SQLCA.SQLCode = -1 THEN
			is_grabada = "no"
			Messagebox("Error","No se pudo hacer los cambios en el maestro para la base de datos",Exclamation!,Ok!)	
		ELSE
			is_grabada = "si"
		END IF
	END IF
END IF

Close(w_retroalimentacion)	
//Return 1
end event

