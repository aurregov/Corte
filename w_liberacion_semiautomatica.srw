HA$PBExportHeader$w_liberacion_semiautomatica.srw
forward
global type w_liberacion_semiautomatica from window
end type
type cb_3 from commandbutton within w_liberacion_semiautomatica
end type
type dw_partes from datawindow within w_liberacion_semiautomatica
end type
type cb_2 from commandbutton within w_liberacion_semiautomatica
end type
type cb_1 from commandbutton within w_liberacion_semiautomatica
end type
type dw_unidxcolorxtalla from datawindow within w_liberacion_semiautomatica
end type
type dw_colores_op from datawindow within w_liberacion_semiautomatica
end type
type dw_telas_ficha from datawindow within w_liberacion_semiautomatica
end type
type cb_buscar from commandbutton within w_liberacion_semiautomatica
end type
type dw_colores from datawindow within w_liberacion_semiautomatica
end type
type cb_limpiar from commandbutton within w_liberacion_semiautomatica
end type
type dw_detalle from datawindow within w_liberacion_semiautomatica
end type
type dw_maestro from datawindow within w_liberacion_semiautomatica
end type
type dw_criterio from datawindow within w_liberacion_semiautomatica
end type
type gb_criterio from groupbox within w_liberacion_semiautomatica
end type
type gb_maestro from groupbox within w_liberacion_semiautomatica
end type
type gb_detalle from groupbox within w_liberacion_semiautomatica
end type
type gb_colores from groupbox within w_liberacion_semiautomatica
end type
type gb_telas from groupbox within w_liberacion_semiautomatica
end type
type gb_colores_op from groupbox within w_liberacion_semiautomatica
end type
type gb_1 from groupbox within w_liberacion_semiautomatica
end type
end forward

global type w_liberacion_semiautomatica from window
integer width = 4539
integer height = 2152
boolean titlebar = true
string menuname = "m_liberacion_semiautomatica"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 67108864
string icon = "AppIcon!"
event ue_rollos ( )
event ue_liberar ( )
event ue_log_errores ( )
event ue_ordenes_pdn ( )
event ue_tela ( )
event ue_unid_prendas ( )
event ue_rollos_problemas ( )
event ue_porcentaje ( )
event ue_determinar_rollos ( )
event ue_grupos ( )
event ue_tela_sustituta ( )
cb_3 cb_3
dw_partes dw_partes
cb_2 cb_2
cb_1 cb_1
dw_unidxcolorxtalla dw_unidxcolorxtalla
dw_colores_op dw_colores_op
dw_telas_ficha dw_telas_ficha
cb_buscar cb_buscar
dw_colores dw_colores
cb_limpiar cb_limpiar
dw_detalle dw_detalle
dw_maestro dw_maestro
dw_criterio dw_criterio
gb_criterio gb_criterio
gb_maestro gb_maestro
gb_detalle gb_detalle
gb_colores gb_colores
gb_telas gb_telas
gb_colores_op gb_colores_op
gb_1 gb_1
end type
global w_liberacion_semiautomatica w_liberacion_semiautomatica

type variables
DataWindowChild idwc_linea, idwc_ref
Long il_ordenpd_pt, il_ref
String	is_po
Boolean ib_rollos
Long ii_fab, ii_lin, ii_tipo_lib
end variables

event ue_rollos();//muestra en dw_maestro las telas que se encuentran disponibles para ser liberadas
//segun el criterio de busqueda dado
Long li_fab, li_lin, li_talla
Long ll_ref, ll_op, ll_result, ll_color
String ls_po, ls_usuario
s_base_parametros lstr_parametros
n_cts_cargar_temporales_liberacion luo_temporal

ls_usuario = Trim(gstr_info_usuario.codigo_usuario)
lstr_parametros.cadena[1] = ls_usuario

dw_criterio.AcceptText()
//se capturan los valores del criterio
li_fab 	= dw_criterio.GetItemNumber(1,'co_fabrica')
li_lin 	= dw_criterio.GetItemNumber(1,'co_linea')
ll_ref 	= dw_criterio.GetItemNumber(1,'co_referencia')
ll_op 	= dw_criterio.GetItemNumber(1,'op')
ll_color = dw_criterio.GetItemNumber(1,'color')
ls_po 	= dw_criterio.GetItemString(1,'po')
li_talla = dw_criterio.GetItemNumber(1,'co_talla')

//*************************************************************************************************************
//en este punto se debe colocar la validacion de referencia marcada en criticas si esta debe de bloquearse la 
//liberacion especificandose el motivo, pero primero debemos establecer como determinar cuando una referencia
//es de linea o de moda, porque la restriccion es solo para linea.
//*************************************************************************************************************


//se colocan valores inicales para los criterios no seleccionados
If isnull(li_fab) 	Then li_fab 	= 0
If isnull(li_lin) 	Then li_lin 	= 0
If isnull(ll_ref) 	Then ll_ref 	= 0
If isnull(ll_op) 		Then ll_op 		= 0
If isnull(ll_color) 	Then ll_color 	= 0
If isnull(ls_po) 		Then ls_po 		= ''
If isnull(li_talla)	Then li_talla  = 0

If li_fab = 0 and li_lin = 0 and ll_ref = 0 and ll_op = 0 and ll_color = 0 and ls_po = '' and li_talla = 0 Then
	MessageBox('Advertencia','no puede generarse una preliberaci$$HEX1$$f300$$ENDHEX$$n sin criterios.',StopSign!)
	Return
End if

dw_detalle.Reset()
dw_maestro.Reset()
dw_colores.Reset()
//dw_colores_op.Reset()
//dw_telas_ficha.Reset()

//se eliminan los datos de las temporales
If luo_temporal.of_borrarTemporales(ls_usuario) = -1 Then
	Rollback;
	Return
End if

//se debe cargar la tabla temporal de rollos(Telas)
If luo_temporal.of_cargarTempRollos(li_fab,li_lin,ll_ref,ll_op,ls_po,ll_color) = -1 Then
	Rollback;
	Return
Else
	//se verifica si el usuario desea borrar rollos para forzar la liberaci$$HEX1$$f300$$ENDHEX$$n.
	If ib_rollos = True Then
		OpenWithParm(w_seleccion_rollos,lstr_parametros)
		
		lstr_parametros = Message.PowerObjectParm	
		
		If lstr_parametros.hay_parametros = True Then
			ib_rollos = False	
		Else	
			Rollback;
			Return
		End if
	End if
	
	//se carga la temporal de referencias
	If luo_temporal.of_cargarTemReferencias(ll_color, li_talla) = -1 Then
		Rollback;
		Return
	Else
		//debemos validar las telas disponibles con respecto a la ficha
		If luo_temporal.of_validarficha() = -1 Then//descomentado
			open(w_log_errores_liberacion)//abrir ventana del log de errores de liberacion
			Rollback;
			Return
		Else
			If luo_temporal.of_cargar_modelos_unid() = -1 Then
				Rollback;
				Return
			End if
	   End if
	End if
