HA$PBExportHeader$w_verificar_unidades_numeradas.srw
forward
global type w_verificar_unidades_numeradas from w_base_buscar_lista_parametro
end type
type sle_de_referencia from singlelineedit within w_verificar_unidades_numeradas
end type
type sle_po from singlelineedit within w_verificar_unidades_numeradas
end type
type st_2 from statictext within w_verificar_unidades_numeradas
end type
type st_3 from statictext within w_verificar_unidades_numeradas
end type
end forward

global type w_verificar_unidades_numeradas from w_base_buscar_lista_parametro
integer x = 0
integer width = 3543
integer height = 1352
sle_de_referencia sle_de_referencia
sle_po sle_po
st_2 st_2
st_3 st_3
end type
global w_verificar_unidades_numeradas w_verificar_unidades_numeradas

type variables
// Variables de Trabajo
Long il_registros_leidos
end variables

on w_verificar_unidades_numeradas.create
int iCurrent
call super::create
this.sle_de_referencia=create sle_de_referencia
this.sle_po=create sle_po
this.st_2=create st_2
this.st_3=create st_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_de_referencia
this.Control[iCurrent+2]=this.sle_po
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.st_3
end on

on w_verificar_unidades_numeradas.destroy
call super::destroy
destroy(this.sle_de_referencia)
destroy(this.sle_po)
destroy(this.st_2)
destroy(this.st_3)
end on

type st_1 from w_base_buscar_lista_parametro`st_1 within w_verificar_unidades_numeradas
integer width = 242
string text = "Simulacion"
end type

type em_dato from w_base_buscar_lista_parametro`em_dato within w_verificar_unidades_numeradas
integer x = 288
integer y = 32
integer width = 242
string text = "1"
end type

type st_numero_registros from w_base_buscar_lista_parametro`st_numero_registros within w_verificar_unidades_numeradas
integer x = 1307
integer y = 968
end type

type pb_cancelar from w_base_buscar_lista_parametro`pb_cancelar within w_verificar_unidades_numeradas
integer x = 1897
integer y = 1088
integer taborder = 50
end type

