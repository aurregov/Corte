HA$PBExportHeader$w_actualiza_maquina_corte.srw
forward
global type w_actualiza_maquina_corte from w_base_pda
end type
type em_orden_corte from editmask within w_actualiza_maquina_corte
end type
type st_1 from statictext within w_actualiza_maquina_corte
end type
type cb_1 from commandbutton within w_actualiza_maquina_corte
end type
type cb_2 from commandbutton within w_actualiza_maquina_corte
end type
type em_maquina from editmask within w_actualiza_maquina_corte
end type
type st_2 from statictext within w_actualiza_maquina_corte
end type
type gb_1 from groupbox within w_actualiza_maquina_corte
end type
end forward

global type w_actualiza_maquina_corte from w_base_pda
integer width = 1490
integer height = 800
string title = "Actualizar Maquina O.C"
em_orden_corte em_orden_corte
st_1 st_1
cb_1 cb_1
cb_2 cb_2
em_maquina em_maquina
st_2 st_2
gb_1 gb_1
end type
global w_actualiza_maquina_corte w_actualiza_maquina_corte

forward prototypes
public function long of_actualiza_maquina (long al_orden_corte, long al_agrupacion, long al_base_trazo, long al_trazo, long al_maquina)
end prototypes

public function long of_actualiza_maquina (long al_orden_corte, long al_agrupacion, long al_base_trazo, long al_trazo, long al_maquina);LONG     ll_existe_orden, ll_orden_preliquidada, ll_estado_mesa, ll_raya, &
         ll_mesa_leer, ll_oc_a_leer, ll_pendientes, ll_subctro_extendido,&
		   ll_ctro_corte, ll_subcentro_act, ll_subcentro_preparacion
DATETIME ldt_fe_inicio_progs
STRING   ls_error, ls_equipos_kamban

n_cts_constantes luo_constantes

luo_constantes = Create n_cts_constantes

//Se verifica que exista la orden de corte con esta informaci$$HEX1$$f300$$ENDHEX$$n, si no existe se genera mensaje y cancela el proceso asi:
SELECT Count(*)
  INTO :ll_existe_orden
  FROM dt_trazosxoc
 WHERE cs_orden_corte = :al_orden_corte 
   AND cs_agrupacion  = :al_agrupacion 
   AND cs_base_trazos = :al_base_trazo 
   AND cs_trazo       = :al_trazo ;
	
IF SQLCA.SQLCODE = -1 THEN
	ls_error = SQLCA.SqlErrText
	MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de consultar la O.C. '+ ls_error)
	RETURN -1
END IF	
	
IF ll_existe_orden = 0 THEN
	MessageBox("Advertencia","La orden de corte no existe, favor verificar")
	RETURN -1
END IF

//Verifica que la orden de corte este pre liquidada,
//si no lo est$$HEX1$$e100$$ENDHEX$$, saca mensaje de orden sin preliquidar y cancela el proceso:
SELECT Count(*)
  INTO :ll_orden_preliquidada
  FROM dt_liquidaxespacio
 WHERE cs_orden_corte = :al_orden_corte 
   AND cs_agrupacion  = :al_agrupacion 
   AND cs_base_trazos = :al_base_trazo 
   AND cs_trazo       = :al_trazo ;
	
IF SQLCA.SQLCODE = -1 THEN
	ls_error = SQLCA.SqlErrText
	MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de consultar en dt_liquidaxespacio. '+ ls_error)
	RETURN -1
END IF	

IF ll_orden_preliquidada = 0 THEN
	MessageBox("Advertencia","Orden sin preliquidar, se cancela el proceso")
	RETURN -1
END IF

//Valida que la orden de corte si est$$HEX2$$e9002000$$ENDHEX$$extendida en el PDP de corte, 
//si no existe se saca un mensaje diciendo  "La orden de corte no esta extendida en el PDP de corte":
SELECT MAX(co_estado)
  INTO :ll_estado_mesa
  FROM dt_rayas_telaxoc
 WHERE cs_orden_corte = :al_orden_corte
   AND cs_agrupacion  = :al_agrupacion
   AND cs_base_trazos = :al_base_trazo ;
	
IF SQLCA.SQLCODE = -1 THEN
	ls_error = SQLCA.SqlErrText
	MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de consultar el estado de la O.C. '+ ls_error)
	RETURN -1
END IF	
	