End if

Commit;

ll_result = dw_maestro.Retrieve(ls_usuario)

If ll_result > 0 Then
Else
	//MessageBox('Advertencia','No existe tela para cumplir el criterio.')//comentado
	open(w_log_errores_liberacion)//abrir ventana del log de errores de liberacion
End if
	
end event

event ue_liberar();//Evento para cargar los datos generados de la liberacion de las tablas temporal a 
//las tablas de la liberaci$$HEX1$$f300$$ENDHEX$$n
Long ll_fila, ll_ordenpd_pt, ll_total_pedido, ll_ped_tall, ll_cant_libe, ll_fila2,&
     ll_ordenpd_pt_new, ll_lib_tall, ll_total_lib, ll_result, ll_reftel, ll_tot_lib,&
	  ll_cant_libe2, ll_total_pedido2, ll_tanda, ll_referencia, ll_colorte, ll_color_old, ll_color_new, ll_color
String ls_po, ls_usuario, ls_po_new, ls_po_old, ls_tono, ls_error
String ls_clave, ls_clave_valida
Long li_talla,  li_raya, li_raya_new,&
        li_caract, li_diametro, li_talla2, li_modelos_ficha, li_modelos_liberar, &
		  li_fabrica, li_linea
Decimal{4} ldc_porctlla, ldc_porctllalib, ldc_ancho, ldc_mt_bod, ldc_consumo, ldc_total_mt,&
           ldc_ancho_new, ldc_acum_consumo, ldc_metros_nec, ldc_met_bod, ld_diferencia 
n_cts_liberacion_semiautomatica luo_liberar
n_cts_constantes_tela luo_constantes
s_base_parametros lstr_parametros
DataStore lds_total_modelos_liberacion, lds_total_modelos_ficha

lds_total_modelos_liberacion = Create DataStore
lds_total_modelos_liberacion.DataObject = 'ds_total_modelos_liberacion'
lds_total_modelos_liberacion.SetTransObject(sqlca)

lds_total_modelos_ficha = Create DataStore
lds_total_modelos_ficha.DataObject = 'ds_total_modelos_ficha'
lds_total_modelos_ficha.SetTransObject(sqlca)

ls_usuario = gstr_info_usuario.codigo_usuario

//primero se debe validar que la proporci$$HEX1$$f300$$ENDHEX$$n si se siga cumpliendo.
dw_detalle.AcceptText()

ll_color_old = -1
ls_po_old = ''

//Se crea para verificar los modelos antes de cargar a las tablas de la liberacion, se verifica
//que el total de modelos de la ficha sea igual al total de modelos a cargar mayo 26-2006
li_fabrica = dw_detalle.GetItemNumber(1,'co_fabrica')
li_linea = dw_detalle.GetItemNumber(1,'co_linea')
ll_referencia = dw_detalle.GetItemNumber(1,'co_referencia')
ll_color = dw_detalle.GetItemNumber(1,'co_color')
ll_ordenpd_pt = dw_detalle.GetItemNumber(1,'cs_ordenpd_pt')

li_modelos_ficha = lds_total_modelos_ficha.Retrieve(li_fabrica,li_linea,ll_referencia,ll_color)
li_modelos_liberar = lds_total_modelos_liberacion.Retrieve(ls_usuario,ll_ordenpd_pt)

IF li_modelos_ficha <> li_modelos_liberar THEN
	MessageBox('Error','El total de modelos a liberar es diferente al total de modelos de la ficha, Verifique en el icono Unidades x Modelo')
	Return
