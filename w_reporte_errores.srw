HA$PBExportHeader$w_reporte_errores.srw
$PBExportComments$OBJETO BASE - Ventana utilizada para reportar los errores de base de datos al usuario y para que el mismo digite cierta informacion en el LOG de errores. Debe ser llamada cuando se quiera validar algun error de base de datos.
forward
global type w_reporte_errores from window
end type
type pb_aceptar from picturebutton within w_reporte_errores
end type
type sle_reportado_a from singlelineedit within w_reporte_errores
end type
type mle_mensaje from multilineedit within w_reporte_errores
end type
type st_codigo from statictext within w_reporte_errores
end type
type st_2 from statictext within w_reporte_errores
end type
type st_1 from statictext within w_reporte_errores
end type
type mle_problemas from multilineedit within w_reporte_errores
end type
type st_4 from statictext within w_reporte_errores
end type
type st_3 from statictext within w_reporte_errores
end type
type gb_2 from groupbox within w_reporte_errores
end type
type gb_1 from groupbox within w_reporte_errores
end type
end forward

global type w_reporte_errores from window
integer x = 549
integer y = 208
integer width = 1838
integer height = 1540
boolean titlebar = true
string title = "Error de Base de Datos"
windowtype windowtype = response!
long backcolor = 79741120
pb_aceptar pb_aceptar
sle_reportado_a sle_reportado_a
mle_mensaje mle_mensaje
st_codigo st_codigo
st_2 st_2
st_1 st_1
mle_problemas mle_problemas
st_4 st_4
st_3 st_3
gb_2 gb_2
gb_1 gb_1
end type
global w_reporte_errores w_reporte_errores

type variables
s_base_parametros istr_parametros
string             is_dbms, is_usuario, is_ventana, is_evento
string             is_clave, is_reportado_a, is_problema, is_mensaje
long            il_dbcode, il_cod_aplicacion, il_modo
string             id_ocurrencia, is_error
end variables

on w_reporte_errores.create
this.pb_aceptar=create pb_aceptar
this.sle_reportado_a=create sle_reportado_a
this.mle_mensaje=create mle_mensaje
this.st_codigo=create st_codigo
this.st_2=create st_2
this.st_1=create st_1
this.mle_problemas=create mle_problemas
this.st_4=create st_4
this.st_3=create st_3
this.gb_2=create gb_2
this.gb_1=create gb_1
this.Control[]={this.pb_aceptar,&
this.sle_reportado_a,&
this.mle_mensaje,&
this.st_codigo,&
this.st_2,&
this.st_1,&
this.mle_problemas,&
this.st_4,&
this.st_3,&
this.gb_2,&
this.gb_1}
end on

on w_reporte_errores.destroy
destroy(this.pb_aceptar)
destroy(this.sle_reportado_a)
destroy(this.mle_mensaje)
destroy(this.st_codigo)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.mle_problemas)
destroy(this.st_4)
destroy(this.st_3)
destroy(this.gb_2)
destroy(this.gb_1)
end on

event open;Long li_pos_inicial
istr_parametros = message.PowerObjectParm

////////////////////////////////////////////////////////////////////////
// Las siguientes lineas estan asignandole, a las variables de
// instancia, el contenido de los campos cadena y entero de la
// estructura s_base_parametro.
////////////////////////////////////////////////////////////////////////

is_dbms = istr_parametros.cadena[1]
il_dbcode = istr_parametros.entero[1]
is_ventana = istr_parametros.cadena[2]
is_evento = istr_parametros.cadena[3]
is_clave = istr_parametros.cadena[4]
is_error = istr_parametros.cadena[5]

////////////////////////////////////////////////////////////////////////
// Las dos lineas siguientes estan asignandole, a las dos variables de
// instancia el valor de los campos codigo_aplicacion y codigo_usuario, 
// de la estructura s_info_base_usuario.
////////////////////////////////////////////////////////////////////////

il_cod_aplicacion = gstr_info_usuario.codigo_aplicacion
is_usuario = gstr_info_usuario.codigo_usuario

////////////////////////////////////////////////////////////////////////
// El codigo 9999, con el cual se esta controlando el IF, es el codigo
// Standar para cuando no haya conexi$$HEX1$$f300$$ENDHEX$$n con el servidor.
////////////////////////////////////////////////////////////////////////

IF il_dbcode <> 9999 THEN
	IF il_dbcode = -746 THEN
		st_codigo.text = String(il_dbcode)
		li_pos_inicial = Pos(is_error, ':', 1)
		mle_mensaje.text = Mid(is_error, li_pos_inicial + 1, Len(is_error) - (li_pos_inicial + 1))
		id_ocurrencia = String(DateTime(Today(),Now()))
		sle_reportado_a.SetFocus()
	ELSE
			
	//////////////////////////////////////////////////////////////////////////
  // Con la siguiente Sentencia SQL, se esta seleccionando el mensaje de 
  // error y el nivel de gravedad del error de la base de datos.
  ////////////////////////////////////////////////////////////////////////
	
	  SELECT cf_errores_bd.mensaje_1,   
   	      cf_errores_bd.modo  
	    INTO :is_mensaje,   
   	      :il_modo  
	    FROM cf_errores_bd  
   	WHERE ( cf_errores_bd.dbms = :is_dbms ) AND  
      	   ( cf_errores_bd.co_error = :il_dbcode )   ;
		IF SQLCA.SQLCODE = -1 THEN
			st_codigo.text = String(il_dbcode)
			mle_mensaje.text = "No se pudo leer datos de la tabla de errores, favor reportar a sistemas"
			id_ocurrencia = String(DateTime(today(),now()))
			sle_reportado_a.enabled = FALSE
			sle_reportado_a.visible = FALSE
			mle_problemas.enabled = FALSE
			mle_problemas.visible = FALSE
			st_3.visible = FALSE
			st_4.visible = FALSE
		ELSE
			IF SQLCA.SQLCODE = 100 THEN
				st_codigo.text = String(il_dbcode)
				mle_mensaje.text = "Mensaje de error no encontrado, favor reportar a sistemas"
				id_ocurrencia = String(DateTime(Today(),Now()))
				sle_reportado_a.SetFocus()		
			ELSE
				//Mostrar mensaje de error
				st_codigo.text = String(il_dbcode)
				mle_mensaje.text = is_mensaje
				id_ocurrencia = String(DateTime(Today(),Now()))
				sle_reportado_a.SetFocus()
			END IF
		END IF
	END IF
