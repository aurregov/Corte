HA$PBExportHeader$w_devolucion_rollos.srw
forward
global type w_devolucion_rollos from w_base_maestrotb_detalletb
end type
type pb_devolver from picturebutton within w_devolucion_rollos
end type
type pb_cerrar from picturebutton within w_devolucion_rollos
end type
type pb_imprimir from picturebutton within w_devolucion_rollos
end type
type st_adhesivo from statictext within w_devolucion_rollos
end type
type gb_imprimir from groupbox within w_devolucion_rollos
end type
type dw_1 from datawindow within w_devolucion_rollos
end type
type sle_1 from singlelineedit within w_devolucion_rollos
end type
type st_2 from statictext within w_devolucion_rollos
end type
type st_3 from statictext within w_devolucion_rollos
end type
type gb_1 from groupbox within w_devolucion_rollos
end type
type dw_3 from datawindow within w_devolucion_rollos
end type
type dw_2 from datawindow within w_devolucion_rollos
end type
end forward

global type w_devolucion_rollos from w_base_maestrotb_detalletb
integer width = 3515
integer height = 1428
string title = "Movimientos de rollos de Corte para el Almacen de Telas"
pb_devolver pb_devolver
pb_cerrar pb_cerrar
pb_imprimir pb_imprimir
st_adhesivo st_adhesivo
gb_imprimir gb_imprimir
dw_1 dw_1
sle_1 sle_1
st_2 st_2
st_3 st_3
gb_1 gb_1
dw_3 dw_3
dw_2 dw_2
end type
global w_devolucion_rollos w_devolucion_rollos

type variables
Transaction itr_tela
long il_fila_actual,il_rollo,il_caract,il_diametro
LONG il_fabrica_tela,il_reftel,il_color_tela,il_unidades,il_insertados,il_ordencorte,il_motivo_dev
STRING is_tono,is_usuario,is_grupo
DECIMAL id_ca_tela,id_tela_metros

end variables

on w_devolucion_rollos.create
int iCurrent
call super::create
this.pb_devolver=create pb_devolver
this.pb_cerrar=create pb_cerrar
this.pb_imprimir=create pb_imprimir
this.st_adhesivo=create st_adhesivo
this.gb_imprimir=create gb_imprimir
this.dw_1=create dw_1
this.sle_1=create sle_1
this.st_2=create st_2
this.st_3=create st_3
this.gb_1=create gb_1
this.dw_3=create dw_3
this.dw_2=create dw_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_devolver
this.Control[iCurrent+2]=this.pb_cerrar
this.Control[iCurrent+3]=this.pb_imprimir
this.Control[iCurrent+4]=this.st_adhesivo
this.Control[iCurrent+5]=this.gb_imprimir
this.Control[iCurrent+6]=this.dw_1
this.Control[iCurrent+7]=this.sle_1
this.Control[iCurrent+8]=this.st_2
this.Control[iCurrent+9]=this.st_3
this.Control[iCurrent+10]=this.gb_1
this.Control[iCurrent+11]=this.dw_3
this.Control[iCurrent+12]=this.dw_2
end on

on w_devolucion_rollos.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_devolver)
destroy(this.pb_cerrar)
destroy(this.pb_imprimir)
destroy(this.st_adhesivo)
destroy(this.gb_imprimir)
destroy(this.dw_1)
destroy(this.sle_1)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.gb_1)
destroy(this.dw_3)
destroy(this.dw_2)
end on

event open;This.width = 3470
This.height = 1428

 dw_maestro.SetTransObject(SQLCA)
 dw_detalle.SetTransObject(SQLCA) 
 dw_1.SetTransObject(SQLCA)  
 dw_2.SetTransObject(SQLCA) 
 dw_3.SetTransObject(SQLCA) 
 DELETE FROM t_devolrollos  ;

end event

event ue_borrar_maestro;call super::ue_borrar_maestro;//nada
end event

event ue_insertar_detalle;
Long ll_fila,ll_contador