END IF


	
	//recorro la data windows
	For ll_fila = 1 To dw_detalle.RowCount()
		//***************************************** PROPORCION ***************************************
		//obtengo las datos necesarios para conocer la proporcion de la talla
		ls_po 		  = dw_detalle.GetItemString(ll_fila,'po')
		ll_ordenpd_pt = dw_detalle.GetItemNumber(ll_fila,'cs_ordenpd_pt')
		ll_color 	  = dw_detalle.GetItemNumber(ll_fila,'co_color')
		li_talla 	  = dw_detalle.GetItemNumber(ll_fila,'co_talla')
		ll_ped_tall   = dw_detalle.GetItemNumber(ll_fila,'unid_prog')
		li_raya		  = dw_detalle.GetItemNumber(ll_fila,'raya')	
		ldc_ancho     = dw_detalle.getItemNumber(ll_fila,'ancho')
		//cantidad modificable en la dw detalle
		ll_cant_libe = dw_detalle.GetItemNumber(ll_fila,'unid_real_liberar')
			
		If ll_cant_libe > 0 Then
			If ll_color <> ll_color_old and ls_po <> ls_po_old Then
				//Determino el total pedido para la po-color
				//se debe recorrer toda la datawindows y preguntar por cada talla para solo
				//sumarle al valor del pedido las tallas que tengan cantidad diferente de cero
				//en el campo de unid. liberar.
				For ll_fila2 = 1 To dw_detalle.RowCount()
					ll_cant_libe2 = dw_detalle.GetItemNumber(ll_fila2,'unid_real_liberar')
					li_talla2 	  = dw_detalle.GetItemNumber(ll_fila2,'co_talla')
					ldc_ancho 	= dw_detalle.GetItemNumber(ll_fila2,'ancho')
					If ll_cant_libe2 > 0 Then
						SELECT SUM(unid_prog)
						  INTO :ll_total_pedido
						  FROM temp_modelos_ref
						 WHERE usuario 		= :ls_usuario AND
								 cs_ordenpd_pt = :ll_ordenpd_pt AND
								 co_color 		= :ll_color AND
								 po  				= :ls_po AND
								 raya				= :li_raya AND
								 co_talla		= :li_talla2 AND
								 ancho			= :ldc_ancho AND
								 sw_carga		= 1;
						 
						 If sqlca.sqlcode = -1 Then
							ls_error = sqlca.sqlerrtext
							Rollback;
							MessageBox('Error Base Datos','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de consultar las unidades, ERROR: '+ls_error)
						End if
						 
						ll_total_pedido2 += ll_total_pedido  
					End if
				Next
			End if
			ll_total_pedido = ll_total_pedido2
			ll_total_pedido2 = 0
			//ahorra puedo conocer el porcentaje de la talla con respecto a la po
			ldc_porctlla = (ll_ped_tall * 100 ) / ll_total_pedido 
			//ya conozco el porcentaje de la talla ahorra debo conocer las unidades designadas
			// a esta talla a que porcentaje equivalen
			ll_total_lib = 0
			//averiguo el total a liberar para el color-po
			For ll_fila2 = 1 To dw_detalle.RowCount()
				ls_po_new 		   = dw_detalle.GetItemString(ll_fila2,'po')
				ll_ordenpd_pt_new = dw_detalle.GetItemNumber(ll_fila2,'cs_ordenpd_pt')
				ll_color_new 	   = dw_detalle.GetItemNumber(ll_fila2,'co_color')
				ll_lib_tall       = dw_detalle.GetItemNumber(ll_fila2,'unid_real_liberar')
				
				IF ls_po_new = ls_po AND ll_ordenpd_pt_new = ll_ordenpd_pt AND ll_color_new = ll_color THEN
					ll_total_lib += ll_lib_tall
				End if
			Next
			
			//vamos a hacer una prueba con la referencia musset que al recalcular en texografo
			//se bajan las unidades,  se va a dejar liberar con las unidades que tengan los rectilineos
			//y sin proporcion, esto es para probar solo en esta rerefencia
			//jorodrig enero3 - 2008
	
			//averiguo el porcentaje pedido para dicha talla
			ldc_porctllalib = (ll_cant_libe * 100) / ll_total_lib
			//comparo el porcentaje de participaci$$HEX1$$f300$$ENDHEX$$n de la talla con el porcentaje de unidades solicitadas a liberar
			If Truncate(ldc_porctlla,0) <> Truncate(ldc_porctllalib,0) Then
				ld_diferencia =  ldc_porctlla - ldc_porctllalib
				IF ld_diferencia < 0 THEN ld_diferencia = ld_diferencia * -1
				IF ld_diferencia > 2 THEN   //esta se utiliza porque en ocasiones la diferencia es peque$$HEX1$$f100$$ENDHEX$$a menor que 2
					MessageBox('Error','La proporcion para la P.O. '+Trim(ls_po)+' en la talla: '+String(li_talla)+' no es valida.')

					//para el caso que se esta cerrando la op con las ultimas unidades se debe permitir liberar sin proporcion
					//esto lo pide Jesus Maria Henao y se realiza el 2 de mayo del 2008  jorodrig
					ls_clave_valida = luo_constantes.of_consultar_texto("PASSWORD_LIBERA")
					Open(w_porcentaje)
					lstr_parametros = message.PowerObjectParm
					If lstr_parametros.hay_parametros = True Then
						ls_clave = lstr_parametros.cadena[1]
						IF TRIM(ls_clave) <> TRIM(ls_clave_valida) THEN
							MessageBox('Advertencia','Clave Invalida')
							Return
						END IF
					ELSE
						Return
					END IF
					
				END IF
				
			End if
			
		End if
	Next
	
dw_detalle.Update()

ls_po 		  = dw_detalle.GetItemString(1,'po')
ll_ordenpd_pt = dw_detalle.GetItemNumber(1,'cs_ordenpd_pt')
ll_color 	  = dw_detalle.GetItemNumber(1,'co_color')
ldc_ancho     = dw_detalle.getItemNumber(1,'ancho')
ll_tanda 	  = dw_detalle.GetItemNumber(1,'cs_tanda')
//una vez cumplidas estas validaciones debemos descargar los datos a las tablas de la liberacion.
//If luo_liberar.of_generar_liberacion(ls_usuario,ll_ordenpd_pt,ls_po,ll_color,ldc_ancho,ll_tanda,1,0,'0','0',0) = -1 Then
//	Return
//End if

dw_maestro.Retrieve(ls_usuario)
dw_detalle.Retrieve(ls_usuario, ll_ordenpd_pt,ll_color,ls_po, ldc_ancho,ll_tanda)

	
	
end event

event ue_log_errores();OpenSheet(w_log_errores_liberacion,w_principal, 0, Original!)
end event

event ue_ordenes_pdn();s_base_parametros lstr_parametros

Open(w_inicial_liberacion_semiautomatica)

lstr_parametros = message.PowerObjectParm	

If lstr_parametros.hay_parametros Then

	dw_criterio.Reset()
	dw_criterio.InsertRow(0)
	
	dw_criterio.SetItem(1,'co_fabrica',lstr_parametros.entero[1])
	dw_criterio.SetItem(1,'co_linea',lstr_parametros.entero[2])
	dw_criterio.SetItem(1,'co_referencia',lstr_parametros.entero[3])
	dw_criterio.SetItem(1,'op',lstr_parametros.entero[4])
	
	dw_criterio.AcceptText()
	
	TriggerEvent("ue_rollos")
	
End if

dw_criterio.SetFocus()
end event

event ue_tela();String ls_usuario
long ll_ordenpd

s_base_parametros lstr_parametros

ls_usuario = gstr_info_usuario.codigo_usuario

//ll_ordenpd = dw_maestro.getitemnumber(dw_maestro.getRow(),"cs_ordenpd_pt")

lstr_parametros.cadena[1] = ls_usuario

lstr_parametros.entero[1] = il_ordenpd_pt

openwithparm(w_telas,lstr_parametros)

end event

event ue_unid_prendas();String ls_usuario
long ll_ordenpd
long	ll_color

s_base_parametros lstr_parametros

ls_usuario = gstr_info_usuario.codigo_usuario

//ll_ordenpd = dw_maestro.getitemnumber(dw_maestro.getrow(),"cs_ordenpd_pt")
ll_color = dw_colores.getitemnumber(dw_colores.getrow(),"co_color")
lstr_parametros.cadena[1] = ls_usuario

lstr_parametros.entero[1] = il_ordenpd_pt
lstr_parametros.entero[2] = ll_color

openwithparm(w_unid_referencias,lstr_parametros)
end event

event ue_rollos_problemas();String ls_usuario
long ll_ordenpd

s_base_parametros lstr_parametros

dw_criterio.AcceptText()

ll_ordenpd = dw_criterio.getitemnumber(1,"op")

lstr_parametros.entero[1] = ll_ordenpd

openwithparm(w_rollos_liberacion_problemas,lstr_parametros)
end event

event ue_porcentaje();String ls_referencia
Long ll_fila
s_base_parametros lstr_parametros

ll_fila = dw_maestro.GetRow()

If ll_fila > 0 Then
	ls_referencia = dw_maestro.GetItemString(ll_fila,'de_referencia')
	lstr_parametros.cadena[1] = ls_referencia