ELSE
	st_codigo.text = String(il_dbcode)
	mle_mensaje.text = "No se pudo conectar a la Base de Datos, favor reportar a sistemas"
	id_ocurrencia = String(DateTime(Today(),Now()))
	sle_reportado_a.enabled = FALSE
	sle_reportado_a.visible = FALSE
	mle_problemas.enabled = FALSE
	mle_problemas.visible = FALSE
	st_3.visible = FALSE
	st_4.visible = FALSE
END IF

end event

type pb_aceptar from picturebutton within w_reporte_errores
integer x = 750
integer y = 1272
integer width = 393
integer height = 124
integer taborder = 51
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "&Aceptar"
boolean default = true
string picturename = "c:\graficos\ok.bmp"
alignment htextalign = right!
end type

event clicked;is_reportado_a = sle_reportado_a.text
is_problema = mle_problemas.text

IF mle_problemas.visible = TRUE THEN
	INSERT INTO cf_error_log  
         ( co_aplicacion,   
           usuario,   
           fe_ocurrencia,   
           co_error,   
           ventana,   
           problema_usu,   
           reportado_a,   
           clave )  
	VALUES ( :il_cod_aplicacion,   
           :is_usuario,   
           :id_ocurrencia,   
           :il_dbcode,   
           :is_ventana,   
           :is_problema,   
           :is_reportado_a,   
           :is_clave )  ;
	IF (SQLCA.SQLCODE = -1) OR (SQLCA.SQLCODE = 100) THEN
		MessageBox("Error Base de datos","No se pudo insertar el log de errores",StopSign!,Ok!)
		ROLLBACK;
	ELSE
		COMMIT;
		IF (SQLCA.SQLCODE = -1) OR (SQLCA.SQLCODE = 100) THEN
			MessageBox("Error Base de datos","No se pudo insertar el log de errores",StopSign!,Ok!)	
		ELSE
		END IF
	END IF
ELSE
END IF
Close(Parent)

end event

type sle_reportado_a from singlelineedit within w_reporte_errores
integer x = 393
integer y = 560
integer width = 1353
integer height = 72
integer taborder = 30
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long backcolor = 16777215
textcase textcase = lower!
borderstyle borderstyle = stylelowered!
end type

type mle_mensaje from multilineedit within w_reporte_errores
integer x = 357
integer y = 192
integer width = 1353
integer height = 240
integer taborder = 20
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long backcolor = 79741120
boolean enabled = false
boolean vscrollbar = true
boolean autovscroll = true
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type st_codigo from statictext within w_reporte_errores
integer x = 357
integer y = 88
integer width = 1353
integer height = 72
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long backcolor = 79741120
boolean enabled = false
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type st_2 from statictext within w_reporte_errores
integer x = 73
integer y = 196
integer width = 247
integer height = 72
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long backcolor = 79741120
boolean enabled = false
string text = "Mensaje:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_1 from statictext within w_reporte_errores
integer x = 73
integer y = 80
integer width = 247
integer height = 72
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long backcolor = 79741120
boolean enabled = false
string text = "Codigo:"
alignment alignment = right!
boolean focusrectangle = false
end type

type mle_problemas from multilineedit within w_reporte_errores
integer x = 82
integer y = 772
integer width = 1669
integer height = 408
integer taborder = 50
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long backcolor = 16777215
boolean vscrollbar = true
boolean autovscroll = true
textcase textcase = lower!
borderstyle borderstyle = stylelowered!
boolean ignoredefaultbutton = true
end type

type st_4 from statictext within w_reporte_errores
integer x = 73
integer y = 700
integer width = 1440
integer height = 72
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long backcolor = 79741120
boolean enabled = false
string text = "Que estaba intentando hacer antes de que ocurriera el problema? "
boolean focusrectangle = false
end type

type st_3 from statictext within w_reporte_errores
integer x = 73
integer y = 560
integer width = 306
integer height = 72
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long backcolor = 79741120
boolean enabled = false
string text = "Reportado a: "
boolean focusrectangle = false
end type

type gb_2 from groupbox within w_reporte_errores
integer x = 32
integer width = 1765
integer height = 484
integer taborder = 10
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long backcolor = 79741120
end type

type gb_1 from groupbox within w_reporte_errores
integer x = 37
integer y = 488
integer width = 1765
integer height = 748
integer taborder = 40
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long backcolor = 79741120
end type

