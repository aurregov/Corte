HA$PBExportHeader$w_dt_lectura_bolsas.srw
forward
global type w_dt_lectura_bolsas from window
end type
type cb_1 from commandbutton within w_dt_lectura_bolsas
end type
end forward

global type w_dt_lectura_bolsas from window
integer width = 2533
integer height = 1408
boolean titlebar = true
string title = "Untitled"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_1 cb_1
end type
global w_dt_lectura_bolsas w_dt_lectura_bolsas

on w_dt_lectura_bolsas.create
this.cb_1=create cb_1
this.Control[]={this.cb_1}
end on

on w_dt_lectura_bolsas.destroy
destroy(this.cb_1)
end on

type cb_1 from commandbutton within w_dt_lectura_bolsas
integer x = 146
integer y = 752
integer width = 343
integer height = 100
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "none"
end type

event clicked;Long ll_fila, ll_count, ll_result
String ls_bolsa
Long Net, ll_delete, ll_veces
DataStore lds_bolsas
lds_bolsas = Create DataStore
lds_bolsas.DataObject = 'ds_dt_lectura'
lds_bolsas.SetTransObject(sqlca)
lds_bolsas.Retrieve()

ll_fila = lds_bolsas.RowCount()

For ll_fila = 1 To lds_bolsas.RowCount()
	ls_bolsa = lds_bolsas.GetItemString(ll_fila,'cs_canasta')
	SELECT count(*)
	  INTO :ll_count
	  FROM h_canasta_corte
	 WHERE cs_canasta = :ls_bolsa;
	 IF ll_count = 0 THEN
		DELETE FROM dt_lectura_bolsas
			WHERE cs_canasta = :ls_bolsa;
			ll_delete += 1;
	 END IF	
	IF ll_delete = 5000 THEN
		ll_veces += 1
		ll_result = ll_delete * ll_veces
		Net = MessageBox("ojo", 'seguir '+String(ll_result), Exclamation!, OKCancel!, 2)
		IF Net = 1 THEN
			ll_delete = 0
		   Commit;
		ELSE
		  ll_delete = 0
		  ll_fila = lds_bolsas.RowCount() + 1
		  Commit;
		END IF
	 END IF
Next

Destroy lds_bolsas
end event