ll_fila = dw_detalle.InsertRow(0)
IF ll_fila = -1 THEN
	MessageBox("Error datawindow","No se pudo insertar el registro del maestro",StopSign!,Ok!)
ELSE
	dw_detalle.SetRow(ll_fila)
	dw_detalle.ScrollToRow(ll_fila)
	dw_detalle.SetColumn(1)
	dw_detalle.SelectRow(0,False)
	il_fila_actual_detalle = ll_fila
END IF

dw_detalle.SelectRow(il_fila_actual_detalle,FALSE)
il_fila_actual_detalle = dw_detalle.GetRow()
  

IF ((il_fila_actual_detalle<> -1) and &
     (NOT ISNULL (il_fila_actual_detalle)) and &
	  (il_fila_actual_detalle>0))THEN
     dw_detalle.SelectRow(il_fila_actual_detalle,TRUE)
  
  SELECT count(*)  
    INTO :ll_contador  
    FROM t_devolrollos  ;
IF isnull(ll_contador) then
dw_detalle.SetItem(il_fila_actual_detalle, "item", ll_contador)
ELSE 
ll_contador = ll_contador + 1
dw_detalle.SetItem(il_fila_actual_detalle, "item", ll_contador)
END IF

dw_detalle.SetItem(il_fila_actual_detalle, "cs_rollo", il_rollo)
dw_detalle.SetItem(il_fila_actual_detalle, "co_fabrica_act", il_fabrica_tela)
dw_detalle.SetItem(il_fila_actual_detalle, "co_reftel_act", il_reftel)
dw_detalle.SetItem(il_fila_actual_detalle, "co_color_act", il_color_tela)
dw_detalle.SetItem(il_fila_actual_detalle, "diametro_act", il_diametro)
dw_detalle.SetItem(il_fila_actual_detalle, "co_caract_act", il_caract)
dw_detalle.SetItem(il_fila_actual_detalle, "tono", is_tono)
dw_detalle.SetItem(il_fila_actual_detalle, "ca_kg", id_ca_tela)
dw_detalle.SetItem(il_fila_actual_detalle, "ca_kg_metros", id_tela_metros)
dw_detalle.SetItem(il_fila_actual_detalle, "usuario", gstr_info_usuario.codigo_usuario)
dw_detalle.SetItem(il_fila_actual_detalle, "grupo", is_grupo)
dw_detalle.SetItem(il_fila_actual_detalle, "indicador", '0')
dw_detalle.SetItem(il_fila_actual_detalle, "cs_ordencorte", il_ordencorte)
dw_detalle.SetItem(il_fila_actual_detalle, "motivo_dev", 0)

ELSE
END IF
This.TriggerEvent("ue_grabar")
end event

event ue_insertar_maestro;//nada
end event

event ue_buscar;long ll_cs_rollo

Trim(sle_argumento.Text)
ll_cs_rollo		=	Long(sle_argumento.Text)
dw_maestro.Retrieve( ll_cs_rollo)
il_fila_actual_maestro = 1
dw_maestro.SetRow(il_fila_actual_maestro)
dw_maestro.SetColumn(1)
dw_maestro.SetFocus()
end event

