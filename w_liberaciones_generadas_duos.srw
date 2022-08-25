HA$PBExportHeader$w_liberaciones_generadas_duos.srw
forward
global type w_liberaciones_generadas_duos from window
end type
type cb_cerrar from commandbutton within w_liberaciones_generadas_duos
end type
type cb_anular from commandbutton within w_liberaciones_generadas_duos
end type
type cb_igualar from commandbutton within w_liberaciones_generadas_duos
end type
type dw_lista from datawindow within w_liberaciones_generadas_duos
end type
type gb_1 from groupbox within w_liberaciones_generadas_duos
end type
end forward

global type w_liberaciones_generadas_duos from window
integer width = 3342
integer height = 1868
boolean titlebar = true
string title = "Liberaci$$HEX1$$f300$$ENDHEX$$n Duo _ Conjunto"
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_cerrar cb_cerrar
cb_anular cb_anular
cb_igualar cb_igualar
dw_lista dw_lista
gb_1 gb_1
end type
global w_liberaciones_generadas_duos w_liberaciones_generadas_duos

type variables
Long il_cons_lib_duo
Long ii_ref_x_lib
end variables

forward prototypes
public function long of_ref_lib_duo ()
end prototypes

public function long of_ref_lib_duo ();//funcion para determinar el numero de referencias liberadas del duo o counjunto
//jcrm - jorodrig
//septiembre 2 de 2008
Long li_ref_lib_duo
DataStore lds_ref_lib_duo

lds_ref_lib_duo = Create DataStore
lds_ref_lib_duo.DataObject = 'ds_ref_lib_duo'
lds_ref_lib_duo.SetTransObject(sqlca)


li_ref_lib_duo = lds_ref_lib_duo.Retrieve(il_cons_lib_duo)




Return li_ref_lib_duo


end function

on w_liberaciones_generadas_duos.create
this.cb_cerrar=create cb_cerrar
this.cb_anular=create cb_anular
this.cb_igualar=create cb_igualar
this.dw_lista=create dw_lista
this.gb_1=create gb_1
this.Control[]={this.cb_cerrar,&
this.cb_anular,&
this.cb_igualar,&
this.dw_lista,&
this.gb_1}
end on

on w_liberaciones_generadas_duos.destroy
destroy(this.cb_cerrar)
destroy(this.cb_anular)
destroy(this.cb_igualar)
destroy(this.dw_lista)
destroy(this.gb_1)
end on

event open;s_base_parametros lstr_parametros


dw_lista.SetTransObject(sqlca)

lstr_parametros = Message.PowerObjectParm	

il_cons_lib_duo = lstr_parametros.entero[1]
ii_ref_x_lib	 = lstr_parametros.entero[2]	

IF dw_lista.Retrieve(il_cons_lib_duo) <= 0 THEN
	MessageBox('Advertencia','No fue posible recuperar liberaciones, por favor verifique su informaci$$HEX1$$f300$$ENDHEX$$n.',StopSign!)
	Close(This)
END IF
end event

type cb_cerrar from commandbutton within w_liberaciones_generadas_duos
integer x = 2043
integer y = 1348
integer width = 343
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cerrar"
end type

event clicked;Close(Parent)
end event

type cb_anular from commandbutton within w_liberaciones_generadas_duos
integer x = 1440
integer y = 1348
integer width = 489
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Anular Liberaciones"
end type

event clicked;//metodo para anular las liberaciones del duo o conjunto, por no ser aceptada por el 
//usuario de la liberacion
//jcrm - jorodrig
//agosto 26 de 2008
n_cts_liberacion_x_proyeccion luo_liberacion


//se anulan las liberaciones que pertenecen al duo o conjunto
IF luo_liberacion.of_anular_liberacion_duo_conjunto(il_cons_lib_duo) = -1 THEN
	Rollback;
	Close(Parent)
END IF

Close(Parent)
end event

type cb_igualar from commandbutton within w_liberaciones_generadas_duos
integer x = 837
integer y = 1348
integer width = 489
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Igualar Liberaciones"
end type

event clicked;//evento para realizar el recalculo de unidades teniendo como base la liberacion
//con menos numero de unidades dentro del duo o conjunto
//jcrm - jorodrig
//septiembre 2 de 2008
Long li_ref_lib, li_result
n_cts_liberacion_x_proyeccion luo_liberacion
s_base_parametros  lstr_parametros_retro

//se valida si las liberaciones estan aun pendientes de ser igualadas
li_result = luo_liberacion.of_verificar_liberacion(il_cons_lib_duo)
IF li_result > 0 THEN
	//se continua el proceso las liberaciones no han sido igualadas aun
ELSE
	MessageBox('Error','Este proceso ya fue ejecutado.',StopSign!)
	Rollback;
	Return
END IF

//para mostrar ventana de espera  
lstr_parametros_retro.cadena[1]="Procesando ..."
lstr_parametros_retro.cadena[2]="Espere un momento por favor, Verificando total de liberaciones 1/6 "
lstr_parametros_retro.cadena[3]="reloj"
OpenWithParm(w_retroalimentacion,lstr_parametros_retro)     


//se valida que las referencias liberadas sean iguales a las referencias que conforman el duo o conjunto
//se verifican cuantas referencias han sido liberadas
li_ref_lib = of_ref_lib_duo()

//se comparan las refeerencias liberadas con las referencias a liberar
//ii_ref_x_lib = referencias a liberar se envia por parametro desde la ventana w_exitencia_tela_critica
//li_ref_lib   = referencias que han sido liberadas y estan registradas en la tabla temp_unid_liberar_duo
IF ii_ref_x_lib <> li_ref_lib THEN
	MessageBox('Advertencia','Solo es posible ejecutar el proceso de igualar cuando halla liberado la totalidad de las referencias que ~n conforman el duo o conjunto. ',StopSign!)
	CLOSE(w_retroalimentacion)
	Close(Parent)
END IF


CLOSE(w_retroalimentacion)

//se igualan las unidades a liberar de las diferentes referencias que forman el duo o  conjunto
li_result = luo_liberacion.of_calcular_mt_sobra(il_cons_lib_duo)
IF li_result = -1 THEN
	Rollback;
	Close(Parent)
ELSEIF li_result = -2 THEN
	Rollback;
	
	MessageBox('Advertencia','Se presento un error de bloqueo, intente nuevamente.',Exclamation!)
	Return
ELSE
	Close(Parent)
END IF


end event

type dw_lista from datawindow within w_liberaciones_generadas_duos
integer x = 59
integer y = 56
integer width = 3191
integer height = 1164
integer taborder = 10
string title = "none"
string dataobject = "dtb_liberacion_generada_duo"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type gb_1 from groupbox within w_liberaciones_generadas_duos
integer x = 37
integer y = 12
integer width = 3255
integer height = 1260
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
end type

