HA$PBExportHeader$w_letras_paquetes.srw
forward
global type w_letras_paquetes from w_base_tabular
end type
end forward

global type w_letras_paquetes from w_base_tabular
integer width = 731
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
end type
global w_letras_paquetes w_letras_paquetes

on w_letras_paquetes.create
call super::create
end on

on w_letras_paquetes.destroy
call super::destroy
end on

event open;Long ll_ordencorte, ll_agrupacion, ll_basetrazo, ll_trazo, ll_modelo, ll_reftel, ll_colorte
Long li_seccion, li_produccion, li_fabtela, li_caract, li_diametro, li_talla, li_paquetes
Long li_fila, li_registros, li_faltantes
s_base_parametros lstr_parametros

dw_maestro.SetTransObject(SQLCA)
lstr_parametros = Message.PowerObjectParm
ll_ordencorte = lstr_parametros.entero[1]
ll_agrupacion = lstr_parametros.entero[2]
ll_basetrazo = lstr_parametros.entero[3]
ll_trazo = lstr_parametros.entero[4]
li_seccion = lstr_parametros.entero[5]
li_produccion = lstr_parametros.entero[6]
ll_modelo = lstr_parametros.entero[7]
li_fabtela = lstr_parametros.entero[8]
ll_reftel = lstr_parametros.entero[9]
li_caract = lstr_parametros.entero[10]
li_diametro = lstr_parametros.entero[11]
ll_colorte = lstr_parametros.entero[12]
li_talla = lstr_parametros.entero[13]
li_paquetes = lstr_parametros.entero[14]

li_registros = dw_maestro.Retrieve(ll_ordencorte, ll_agrupacion, ll_basetrazo, ll_trazo, &
												li_seccion, li_produccion, ll_modelo, li_fabtela, ll_reftel, &
												li_caract, li_diametro, ll_colorte, li_talla)
FOR li_faltantes = (li_registros + 1) TO li_paquetes
	li_fila = dw_maestro.InsertRow(0)
	IF li_fila > 0 THEN
		dw_maestro.SetItem(li_fila, 'cs_orden_corte', ll_ordencorte)
		dw_maestro.SetItem(li_fila, 'cs_agrupacion', ll_agrupacion)
		dw_maestro.SetItem(li_fila, 'cs_base_trazos', ll_basetrazo)
		dw_maestro.SetItem(li_fila, 'cs_trazo', ll_trazo)
		dw_maestro.SetItem(li_fila, 'cs_seccion', li_seccion)
		dw_maestro.SetItem(li_fila, 'cs_pdn', li_produccion)
		dw_maestro.SetItem(li_fila, 'co_modelo', ll_modelo)
		dw_maestro.SetItem(li_fila, 'co_fabrica_tela', li_fabtela)
		dw_maestro.SetItem(li_fila, 'co_reftel', ll_reftel)
		dw_maestro.SetItem(li_fila, 'co_caract', li_caract)
		dw_maestro.SetItem(li_fila, 'diametro', li_diametro)
		dw_maestro.SetItem(li_fila, 'co_color_te', ll_colorte)
		dw_maestro.SetItem(li_fila, 'co_talla', li_talla)
		dw_maestro.SetItem(li_fila, 'cs_paquete', li_faltantes)
		dw_maestro.SetItem(li_fila, 'fe_creacion', f_fecha_servidor())
		dw_maestro.SetItem(li_fila, 'fe_actualizacion', f_fecha_servidor())
		dw_maestro.SetItem(li_fila, 'usuario', gstr_info_usuario.codigo_usuario)
		dw_maestro.SetItem(li_fila, 'instancia', gstr_info_usuario.instancia)
	ELSE
		MessageBox("Error","Error al insertar registro")
		Return
	END IF
NEXT
end event

type dw_maestro from w_base_tabular`dw_maestro within w_letras_paquetes
integer y = 32
integer width = 631
integer height = 804
string dataobject = "dtb_letras_paquetes"
boolean border = true
end type

type sle_argumento from w_base_tabular`sle_argumento within w_letras_paquetes
boolean visible = false
boolean enabled = false
end type

type st_1 from w_base_tabular`st_1 within w_letras_paquetes
boolean visible = false
end type

