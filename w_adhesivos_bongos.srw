HA$PBExportHeader$w_adhesivos_bongos.srw
forward
global type w_adhesivos_bongos from w_preview_de_impresion
end type
type cb_1 from commandbutton within w_adhesivos_bongos
end type
type sle_bongo from singlelineedit within w_adhesivos_bongos
end type
type st_4 from statictext within w_adhesivos_bongos
end type
type cb_generar_adhesivos from commandbutton within w_adhesivos_bongos
end type
end forward

global type w_adhesivos_bongos from w_preview_de_impresion
integer width = 3506
cb_1 cb_1
sle_bongo sle_bongo
st_4 st_4
cb_generar_adhesivos cb_generar_adhesivos
end type
global w_adhesivos_bongos w_adhesivos_bongos

forward prototypes
public function long wf_leerconstantescorte (readonly string as_constante, readonly string as_error)
public function long wf_leerconstantes (readonly string as_constante, readonly string as_error)
end prototypes

public function long wf_leerconstantescorte (readonly string as_constante, readonly string as_error);/********************************************************************
SA53802 - Ceiba/JJ - 29-10-2015 FunctionName : wf_leerConstantesCorte
<DESC> Description</DESC> 
<RETURN> Long: <LI> 1, X ok <LI> -1, X failed</RETURN> 
<ACCESS> Public/Protected/Private 
<ARGS> as_Arg1: Description as_Arg2: Description</ARGS> 
<USAGE> How to use this function.</USAGE>
********************************************************************/
Long					ll_retorno
Constant Long		ERROR_LEC = -1 , EXITO_LEC = 1
n_cts_constantes_corte 	luo_constantes

ll_retorno = luo_constantes.of_consultar_numerico(as_constante)
IF ll_retorno = ERROR_LEC THEN
	MessageBox('Error','Ocurrio un error al momento de validar '+as_error,StopSign!)
	Return ERROR_LEC
END IF

return ll_retorno 
end function

public function long wf_leerconstantes (readonly string as_constante, readonly string as_error);/********************************************************************
SA53802 - Ceiba/JJ - 29-10-2015 FunctionName : wf_leerConstantes
<DESC> Description</DESC> 
<RETURN> Long: <LI> 1, X ok <LI> -1, X failed</RETURN> 
<ACCESS> Public/Protected/Private 
<ARGS> as_Arg1: Description as_Arg2: Description</ARGS> 
<USAGE> How to use this function.</USAGE>
********************************************************************/
Long					ll_retorno
Constant Long		ERROR_LEC = -1 , EXITO_LEC = 1
n_cts_constantes 	luo_constantes

luo_constantes = Create n_cts_constantes

ll_retorno = luo_constantes.of_consultar_numerico(as_constante)
IF ll_retorno = ERROR_LEC THEN
	MessageBox('Error','Ocurrio un error al momento de validar '+as_error,StopSign!)
	Return ERROR_LEC
END IF

return ll_retorno 
end function

on w_adhesivos_bongos.create
int iCurrent
call super::create
this.cb_1=create cb_1
this.sle_bongo=create sle_bongo
this.st_4=create st_4
this.cb_generar_adhesivos=create cb_generar_adhesivos
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.sle_bongo
this.Control[iCurrent+3]=this.st_4
this.Control[iCurrent+4]=this.cb_generar_adhesivos
end on

on w_adhesivos_bongos.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.sle_bongo)
destroy(this.st_4)
destroy(this.cb_generar_adhesivos)
end on

event open;/***********************************************************
SA54091 - Ceiba/jjmonsal - 04-03-2016 : Ruta en el adhesivo del recipiente
Comentario: Se crea el dw: d_gr_ruta_corte_despues_preparacion
Se asocia a los DW: dtb_adhesivos_bongo_new_duo y dtb_adhesivos_bongo_new_colores
***********************************************************/
/***********************************************************
SA53416 - Ceiba/jjmonsal - 20-02-2016
Comentario: Se modifica dtb_adhesivos_bongo_new_colores y dtb_adhesivos_bongo_new_duo 
para adicionarle en el campo tipo el dddw_m_cptos_corte
***********************************************************/
/***********************************************************
SA53802 - Ceiba/JJ - 29-10-2015
Comentario: se adiciona el Report dw_ProcesosConfeccion a los dw: dtb_adhesivos_bongo_new_duo y dtb_adhesivos_bongo_new_colores
adicionando los arg de recuperacion an_tipoPdto, an_centro_pdn,an_infoProc, de lectura a constantes:TIPO PRENDAS CONFECCION y MENS_LOTEO_CONF
***********************************************************/