type dw_maestro from w_base_maestrotb_detalletb`dw_maestro within w_devolucion_rollos
integer x = 27
integer y = 148
integer width = 2981
integer height = 376
integer taborder = 0
string title = "B$$HEX1$$fa00$$ENDHEX$$squeda de rollos"
string dataobject = "dtb_devolucion_rollo"
boolean hscrollbar = false
boolean vscrollbar = false
end type

event dw_maestro::doubleclicked;call super::doubleclicked;//////////////////////////////////////////////////////////////////////
// Se evalua si se hizo click sobre una fila valida
//////////////////////////////////////////////////////////////////////
long ll_fabrica_tela,ll_contador

IF row <> 0 AND row <> -1 AND NOT IsNull(row) THEN
	This.SelectRow(il_fila_actual_maestro,FALSE)
	il_fila_actual_maestro = row
ELSE
END IF


il_rollo				= dw_maestro.GetItemNumber(il_fila_actual_maestro, "cs_rollo")
il_fabrica_tela 	= dw_maestro.GetItemNumber(il_fila_actual_maestro, "co_fabrica_act")
il_reftel 			= dw_maestro.GetItemNumber(il_fila_actual_maestro, "co_reftel_act")
il_color_tela 		= dw_maestro.GetItemNumber(il_fila_actual_maestro, "co_color_act")
il_diametro			= dw_maestro.GetItemNumber(il_fila_actual_maestro, "diametro_act")
il_caract 			= dw_maestro.GetItemNumber(il_fila_actual_maestro, "co_caract_act")
is_tono 				= dw_maestro.GetItemString(il_fila_actual_maestro, "co_tono_cli")
id_ca_tela 			= dw_maestro.GetItemNumber(il_fila_actual_maestro, "ca_kg")
id_tela_metros		= dw_maestro.GetItemNumber(il_fila_actual_maestro, "ca_mt")
is_grupo				= dw_maestro.GetItemString(il_fila_actual_maestro, "co_grupo_cte")
il_ordencorte		= dw_maestro.GetItemNumber(il_fila_actual_maestro, "cs_ordencr")
is_usuario			= gstr_info_usuario.codigo_usuario

parent.triggerevent("ue_insertar_detalle")
		dw_detalle.AcceptText()
		COMMIT; 
  


end event

event dw_maestro::itemchanged;//nada
end event

type sle_argumento from w_base_maestrotb_detalletb`sle_argumento within w_devolucion_rollos
integer x = 421
integer height = 76
integer taborder = 10
end type

event sle_argumento::getfocus;call super::getfocus;sle_argumento.SelectText(1, Len(sle_argumento.Text))
end event

type st_1 from w_base_maestrotb_detalletb`st_1 within w_devolucion_rollos
integer width = 357
string text = "Buscar por rollo:"
end type

type dw_detalle from w_base_maestrotb_detalletb`dw_detalle within w_devolucion_rollos
integer x = 23
integer y = 524
integer width = 2990
integer height = 772
integer taborder = 0
string title = "Rollos seleccionados"
string dataobject = "dtb_rollos_devolucion"
end type

event dw_detalle::itemchanged;//STRING ls_indicador
//LONG ll_rollo
//dw_detalle.AcceptText()		
//IF dwo.Name = "motivo_dev"  THEN
//	IF il_fila_actual_detalle > 0 THEN
//		il_motivo_dev = long(data)
//	  	//dw_detalle.SetItem(il_fila_actual_detalle, "motivo_dev", il_motivo_dev)
//	   ll_rollo	= dw_detalle.GetItemNumber(il_fila_actual_detalle, "cs_rollo")
//		UPDATE t_devolrollos  
//     	SET motivo_dev = :il_motivo_dev  
//   	WHERE t_devolrollos.cs_rollo = :ll_rollo;
//		This.TriggerEvent("ue_grabar")
//	ELSE
//	END IF		
//ELSE
//END IF
////
////IF dwo.Name = "indicador"  THEN
////	IF il_fila_actual_detalle > 0 THEN
////		ls_indicador = data
////		
////		This.TriggerEvent("ue_grabar")
////	ELSE
////	END IF		
////ELSE
////END IF
////
////
end event

type pb_devolver from picturebutton within w_devolucion_rollos
integer x = 3054
integer y = 28
integer width = 357
integer height = 140
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "Devolver"
string picturename = "k:\aplicaciones\graficos\ok.bmp"
alignment htextalign = right!
vtextalign vtextalign = multiline!
end type

