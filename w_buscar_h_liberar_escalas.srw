HA$PBExportHeader$w_buscar_h_liberar_escalas.srw
forward
global type w_buscar_h_liberar_escalas from w_base_buscar_lista_parametro
end type
end forward

global type w_buscar_h_liberar_escalas from w_base_buscar_lista_parametro
int X=27
int Y=288
int Width=3488
boolean TitleBar=true
string Title="Busqueda de grupos"
end type
global w_buscar_h_liberar_escalas w_buscar_h_liberar_escalas

on w_buscar_h_liberar_escalas.create
call super::create
end on

on w_buscar_h_liberar_escalas.destroy
call super::destroy
end on

event open;call super::open;x=27
y=288
This.width = 3488
This.height =1128
end event

type st_1 from w_base_buscar_lista_parametro`st_1 within w_buscar_h_liberar_escalas
string Text="Grupo:"
end type

type em_dato from w_base_buscar_lista_parametro`em_dato within w_buscar_h_liberar_escalas
TextCase TextCase=Upper!
string Mask=""
end type

event em_dato::modified;String ls_datocon
Long ll_numero_registros,ll_co_fabrica_exp,ll_pedido_grupo


ls_datocon = em_dato.Text
IF Not IsNull(ls_datocon) THEN
	ll_co_fabrica_exp=91
	SELECT peddig.pedido  
	 INTO :ll_pedido_grupo  
	 FROM peddig  
	WHERE ( peddig.co_fabrica_vta =:ll_co_fabrica_exp  ) AND  
			( peddig.gpa LIKE :ls_datocon  ) AND  
			( peddig.tipo_pedido = "AL" )   ;
	IF SQLCA.SQLCode = -1 THEN
		MessageBox("Error Base Datos","Error al consultar el pedido para el grupo")
		Return
	END IF
						
	
//	ls_datocon = ls_datocon + '%'
	ll_numero_registros = dw_lista.Retrieve(ll_co_fabrica_exp,ll_pedido_grupo)
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

type st_numero_registros from w_base_buscar_lista_parametro`st_numero_registros within w_buscar_h_liberar_escalas
int X=1074
int Y=756
end type

type pb_cancelar from w_base_buscar_lista_parametro`pb_cancelar within w_buscar_h_liberar_escalas
int X=1673
int Y=876
int TabOrder=40
end type

type pb_aceptar from w_base_buscar_lista_parametro`pb_aceptar within w_buscar_h_liberar_escalas
int X=1115
int Y=876
int TabOrder=20
end type

event pb_aceptar::clicked;call super::clicked;///////////////////////////////////////////////////////////////////
// En este evento se le asigna al campo entero de la estructura 
// s_base_parametros el contenido del campo clave de la fila actual.
///////////////////////////////////////////////////////////////////

LONG   ll_co_fabrica_exp,ll_pedido,ll_cs_lib_preliminar,ll_co_fabrica_pt,ll_co_linea,ll_co_referencia
LONG   ll_co_color_pt,ll_ca_pedidas,ll_tipo_lib_prelim,ll_cs_liberacion
String ls_nu_orden,ls_nu_cut,ls_tono_rollo,ls_gpa,ls_po
s_base_parametros	lstr_parametros

IF il_fila_actual > 0 THEN
	lstr_parametros.hay_parametros = TRUE
	lstr_parametros.entero[1]=dw_lista.getitemnumber(il_fila_actual,"co_fabrica_exp")
	lstr_parametros.entero[2]=dw_lista.getitemnumber(il_fila_actual,"pedido")
	lstr_parametros.entero[3]=dw_lista.getitemnumber(il_fila_actual,"cs_liberacion")
	lstr_parametros.entero[4]=dw_lista.getitemnumber(il_fila_actual,"cs_lib_preliminar")
	lstr_parametros.cadena[1]=dw_lista.getitemString(il_fila_actual,"gpa")
	
	ls_po=dw_lista.getitemString(il_fila_actual,"nu_orden")
		
	IF ISNULL(ls_po) THEN
		lstr_parametros.cadena[2]=""
		lstr_parametros.entero[5]=0
		lstr_parametros.entero[6]=0
		lstr_parametros.entero[7]=0
		lstr_parametros.entero[8]=0
		lstr_parametros.cadena[3]=""
		lstr_parametros.entero[9]=0
	ELSE
		lstr_parametros.cadena[2]=dw_lista.getitemString(il_fila_actual,"nu_orden")
		lstr_parametros.entero[5]=dw_lista.getitemnumber(il_fila_actual,"co_fabrica")
		lstr_parametros.entero[6]=dw_lista.getitemnumber(il_fila_actual,"co_linea")
		lstr_parametros.entero[7]=dw_lista.getitemnumber(il_fila_actual,"co_referencia")
		lstr_parametros.entero[8]=dw_lista.getitemnumber(il_fila_actual,"co_color_pt")
		lstr_parametros.cadena[3]=dw_lista.getitemString(il_fila_actual,"tono")
		lstr_parametros.entero[9]=dw_lista.getitemnumber(il_fila_actual,"cs_estilocolortono")
	END IF
	
	closewithreturn(parent,lstr_parametros)
ELSE
	lstr_parametros.hay_parametros = FALSE
	CloseWithReturn(parent,lstr_parametros)
END IF

end event

type dw_lista from w_base_buscar_lista_parametro`dw_lista within w_buscar_h_liberar_escalas
int X=5
int Width=3433
int TabOrder=30
string DataObject="dtb_seleccionar_h_liberar_escalas"
end type

