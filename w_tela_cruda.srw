HA$PBExportHeader$w_tela_cruda.srw
forward
global type w_tela_cruda from w_base_filtro
end type
end forward

global type w_tela_cruda from w_base_filtro
integer width = 3515
integer height = 1168
string title = "Bodega de tela cruda"
boolean minbox = false
boolean maxbox = false
string icon = "OleGenReg!"
event ue_open ( )
end type
global w_tela_cruda w_tela_cruda

type variables

uo_calendario ipo_calendario
date id_fecha_ini, id_fecha_fin
n_cst_ole_calendario ipo_calendario_ole
DataWindowChild idwc_estilo
end variables

forward prototypes
public function long of_cargar_totales ()
public function long of_encender_check (long bandera)
public function long of_buscar_cliente ()
public function long of_buscar_tela ()
public function long of_buscar_marca ()
public function long of_buscar_linea ()
public function long of_buscar_estilo (string a_nombre)
public function long of_verificar_nulos ()
end prototypes

event ue_open();//Carga los eventos del open

DataWindowChild dwc_planeadores

icst_lectura = create  cst_adm_conexion
OpenUserObject(ipo_calendario)



//OpenUserObject(ipo_calendario_ole)
//se crea el objeto principal
dw_filtro.SetTransObject(icst_lectura.of_get_transaccion_sucia())
dw_filtro.InsertRow(0)
//se carga el ddww de programadores
dw_filtro.GetChild("op_programador", dwc_planeadores)
dwc_planeadores.SetTransObject(icst_lectura.of_get_transaccion_sucia())
dwc_planeadores.Retrieve()

dw_filtro.GetChild("estilo", idwc_estilo)
idwc_estilo.SetTransObject(icst_lectura.of_get_transaccion_sucia())






	


end event

public function long of_cargar_totales ();//carga los totales

DataStore ds_total
Decimal ld_total1,ld_total2,ld_total3,ld_total4

ds_total = Create datastore
//con op estilo
ds_total.DataObject = "d_gr_suma_conestilo"
ds_total.SetTransObject (icst_lectura.of_get_transaccion_sucia( ))
If ds_total.Retrieve() > 0 Then
	ld_total1=ds_total.getitemdecimal(1,"suma_1")
End if
//sin op estilo
ds_total.DataObject = "d_gr_suma_sinestilo"
ds_total.SetTransObject (icst_lectura.of_get_transaccion_sucia( ))
If ds_total.Retrieve() > 0 Then
	ld_total2=ds_total.getitemdecimal(1,"suma_1")
End if
//sin op estilo
ds_total.DataObject = "d_gr_suma_contanda"
ds_total.SetTransObject (icst_lectura.of_get_transaccion_sucia( ))
If ds_total.Retrieve() > 0 Then
	ld_total3=ds_total.getitemdecimal(1,"suma_1")
End if

//sin op estilo
ds_total.DataObject = "d_gr_suma_sobrantes"
ds_total.SetTransObject (icst_lectura.of_get_transaccion_sucia( ))
If ds_total.Retrieve() > 0 Then
	ld_total4=ds_total.getitemdecimal(1,"suma_1")
End if


dw_filtro.Setitem(1,"total1",ld_total1)
dw_filtro.Setitem(1,"total2",ld_total2)
dw_filtro.Setitem(1,"total3",ld_total3)
dw_filtro.Setitem(1,"total4",ld_total4)
dw_filtro.Setitem(1,"total5",ld_total1+ld_total2+ld_total3+ld_total4)




Return 1
end function

public function long of_encender_check (long bandera);//hablita los check al seleccionar toddas las telas
if bandera = 1 Then
	dw_filtro.Setitem(1,"op_conestilo",1)
	dw_filtro.Setitem(1,"op_sinestilo",1)
	dw_filtro.Setitem(1,"op_contanda",1)
	dw_filtro.Setitem(1,"op_sobrantes",1)
		
Else
	dw_filtro.Setitem(1,"op_conestilo",0)
	dw_filtro.Setitem(1,"op_sinestilo",0)
	dw_filtro.Setitem(1,"op_contanda",0)
	dw_filtro.Setitem(1,"op_sobrantes",0)
	
End If


Return 1

end function

public function long of_buscar_cliente ();s_base_parametros lstr_parametros
lstr_parametros.cadena[1] = 'dgr_buscar_clientes'
			OpenWithParm ( w_buscar_dato, lstr_parametros )
			lstr_parametros = Message.PowerObjectParm
			If lstr_parametros.hay_parametros Then
					dw_filtro.SetItem(1,'cliente',lstr_parametros.entero[1])
					dw_filtro.SetItem(1,'de_cliente',lstr_parametros.cadena[1])
			Return 1
		   End if		
Return 0

end function

public function long of_buscar_tela ();s_base_parametros lstr_parametros

lstr_parametros.cadena[1] = 'dgr_buscar_tela'
		OpenWithParm ( w_buscar_dato, lstr_parametros )
		
		lstr_parametros = Message.PowerObjectParm
		
		If lstr_parametros.hay_parametros Then
			dw_filtro.SetItem(1,'tela',lstr_parametros.entero[1])
			dw_filtro.SetItem(1,'de_tela',lstr_parametros.cadena[1])
			Return 1
		End if	
	
Return 0
end function

public function long of_buscar_marca ();s_base_parametros lstr_parametros