Else
	lstr_parametros.cadena[1] = 'XXX'
End if

OpenSheetWithParm(w_administracion_porc_permitido_ref,lstr_parametros,w_principal,0,Original!)
end event

event ue_determinar_rollos();ib_rollos = True
end event

event ue_grupos();Long ll_fila, ll_ordenpd_pt
Long li_fabrica
String ls_po
s_base_parametros lstr_parametros

ll_fila = dw_maestro.GetRow()

If ll_fila > 0 Then
	ll_ordenpd_pt = dw_maestro.GetItemNumber(ll_fila,'cs_ordenpd_pt')
	
	SELECT Distinct co_fabrica_exp, nu_orden
	  INTO :li_fabrica, :ls_po
	  FROM dt_pedidosxorden
	 WHERE cs_ordenpd_pt = :ll_ordenpd_pt;
	 
	IF sqlca.sqlcode = 0 Then
	 	 lstr_parametros.entero[1] = li_fabrica
		 lstr_parametros.cadena[1] = ls_po
		
		 OpenWithParm (w_grupos, lstr_parametros)
	Else
		MessageBox('Error','No fue posible establer la P.O. ',Exclamation!)
		Return
	End if
End if


end event

event ue_tela_sustituta();//evento utilizado para poder marcar los rollos con tela sustituta
//y modificarla por la referencia de tela correcta.
//jcrm
//octubre 2 de 2007
Long li_centroterm
n_cts_constantes luo_constantes
luo_constantes = Create n_cts_constantes
s_base_parametros lstr_parametros


lstr_parametros.entero[1] = dw_criterio.GetItemNumber(1,'op')
lstr_parametros.entero[2] = dw_criterio.GetItemNumber(1,'color')

//se modifica el centro de tela terminado a 15 si la fabrica es MARINILLA o 21 si es PEREIRA
//jcrm
//octubre 8 de 2007
IF gstr_info_usuario.co_planta_pro = 2 THEN
	li_centroterm = luo_constantes.of_consultar_numerico("CENTRO TELA TERMINAD")
	IF li_centroterm = -1 THEN
		MessageBox('Error','No fue posible establecer el centro de los rollos para Marinilla.')
		Return 
	END IF
END IF

IF gstr_info_usuario.co_planta_pro = 99 THEN
	li_centroterm = luo_constantes.of_consultar_numerico("CENTRO TELA PEREIRA")
	IF li_centroterm = -1 THEN
		MessageBox('Error','No fue posible establecer el centro de los rollos para Pereira.')
		Return 
	END IF
END IF

lstr_parametros.entero[3] = li_centroterm

IF IsNull(lstr_parametros.entero[1]) Or IsNull(lstr_parametros.entero[2]) THEN
	MessageBox('Advertencia','Para utilizar esta opci$$HEX1$$f300$$ENDHEX$$n es necesario que ingrese La OP de Estilo y el color.',Exclamation!)
	Return
END IF

OpenSheetWithParm(w_rollos_tela_sustituta, lstr_parametros, This, 0, Original!)

		
		



end event

on w_liberacion_semiautomatica.create
if this.MenuName = "m_liberacion_semiautomatica" then this.MenuID = create m_liberacion_semiautomatica
this.cb_3=create cb_3
this.dw_partes=create dw_partes
this.cb_2=create cb_2
this.cb_1=create cb_1
this.dw_unidxcolorxtalla=create dw_unidxcolorxtalla
this.dw_colores_op=create dw_colores_op
this.dw_telas_ficha=create dw_telas_ficha
this.cb_buscar=create cb_buscar
this.dw_colores=create dw_colores
this.cb_limpiar=create cb_limpiar
this.dw_detalle=create dw_detalle
this.dw_maestro=create dw_maestro
this.dw_criterio=create dw_criterio
this.gb_criterio=create gb_criterio
this.gb_maestro=create gb_maestro
this.gb_detalle=create gb_detalle
this.gb_colores=create gb_colores
this.gb_telas=create gb_telas
this.gb_colores_op=create gb_colores_op
this.gb_1=create gb_1
this.Control[]={this.cb_3,&
this.dw_partes,&
this.cb_2,&
this.cb_1,&
this.dw_unidxcolorxtalla,&
this.dw_colores_op,&
this.dw_telas_ficha,&
this.cb_buscar,&
this.dw_colores,&
this.cb_limpiar,&
this.dw_detalle,&
this.dw_maestro,&
this.dw_criterio,&
this.gb_criterio,&
this.gb_maestro,&
this.gb_detalle,&
this.gb_colores,&
this.gb_telas,&
this.gb_colores_op,&
this.gb_1}
end on

on w_liberacion_semiautomatica.destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_3)
destroy(this.dw_partes)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.dw_unidxcolorxtalla)
destroy(this.dw_colores_op)
destroy(this.dw_telas_ficha)
destroy(this.cb_buscar)
destroy(this.dw_colores)
destroy(this.cb_limpiar)
destroy(this.dw_detalle)
destroy(this.dw_maestro)
destroy(this.dw_criterio)
destroy(this.gb_criterio)
destroy(this.gb_maestro)
destroy(this.gb_detalle)
destroy(this.gb_colores)
destroy(this.gb_telas)
destroy(this.gb_colores_op)
destroy(this.gb_1)
end on

event open;This.x = 1
This.y = 1
Long li_fab, li_lin
Long ll_ref, ll_color
s_base_parametros lstr_parametros

ii_tipo_lib = 1   //liberacion por demanda (moda)

dw_criterio.SetTransObject(sqlca)
dw_maestro.SetTransObject(sqlca)
dw_detalle.SetTransObject(sqlca)
dw_colores.SetTransObject(sqlca)
dw_telas_ficha.SetTransObject(sqlca)
dw_colores_op.SetTransObject(sqlca)
dw_unidxcolorxtalla.SetTransObject(sqlca)
dw_partes.SetTransObject(sqlca)

dw_criterio.GetChild('co_linea',idwc_linea)
dw_criterio.GetChild('co_referencia',idwc_ref)

idwc_linea.SetTransObject(sqlca)
idwc_ref.SetTransObject(sqlca)

idwc_linea.Retrieve(2)
idwc_ref.Retrieve(2,1)

dw_criterio.InsertRow(0)
dw_criterio.SetFocus()

w_liberacion_semiautomatica.title = " Liberaci$$HEX1$$f300$$ENDHEX$$n " 

lstr_parametros = Message.PowerObjectParm	
 
//******************************************************* 
lstr_parametros = Message.PowerObjectParm