This.WindowState = Maximized!
end event

type dw_reporte from w_preview_de_impresion`dw_reporte within w_adhesivos_bongos
integer width = 3438
integer taborder = 0
string dataobject = "dtb_adhesivos_bongo_new_colores"
end type

type cb_1 from commandbutton within w_adhesivos_bongos
integer x = 695
integer y = 24
integer width = 315
integer height = 84
integer taborder = 70
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "Ver Reporte"
boolean default = true
end type

event clicked;
LONG  ll_hallados,ll_estado, ll_orden_corte, ll_result, ll_found, ll_referencia,  ll_duo, &
		li_loteoConf,ll_tipoPdto,ll_centro_pdn
STRING as_grupo,as_estilo,as_po,ls_bongo,ll_ubicacion, ls_po, ls_atributo
DateTime ldt_fecha
Time lt_time
Long li_time, li_fabrica, li_linea
n_cst_orden_corte luo_corte
DataStore lds_bongo

ldt_fecha = f_fecha_servidor()
lt_time = Time(ldt_fecha)
li_time = Hour(lt_time)

DISCONNECT ;
SQLCA.Lock = "Dirty Read"					
CONNECT ;

lds_bongo = Create DataStore
lds_bongo.DataObject = "ds_pallet_id_reimpresion" //conozco los diferentes bongos que tiene la O.C. - P.O.
lds_bongo.SetTransObject(sqlca)

dw_reporte.settransobject(sqlca)

ls_bongo			=string(sle_bongo.TEXT)
//****************************con el bongo obtengo la orden de corte y la po
select Distinct dt_canasta_corte.cs_orden_corte,
		 dt_canasta_corte.co_fabrica_ref,
		 dt_canasta_corte.co_linea,
		 dt_canasta_corte.co_referencia
  into :ll_orden_corte,
 		 :li_fabrica,
		 :li_linea,
		 :ll_referencia
  from h_canasta_corte,
  		 dt_canasta_corte
where  h_canasta_corte.pallet_id  = :ls_bongo and
  		 h_canasta_corte.cs_canasta = dt_canasta_corte.cs_canasta;
	
If sqlca.sqlcode <> 0 Then
	select first 1 dt_canasta_corte.co_referencia
	  into :ll_referencia
     from h_canasta_corte,
   		 dt_canasta_corte
	 where h_canasta_corte.pallet_id  = :ls_bongo and
			 h_canasta_corte.cs_canasta = dt_canasta_corte.cs_canasta
    order by ca_actual;
	If sqlca.sqlcode <> 0 Then
		MessageBox('Error','No fue posible consultar la O.C. y la P.O. del bongo. '+Sqlca.SqlErrText,StopSign!,Ok!)
		Return
	End if
	select Distinct dt_canasta_corte.cs_orden_corte,
		    dt_canasta_corte.co_fabrica_ref,
		    dt_canasta_corte.co_linea
    into :ll_orden_corte,
 		   :li_fabrica,
		   :li_linea
     from h_canasta_corte,
  		    dt_canasta_corte
    where h_canasta_corte.pallet_id  = :ls_bongo and
	       dt_canasta_corte.co_referencia = :ll_referencia and
  	    	 h_canasta_corte.cs_canasta = dt_canasta_corte.cs_canasta;
	If sqlca.sqlcode <> 0 Then
		MessageBox('Error','No fue posible consultar la O.C. y la P.O. del bongo. '+Sqlca.SqlErrText,StopSign!,Ok!)
		Return
	End if
	
END IF


select Max( dt_canasta_corte.po)
  into :ls_po
  from h_canasta_corte,
  		 dt_canasta_corte
where  h_canasta_corte.pallet_id  = :ls_bongo and
  		 h_canasta_corte.cs_canasta = dt_canasta_corte.cs_canasta and
	    dt_canasta_corte.co_fabrica_ref = :li_fabrica and
		 dt_canasta_corte.co_linea = :li_linea and
		 dt_canasta_corte.co_referencia = :ll_referencia;
			
	
If sqlca.sqlcode <> 0 Then
	MessageBox('Error','No fue posible consultar la O.C. y la P.O. del bongo. '+Sqlca.SqlErrText,StopSign!,Ok!)
	Return
End if

Select Distinct atributo3
into :ls_atributo
from h_canasta_corte
where pallet_id = :ls_bongo;

//***********************************me dice el numero de bongos
ll_result = lds_bongo.Retrieve(ll_orden_corte,ls_po,ls_atributo)	
//**************************me dice el lugar especifico que ocupa el bongo
ll_found = lds_bongo.Find("pallet_id = '"+ls_bongo+"'",1,lds_bongo.RowCount())			

//se establece si es un duo
//ll_duo = luo_corte.of_duo_conjunto(ll_orden_corte)

//IF ll_duo <= 0 THEN
	//no es un duo
	//SA53802 - Ceiba/JJ - 29-10-2015 Valores por defecto para buscar en los est$$HEX1$$e100$$ENDHEX$$ndares de la referencia y procesos
	ll_tipoPdto		= wf_leerConstantes('TIPO PRENDAS','el tipo de producto.') //SA53802 - Ceiba/JJ - 29-10-2015
	ll_centro_pdn	= wf_leerConstantes('CONFECCION','el centro de confecci$$HEX1$$f300$$ENDHEX$$n') //SA53802 - Ceiba/JJ - 29-10-2015
	li_loteoConf 	= wf_leerConstantescorte('MENS_LOTEO_CONF','la configuraci$$HEX1$$f300$$ENDHEX$$n del loteo.') //SA53802 - Ceiba/JJ - 29-10-2015
	
	ll_hallados = dw_reporte.Retrieve(ls_bongo,ll_found,ll_result,ll_orden_corte,ls_po,li_time,li_fabrica,li_linea,ll_referencia,ls_atributo,ll_tipoPdto,ll_centro_pdn,li_loteoConf)
//ELSE
	//se trata de un duo se deben traer todos los bongos que lo componen
//	dw_reporte.DataObject = 'dtb_adhesivos_bongo_new_duo'
//	dw_reporte.SetTransObject(sqlca)
//	ll_hallados = dw_reporte.Retrieve(ls_bongo,ll_found,ll_result,ll_duo,ls_po,li_time,li_fabrica,li_linea,ll_referencia,ls_atributo)
//END IF

IF isnull(ll_hallados) THEN
	MessageBox("Error buscando","parametros nulos",Exclamation!,Ok!)
ELSE
CHOOSE CASE ll_hallados
		CASE -1
			MessageBox("Error buscando","Error de la base",StopSign!,Ok!)
		CASE 0
			MessageBox("Sin Datos","No hay datos para su criterio",Exclamation!,Ok!)
		CASE ELSE
	END CHOOSE
END IF

dw_reporte.Modify("DataWindow.Print.Preview=No")
dw_reporte.Modify("DataWindow.Print.Preview.Rulers=No")
is_zoom = dw_reporte.Describe("DataWindow.Print.Preview.Zoom")

DISCONNECT ;
SQLCA.Lock = "cursor stability"					
CONNECT ;



end event

type sle_bongo from singlelineedit within w_adhesivos_bongos
integer x = 178
integer y = 20
integer width = 274
integer height = 84
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type st_4 from statictext within w_adhesivos_bongos
integer x = 18
integer y = 56
integer width = 165
integer height = 52
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Bongo:"
boolean focusrectangle = false
end type

type cb_generar_adhesivos from commandbutton within w_adhesivos_bongos
string tag = "Genera los adhesivos para las secciones de preparaci$$HEX1$$f300$$ENDHEX$$n"
boolean visible = false
integer x = 2990
integer y = 20
integer width = 457
integer height = 84
integer taborder = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
boolean enabled = false
string text = "Generar Adhesivos"
end type

event clicked;long  ll_hallados, ll_fila, respuesta,ll_llamar,ll_cs_bolsa, ll_co_fabrica_pt,ll_co_linea,ll_co_referencia,ll_co_talla,ll_cs_base_trazos
long ll_cs_orden_corte,ll_cs_espacio,ll_cantidad, ll_cs_pdn, ll_cs_agrupacion
long ll_co_color_pt
String ls_de_talla,ls_de_referencia,ls_capas,ls_numeracion
string ls_lote, ls_grupo,ls_letra,ls_cs_orden_corte,ls_cs_espacio,ls_cs_bolsa,ls_bolsa_guardada
ll_fila=1

//dw_adhesivo.SetTransobject(SQLCA)
//dw_adbolsa.SetTransobject(SQLCA)
//dw_adhesivo_partes.SetTransobject(SQLCA)
//ll_hallados =dw_adhesivo.RowCount()
//
//respuesta = MessageBox("Advertencia", 'Desea Imprimir Adhesivos Partes de Prenda',Exclamation!, YesNo!, 2)
//IF respuesta = 1 AND ll_hallados > 0  THEN
//	ls_de_talla = dw_adhesivo.GetitemString(ll_fila,"de_talla")
//	ls_de_referencia= dw_adhesivo.GetitemString(ll_fila,"de_referencia")
//   ls_capas =String(dw_adhesivo.GetitemNumber(ll_fila,"capas"))
//	ll_cantidad =dw_adhesivo.GetitemNumber(ll_fila,"capas")
//	ls_numeracion = string(dw_adhesivo.Getitemnumber(ll_fila,"valor_inicial")) +" AL " + string(dw_adhesivo.Getitemnumber(ll_fila,"valor_final"))
//	ls_lote = string(dw_adhesivo.GetitemString(ll_fila,"lote"))
//	ls_cs_orden_corte = String(dw_adhesivo.GetitemNumber(ll_fila,"cs_orden_corte"))
//	ll_cs_orden_corte = dw_adhesivo.GetitemNumber(ll_fila,"cs_orden_corte")
//	ls_grupo    = string(dw_adhesivo.GetitemString(ll_fila,"gpa"))
//	ls_letra = string(dw_adhesivo.GetitemString(ll_fila,"letra"))
//	ls_cs_espacio = String(dw_adhesivo.GetitemNumber(ll_fila,"cs_espacio"))
//	ll_cs_espacio = dw_adhesivo.GetitemNumber(ll_fila,"cs_espacio")
//	ll_cs_pdn = dw_adhesivo.GetitemNumber(ll_fila,"cs_pdn")
//	ll_cs_agrupacion = dw_adhesivo.GetitemNumber(ll_fila,"cs_agrupacion")
//	ll_co_fabrica_pt = dw_adhesivo.GetitemNumber(ll_fila,"co_fabrica_pt")
// 	ll_co_linea = dw_adhesivo.GetitemNumber(ll_fila,"co_linea")
// 	ll_co_referencia = dw_adhesivo.GetitemNumber(ll_fila,"co_referencia")
//	ll_co_talla = dw_adhesivo.GetitemNumber(ll_fila,"co_talla")
//	ll_co_color_pt = dw_adhesivo.GetitemNumber(ll_fila,"dt_agrupa_pdn_co_color_pt")
//   ll_cs_base_trazos = dw_adhesivo.GetitemNumber(1,"cs_base_trazos")
//	// Reporte de adhesivos de partes de prenda
//	dw_adhesivo_partes.Retrieve(ll_cs_orden_corte,ll_cs_base_trazos,ll_cs_espacio)
//	ll_hallados =dw_adhesivo_partes.RowCount()
//	dw_adhesivo_partes.print()	
//END IF
//
end event