lstr_parametros.cadena[1] = 'dgr_buscar_marcas_prnda'
OpenWithParm ( w_buscar_dato_string, lstr_parametros )
lstr_parametros = Message.PowerObjectParm
If lstr_parametros.hay_parametros Then
	dw_filtro.SetItem(1,'marca',lstr_parametros.cadena[2])
	dw_filtro.SetItem(1,'de_marca',lstr_parametros.cadena[1])
	idwc_estilo.Retrieve(lstr_parametros.cadena[2])
	Return 1
End If
		
Return 0
end function

public function long of_buscar_linea ();s_base_parametros lstr_parametros

lstr_parametros.cadena[1] = 'dgr_buscar_lineas'
OpenWithParm ( w_buscar_dato, lstr_parametros )
lstr_parametros = Message.PowerObjectParm
		
If lstr_parametros.hay_parametros Then
			dw_filtro.SetItem(1,'linea',lstr_parametros.entero[1])
			dw_filtro.SetItem(1,'de_linea',lstr_parametros.cadena[1])
	Return 1
End If
		
Return 0
end function

public function long of_buscar_estilo (string a_nombre);//messagebox("nombre",a_nombre+'%')
idwc_estilo.Retrieve(a_nombre+'%')
//mESSAGEBOX("AAA",idwc_Estilo.rOWcOUNT())




Return 1
end function

public function long of_verificar_nulos ();/*verifica si las fechas de rango no sean nulas
dbelalca
*/
Date ldtm_ini,ldtm_fin

ldtm_ini=dw_filtro.Getitemdate(1,"fecha_ini")
ldtm_fin=dw_filtro.Getitemdate(1,"fecha_fin")

If isNull(ldtm_ini) and isNull(ldtm_fin) Then
	//Messagebox("Advertecia","Ingrese el rango de fechas",Exclamation!)
	dw_filtro.SetItem(1, "fecha_ini",DATE('1900-1-1'))
	dw_filtro.Setitem(1, "fecha_fin",DATE('1900-1-1'))
	
	

	Return 1
End If
Return 1


end function

on w_tela_cruda.create
call super::create
end on

on w_tela_cruda.destroy
call super::destroy
end on

event open;call super::open;postevent("ue_open")
end event

type dw_filtro from w_base_filtro`dw_filtro within w_tela_cruda
integer x = 50
integer width = 3374
integer height = 800
string title = "Bodega de tela cruda"
string dataobject = "d_ext_ff_filtro_tela_cruda"
boolean border = false
boolean livescroll = false
end type

event dw_filtro::buttonclicked;call super::buttonclicked;//eventos del boton totales y buscar

Choose Case dwo.name
			Case "b_total"
		     //This.height=This.height+800
			  //of_cargar_totales()
			  open(w_totales_bodega_cruda)
			Case "b_buscar"
 				This.accepttext()
				If of_verificar_nulos() > 0 Then
					OpenSheetWithParm(w_reporte_bodega_tela_cruda,This, &
            	Parent, 2,Layered!)
				End If
			Case "b_limpiar"
				This.Reset( )
				This.Insertrow( 0)
				
End Choose

Return 1



end event

event dw_filtro::doubleclicked;call super::doubleclicked;/*llama las funciones que llaman una ventana para buscar cada item
dbelalca
*/
This.AcceptText()
Choose case dwo.name
	Case "fecha_ini","fecha_fin"
			//ipo_calendario_ole.of_Show_Calendario(This)
			ipo_calendario.of_show_calendar(This)
   Case "cliente"
		  of_buscar_cliente()
	Case "tela"
		  Of_buscar_tela()
	Case "marca"
		  of_buscar_marca()
		  	  
	Case "linea"
		  Of_buscar_linea()
    
End Choose


end event

event dw_filtro::itemchanged;call super::itemchanged;
n_cts_descripciones luo_descripcion
long ll_codigo, ll_rows
string ls_descripcion, ls_codigo

DataStore ds_marcas_prnda
ds_marcas_prnda = Create DataStore
ds_marcas_prnda.DataObject = "d_gr_marcas_prnda"
ds_marcas_prnda.SetTransObject(icst_lectura.of_get_transaccion_sucia( ))


Choose Case dwo.name
			 
		Case "op_todatela"
		   of_encender_check(long(data))
		
		Case "op_conestilo","op_sinestilo","op_contanda","op_sobrantes"
			dw_filtro.Setitem(1,"op_todatela",0)
      
		Case "cliente"
			ll_codigo = long(data)
			ls_descripcion = luo_descripcion.of_cliente(ll_codigo)
			This.SetItem(1,'de_cliente',ls_descripcion)
		Case "tela"
			ll_codigo = long(data)
			ls_descripcion = luo_descripcion.of_tela(ll_codigo)
			This.SetItem(1,'de_tela',ls_descripcion)
		Case "marca"
			ls_codigo = string(data)
			ll_rows = ds_marcas_prnda.Retrieve(ls_codigo)
			ls_descripcion = ds_marcas_prnda.GetItemString(1,"de_marca")
			This.SetItem(1,'de_marca',ls_descripcion)
			idwc_estilo.Retrieve(ls_codigo)
		Case  "estilo"
			//ll_codigo = This.GetItemNumber(1,'an_estilo')
			//ls_descripcion = luo_descripcion.of_referencia(1,ll_codigo)
			//This.SetItem(1,'de_estilo',ls_descripcion)
   	Case  "linea"
			ll_codigo = long(data)
			ls_descripcion = luo_descripcion.of_linea(ll_codigo)
			This.SetItem(1,'de_linea',ls_descripcion)
      Case "estilo" 

End Choose


end event

event dw_filtro::editchanged;call super::editchanged;Choose Case dwo.name
	Case "estilo"
		// Messagebox("estilo",data)
       //of_buscar_estilo(data)

End Choose
end event