//se cargan los parametros enviados desde la ventana filtro de liberacion
IF lstr_parametros.hay_parametros = True Then
	dw_criterio.SetItem(1,'co_fabrica',lstr_parametros.entero[2])
	dw_criterio.SetItem(1,'co_linea',lstr_parametros.entero[3])
	dw_criterio.SetItem(1,'co_referencia',lstr_parametros.entero[4])
	dw_criterio.SetItem(1,'op',lstr_parametros.entero[5])
	dw_criterio.SetItem(1,'color',lstr_parametros.entero[6])	
	dw_criterio.SetItem(1,'co_talla',lstr_parametros.entero[7])
	
	IF lstr_parametros.entero[5] > 0 THEn
		dw_colores_op.Retrieve(lstr_parametros.entero[5])
	END IF
	
	IF lstr_parametros.entero[6] > 0 AND lstr_parametros.entero[5] > 0 THEN
			SELECT co_fabrica, co_linea, co_referencia
			  INTO :li_fab, :li_lin, :ll_ref
			  FROM h_ordenpd_pt
			 WHERE cs_ordenpd_pt = :lstr_parametros.entero[5]; 
			dw_telas_ficha.Retrieve(li_fab, li_lin, ll_ref, lstr_parametros.entero[6])
			dw_colores_op.Retrieve(lstr_parametros.entero[5])
			ii_fab = li_fab
			ii_lin = li_lin
			il_ref = ll_ref
			dw_criterio.SetItem(1,'co_fabrica',ii_fab)
			dw_criterio.SetItem(1,'co_linea',ii_lin)
			dw_criterio.SetItem(1,'co_referencia',il_ref)
			
			dw_partes.Reset()
			dw_partes.InsertRow(0)
	END IF
END IF


end event

event closequery;String ls_usuario
n_cts_cargar_temporales_liberacion luo_temporal

ls_usuario = gstr_info_usuario.codigo_usuario

//se eliminan los datos de las temporales
If luo_temporal.of_borrarTemporales(ls_usuario) = -1 Then
	Rollback;
	Return
End if
end event

type cb_3 from commandbutton within w_liberacion_semiautomatica
integer x = 3273
integer y = 360
integer width = 343
integer height = 76
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Existencia"
end type

event clicked;Long	li_fab, li_lin, li_bodysize, li_talla_pt
LONG		ll_ref, ll_op, ll_color_pt
STRING	usuario
s_base_parametros lstr_parametros, lstr_parametros_retro
n_cts_liberacion_x_proyeccion   luo_liberacion_x_proyeccion

//para mostrar ventana de espera  
lstr_parametros_retro.cadena[1]="Procesando ..."
lstr_parametros_retro.cadena[2]="Espere un momento por favor, Cargando  datos segun Ficha y Existencia en bodega "
lstr_parametros_retro.cadena[3]="reloj"
OpenWithParm(w_retroalimentacion,lstr_parametros_retro)     

usuario = gstr_info_usuario.codigo_usuario
ll_color_pt = dw_criterio.GetItemNumber(1,'color')
ll_op = dw_criterio.GetItemNumber(1,'op')
li_talla_pt = dw_criterio.GetItemNumber(1,'co_talla')

SELECT co_fabrica, co_linea, co_referencia
  INTO :li_fab, :li_lin, :ll_ref
  FROM h_ordenpd_pt
 WHERE cs_ordenpd_pt =  :ll_op;

//revisar si la referencia es bodysize, esta revision es contando si en el modelo principal cada talla tiene diferene diametro
li_bodysize = luo_liberacion_x_proyeccion.of_revisar_si_bodysize(li_fab, li_lin, ll_ref, ll_color_pt)
IF li_bodysize = 1 THEN
	//La ref es bodysize
	IF IsNull(li_talla_pt) THEN
		MessageBox('Error,','El estilo es Bodysize, debe ingresar el codigo de la talla a consultar')
		Return
	ELSE
		MessageBox('Mensaje','El Estilo es Bodysize porque tiene varios diametros en el modelo principal, se libera la talla: '+string(li_talla_pt))
	END IF
ELSE
	li_talla_pt = 9999
END IF
IF luo_liberacion_x_proyeccion.of_cargar_temp_ref_liberar(usuario, li_fab, li_lin, ll_ref, ll_color_pt, li_talla_pt, li_bodysize, 0, 0, ll_op,0,0,'0','0',0,0) = -1 THEN
	CLOSE(w_retroalimentacion)
	Return
END IF

lstr_parametros.entero[1]  = li_fab
lstr_parametros.entero[2]  = li_lin
lstr_parametros.entero[3]  = ll_ref
lstr_parametros.entero[4]  = ll_color_pt
lstr_parametros.entero[5]  = 0
lstr_parametros.entero[6]  = 0
lstr_parametros.entero[7]  = li_talla_pt
lstr_parametros.entero[8]  = ll_op
lstr_parametros.entero[9]  = 0
lstr_parametros.cadena[1]  = '0'
lstr_parametros.cadena[2]  = '0'

OpenSheetWithParm(w_existencias_tela_critica, lstr_parametros, W_PRINCIPAL,0,Original!)
CLOSE(w_retroalimentacion)
end event

type dw_partes from datawindow within w_liberacion_semiautomatica
integer x = 1883
integer y = 1572
integer width = 690
integer height = 372
integer taborder = 70
string title = "none"
string dataobject = "dgr_partes_modelo"
boolean border = false
boolean livescroll = true
end type

type cb_2 from commandbutton within w_liberacion_semiautomatica
boolean visible = false
integer x = 119
integer y = 1856
integer width = 343
integer height = 88
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "none"
end type

event clicked;DataStore lds_oc, lds_unid_talla_oc
Long	ll_fila, ll_result, li_fab, li_linea, li_fila1, ll_result1, li_talla, li_existe
Long		ll_liberacion, ll_oc, ll_referencia, ll_unid, ll_color_pt
                             
lds_oc 		= Create DataStore
lds_unid_talla_oc = Create DataStore

lds_oc.DataObject = 'd_oc_cargar'
lds_unid_talla_oc.DataObject = 'd_unid_talla_oc'

lds_oc.SetTransObject(sqlca)
lds_unid_talla_oc.SetTransObject(sqlca)

ll_result = lds_oc.Retrieve()