event clicked;long ll_rollo,ll_caract,ll_diametro,ll_contador,ll_documento,ll_consecutivo,ll_fabrica_exp
LONG ll_fabrica_tela,ll_reftel,ll_color_tela,ll_unidades,ll_pedido,ll_cs_liberacion,Job
LONG ll_fabrica_pt, ll_co_linea,ll_co_referencia,ll_color_pt,ll_ordencorte,ll_motivo
STRING ls_tono,ls_grupo,ls_nu_orden,ls_tono1,ls_placa
DECIMAL ld_ca_tela,ld_metros_tela
DATETIME ld_anomes
ls_placa= trim(sle_1.text)
IF ls_placa ='' THEN
	Messagebox("Error","Debe digitar la placa del vehiculo que transportar$$HEX2$$e1002000$$ENDHEX$$la tela",Exclamation!,Ok!)	
	sle_1.SetFocus()
ELSE

IF is_accion = "si update" THEN
	IF dw_detalle.AcceptText() = -1 THEN
		is_accion = "no accepttext"
		MessageBox("Error","No se pudieron realizar los cambios en el detalle",Exclamation!,Ok!)	
		RETURN
	ELSE
		IF dw_detalle.Update() = -1 THEN
			is_accion = "no update"
			ROLLBACK;
			MessageBox("Error","No se pudo hacer los cambios en el detalle para la base de datos",Exclamation!,Ok!)	
			RETURN
		ELSE
			is_accion = "si update"
			COMMIT;
			IF sqlca.sqlcode = -1 THEN
				is_grabada = "no"
				MessageBox("Error","No se pudo hacer los cambios en el detalle para la base de datos" &
								,Exclamation!,Ok!)	
			ELSE
				is_grabada = "si"
			END IF
		END IF
	END IF
END IF
  UPDATE t_devolrollos  
     SET placa_camion = :ls_placa  ;

 DECLARE cur_rollos CURSOR FOR  
  SELECT t_devolrollos.cs_rollo,   
         t_devolrollos.co_fabrica_act,   
         t_devolrollos.co_reftel_act,   
         t_devolrollos.co_caract_act,   
         t_devolrollos.diametro_act,   
         t_devolrollos.co_color_act,
			t_devolrollos.tono,
         t_devolrollos.ca_kg,
			t_devolrollos.ca_kg_metros,
         t_devolrollos.item, 
			t_devolrollos.grupo,
			t_devolrollos.cs_ordencorte,
			t_devolrollos.motivo_dev
    FROM t_devolrollos;

OPEN cur_rollos;
FETCH cur_rollos into:ll_rollo,:ll_fabrica_tela,:ll_reftel,:ll_caract,:ll_diametro,:ll_color_tela,:ls_tono,:ld_ca_tela,:ld_metros_tela,:ll_contador,:ls_grupo,:ll_ordencorte,:ll_motivo;

  SELECT m_remision_rol.cs_remision  
    INTO :ll_consecutivo  
    FROM m_remision_rol  
   WHERE ( m_remision_rol.origen = 90 ) AND  
         ( m_remision_rol.destino = 21 )   ;

		ll_consecutivo = ll_consecutivo +1	
		
		  UPDATE m_remision_rol  
     SET cs_remision = :ll_consecutivo  
   WHERE ( m_remision_rol.origen = 90 ) AND  
         ( m_remision_rol.destino = 21 )   
           ;