IF (ll_estado_mesa <> 13) AND (ll_estado_mesa <> 14) THEN  //extendido y cortando
   MessageBox("Error","La orden de corte no esta extendida en el PDP de corte")
   RETURN -1
END IF

//Se trae la raya a la que pertenece para luego validar que se este leyendo en orden del PDP:
SELECT MAX(raya) 
  INTO :ll_raya
  FROM dt_rayas_telaxoc
 WHERE cs_orden_corte = :al_orden_corte 
   AND cs_agrupacion  = :al_agrupacion 
   AND cs_base_trazos = :al_base_trazo ;
	
IF SQLCA.SQLCODE = -1 THEN
	ls_error = SQLCA.SqlErrText
	MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de consultar en la raya de la O.C. '+ ls_error)
	RETURN -1
END IF		
	
//Luego se trae la maquina en la que esta montada la orden en el PDP de corte:
 SELECT MAX(co_maquina) 
   INTO :ll_mesa_leer
   FROM dt_simulacion
  WHERE co_tipo_negocio           = 7
    AND co_estado                 = 'A'
    AND trim(co_referencia[9,11]) = :ll_raya
    AND trim(co_referencia[1,6])  = :al_orden_corte
    AND pedido                    = :al_orden_corte ;
	 
IF SQLCA.SQLCODE = -1 THEN
	ls_error = SQLCA.SqlErrText
	MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de consultar la m$$HEX1$$e100$$ENDHEX$$quina de la O.C. '+ ls_error)
	RETURN -1
END IF	

IF IsNull(ll_mesa_leer) OR ll_mesa_leer = 0 THEN
	MessageBox("Advertencia","No existe programaci$$HEX1$$f300$$ENDHEX$$n en el PDP para la O.C.")
	RETURN -1
END IF
	 
//Luego se busca la m$$HEX1$$ed00$$ENDHEX$$nima fecha de programaci$$HEX1$$f300$$ENDHEX$$n en la mesa que encontr$$HEX1$$f300$$ENDHEX$$, 
//para luego buscar esta m$$HEX1$$ed00$$ENDHEX$$nima fecha a que orden de corte pertenece y 
//verificar si es la misma orden de corte que se esta leyendo, 
//si no es se saca un mensaje "No sigue en PDP"  y se vuelve al campo espacio en la ventana:
SELECT MIN(fe_inicio_progs)            
  INTO :ldt_fe_inicio_progs
  FROM dt_simulacion a, 
       dt_rayas_telaxoc d
 WHERE a.co_maquina      = :ll_mesa_leer
   AND a.co_tipo_negocio = 7
   AND a.co_estado       = 'A'
   AND a.pedido          = d.cs_orden_corte
   AND d.co_estado       = 13 ;
	
IF SQLCA.SQLCODE = -1 THEN
	ls_error = SQLCA.SqlErrText
	MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de consultar en el PDP. '+ ls_error)
	RETURN -1
END IF			
	
IF Not IsNull(ldt_fe_inicio_progs) THEN
   SELECT MIN(pedido)
     INTO :ll_oc_a_leer
     FROM dt_simulacion a, 
	       dt_rayas_telaxoc d
    WHERE a.co_maquina                = :ll_mesa_leer
      AND a.co_tipo_negocio           = 7
      AND a.co_estado                 = 'A'
      AND trim(a.co_referencia[9,11]) = 10
      AND a.pedido                    = d.cs_orden_corte
      AND fe_inicio_progs             = :ldt_fe_inicio_progs
      AND d.co_estado                 = 13 ;
		
	IF SQLCA.SQLCODE = -1 THEN
		ls_error = SQLCA.SqlErrText
		MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de consultar la O.C a leer. '+ ls_error)
		RETURN -1
	END IF

	IF ll_oc_a_leer > 0 AND ll_oc_a_leer <> al_orden_corte THEN
		MessageBox("Error","No sigue en PDP")
		em_orden_corte.SetFocus()
		RETURN -1 
	END IF	
END IF

//Se verifica si este es el ultimo espacio que est$$HEX1$$e100$$ENDHEX$$n leyendo de la orden de corte para actualizar el estado en el PDP de corte,  
//si no es el ultimo espacio entonces no se actualiza todav$$HEX1$$ed00$$ENDHEX$$a la orden en el PDP de corte
SELECT COUNT(*)       
  INTO :ll_pendientes
  FROM dt_liquidaxespacio
 WHERE cs_orden_corte = :al_orden_corte
   AND cs_agrupacion  = :al_agrupacion
   AND cs_base_trazos = 1
   AND fe_corte       IS NULL ;
	