FOR ll_fila = 1 To ll_result
	ll_liberacion = lds_oc.GetItemNumber(ll_fila,'cs_liberacion')
	ll_oc = lds_oc.GetItemNumber(ll_fila,'cs_asignacion')
	li_fab = lds_oc.GetItemNumber(ll_fila,'co_fabrica_pt')
	li_linea = lds_oc.GetItemNumber(ll_fila,'co_linea')
	ll_referencia = lds_oc.GetItemNumber(ll_fila,'co_referencia')
	ll_color_pt = lds_oc.GetItemNumber(ll_fila,'co_color_pt')
	
	select count(*)
	  into :li_existe
	  from t_criticas_cedi
	 where ano = 2007
	   and semana = 51
		and co_fabrica = :li_fab
		and co_linea = :li_linea
		and co_referencia = :ll_referencia
		and co_color = :ll_color_pt;
		
	IF li_existe > 0 THEN
		ll_result1 = lds_unid_talla_oc.Retrieve(ll_liberacion, li_fab, li_linea, ll_referencia, ll_color_pt)
		FOR li_fila1 = 1 TO ll_result1
			li_talla = lds_unid_talla_oc.GetItemNumber(li_fila1,'co_talla')
			ll_unid  = lds_unid_talla_oc.GetItemNumber(li_fila1,'compute_0002')
			
			UPDATE t_criticas_cedi
			SET cant_liberado = (cant_liberado + :ll_unid)
			WHERE ano = 2007
		   AND semana = 51
		   AND co_fabrica = :li_fab
		   AND co_linea = :li_linea
		   AND co_referencia = :ll_referencia
		   AND co_color = :ll_color_pt
			AND co_talla = :li_talla;
			
		NEXT
		
		UPDATE dt_pdnxmodulo
		SET semana = 51
		WHERE cs_liberacion = :ll_liberacion  
		  AND co_fabrica_pt = :li_fab
		  AND co_linea = :li_linea
		  AND co_referencia = :ll_referencia
		  AND co_color_pt = :ll_color_pt
		  AND cs_asignacion = :ll_oc;
		
		COMMIT;
	END IF
	

NEXT

end event

type cb_1 from commandbutton within w_liberacion_semiautomatica
integer x = 3273
integer y = 268
integer width = 343
integer height = 76
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Concepto 15"
end type

event clicked;
//si la fabrica seleccionada al ingresar en la aplicacion es marinilla se muestran los conceptos
//de lo contrario no se muestran ya que a NICOLE esto no le aplica
//jcrm
//mayo 15 de 2007
IF gstr_info_usuario.co_planta_pro = 2 THEN
	//evento para marcar los rollos de laliberaci$$HEX1$$f300$$ENDHEX$$n selecciona con los conceptos de Molderia o Lote validaci$$HEX1$$f300$$ENDHEX$$n
	Long ll_fila
	s_base_parametros lstr_parametros
	
	dw_criterio.AcceptText()
	
	lstr_parametros.entero[1] = dw_criterio.GetItemNumber(1,'op')
	//abrir ventana donde esten los rollos de la liberaci$$HEX1$$f300$$ENDHEX$$n y donde puedan elegir el concepto por el cual
	//no es posible liberar 
	OpenWithParm ( w_conceptos_planeacion_centro_15, lstr_parametros )
END IF


end event

type dw_unidxcolorxtalla from datawindow within w_liberacion_semiautomatica
integer x = 3255
integer y = 1568
integer width = 1166
integer height = 380
integer taborder = 60
string title = "none"
string dataobject = "dtb_unidades_libxcolor_talla_exp"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type dw_colores_op from datawindow within w_liberacion_semiautomatica
integer x = 2615
integer y = 1576
integer width = 645
integer height = 348
integer taborder = 50
string title = "none"
string dataobject = "dgr_color_op"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event clicked;Long li_fabrica, li_linea, li_result
Long ll_referencia, ll_color
STRING	ls_po

This.SelectRow(0, FALSE)

This.SelectRow(row, TRUE)


li_fabrica = This.GetItemNumber(row,'co_fabrica')
li_linea = This.GetItemNumber(row,'co_linea')
ll_referencia = This.GetItemNumber(row,'co_referencia')
ll_color = This.GetItemNumber(row,'co_color')
ls_po    = This.GetItemString(row,'nu_orden')

dw_telas_ficha.Retrieve(li_fabrica, li_linea, ll_referencia, ll_color)


dw_unidxcolorxtalla.DataObject = 'dtb_unidades_libxcolor_talla_exp'
dw_unidxcolorxtalla.SetTransObject(sqlca)
li_result = dw_unidxcolorxtalla.Retrieve(il_ordenpd_pt, ls_po, ll_color)

end event

event getfocus;gb_detalle.TextColor = (rgb(0,0,0))
gb_maestro.TextColor = (rgb(0,0,0))
gb_criterio.TextColor = (rgb(0,0,0))
gb_colores.TextColor = (rgb(0,0,0))
gb_telas.TextColor = (rgb(0,0,0))
gb_colores_op.TextColor = (rgb(0,0,255))
end event

type dw_telas_ficha from datawindow within w_liberacion_semiautomatica
integer x = 41
integer y = 1576
integer width = 1815
integer height = 372
integer taborder = 50
string title = "none"
string dataobject = "dgr_telas_ficha"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event getfocus;gb_detalle.TextColor = (rgb(0,0,0))
gb_maestro.TextColor = (rgb(0,0,0))
gb_criterio.TextColor = (rgb(0,0,0))
gb_colores.TextColor = (rgb(0,0,0))
gb_telas.TextColor = (rgb(0,0,255))
gb_colores_op.TextColor = (rgb(0,0,0))
end event

event clicked;//This.SelectRow(0, FALSE)
//
//This.SelectRow(row, TRUE)
//
Long ll_modelo, ll_referencia

This.SelectRow(0,False)

If isnull(row) Then row = 1
This.SelectRow(row,True)

If row > 0 Then
	ll_modelo = This.GetItemNumber(Row,'dt_color_modelo_co_modelo')
	dw_partes.Retrieve(ll_modelo,ii_fab,ii_lin,il_ref)
	

End if
end event

type cb_buscar from commandbutton within w_liberacion_semiautomatica
integer x = 3273
integer y = 92
integer width = 343
integer height = 76
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Buscar"
end type

event clicked;w_liberacion_semiautomatica.TriggerEvent('ue_rollos')
end event

type dw_colores from datawindow within w_liberacion_semiautomatica
integer x = 2729
integer y = 576
integer width = 1655
integer height = 932
integer taborder = 40
string title = "none"
string dataobject = "dtb_colores_liberacion_semiautomatica"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event getfocus;gb_detalle.TextColor = (rgb(0,0,0))
gb_maestro.TextColor = (rgb(0,0,0))
gb_colores.TextColor = (rgb(0,0,255))
gb_criterio.TextColor = (rgb(0,0,0))
gb_telas.TextColor = (rgb(0,0,0))
gb_colores_op.TextColor = (rgb(0,0,0))
end event

