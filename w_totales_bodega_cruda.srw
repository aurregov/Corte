HA$PBExportHeader$w_totales_bodega_cruda.srw
forward
global type w_totales_bodega_cruda from w_base_filtro
end type
type cb_1 from commandbutton within w_totales_bodega_cruda
end type
end forward

global type w_totales_bodega_cruda from w_base_filtro
integer width = 2501
integer height = 1168
string title = "Total Bodega de Tela Cruda"
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
string icon = "OleGenReg!"
event ue_open ( )
cb_1 cb_1
end type
global w_totales_bodega_cruda w_totales_bodega_cruda

forward prototypes
public function long of_cargar_totales ()
end prototypes

event ue_open();//totales
icst_lectura = create  cst_adm_conexion
dw_filtro.InsertRow(0)
of_cargar_totales()
end event

public function long of_cargar_totales ();

DataStore ds_total
Decimal ld_total1,ld_total2,ld_total3,ld_total4, ld_total1prt, ld_total3prt, ld_total4prt

ds_total = Create datastore
//con op estilo crudo
ds_total.DataObject = "d_gr_suma_conestilo"
ds_total.SetTransObject (icst_lectura.of_get_transaccion_sucia( ))
If ds_total.Retrieve() > 0 Then
	ld_total1=ds_total.getitemdecimal(1,"suma_1")
End if
//con estilo prete$$HEX1$$f100$$ENDHEX$$ido
ds_total.DataObject = "d_gr_suma_conestilo_pret"
ds_total.SetTransObject (icst_lectura.of_get_transaccion_sucia( ))
If ds_total.Retrieve() > 0 Then
	ld_total1prt=ds_total.getitemdecimal(1,"suma_1")
End if


////sin op estilo
//ds_total.DataObject = "d_gr_suma_sinestilo"
//ds_total.SetTransObject (icst_lectura.of_get_transaccion_sucia( ))
//If ds_total.Retrieve() > 0 Then
//	ld_total2=ds_total.getitemdecimal(1,"suma_1")
//End if

//con tanda crudo
ds_total.DataObject = "d_gr_suma_contanda"
ds_total.SetTransObject (icst_lectura.of_get_transaccion_sucia( ))
If ds_total.Retrieve() > 0 Then
	ld_total3=ds_total.getitemdecimal(1,"suma_1")
End if
//con tanda prete$$HEX1$$f100$$ENDHEX$$ido
ds_total.DataObject = "d_gr_suma_contanda_prt"
ds_total.SetTransObject (icst_lectura.of_get_transaccion_sucia( ))
If ds_total.Retrieve() > 0 Then
	ld_total3prt=ds_total.getitemdecimal(1,"suma_1")
End if


//sin op estilo
ds_total.DataObject = "d_gr_suma_sobrantes"
ds_total.SetTransObject (icst_lectura.of_get_transaccion_sucia( ))
If ds_total.Retrieve() > 0 Then
	ld_total4=ds_total.getitemdecimal(1,"suma_1")
End if
ds_total.DataObject = "d_gr_suma_sobrantes_prt"
ds_total.SetTransObject (icst_lectura.of_get_transaccion_sucia( ))
If ds_total.Retrieve() > 0 Then
	ld_total4prt=ds_total.getitemdecimal(1,"suma_1")
End if



IF IsNull(ld_total2) THEN ld_total2 = 0
IF IsNull(ld_total1) THEN ld_total1 = 0
IF IsNull(ld_total3) THEN ld_total3 = 0
IF IsNull(ld_total4) THEN ld_total4 = 0
IF IsNull(ld_total1prt) THEN ld_total1prt = 0
IF IsNull(ld_total3prt) THEN ld_total3prt = 0
IF IsNull(ld_total4prt) THEN ld_total4prt = 0

//sin estilo
//dw_filtro.Setitem(1,"total1",ld_total2)

//con op estilo
dw_filtro.Setitem(1,"total2",ld_total1)
dw_filtro.Setitem(1,"total2prt",ld_total1prt)

//tanda
dw_filtro.Setitem(1,"total3",ld_total3)
dw_filtro.Setitem(1,"total3prt",ld_total3prt)

//sobrantes
dw_filtro.Setitem(1,"total4",ld_total4)
dw_filtro.Setitem(1,"total4prt",ld_total4prt)

dw_filtro.Setitem(1,"total5",ld_total1+ld_total2+ld_total3+ld_total4)
dw_filtro.Setitem(1,"total5prt",ld_total1prt+ld_total3prt+ld_total4prt)



Return 1
end function

on w_totales_bodega_cruda.create
int iCurrent
call super::create
this.cb_1=create cb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
end on

on w_totales_bodega_cruda.destroy
call super::destroy
destroy(this.cb_1)
end on

event open;call super::open;postevent("ue_open")
end event

type dw_filtro from w_base_filtro`dw_filtro within w_totales_bodega_cruda
integer x = 87
integer y = 40
integer width = 2336
integer height = 808
string title = "Total Bodega Cruda"
string dataobject = "d_ext_ff_totales_bodega"
boolean livescroll = false
end type

type cb_1 from commandbutton within w_totales_bodega_cruda
integer x = 1211
integer y = 920
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
string text = "Cerrar"
boolean default = true
end type

event clicked;Close(parent)


end event