DO WHILE SQLCA.SQLCODE=0  

	IF ll_motivo = 1 THEN
  	   UPDATE m_rollo  
		  SET //co_centro 			= 	21,
		  		cs_ordencr 			= 	0,  
				co_estado_rollo	= 	2,  
				marca 				= 	4,
				bodega				=	21,
				placa_camion 		= 	:ls_placa, 
				carrito 				= 	0 , 
				cs_remision			=  :ll_consecutivo
		WHERE m_rollo.cs_rollo = 	:ll_rollo   ;
		IF SQLCA.SQLCODE=-1 THEN
			MESSAGEBOX("ERROR BASE DATOS","NO PUDO ACTUALIZAR ROLLOS")
		 RETURN
		ELSE
		END IF
	ELSE
		ls_tono1 = "$" + ls_tono
		UPDATE m_rollo  
		  SET //co_centro 			= 	21,
		  		cs_ordencr 			= 	0,  
				co_estado_rollo	= 	2,  
				marca 				= 	4,
				bodega				=	21,	
				placa_camion 		= 	:ls_placa, 
				carrito 				= 	0,
				co_tono_cli			= :ls_tono1,
				cs_remision			=  :ll_consecutivo
		WHERE m_rollo.cs_rollo 	= 	:ll_rollo   ;
		IF SQLCA.SQLCODE=-1 THEN
			MESSAGEBOX("ERROR BASE DATOS","NO PUDO ACTUALIZAR ROLLOS")
		 RETURN
		ELSE
		END IF
	END IF
	
  INSERT INTO m_rollosdev  
         ( cs_ordencr,   
           cs_rollo,   
           co_fabrica,   
           co_reftel,   
           co_color,   
           co_tono,   
           ca_yds,   
           co_grupo_cte,   
           motivo_dev,   
           fe_actualizacion,   
           usuario,   
           instancia)  
  VALUES ( :ll_ordencorte,   
           :ll_rollo,   
           :ll_fabrica_tela,   
           :ll_reftel,   
           :ll_color_tela,   
           :ls_tono,   
           :ld_ca_tela,   
           :ls_grupo,   
           :ll_motivo,   
           current,   
           :is_usuario,   
           'nicoledb');

	
	
	
//	** actualiza el documento de la tabla temporal **//
  UPDATE t_devolrollos  
     SET documento = :ll_consecutivo  
   WHERE t_devolrollos.cs_rollo = :ll_rollo;
	
	//** toma la fabrica y el pedido alocation del grupo **//
  SELECT   peddig.co_fabrica_vta,   
           peddig.pedido 
  	 INTO  :ll_fabrica_exp, :ll_pedido
    FROM  peddig  
   WHERE ( peddig.gpa = :ls_grupo ) AND  
         ( peddig.tipo_pedido = 'AL' ) ;
	
	//** toma la maxima liberacion **//
	SELECT MAX(dt_telaxmodelo_lib.cs_liberacion )
	  INTO   :ll_cs_liberacion
		 FROM dt_telaxmodelo_lib  
		WHERE ( dt_telaxmodelo_lib.co_fabrica_exp = :ll_fabrica_exp )AND
				( dt_telaxmodelo_lib.pedido = :ll_pedido ) AND  
				( dt_telaxmodelo_lib.cs_estilocolortono = 1 ) AND  
				( dt_telaxmodelo_lib.co_fabrica_tela = :ll_fabrica_tela ) AND  
				( dt_telaxmodelo_lib.co_reftel = :ll_reftel ) AND  
				( dt_telaxmodelo_lib.co_caract = :ll_caract) AND
				( dt_telaxmodelo_lib.diametro = 	:ll_diametro) AND
				( dt_telaxmodelo_lib.co_color_tela = :ll_color_tela ) AND  
				( dt_telaxmodelo_lib.tono = :ls_tono )  ;
	
  //** toma datos adicionales para completar la llave **//			
  SELECT dt_telaxmodelo_lib.nu_orden,   
         dt_telaxmodelo_lib.co_fabrica_pt,   
         dt_telaxmodelo_lib.co_linea,   
         dt_telaxmodelo_lib.co_referencia,   
         dt_telaxmodelo_lib.co_color_pt 
	 INTO :ls_nu_orden,:ll_fabrica_pt, :ll_co_linea,:ll_co_referencia,:ll_color_pt
    FROM dt_telaxmodelo_lib  
   WHERE 	( dt_telaxmodelo_lib.co_fabrica_exp = :ll_fabrica_exp )AND
				( dt_telaxmodelo_lib.pedido = :ll_pedido ) AND  
				( dt_telaxmodelo_lib.cs_estilocolortono = 1 ) AND  
				( dt_telaxmodelo_lib.co_fabrica_tela = :ll_fabrica_tela ) AND  
				( dt_telaxmodelo_lib.co_reftel = :ll_reftel ) AND  
				( dt_telaxmodelo_lib.co_caract = :ll_caract) AND
				( dt_telaxmodelo_lib.diametro = 	:ll_diametro) AND
				( dt_telaxmodelo_lib.co_color_tela = :ll_color_tela ) AND  
				( dt_telaxmodelo_lib.tono = :ls_tono )  AND
			   ( dt_telaxmodelo_lib.cs_liberacion = :ll_cs_liberacion ) AND  
         	( dt_telaxmodelo_lib.ca_unidades = (  SELECT MAX(dt_telaxmodelo_lib.ca_unidades)  
																	 FROM dt_telaxmodelo_lib  
																	WHERE ( dt_telaxmodelo_lib.co_fabrica_exp = :ll_fabrica_exp )AND
																			( dt_telaxmodelo_lib.pedido = :ll_pedido ) AND  
																			( dt_telaxmodelo_lib.cs_estilocolortono = 1 ) AND  
																			( dt_telaxmodelo_lib.co_fabrica_tela = :ll_fabrica_tela ) AND  
																			( dt_telaxmodelo_lib.co_reftel = :ll_reftel ) AND  
																			( dt_telaxmodelo_lib.co_caract = :ll_caract) AND
																			( dt_telaxmodelo_lib.diametro = 	:ll_diametro) AND
																			( dt_telaxmodelo_lib.co_color_tela = :ll_color_tela ) AND  
																			( dt_telaxmodelo_lib.tono = :ls_tono ) AND
																			( dt_telaxmodelo_lib.cs_liberacion = :ll_cs_liberacion )) ) 

	GROUP BY dt_telaxmodelo_lib.nu_orden,   
				dt_telaxmodelo_lib.co_fabrica_pt,   
				dt_telaxmodelo_lib.co_linea,   
				dt_telaxmodelo_lib.co_referencia,   
				dt_telaxmodelo_lib.co_color_pt  ; 
				