event clicked;String ls_usuario, ls_po
Long ll_ordenpd_pt, ll_tanda, ll_referencia, ll_reftel, ll_color
Decimal{2} ldc_ancho
Long li_fabrica, li_linea
n_cts_cargar_temporales_liberacion luo_liberacion

This.SelectRow(0, FALSE)

This.SelectRow(row, TRUE)

li_fabrica = dw_maestro.GetItemNumber(dw_maestro.GetRow(),'co_fabrica')
li_linea = dw_maestro.GetItemNumber(dw_maestro.GetRow(),'co_linea')
ll_referencia = dw_maestro.GetItemNumber(dw_maestro.GetRow(),'co_referencia')

ls_usuario 	  = gstr_info_usuario.codigo_usuario
ll_ordenpd_pt = dw_maestro.GetItemNumber(dw_maestro.GetRow(),'cs_ordenpd_pt')
ll_color      = This.GetItemNumber(row,'co_color')
ls_po			  = This.GetItemString(row,'po')	
ldc_ancho     = This.GetItemNumber(row,'ancho')
ll_tanda	     = This.GetItemNumber(row,'cs_tanda')
ll_reftel     = This.GetItemNumber(row,'co_reftel')

IF luo_liberacion.of_recalcularunidadesmin(ll_ordenpd_pt,ll_color,ls_po,ldc_ancho,ll_tanda,ll_reftel,ii_tipo_lib,'',ll_ordenpd_pt) = -1 THEN
	Return
END IF

il_ordenpd_pt = ll_ordenpd_pt
is_po			  = ls_po	

dw_maestro.Retrieve(ls_usuario)

dw_colores_op.Retrieve(ll_ordenpd_pt)
dw_detalle.Retrieve(ls_usuario, ll_ordenpd_pt,ll_color,ls_po, ldc_ancho,ll_tanda)
dw_telas_ficha.Retrieve(li_fabrica, li_linea, ll_referencia, ll_color)
end event

type cb_limpiar from commandbutton within w_liberacion_semiautomatica
integer x = 3273
integer y = 180
integer width = 343
integer height = 76
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Limpiar"
end type

event clicked;dw_criterio.Reset()
dw_criterio.InsertRow(0)
dw_criterio.SetFocus()
end event

type dw_detalle from datawindow within w_liberacion_semiautomatica
integer x = 553
integer y = 576
integer width = 2085
integer height = 932
integer taborder = 30
string title = "none"
string dataobject = "dtb_detalla_liberacion_semiautomatica"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event getfocus;gb_detalle.TextColor = (rgb(0,0,255))
gb_maestro.TextColor = (rgb(0,0,0))
gb_criterio.TextColor = (rgb(0,0,0))
gb_colores.TextColor = (rgb(0,0,0))
gb_telas.TextColor = (rgb(0,0,0))
gb_colores_op.TextColor = (rgb(0,0,0))
end event

event itemchanged;//validar que al cambiar unidadesa liberar no esten colocando m$$HEX1$$e100$$ENDHEX$$s unidades
//de las que hay en rectilineas
Long ll_reftel, ll_result, ll_fila, ll_filas, ll_ordenpd_pt, ll_unid_rectilinea,ll_unid_liberar, ll_color
Long li_caract, li_talla
String ls_usuario, ls_po
n_cts_cargar_temporales_liberacion luo_liberacion
DataStore lds_modelos

lds_modelos = Create dataStore
lds_modelos.DataObject = 'dtb_modelos_po'
lds_modelos.SetTransObject(sqlca)

ls_usuario = gstr_info_usuario.codigo_usuario
ll_ordenpd_pt = This.GetItemNumber(row,'cs_ordenpd_pt')
ll_color = This.GetItemNumber(row,'co_color')
ls_po = This.GetItemString(row,'po')
li_talla = This.GetItemNumber(row,'co_talla')

//se recorren todos los modelos para la po-color
ll_filas = lds_modelos.Retrieve(ls_usuario,ll_ordenpd_pt,ll_color,ls_po,li_talla)

For ll_fila = 1 To ll_filas
	//primero se verifica que sea rectilinea.
	ll_reftel = This.GetItemNumber(row,'co_reftel')
	li_caract = This.GetItemNumber(row,'co_caract')
	
	ll_result = luo_liberacion.of_rectilineo(ll_reftel,li_caract)
	
	If ll_result = 3 Then //es rectilinea
		//se verifican las unidades y se compara con las unidades a programar
		ll_unid_rectilinea = lds_modelos.GetItemNumber(ll_fila,'unid_bodega')
		ll_unid_liberar = This.GetItemNumber(row,'unid_real_liberar')
		
		If ll_unid_liberar > ll_unid_rectilinea Then
			MessageBox('Error','Las unidades a liberar son mayores a las rectilineas, que son: '+String(ll_unid_rectilinea))
			Return 1
		End if
	ElseIf ll_result = -1 Then //fallo la verificacion
		Return
		
	End if
Next
end event

type dw_maestro from datawindow within w_liberacion_semiautomatica
integer x = 37
integer y = 64
integer width = 3113
integer height = 384
integer taborder = 20
string title = "none"
string dataobject = "dtb_maestro_liberacion_semiautomatica"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event getfocus;gb_detalle.TextColor = (rgb(0,0,0))
gb_maestro.TextColor = (rgb(0,0,255))
gb_criterio.TextColor = (rgb(0,0,0))
gb_colores.TextColor = (rgb(0,0,0))
gb_telas.TextColor = (rgb(0,0,0))
gb_colores_op.TextColor = (rgb(0,0,0))
end event

event retrieveend;Long ll_liberar,ll_ordenpd,ll_ordenpd1
Long ll_fila,ll_fila1,li_libaprobadas,li_libanuladas,filas_error 
String ls_usuario
Datastore lds_errores_liberacion 

lds_errores_liberacion = create Datastore
lds_errores_liberacion.dataobject= 'dtb_log_errores_liberacion' 
lds_errores_liberacion.SetTransObject(sqlca)

ls_usuario = gstr_info_usuario.codigo_usuario

filas_error = lds_errores_liberacion.retrieve(ls_usuario)