IF SQLCA.SQLCODE = -1 THEN
	ls_error = SQLCA.SqlErrText
	MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de consultar el espacio en la O.C. '+ ls_error)
	RETURN -1
END IF		

//Despu$$HEX1$$e900$$ENDHEX$$s ingresa la maquina se verifica que exista asi:
SELECT de_equipos_kanban
  INTO :ls_equipos_kamban
  FROM m_equipos_kanbanc
 WHERE co_equipos_kanban = :al_maquina ;
 
IF SQLCA.SQLCODE = -1 THEN
	ls_error = SQLCA.SqlErrText
	MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de consultar la m$$HEX1$$e100$$ENDHEX$$quina. '+ ls_error)
	RETURN -1
END IF	 

//Si encuentra el equipo hace la siguiente actualizaci$$HEX1$$f300$$ENDHEX$$n:
UPDATE dt_liquidaxespacio
   SET co_equipos_kanban = :al_maquina,
       fe_corte          = Current
 WHERE cs_orden_corte = :al_orden_corte
   AND cs_agrupacion  = :al_agrupacion
   AND cs_base_trazos = :al_base_trazo
   AND cs_trazo       = :al_trazo ;
	
IF SQLCA.SQLCODE = -1 THEN
	ls_error = SQLCA.SqlErrText
	ROLLBACK;
	MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de actualizar la m$$HEX1$$e100$$ENDHEX$$quina. '+ ls_error)
	RETURN -1
END IF	 

//Se mira la variable ll_pendientes para saber si se actualiza la tabla del PDP o No.
IF ll_pendientes = 1 THEN
   UPDATE dt_rayas_telaxoc
      SET co_estado        = 14,  //cortando
          fe_actualizacion = Current
    WHERE cs_orden_corte = :al_orden_corte 
      AND cs_agrupacion  = :al_agrupacion ;
		
	IF SQLCA.SQLCODE = -1 THEN
		ls_error = SQLCA.SqlErrText
		ROLLBACK;
		MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de actualizar el estado de la O.C. '+ ls_error)
		RETURN -1
	END IF		
END IF

//Ahora vamos a actualizar el kamban de corte as$$HEX1$$ed00$$ENDHEX$$:  
//Se verifica si la orden de corte esta en el proceso extendido para actualizarla, de lo contrario no se actualiza

//Consulta el Subcentro de Extendido
ll_subctro_extendido = luo_constantes.of_consultar_numerico("SUBCENTRO EXTENDIDO")
IF ll_subctro_extendido = -1 THEN
	ROLLBACK;
	MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de consultar en m_constantes')
	RETURN -1
END IF

//Consulta el Centro de Corte
ll_ctro_corte = luo_constantes.of_consultar_numerico("CENTRO CORTE")
IF ll_ctro_corte = -1 THEN
	ROLLBACK;
	MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de consultar en m_constantes')
	RETURN -1
END IF
 
//Ahora traemos el subcentro de la orden de corte:
SELECT co_subcentro_pdn
  INTO :ll_subcentro_act
  FROM dt_kamban_corte
 WHERE cs_orden_corte = :al_orden_corte
   AND co_tipoprod    = 1
   AND co_centro_pdn  = :ll_ctro_corte
   AND fe_inicial     IS NOT NULL
   AND fe_final       IS NULL ;
	
IF SQLCA.SQLCODE = -1 THEN
	ls_error = SQLCA.SqlErrText
	ROLLBACK;
	MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de consultar el subcentro de la O.C. '+ ls_error)
	RETURN -1
END IF		

