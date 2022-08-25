HA$PBExportHeader$w_movimientos_de_rollos.srw
forward
global type w_movimientos_de_rollos from w_base_maestrotb_detalletb
end type
type dw_2 from datawindow within w_movimientos_de_rollos
end type
type pb_1 from picturebutton within w_movimientos_de_rollos
end type
type pb_2 from picturebutton within w_movimientos_de_rollos
end type
type pb_3 from picturebutton within w_movimientos_de_rollos
end type
type st_3 from statictext within w_movimientos_de_rollos
end type
type gb_1 from groupbox within w_movimientos_de_rollos
end type
end forward

global type w_movimientos_de_rollos from w_base_maestrotb_detalletb
integer width = 3392
integer height = 1416
dw_2 dw_2
pb_1 pb_1
pb_2 pb_2
pb_3 pb_3
st_3 st_3
gb_1 gb_1
end type
global w_movimientos_de_rollos w_movimientos_de_rollos

type variables
Transaction itr_tela
long il_fila_actual,il_rollo,il_caract,il_diametro
LONG il_fabrica_tela,il_reftel,il_color_tela,il_unidades,il_insertados
STRING is_tono,is_usuario,is_grupo
DECIMAL id_ca_tela,id_tela_metros

end variables

on w_movimientos_de_rollos.create
int iCurrent
call super::create
this.dw_2=create dw_2
this.pb_1=create pb_1
this.pb_2=create pb_2
this.pb_3=create pb_3
this.st_3=create st_3
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_2
this.Control[iCurrent+2]=this.pb_1
this.Control[iCurrent+3]=this.pb_2
this.Control[iCurrent+4]=this.pb_3
this.Control[iCurrent+5]=this.st_3
this.Control[iCurrent+6]=this.gb_1
end on

on w_movimientos_de_rollos.destroy
call super::destroy
destroy(this.dw_2)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.pb_3)
destroy(this.st_3)
destroy(this.gb_1)
end on

event open;This.width = 3282
This.height = 1396

 dw_maestro.SetTransObject(SQLCA)
 dw_detalle.SetTransObject(SQLCA) 
 dw_2.SetTransObject(SQLCA)  
	DELETE FROM t_devolrollos  ;

end event

event ue_borrar_maestro;call super::ue_borrar_maestro;//nada
end event

event ue_grabar;/////////////////////////////////////////////////////////////////////
// En este evento se realiza el ACCEPTTEXT para llevar los
// datos al buffer. El UPDATE() para preparar los datos a grabar y
// el COMMIT, para grabar los cambios en la base de datos
/////////////////////////////////////////////////////////////////////

IF dw_detalle.AcceptText() = -1 THEN
	is_accion = "no accepttext"
	Messagebox("Error","No se pudieron realizar los cambios en el maestro" &
	           ,Exclamation!,Ok!)	
	RETURN
ELSE
	IF dw_detalle.Update() = -1 THEN
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

event ue_insertar_detalle;call super::ue_insertar_detalle;
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
     (NOT ISNULL (il_fila_actual)) and &
	  (il_fila_actual>0))THEN
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
ELSE
END IF
This.TriggerEvent("ue_grabar")
end event

event ue_insertar_maestro;//nada
end event

type dw_maestro from w_base_maestrotb_detalletb`dw_maestro within w_movimientos_de_rollos
integer x = 46
integer y = 128
integer width = 2757
integer height = 452
string title = "B$$HEX1$$fa00$$ENDHEX$$squeda de rollos"
string dataobject = "dtb_devolucion_rollo"
boolean hscrollbar = false
boolean vscrollbar = false
end type

event dw_maestro::doubleclicked;call super::doubleclicked;//////////////////////////////////////////////////////////////////////
// Se evalua si se hizo click sobre una fila valida
//////////////////////////////////////////////////////////////////////


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

is_usuario			= gstr_info_usuario.codigo_usuario

parent.triggerevent("ue_insertar_maestro")
dw_maestro.AcceptText()
COMMIT;
end event

type sle_argumento from w_base_maestrotb_detalletb`sle_argumento within w_movimientos_de_rollos
end type