type pb_aceptar from w_base_buscar_lista_parametro`pb_aceptar within w_verificar_unidades_numeradas
integer x = 1339
integer y = 1088
integer taborder = 40
end type

event pb_aceptar::clicked;// --- Variables
Long 	li_simulacion, li_fabrica, li_planta, li_modulo ,li_fabrica_ref, li_linea_ref
Long	li_estilocolortono, li_particion, li_referencia, li_talla
Long		ll_numeradas_pdn, ll_numeradas_linea, ll_numeradas_manual, ll_color
Long	li_indice
String	ls_po, ls_tono

// ---
// --- Si hubo regristos lleva valores a Variables
// --- para tomar numero total unidades numeradas
// ---

IF il_registros_leidos > 0 THEN
	// ---
	// Ejecuta Ciclo para Actualizar unidades numeradas 
	// ---
	FOR li_indice = 1 TO il_registros_leidos
		// --- Busca Datos en dt_pdnxmodulo
		li_simulacion	=Long(em_dato.TEXT)
		li_fabrica		=dw_lista.getitemnumber(li_indice, "dt_talla_pdnmodulo_co_fabrica")
		li_planta		=dw_lista.getitemnumber(li_indice, "dt_talla_pdnmodulo_co_planta")
		li_modulo		=dw_lista.getitemnumber(li_indice, "dt_talla_pdnmodulo_co_modulo")
		li_fabrica_ref	=dw_lista.getitemnumber(li_indice, "dt_talla_pdnmodulo_co_fabrica_pt")
		li_linea_ref	=dw_lista.getitemnumber(li_indice, "dt_talla_pdnmodulo_co_linea")
		li_referencia	=dw_lista.getitemnumber(li_indice, "dt_talla_pdnmodulo_co_referencia")
		ls_po 			=sle_po.text
		ll_color			=dw_lista.getitemnumber(li_indice, "dt_talla_pdnmodulo_co_color_pt")
		ls_tono			=dw_lista.getitemstring(li_indice, "dt_talla_pdnmodulo_tono")
		li_estilocolortono =dw_lista.getitemnumber(li_indice, "dt_talla_pdnmodulo_cs_estilocolortono")
		li_particion	=dw_lista.getitemnumber(li_indice, "dt_talla_pdnmodulo_cs_particion")
		li_talla 		=dw_lista.getitemnumber(li_indice, "dt_talla_pdnmodulo_co_talla")
		ll_numeradas_linea=dw_lista.getitemnumber(li_indice, "dt_talla_pdnmodulo_ca_numerada")

		// --- Busca unidades Numeradas 
		UPDATE dt_talla_pdnmodulo
		SET    dt_talla_pdnmodulo.ca_numerada 		=  :ll_numeradas_linea
		WHERE ( dt_talla_pdnmodulo.simulacion 		=	:li_simulacion ) AND  
			( dt_talla_pdnmodulo.co_fabrica 			=	:li_fabrica ) AND  
			( dt_talla_pdnmodulo.co_planta 			=  :li_planta) AND  
			( dt_talla_pdnmodulo.co_modulo 			=  :li_modulo) AND  
			( dt_talla_pdnmodulo.co_fabrica_pt		=  :li_fabrica_ref) AND  
			( dt_talla_pdnmodulo.co_linea 			=  :li_linea_ref) AND  
			( dt_talla_pdnmodulo.co_referencia		=	:li_referencia) AND  
			( dt_talla_pdnmodulo.po		 				=  :ls_po) AND  
			( dt_talla_pdnmodulo.co_color_pt			=  :ll_color) AND  
			( dt_talla_pdnmodulo.tono 					=  :ls_tono) AND  
			( dt_talla_pdnmodulo.cs_estilocolortono = :li_estilocolortono) AND  
			( dt_talla_pdnmodulo.co_talla 			=  :li_talla) AND  
			( dt_talla_pdnmodulo.cs_particion 		=  :li_particion);
		IF SQLCA.SQLCODE=-1 THEN
			MessageBox("Error Base Datos","No pudo actualizar unidades numeradas en dt_talla_pdnmodulo")
		ELSE
		END IF
	NEXT // 	FOR li_indice = 1 TO il_registros_leidos

	// --- 
	// --- Busca unidades Numeradas para verifica integridad de unidades
	// --- para aplicar el COMMIT p ROLLBACK
	// ---
		
	FOR li_indice = 1 TO il_registros_leidos
		// --- Busca Datos en dt_pdnxmodulo
		li_simulacion	=Long(em_dato.TEXT)
		li_fabrica		=dw_lista.getitemnumber(li_indice, "dt_talla_pdnmodulo_co_fabrica")
		li_planta		=dw_lista.getitemnumber(li_indice, "dt_talla_pdnmodulo_co_planta")
		li_modulo		=dw_lista.getitemnumber(li_indice, "dt_talla_pdnmodulo_co_modulo")
		li_fabrica_ref	=dw_lista.getitemnumber(li_indice, "dt_talla_pdnmodulo_co_fabrica_pt")
		li_linea_ref	=dw_lista.getitemnumber(li_indice, "dt_talla_pdnmodulo_co_linea")
		li_referencia	=dw_lista.getitemnumber(li_indice, "dt_talla_pdnmodulo_co_referencia")
		ls_po 			=sle_po.text
		ll_color			=dw_lista.getitemnumber(li_indice, "dt_talla_pdnmodulo_co_color_pt")
		ls_tono			=dw_lista.getitemstring(li_indice, "dt_talla_pdnmodulo_tono")
		li_estilocolortono =dw_lista.getitemnumber(li_indice, "dt_talla_pdnmodulo_cs_estilocolortono")
		li_particion	=dw_lista.getitemnumber(li_indice, "dt_talla_pdnmodulo_cs_particion")
		li_talla 		=dw_lista.getitemnumber(li_indice, "dt_talla_pdnmodulo_co_talla")
		ll_numeradas_linea=dw_lista.getitemnumber(li_indice, "dt_talla_pdnmodulo_ca_numerada")

		// --- 
		// --- Busca unidades Numeradas en dt_pdnxmodulo
		// ---
		SELECT dt_pdnxmodulo.ca_numerada
		INTO :ll_numeradas_pdn
		FROM dt_pdnxmodulo  
		WHERE ( dt_pdnxmodulo.simulacion 	= 	:li_simulacion ) AND  
			( dt_pdnxmodulo.co_fabrica 	=	:li_fabrica ) AND  
			( dt_pdnxmodulo.co_planta 		=  :li_planta) AND  
			( dt_pdnxmodulo.co_modulo 		=  :li_modulo) AND  
			( dt_pdnxmodulo.co_fabrica_pt	=  :li_fabrica_ref) AND  
			( dt_pdnxmodulo.co_linea 		=  :li_linea_ref) AND  
			( dt_pdnxmodulo.co_referencia	=  :li_referencia) AND  
			( dt_pdnxmodulo.po		 		=  :ls_po) AND  
			( dt_pdnxmodulo.co_color_pt	=  :ll_color) AND  
			( dt_pdnxmodulo.tono 			=  :ls_tono) AND  
			( dt_pdnxmodulo.cs_estilocolortono =  :li_estilocolortono) AND  
			( dt_pdnxmodulo.cs_particion 	=  :li_particion);
		IF SQLCA.SQLCODE=-1 THEN
			MessageBox("Error Base Datos","No pudo encontrar parametros de la prioridad anterior")
		ELSE
		END IF
	
		// ---
		// --- Calcula unidades numeradas en dt_talla_pdnmodulo
		// ---
		ll_numeradas_manual =0
		SELECT SUM(dt_talla_pdnmodulo.ca_numerada)
		INTO :ll_numeradas_manual
		FROM dt_talla_pdnmodulo  
		WHERE ( dt_talla_pdnmodulo.simulacion 		=	:li_simulacion ) AND  
			( dt_talla_pdnmodulo.co_fabrica 			=	:li_fabrica ) AND  
			( dt_talla_pdnmodulo.co_planta 			=  :li_planta) AND  
			( dt_talla_pdnmodulo.co_modulo 			=  :li_modulo) AND  
			( dt_talla_pdnmodulo.co_fabrica_pt		=  :li_fabrica_ref) AND  
			( dt_talla_pdnmodulo.co_linea 			=  :li_linea_ref) AND  
			( dt_talla_pdnmodulo.co_referencia		=  :li_referencia) AND  
			( dt_talla_pdnmodulo.po		 				=  :ls_po) AND  
			( dt_talla_pdnmodulo.co_color_pt			=  :ll_color) AND  
			( dt_talla_pdnmodulo.tono 					=  :ls_tono) AND  
			( dt_talla_pdnmodulo.cs_estilocolortono = :li_estilocolortono) AND  
			( dt_talla_pdnmodulo.cs_particion 		=  :li_particion);
		IF SQLCA.SQLCODE=-1 THEN
			MessageBox("Error Base Datos","No pudo calculat total unidades numeradas en de_talla_pdnmodulo")
		ELSE
		END IF

		// --- Valida unidades
		IF ll_numeradas_pdn <> ll_numeradas_manual THEN
			MessageBox("Error en Unidades","Unidades Numeradas Originales " + STRING(ll_numeradas_pdn) & 
			+ " es diferente de Unidades Numeradas digitadas " + STRING(ll_numeradas_manual))
			RETURN(1)
		ELSE
		END IF
	NEXT
	// ---
	// --- Aplica los Cambios Hechos
	// ---
	COMMIT;
ELSE
END IF

end event

type dw_lista from w_base_buscar_lista_parametro`dw_lista within w_verificar_unidades_numeradas
integer width = 3493
integer height = 784
integer taborder = 60
string dataobject = "dtb_verificar_unidades_numeradas"
end type