// ** Actualiza la cantidad de tela a devolver **//
 
  UPDATE dt_telaxmodelo_lib  
     SET tela_dev = :ld_ca_tela  
   WHERE ( dt_telaxmodelo_lib.co_fabrica_exp = :ll_fabrica_exp ) AND  
         ( dt_telaxmodelo_lib.pedido = :ll_pedido ) AND  
         ( dt_telaxmodelo_lib.cs_liberacion = :ll_cs_liberacion ) AND  
         ( dt_telaxmodelo_lib.nu_orden = :ls_nu_orden ) AND  
         ( dt_telaxmodelo_lib.co_fabrica_pt = :ll_fabrica_pt ) AND  
         ( dt_telaxmodelo_lib.co_linea = :ll_co_linea ) AND  
         ( dt_telaxmodelo_lib.co_referencia = :ll_co_referencia ) AND  
         ( dt_telaxmodelo_lib.co_color_pt = :ll_color_pt ) AND  
         ( dt_telaxmodelo_lib.tono = :ls_tono ) AND  
         ( dt_telaxmodelo_lib.cs_estilocolortono = 1 ) AND  
         ( dt_telaxmodelo_lib.co_fabrica_tela = :ll_fabrica_tela ) AND  
         ( dt_telaxmodelo_lib.co_reftel = :ll_reftel ) AND  
         ( dt_telaxmodelo_lib.co_color_tela = :ll_color_tela );

	
	FETCH cur_rollos into:ll_rollo,:ll_fabrica_tela,:ll_reftel,:ll_caract,:ll_diametro,:ll_color_tela,:ls_tono,:ld_ca_tela,:ld_metros_tela,:ll_contador,:ls_grupo,:ll_ordencorte,:ll_motivo;