For ll_fila = 1 To This.RowCount()
	ll_ordenpd = This.GetItemNumber(ll_fila,'cs_ordenpd_pt')
	
	ll_liberar = This.GetItemNumber(ll_fila,'unid_liberar')
	This.SetItem(ll_fila,'a_liberar',ll_liberar)
	
	select count(distinct cs_liberacion)
	  into :li_libaprobadas  
	  from dt_pdnxmodulo
	 where cs_ordenpd_pt = :ll_ordenpd and co_estado_asigna <> 28;
		
	This.setitem(ll_fila,"lib_creadas",li_libaprobadas)
		
	select count(distinct cs_liberacion)
	  into :li_libanuladas  
	  from dt_pdnxmodulo
	 where cs_ordenpd_pt = :ll_ordenpd and co_estado_asigna = 28;
	 
	 This.setitem(ll_fila,"lib_anuladas",li_libanuladas)
	 
	ll_ordenpd = this.getitemnumber(ll_fila,'cs_ordenpd_pt')  
	
	If lds_errores_liberacion.rowcount()>0 Then
		For ll_fila1 = 1 to lds_errores_liberacion.rowcount()
			 ll_ordenpd1 = lds_errores_liberacion.getitemnumber(ll_fila1,'cs_ordenpd_pt')
			 If ll_ordenpd = ll_ordenpd1 Then
				this.setitem(ll_fila,"seleccion","S")
			 End if	
		Next	
	 End if
	 
	If ll_ordenpd = il_ordenpd_pt Then
		This.SetItem(ll_fila,'marca','S')
	End if
	 
Next

destroy lds_errores_liberacion
This.AcceptText()
TriggerEvent('RowFocusChanging')
end event

event rbuttondown;s_base_parametros lstr_parametros

lstr_parametros.entero[1] = This.GetItemNumber(row,'cs_ordenpd_pt')

OpenWithParm(w_resumen_liberacion_po, lstr_parametros)
end event

event clicked;String ls_usuario
Long ll_ordenpd_pt
Long ll_fila
//This.SelectRow(0, FALSE)
//
//This.SelectRow(row, TRUE)

ls_usuario = gstr_info_usuario.codigo_usuario
ll_ordenpd_pt = This.GetItemNumber(row,'cs_ordenpd_pt')

w_liberacion_semiautomatica.title = " Liberaci$$HEX1$$f300$$ENDHEX$$n "  +  "  Orden de producci$$HEX1$$f300$$ENDHEX$$n:  " + string(ll_ordenpd_pt)

if This.GetItemString(row,'marca')='N'then
	this.setitem(row,'marca','S')  
end if		

for ll_fila=1 to this.rowcount()
	if ll_fila<>row then
		this.setitem(ll_fila,'marca','N')  
	end if	
next	
	
dw_detalle.Reset()
dw_telas_ficha.Reset()
dw_colores_op.Retrieve(ll_ordenpd_pt)
dw_colores.Retrieve(ls_usuario, ll_ordenpd_pt)

end event

event doubleclicked;Long ll_ordenpdn, ll_color
n_cts_param luo_param

IF Row > 0 THEN
	ll_ordenpdn = This.GetItemNumber(Row, "cs_ordenpd_pt")
	
	luo_param.il_vector[1] = ll_ordenpdn
	OpenWithParm(w_seguimiento_op_procesos, luo_param)
END IF
end event

type dw_criterio from datawindow within w_liberacion_semiautomatica
integer x = 37
integer y = 544
integer width = 480
integer height = 964
integer taborder = 10
string title = "none"
string dataobject = "dff_criterio_liberacion_semiautomatica"
boolean border = false
boolean livescroll = true
end type

event itemchanged;Long li_fab, li_lin
Long		ll_op, ll_ref, ll_color

//cada vez que se cambie la fabrica o la linea se deban refrescar los
//dddw de linea y referencia, para que correspondan 
This.AcceptText()

choose case GetColumnName()
	case 'co_fabrica'
		li_fab = This.GetItemNumber(1,'co_fabrica')
		idwc_linea.Retrieve(li_fab)

   case 'co_linea'
		li_fab = This.GetItemNumber(1,'co_fabrica')
		li_lin = This.GetItemNumber(1,'co_linea')
		idwc_ref.Retrieve(li_fab,li_lin)
	case 'color'
		ll_color = This.GetItemNumber(1,'color')
		ll_op = This.GetItemNumber(1,'op')
		il_ordenpd_pt = ll_op
		IF ll_op > 0 THEN
			SELECT co_fabrica, co_linea, co_referencia
			  INTO :li_fab, :li_lin, :ll_ref
			  FROM h_ordenpd_pt
			 WHERE cs_ordenpd_pt = :ll_op; 
			dw_telas_ficha.Retrieve(li_fab, li_lin, ll_ref, ll_color)
			dw_colores_op.Retrieve(ll_op)
			ii_fab = li_fab
			ii_lin = li_lin
			il_ref = ll_ref
			dw_partes.Reset()
			dw_partes.InsertRow(0)
		END IF
	case 'op'
		ll_op = This.GetItemNumber(1,'op')
		il_ordenpd_pt = ll_op
		IF ll_op > 0 THEN
			SELECT co_fabrica, co_linea, co_referencia
			  INTO :li_fab, :li_lin, :ll_ref
			  FROM h_ordenpd_pt
			 WHERE cs_ordenpd_pt = :ll_op; 
			dw_colores_op.Retrieve(ll_op)
		END IF
		
		
end choose

end event

event getfocus;gb_detalle.TextColor = (rgb(0,0,0))
gb_maestro.TextColor = (rgb(0,0,0))
gb_criterio.TextColor = (rgb(0,0,255))
gb_colores.TextColor = (rgb(0,0,0))
gb_telas.TextColor = (rgb(0,0,0))
gb_colores_op.TextColor = (rgb(0,0,0))

end event

type gb_criterio from groupbox within w_liberacion_semiautomatica
integer x = 27
integer y = 480
integer width = 503
integer height = 1036
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Criterio "
end type

type gb_maestro from groupbox within w_liberacion_semiautomatica
integer x = 27
integer width = 3136
integer height = 480
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Estado por Referencia "
end type

type gb_detalle from groupbox within w_liberacion_semiautomatica
integer x = 539
integer y = 480
integer width = 2112
integer height = 1036
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Detalle por P.O. "
end type

type gb_colores from groupbox within w_liberacion_semiautomatica
integer x = 2688
integer y = 480
integer width = 1733
integer height = 1036
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Colores "
end type

type gb_telas from groupbox within w_liberacion_semiautomatica
integer x = 27
integer y = 1524
integer width = 1842
integer height = 432
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Telas Ficha "
end type

type gb_colores_op from groupbox within w_liberacion_semiautomatica
integer x = 2583
integer y = 1524
integer width = 1847
integer height = 432
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Color O.P."
end type

type gb_1 from groupbox within w_liberacion_semiautomatica
integer x = 1870
integer y = 1524
integer width = 713
integer height = 432
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Partes "
end type