type st_1 from w_base_maestrotb_detalletb`st_1 within w_movimientos_de_rollos
end type

type dw_detalle from w_base_maestrotb_detalletb`dw_detalle within w_movimientos_de_rollos
integer x = 46
integer y = 612
integer width = 2866
integer height = 496
string title = "Rollos seleccionados"
string dataobject = "dtb_rollos_devolucion"
end type

type dw_2 from datawindow within w_movimientos_de_rollos
integer x = 50
integer y = 1132
integer width = 2853
integer height = 400
integer taborder = 20
boolean bringtotop = true
string title = "none"
string dataobject = "dtb_remision_rollos"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type pb_1 from picturebutton within w_movimientos_de_rollos
integer x = 2949
integer y = 28
integer width = 357
integer height = 140
integer taborder = 40
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
LONG ll_fabrica_pt, ll_co_linea,ll_co_referencia,ll_color_pt
STRING ls_tono,ls_grupo,ls_nu_orden
DECIMAL ld_ca_tela,ld_metros_tela
DATETIME ld_anomes

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
			t_devolrollos.grupo
    FROM t_devolrollos;

OPEN cur_rollos;
FETCH cur_rollos into:ll_rollo,:ll_fabrica_tela,:ll_reftel,:ll_caract,:ll_diametro,:ll_color_tela,:ls_tono,:ld_ca_tela,:ld_metros_tela,:ll_contador,:ls_grupo;

SELECT max(informix.m_consecutivos.cs_concepto)  
    INTO :ll_consecutivo  
    FROM informix.m_consecutivos  
   WHERE ( informix.m_consecutivos.co_fabrica = :ll_fabrica_tela ) AND  
         ( informix.m_consecutivos.co_concepto = 14 )   ;
			
		ll_consecutivo = ll_consecutivo +1	
 
 SELECT cf_user_prod.ano_mes  
    INTO :ld_anomes  
    FROM cf_user_prod  
   WHERE cf_user_prod.co_fabrica = :ll_fabrica_tela and
			cf_user_prod.usuario = :is_usuario   ;

 
//		INSERT INTO h_kardex  
//					( co_fabrica,   
//					  co_concepto,   
//					  documento,   
//					  documento_ext,   
//					  origen,   
//					  destino,   
//					  fe_kardex,   
//					  hora,   
//					  ano_mes,   
//					  fe_actualizacion,   
//					  usuario,   
//					  instancia )  
//		  VALUES ( :ll_fabrica_tela,   
//					  14,   
//					  :ll_consecutivo,   
//					  :ll_consecutivo,   
//					  90,   
//					  21,   
//					  current,   
//					  current,   
//					  :ld_anomes,   
//					  current,   
//					  :is_usuario,   
//					  'nicoledb' )  ;
//		  IF SQLCA.SQLCODE=-1 THEN
//			  MESSAGEBOX("ERROR BASE DATOS","NO PUDO INSERTAR EN H_KARDEX")
//				RETURN
//		  ELSE
//		  END IF
		DO WHILE SQLCA.SQLCODE=0  