type sle_de_referencia from singlelineedit within w_verificar_unidades_numeradas
integer x = 841
integer y = 32
integer width = 457
integer height = 76
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
end type

type sle_po from singlelineedit within w_verificar_unidades_numeradas
integer x = 1477
integer y = 32
integer width = 448
integer height = 76
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
end type

event modified;String ls_de_referencia, ls_po
Long ll_numero_registros
Long	li_simulacion

// --- Lee valores
ls_de_referencia=sle_de_referencia.Text
ls_po=sle_po.Text
li_simulacion=Long(em_dato.TEXT)

// --- Valida parametros
IF ISNULL(li_simulacion) THEN
	MessageBox("Error de datos","Falta el dato de simulaci$$HEX1$$f300$$ENDHEX$$n, por favor verifique")
	RETURN
ELSE
END IF

IF ISNULL(ls_de_referencia) THEN
	MessageBox("Error de datos","Falta descripcion Referencia, por favor verifique")
	RETURN
ELSE
END IF

IF ISNULL(ls_po) THEN
	MessageBox("Error de datos","Falta P.O.,  por favor verifique")
	RETURN
ELSE
END IF

// --- Recupera informacion DW
IF Not IsNull(li_simulacion) AND &
   Not IsNull(ls_de_referencia) AND &
	Not IsNull(ls_po) THEN

	ll_numero_registros = dw_lista.Retrieve(li_simulacion,ls_de_referencia,ls_po)
	il_registros_leidos = ll_numero_registros

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

type st_2 from statictext within w_verificar_unidades_numeradas
integer x = 677
integer y = 40
integer width = 169
integer height = 76
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Estilo :"
boolean focusrectangle = false
end type

type st_3 from statictext within w_verificar_unidades_numeradas
integer x = 1339
integer y = 40
integer width = 142
integer height = 76
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "P.O. :"
boolean focusrectangle = false
end type