IF ll_subcentro_act = ll_subctro_extendido THEN
   //Actualizamos en el kamban el proceso de extendido en el que se encuentra en la fecha fin
   UPDATE dt_kamban_corte
      SET fe_final = Current
    WHERE cs_orden_corte   = :al_orden_corte
      AND co_tipoprod      = 1
      AND co_centro_pdn    = :ll_ctro_corte
      AND co_subcentro_pdn = :ll_subcentro_act ;
		
	IF SQLCA.SQLCODE = -1 THEN
		ls_error = SQLCA.SqlErrText
		ROLLBACK;
		MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de actualizar fe_final en el kamban. '+ ls_error)
		RETURN -1
	END IF			
	
	//Consulta el Subcentro de Preparaci$$HEX1$$f300$$ENDHEX$$n
	ll_subcentro_preparacion = luo_constantes.of_consultar_numerico("SUBCENTRO PREPARACIO")
	IF ll_subcentro_preparacion = -1 THEN
		ROLLBACK;
		MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de consultar el subcentro')
		RETURN -1
	END IF	
	
	UPDATE dt_kamban_corte
		SET fe_inicial = Current
	 WHERE cs_orden_corte   = :al_orden_corte
	   AND co_tipoprod      = 1
	   AND co_centro_pdn    = :ll_ctro_corte
	   AND co_subcentro_pdn = :ll_subcentro_preparacion ;
		
	IF SQLCA.SQLCODE = -1 THEN
		ls_error = SQLCA.SqlErrText
		ROLLBACK;
		MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de actualizar fe_inicial en el kamban. '+ ls_error)
		RETURN -1
	END IF		
		
END IF

RETURN 1
end function

on w_actualiza_maquina_corte.create
int iCurrent
call super::create
this.em_orden_corte=create em_orden_corte
this.st_1=create st_1
this.cb_1=create cb_1
this.cb_2=create cb_2
this.em_maquina=create em_maquina
this.st_2=create st_2
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.em_orden_corte
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.cb_1
this.Control[iCurrent+4]=this.cb_2
this.Control[iCurrent+5]=this.em_maquina
this.Control[iCurrent+6]=this.st_2
this.Control[iCurrent+7]=this.gb_1
end on

on w_actualiza_maquina_corte.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.em_orden_corte)
destroy(this.st_1)
destroy(this.cb_1)
destroy(this.cb_2)
destroy(this.em_maquina)
destroy(this.st_2)
destroy(this.gb_1)
end on

event open;//

IF (f_deshabilitar_opciones(this.classname(),this.menuid)= -1) THEN
	Close(This)
END IF
end event

type dw_maestro from w_base_pda`dw_maestro within w_actualiza_maquina_corte
boolean visible = false
integer x = 347
integer y = 716
integer width = 663
integer height = 200
end type

type em_orden_corte from editmask within w_actualiza_maquina_corte
integer x = 590
integer y = 92
integer width = 718
integer height = 108
integer taborder = 10
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
string mask = "####################"
end type

type st_1 from statictext within w_actualiza_maquina_corte
integer x = 64
integer y = 108
integer width = 517
integer height = 88
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Orden de Corte:"
boolean focusrectangle = false
end type

type cb_1 from commandbutton within w_actualiza_maquina_corte
integer x = 288
integer y = 460
integer width = 343
integer height = 100
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Aceptar"
end type

event clicked;LONG   ll_orden_corte, ll_agrupacion, ll_base_trazo, ll_trazo, ll_maquina

ll_orden_corte = Long(Mid(em_orden_corte.text,1,6))
ll_agrupacion  = Long(Mid(em_orden_corte.text,7,6))
ll_base_trazo  = Long(Mid(em_orden_corte.text,13,2))
ll_trazo       = Long(Mid(em_orden_corte.text,15,2))
ll_maquina     = Long(em_maquina.text)

IF of_actualiza_maquina(ll_orden_corte,ll_agrupacion,ll_base_trazo,ll_trazo,ll_maquina) = 1 THEN
	COMMIT;
	MessageBox("Exito","Se actualiz$$HEX2$$f3002000$$ENDHEX$$con $$HEX1$$e900$$ENDHEX$$xito la informaci$$HEX1$$f300$$ENDHEX$$n")
ELSE
	ROLLBACK;
	MessageBox("Error","Ocurri$$HEX2$$f3002000$$ENDHEX$$un error actualizando la informaci$$HEX1$$f300$$ENDHEX$$n")
END IF
end event

type cb_2 from commandbutton within w_actualiza_maquina_corte
integer x = 731
integer y = 460
integer width = 343
integer height = 100
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancelar"
end type

event clicked;Close(w_actualiza_maquina_corte)
end event

type em_maquina from editmask within w_actualiza_maquina_corte
integer x = 590
integer y = 240
integer width = 343
integer height = 108
integer taborder = 20
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
string mask = "######"
end type

type st_2 from statictext within w_actualiza_maquina_corte
integer x = 251
integer y = 256
integer width = 329
integer height = 88
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "M$$HEX1$$e100$$ENDHEX$$quina:"
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_actualiza_maquina_corte
integer x = 37
integer y = 8
integer width = 1381
integer height = 400
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
end type