//			
//		INSERT INTO dt_kardex  
//				( co_fabrica,   
//				  co_concepto,   
//				  documento,   
//				  item,   
//				  cs_rollo,   
//				  cs_ordenpd,   
//				  co_reftel,   
//				  co_caract,   
//				  co_color,   
//				  diametro,   
//				  ubicacion,   
//				  ca_kardex_kg,   
//				  ca_kardex_mt,   
//				  pr_kardex,   
//				  co_recurso,   
//				  co_caractn,   
//				  lote,   
//				  fe_ingreso,   
//				  usuario_upd,   
//				  fe_actualizacion,   
//				  usuario,   
//				  instancia )  
//	  VALUES ( :ll_fabrica_tela,   
//				  14,   
//				  :ll_consecutivo,   
//				  :ll_contador,   
//				  :ll_rollo,   
//				  0,   
//				  :ll_reftel,   
//				  :ll_caract,   
//				  :ll_color_tela,   
//				  :ll_diametro,   
//				  0,   
//				  :ld_ca_tela,   
//				  :ld_metros_tela,   
//				  0,   
//				  1,   
//				  0,   
//				  0,   
//				  current,   
//				  :is_usuario,   
//				  current,   
//				  :is_usuario,   
//				  'nicoledb' )  ;
//	  IF SQLCA.SQLCODE=-1 THEN
//		  MESSAGEBOX("ERROR BASE DATOS","NO PUDO INSERTAR EN DT_KARDEX")
//			RETURN
//	  ELSE
//	  END IF
//	  UPDATE m_rollo  
//		  SET co_centro = 21  
//		WHERE m_rollo.cs_rollo = :ll_rollo   ;
//	IF SQLCA.SQLCODE=-1 THEN
//	   MESSAGEBOX("ERROR BASE DATOS","NO PUDO ACTUALIZAR ROLLOS")
//	 RETURN
//	ELSE
//	END IF
//	
////	** actualiza el documento de la tabla temporal **//
//  UPDATE t_devolrollos  
//     SET documento = :ll_consecutivo  
//   WHERE t_devolrollos.cs_rollo = :ll_rollo;
//	
//	//** toma la fabrica y el pedido alocation del grupo **//
//  SELECT   peddig.co_fabrica_exp,   
//           peddig.pedido 
//  	 INTO  :ll_fabrica_exp, :ll_pedido
//    FROM  peddig  
//   WHERE ( peddig.gpa = :ls_grupo ) AND  
//         ( peddig.tipo_pedido = 'AL' ) ;
//	
//	//** toma la maxima liberacion **//
//	SELECT MAX(dt_telaxmodelo_lib.cs_liberacion )
//	  INTO   :ll_cs_liberacion
//		 FROM dt_telaxmodelo_lib  
//		WHERE ( dt_telaxmodelo_lib.co_fabrica_exp = :ll_fabrica_exp )AND
//				( dt_telaxmodelo_lib.pedido = :ll_pedido ) AND  
//				( dt_telaxmodelo_lib.cs_estilocolortono = 1 ) AND  
//				( dt_telaxmodelo_lib.co_fabrica_tela = :ll_fabrica_tela ) AND  
//				( dt_telaxmodelo_lib.co_reftel = :ll_reftel ) AND  
//				( dt_telaxmodelo_lib.co_caract = :ll_caract) AND
//				( dt_telaxmodelo_lib.diametro = 	:ll_diametro) AND
//				( dt_telaxmodelo_lib.co_color_tela = :ll_color_tela ) AND  
//				( dt_telaxmodelo_lib.tono = :ls_tono )  ;
//	
//  //** toma datos adicionales para completar la llave **//			
//  SELECT dt_telaxmodelo_lib.nu_orden,   
//         dt_telaxmodelo_lib.co_fabrica_pt,   
//         dt_telaxmodelo_lib.co_linea,   
//         dt_telaxmodelo_lib.co_referencia,   
//         dt_telaxmodelo_lib.co_color_pt 
//	 INTO :ls_nu_orden,:ll_fabrica_pt, :ll_co_linea,:ll_co_referencia,:ll_color_pt
//    FROM dt_telaxmodelo_lib  
//   WHERE 	( dt_telaxmodelo_lib.co_fabrica_exp = :ll_fabrica_exp )AND
//				( dt_telaxmodelo_lib.pedido = :ll_pedido ) AND  
//				( dt_telaxmodelo_lib.cs_estilocolortono = 1 ) AND  
//				( dt_telaxmodelo_lib.co_fabrica_tela = :ll_fabrica_tela ) AND  
//				( dt_telaxmodelo_lib.co_reftel = :ll_reftel ) AND  
//				( dt_telaxmodelo_lib.co_caract = :ll_caract) AND
//				( dt_telaxmodelo_lib.diametro = 	:ll_diametro) AND
//				( dt_telaxmodelo_lib.co_color_tela = :ll_color_tela ) AND  
//				( dt_telaxmodelo_lib.tono = :ls_tono )  AND
//			   ( dt_telaxmodelo_lib.cs_liberacion = :ll_cs_liberacion ) AND  
//         	( dt_telaxmodelo_lib.ca_unidades = (  SELECT MAX(dt_telaxmodelo_lib.ca_unidades)  
//																	 FROM dt_telaxmodelo_lib  
//																	WHERE ( dt_telaxmodelo_lib.co_fabrica_exp = :ll_fabrica_exp )AND
//																			( dt_telaxmodelo_lib.pedido = :ll_pedido ) AND  
//																			( dt_telaxmodelo_lib.cs_estilocolortono = 1 ) AND  
//																			( dt_telaxmodelo_lib.co_fabrica_tela = :ll_fabrica_tela ) AND  
//																			( dt_telaxmodelo_lib.co_reftel = :ll_reftel ) AND  
//																			( dt_telaxmodelo_lib.co_caract = :ll_caract) AND
//																			( dt_telaxmodelo_lib.diametro = 	:ll_diametro) AND
//																			( dt_telaxmodelo_lib.co_color_tela = :ll_color_tela ) AND  
//																			( dt_telaxmodelo_lib.tono = :ls_tono ) AND
//																			( dt_telaxmodelo_lib.cs_liberacion = :ll_cs_liberacion )) ) 
//
//	GROUP BY dt_telaxmodelo_lib.nu_orden,   
//				dt_telaxmodelo_lib.co_fabrica_pt,   
//				dt_telaxmodelo_lib.co_linea,   
//				dt_telaxmodelo_lib.co_referencia,   
//				dt_telaxmodelo_lib.co_color_pt  ; 
//				
// //** Actualiza la cantidad de tela a devolver **//
// 
//  UPDATE dt_telaxmodelo_lib  
//     SET tela_dev = :ld_ca_tela  
//   WHERE ( dt_telaxmodelo_lib.co_fabrica_exp = :ll_fabrica_exp ) AND  
//         ( dt_telaxmodelo_lib.pedido = :ll_pedido ) AND  
//         ( dt_telaxmodelo_lib.cs_liberacion = :ll_cs_liberacion ) AND  
//         ( dt_telaxmodelo_lib.nu_orden = :ls_nu_orden ) AND  
//         ( dt_telaxmodelo_lib.co_fabrica_pt = :ll_fabrica_pt ) AND  
//         ( dt_telaxmodelo_lib.co_linea = :ll_co_linea ) AND  
//         ( dt_telaxmodelo_lib.co_referencia = :ll_co_referencia ) AND  
//         ( dt_telaxmodelo_lib.co_color_pt = :ll_color_pt ) AND  
//         ( dt_telaxmodelo_lib.tono = :ls_tono ) AND  
//         ( dt_telaxmodelo_lib.cs_estilocolortono = 1 ) AND  
//         ( dt_telaxmodelo_lib.co_fabrica_tela = :ll_fabrica_tela ) AND  
//         ( dt_telaxmodelo_lib.co_reftel = :ll_reftel ) AND  
//         ( dt_telaxmodelo_lib.co_color_tela = :ll_color_tela );
//
//	
	FETCH cur_rollos into:ll_rollo,:ll_fabrica_tela,:ll_reftel,:ll_caract,:ll_diametro,:ll_color_tela,:ls_tono,:ld_ca_tela,:ld_metros_tela,:ll_contador,:ls_grupo;

LOOP  
 
//   UPDATE informix.m_consecutivos  
//     SET cs_concepto = :ll_consecutivo + 1 
//   WHERE ( informix.m_consecutivos.co_fabrica = :ll_fabrica_tela ) AND  
//         ( informix.m_consecutivos.co_concepto = 14 );
//

 CLOSE cur_rollos;
// dw_2.Retrieve()
// dw_2.Print()
//
 COMMIT;
end event

type pb_2 from picturebutton within w_movimientos_de_rollos
integer x = 2958
integer y = 276
integer width = 357
integer height = 140
integer taborder = 50
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

type pb_3 from picturebutton within w_movimientos_de_rollos
integer x = 3063
integer y = 576
integer width = 201
integer height = 176
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string pointer = "HyperLink!"
string picturename = "Print!"
alignment htextalign = left!
end type

type st_3 from statictext within w_movimientos_de_rollos
integer x = 3049
integer y = 500
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

type gb_1 from groupbox within w_movimientos_de_rollos
integer x = 3013
integer y = 452
integer width = 302
integer height = 344
integer taborder = 60
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

