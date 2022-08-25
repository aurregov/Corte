HA$PBExportHeader$w_rollo_liquida.srw
forward
global type w_rollo_liquida from w_base_simple
end type
type cb_1 from commandbutton within w_rollo_liquida
end type
type cb_2 from commandbutton within w_rollo_liquida
end type
end forward

global type w_rollo_liquida from w_base_simple
integer width = 3246
integer height = 1788
string title = "Rollos Liquidados"
string menuname = ""
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
boolean center = true
cb_1 cb_1
cb_2 cb_2
end type
global w_rollo_liquida w_rollo_liquida

on w_rollo_liquida.create
int iCurrent
call super::create
this.cb_1=create cb_1
this.cb_2=create cb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.cb_2
end on

on w_rollo_liquida.destroy
call super::destroy
destroy(this.cb_1)
destroy(this.cb_2)
end on

event open;This.x = 1
This.y = 1
//This.width = 
//This.height = 


dw_maestro.SetTransObject(SQLCA)
Long ll_ordencorte, ll_fila, ll_rollo, ll_count
s_base_parametros lstr_parametros
DataStore lds_rollo

lstr_parametros = Message.PowerObjectParm	

ll_ordencorte = lstr_parametros.entero[1]

lds_rollo = Create DataStore
lds_rollo.DataObject = 'ds_rollo_liquida'
lds_rollo.SetTransObject(sqlca)

lds_rollo.Retrieve(ll_ordencorte)

FOR ll_fila = 1 To lds_rollo.RowCount()
	ll_rollo = lds_rollo.GetItemNUmber(ll_fila,'cs_rollo')
	
	SELECT count(*)
	  INTO :ll_count
	  FROM m_rollo_liquida
	 WHERE cs_orden_corte = :ll_ordencorte AND
	       cs_rollo = :ll_rollo;
			 
	IF ll_count = 0 THEN		 
		INSERT INTO m_rollo_liquida (cs_orden_corte, cs_rollo)
		  VALUES (:ll_ordencorte, :ll_rollo);
	END IF	  
NEXT
commit;
dw_maestro.Retrieve(ll_ordencorte)

IF (f_deshabilitar_opciones(this.classname(),this.menuid)= -1) THEN
	Close(This)
END IF
end event

type dw_maestro from w_base_simple`dw_maestro within w_rollo_liquida
integer width = 3159
integer height = 1460
string dataobject = "dgr_m_rollo_liquida"
end type

type cb_1 from commandbutton within w_rollo_liquida
integer x = 1125
integer y = 1540
integer width = 352
integer height = 100
integer taborder = 11
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Grabar y Salir"
end type

event clicked;Long ll_fila, ll_registros

ll_registros = dw_maestro.RowCount()

IF ll_registros > 0 THEN
	FOR ll_fila = 1 To ll_registros
			dw_maestro.SetItem(ll_fila, "fe_actualizacion", f_fecha_servidor())
			dw_maestro.SetItem(ll_fila, "usuario", gstr_info_usuario.codigo_usuario)
			dw_maestro.SetItem(ll_fila, "instancia", gstr_info_usuario.instancia)
	
	
	NEXT
	
	dw_maestro.Update()
	
END IF
end event

type cb_2 from commandbutton within w_rollo_liquida
integer x = 1632
integer y = 1540
integer width = 389
integer height = 100
integer taborder = 11
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Salir sin Grabar"
end type

event clicked;Close(Parent)
end event