LOOP  
 
 CLOSE cur_rollos;
 dw_2.Retrieve()
 OpenWithParm(w_opciones_impresion, dw_2)

 COMMIT;
 dw_3.Retrieve()
 dw_3.SaveAs("C:\Mis documentos\Tela_devolucion.htm",HTMLTable!	,false)
			
mailSession lms_sesion
mailReturnCode lmrt_retorno
mailMessage lmsg_mensaje
MailFileDescription lmf_attachment

s_base_parametros lstr_parametros

lstr_parametros.cadena[1] = "Generando Mensajes ..."
lstr_parametros.cadena[2] = "Espere un momento por favor, esta operacion pude durar unos segundos..."
lstr_parametros.cadena[3] = "reloj"

OpenWithParm(w_retroalimentacion,lstr_parametros)


IF SQLCA.SQLCode = 0 THEN
	lms_sesion = create mailSession

	lmrt_retorno = lms_sesion.mailLogon(mailNewSession!)

	IF lmrt_retorno <> mailReturnSuccess! THEN
		MessageBox("Error Correo", 'Error al establecer la sesi$$HEX1$$f300$$ENDHEX$$n de correo')
		RETURN(1)
	END IF
END IF
lmsg_mensaje.Subject =  'Devoluci$$HEX1$$f300$$ENDHEX$$n de tela'
 
// lmsg_mensaje.NoteText = 'Fabrica: '+ TRIM(string(il_fabrica)) + TRIM(string(il_reftel)) + TRIM(string(is_destela)) + TRIM(string(il_colortela)) + TRIM(string(is_decolor)) +  TRIM(string(is_tono)) +  TRIM(string(id_catela))                                      

   lmsg_mensaje.AttachmentFile[1].fileType	=	mailAttach!
	lmsg_mensaje.AttachmentFile[1].FileName	=	"Tela_devolucion.htm"
	lmsg_mensaje.AttachmentFile[1].PathName	= "C:\Mis documentos\Tela_devolucion.htm" 
	lmsg_mensaje.AttachmentFile[1].Position	=	 - 1	
	
	lmsg_mensaje.Recipient[1].name = 'Lucky Brand Nicole' 
	lmsg_mensaje.Recipient[2].name = 'Kenneth Cole Nicole' 
	lmsg_mensaje.Recipient[3].name = 'DKNY Nicole' 
	lmsg_mensaje.Recipient[4].name = 'Replenishment Nicole' 
	lmsg_mensaje.Recipient[5].name = 'Liz Claiborne Nicole' 
	lmsg_mensaje.Recipient[6].name = 'Jones New York Nicole' 
	lmsg_mensaje.Recipient[7].name = 'Programadores Orden Corte' 
	lmsg_mensaje.Recipient[8].name = 'Jorge Eduardo Delgado' 
	lmsg_mensaje.Recipient[9].name = 'Calidad de Telas' 
	lmsg_mensaje.Recipient[10].name = 'Anselma Rodriguez' 
	lmsg_mensaje.Recipient[11].name = 'Jose Fernando Yazo Vargas' 
	lmsg_mensaje.Recipient[12].name = 'Almacen de Telas' 
	lmsg_mensaje.Recipient[13].name = 'Angela Maria Escobar Rendon' 
// lmsg_mensaje.Recipient[1].name = 'Hector Fabio Arango' 
	
	lmrt_retorno = lms_sesion.mailResolveRecipient(lmsg_mensaje.Recipient[1])
	
	IF lmrt_retorno = mailReturnSuccess! THEN
	ELSEIF lmrt_retorno = mailReturnFailure! THEN
		MessageBox("Error Correo", "No se pudo encontrar una direcci$$HEX1$$f300$$ENDHEX$$n de correo para el usuario")
		Return(1)
	ELSE
		MessageBox("Error Correo", "No se pudo encontrar una direcci$$HEX1$$f300$$ENDHEX$$n de correo para el usuario")
		Return(1)
	END IF		

	lmrt_retorno = lms_sesion.mailSend(lmsg_mensaje)

	IF lmrt_retorno <> mailReturnSuccess! THEN
		MessageBox("Error Correo", 'Error al enviar el mensaje de correo')
		RETURN(1)
	END IF	
	
