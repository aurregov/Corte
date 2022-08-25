HA$PBExportHeader$w_mantenimiento_calendario_contable.srw
forward
global type w_mantenimiento_calendario_contable from w_base_tabular
end type
end forward

global type w_mantenimiento_calendario_contable from w_base_tabular
int X=0
int Y=0
int Width=2034
int Height=1776
boolean TitleBar=true
string Title="Administraci$$HEX1$$f300$$ENDHEX$$n Calendario Contable"
end type
global w_mantenimiento_calendario_contable w_mantenimiento_calendario_contable

event open;call super::open;This.width = 2034
This.height = 1776

sle_argumento.setfocus()
end event

on w_mantenimiento_calendario_contable.create
call super::create
end on

on w_mantenimiento_calendario_contable.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_buscar;s_base_parametros lstr_parametros_retro

IF is_cambios = "no" OR is_accion <> "cancelo" THEN
	
	///////////////////////////////////////////////////////////////////
	// Las siguientes tres lineas, estan llenando la estructura 
	// s_base_parametrospara poder asi desplegar en la ventana 
   // de retroalimentacion el mensaje correspondiente a la 
	// accion que se esta ejecutando.
	//
	///////////////////////////////////////////////////////////////////
	
	lstr_parametros_retro.cadena[1]="Cargando datos ..."
	lstr_parametros_retro.cadena[2]="Espere un momento por favor, esta operacion pude durar unos segundos..."
	lstr_parametros_retro.cadena[3]="reloj"

	OpenWithParm(w_retroalimentacion,lstr_parametros_retro)

	CHOOSE CASE dw_maestro.Retrieve(Long(sle_argumento.text))
		CASE -1
			Close(w_retroalimentacion)
			MessageBox("Error datawindow","No se pudo cargar datos", &
			            Exclamation!,Ok!)
			 
			////////////////////////////////////////////////////////////////
       	// Las siguientes cinco lineas, estan llenando la estructura 
      	// s_base_parametros 
      	// para poder asi desplegar en la ventana de errores el mensaje
      	// correspondiente al error reportado por el motor de base de 
			// datos.
       	////////////////////////////////////////////////////////////////
			 
			istr_parametros_error.cadena[1]=sqlca.dbms
			istr_parametros_error.entero[1]=sqlca.sqlcode
			istr_parametros_error.cadena[2]=this.classname()
			istr_parametros_error.cadena[3]="modified"
			istr_parametros_error.cadena[4]=""
			OpenWithParm(w_reporte_errores,istr_parametros_error)
			Close(This)
		CASE 0
			Close(w_retroalimentacion)
//			MessageBox("Error datawindows","No se hallaron datos", &
//			            Exclamation!,Ok!)
		CASE ELSE
			Close(w_retroalimentacion)
			il_fila_actual_maestro = 1
			dw_maestro.SetRow(il_fila_actual_maestro)
			dw_maestro.SelectRow(il_fila_actual_maestro,TRUE)
			dw_maestro.ScrollToRow(il_fila_actual_maestro)
			dw_maestro.SetColumn(1)
			dw_maestro.SetFocus()
	END CHOOSE
ELSE
END IF
end event

event ue_insertar_maestro;Long ll_fila
//////////////////////////////////////////////////////////////////
// En este evento ademas de que hereda lo del padre, se le 
// adicionaron las siguientes lineas, con el proposito
// de obtener la fila actual en el maestro e iluminarla. 
////////////////////////////////////////////////////////////////
ll_fila = dw_maestro.InsertRow(0)
IF ll_fila = -1 THEN
	MessageBox("Error datawindow","No se pudo insertar el registro del maestro",StopSign!,Ok!)
ELSE
	dw_maestro.SetRow(ll_fila)
	dw_maestro.ScrollToRow(ll_fila)
	dw_maestro.SetColumn(1)
	dw_maestro.SelectRow(0,False)
	il_fila_actual_maestro = ll_fila
END IF

dw_maestro.SelectRow(il_fila_actual_maestro,FALSE)
il_fila_actual_maestro = dw_maestro.GetRow()

IF ((il_fila_actual_maestro<> -1) and &
     (NOT ISNULL (il_fila_actual_maestro)) and &
	  (il_fila_actual_maestro<>0))THEN
     dw_maestro.SelectRow(il_fila_actual_maestro,TRUE)
	  //dw_maestro.SetItem(il_fila_actual_maestro, "fe_creacion", DateTime(Today(), Now()))
ELSE
END IF

end event

type dw_maestro from w_base_tabular`dw_maestro within w_mantenimiento_calendario_contable
int Width=1925
int Height=1428
string DataObject="dtb_calendario_contable"
boolean Border=true
BorderStyle BorderStyle=StyleLowered!
boolean HScrollBar=false
boolean HSplitScroll=false
end type

event dw_maestro::itemchanged;////
LONG ll_ano, ll_mes, ll_dia, ll_fila, ll_semana, ll_co_dia
DATE ld_fecha_festivo, ld_fecha

dw_maestro.accepttext()
ll_fila = dw_maestro.getrow()

CHOOSE CASE dwo.name
	CASE 'dia'
		ll_ano = dw_maestro.getitemnumber(ll_fila, 'ano')
		ll_mes = dw_maestro.getitemnumber(ll_fila, 'mes')
		ll_dia = dw_maestro.getitemnumber(ll_fila, 'dia')
		
		ld_fecha = date(ll_ano,ll_mes, ll_dia)
		
		dw_maestro.setitem(ll_fila, 'fe_calendario', ld_fecha)
		
END CHOOSE
end event

type sle_argumento from w_base_tabular`sle_argumento within w_mantenimiento_calendario_contable
int Y=20
boolean BringToTop=true
end type

type st_1 from w_base_tabular`st_1 within w_mantenimiento_calendario_contable
boolean BringToTop=true
end type