lms_sesion.mailLogoff()

DESTROY lms_sesion	

Close(w_retroalimentacion)
Return(0)
END IF

end event

type pb_cerrar from picturebutton within w_devolucion_rollos
integer x = 3063
integer y = 276
integer width = 357
integer height = 140
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "Cerrar"
string picturename = "k:\desarrollo\graficos\cancelar.bmp"
alignment htextalign = right!
end type

event clicked;//Close(w_devolucion_rollos)
Close(parent)
end event

type pb_imprimir from picturebutton within w_devolucion_rollos
integer x = 3122
integer y = 752
integer width = 201
integer height = 176
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string pointer = "HyperLink!"
string picturename = "Print!"
alignment htextalign = left!
end type

event clicked;//Actualiza el archivo temporal para imprimir adhesivos //

IF is_accion = "si update" THEN
	IF dw_detalle.AcceptText() = -1 THEN
		is_accion = "no accepttext"
		MessageBox("Error","No se pudieron realizar los cambios en el detalle",Exclamation!,Ok!)	
		RETURN
	ELSE
		IF dw_detalle.Update() = -1 THEN
			is_accion = "no update"
			ROLLBACK;
			MessageBox("Error","No se pudo hacer los cambios en el detalle para la base de datos",Exclamation!,Ok!)	
			RETURN
		ELSE
			is_accion = "si update"
			COMMIT;
			IF sqlca.sqlcode = -1 THEN
				is_grabada = "no"
				MessageBox("Error","No se pudo hacer los cambios en el detalle para la base de datos" &
								,Exclamation!,Ok!)	
			ELSE
				is_grabada = "si"
			END IF
		END IF
	END IF
END IF

 dw_1.Retrieve()
 dw_1.setFocus()
OpenWithParm(w_opciones_impresion, dw_1)



end event

type st_adhesivo from statictext within w_devolucion_rollos
integer x = 3058
integer y = 576
integer width = 224
integer height = 52
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 255
long backcolor = 67108864
string text = "Adhesivo"
boolean focusrectangle = false
end type

type gb_imprimir from groupbox within w_devolucion_rollos
integer x = 3031
integer y = 528
integer width = 384
integer height = 564
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 255
long backcolor = 67108864
string text = "Imprimir"
end type

type dw_1 from datawindow within w_devolucion_rollos
integer x = 1449
integer y = 596
integer width = 1435
integer height = 692
integer taborder = 60
string title = "none"
string dataobject = "dff_adhesivos_rollos"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type sle_1 from singlelineedit within w_devolucion_rollos
integer x = 2304
integer y = 36
integer width = 402
integer height = 92
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
textcase textcase = upper!
integer limit = 7
borderstyle borderstyle = stylelowered!
end type

type st_2 from statictext within w_devolucion_rollos
integer x = 1742
integer y = 28
integer width = 530
integer height = 52
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 255
long backcolor = 67108864
string text = "Placa del vehiculo que"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_3 from statictext within w_devolucion_rollos
integer x = 1742
integer y = 76
integer width = 530
integer height = 52
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 255
long backcolor = 67108864
string text = "transportar$$HEX2$$e1002000$$ENDHEX$$la tela"
alignment alignment = right!
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_devolucion_rollos
integer x = 1733
integer width = 558
integer height = 148
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 255
long backcolor = 67108864
end type

type dw_3 from datawindow within w_devolucion_rollos
boolean visible = false
integer x = 32
integer y = 876
integer width = 3424
integer height = 400
string title = "none"
string dataobject = "dtb_tela_devolucion"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_2 from datawindow within w_devolucion_rollos
boolean visible = false
integer x = 50
integer y = 1136
integer width = 2853
integer height = 400
string title = "none"
string dataobject = "dtb_remision_rollos"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

