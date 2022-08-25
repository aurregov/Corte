HA$PBExportHeader$w_base_conexion.srw
$PBExportComments$OBJETO BASE - Ventana utilizada para establecer la conexion a las BD y validar usuario, password y perfil. Debe heredarse y adaptar el evento Open.
forward
global type w_base_conexion from window
end type
type dw_1 from datawindow within w_base_conexion
end type
type st_fabrica from statictext within w_base_conexion
end type
type pb_desconectar from picturebutton within w_base_conexion
end type
type pb_conectar from picturebutton within w_base_conexion
end type
type sle_password from singlelineedit within w_base_conexion
end type
type sle_co_usuario from singlelineedit within w_base_conexion
end type
type st_password from statictext within w_base_conexion
end type
type st_cousuario from statictext within w_base_conexion
end type
type gb_captura from groupbox within w_base_conexion
end type
type gb_picture from groupbox within w_base_conexion
end type
end forward

global type w_base_conexion from window
integer x = 910
integer y = 452
integer width = 1024
integer height = 1264
boolean titlebar = true
string title = "Acceso a "
boolean controlmenu = true
boolean minbox = true
boolean resizable = true
long backcolor = 79741120
dw_1 dw_1
st_fabrica st_fabrica
pb_desconectar pb_desconectar
pb_conectar pb_conectar
sle_password sle_password
sle_co_usuario sle_co_usuario
st_password st_password
st_cousuario st_cousuario
gb_captura gb_captura
gb_picture gb_picture
end type
global w_base_conexion w_base_conexion

type variables
string is_nombre_ini
s_base_parametros istr_parametros_error


end variables

forward prototypes
public function integer wf_validar_usuario (readonly string as_usuario, readonly string as_password)
public function integer wf_identificar_aplicacion ()
public function integer wf_llenar_opciones_nopermitidas ()
public function integer wf_conectar_bd (readonly string as_nombre_seccion, readonly string as_usuario, readonly string as_password)
end prototypes

public function integer wf_validar_usuario (readonly string as_usuario, readonly string as_password);///////////////////////////////////////////////////////////////////////
// FUNCION: wf_validar_usuario
// DESCRIPCION: verifica si el usuario y password digitado son validos.
// PARAMETROS: usuario y password
// RETORNA:  0 Si	el Usuario existe y el Password existe
//          -1	Si hubo Error de Base de datos	
//          -2	Si Digito usuario y Password en blanco
//          -3	Si el Usuario en blanco y Digito password
//          -4	Si usuario en blanco	y Password en blanco
//          -5	Si usuario no existe y Password no existe
//          -6	Si Usuario existe	yPassword no existe
//
////////////////////////////////////////////////////////////////////////

string ls_password

IF (as_usuario="") THEN
	IF (as_password="") THEN
	   RETURN (-4)
   ELSE
	   RETURN (-2)
   END IF
ELSE
	IF (as_password="") THEN
	   RETURN (-3)
   ELSE
	   SELECT m_usuario.password,   
             m_usuario.de_usuario,   
             m_usuario.cargo,   
             m_usuario.dpto,
			    sitename
		INTO :ls_password,   
         :gstr_info_usuario.nombre_usuario,   
         :gstr_info_usuario.cargo_usuario,   
         :gstr_info_usuario.departamento_usuario,
			:gstr_info_usuario.instancia
    	FROM m_usuario  
  		WHERE m_usuario.co_usuario = :as_usuario   ;
		gstr_info_usuario.codigo_usuario = as_usuario
      IF (SQLCA.SQLCODE=-1) THEN
      	RETURN (-1)
      ELSE
         IF (SQLCA.SQLCODE=100) THEN
	         RETURN (-5)
         ELSE
				gstr_info_usuario.password = ls_password
	   		gstr_info_usuario.codigo_aplicacion=&
 		      integer(ProfileString(gstr_info_usuario.ruta_ini,&
				                      "aplicacion","codigo",""))
											 
			  	SELECT dt_usuxper.co_perfil  
    				INTO :gstr_info_usuario.codigo_perfil  
					FROM dt_usuxper  
   				WHERE ( dt_usuxper.co_aplicacion = :gstr_info_usuario.codigo_aplicacion ) AND  
		         		( dt_usuxper.co_usuario = :gstr_info_usuario.codigo_usuario );
							  
				IF (SQLCA.SQLCODE=-1) OR (SQLCA.SQLCODE=100)THEN
		      	RETURN (-1)
		      ELSE
//      	   	IF (trim(ls_password)=as_password) THEN
               	RETURN (0)
//         	   ELSE
//               	RETURN (-6)
//					END IF
            END IF
           END IF
      END IF
   END IF
END IF

end function

public function integer wf_identificar_aplicacion ();////////////////////////////////////////////////////////////////////////
// FUNCION: wf_identificar_aplicacion
// DESCRIPCION: verifica si la aplicacion a la que el usuario intenta
//              conectarse y que esta registrada en el archivo .ini
//              existe, en la base de datos de seguridad.
// PARAMETROS: Ninguno
// VALOR DE RETORNO: -1 Si hubo error de base de datos.
//                    1 Si la aplicacion no fue encontrada en la base
//                      datos.
//                    0 Si la aplicacion fue encontrada en la base de 
//                      datos.
////////////////////////////////////////////////////////////////////////


IF isnumber(ProfileString(gstr_info_usuario.ruta_ini,"aplicacion","codigo","")) THEN
	gstr_info_usuario.codigo_aplicacion=integer(ProfileString(gstr_info_usuario.ruta_ini,"aplicacion","codigo",""))
	
	////////////////////////////////////////////////////////////////////////
	// Con la siguiente sentencia SQL, se esta seleccionando la descripcion
	// generica d ela aplicacion y la ruta donde se encuentra la aplicacion
	// a la que se esta intentando conectar el usuario.
	////////////////////////////////////////////////////////////////////////
   SELECT 	produc.m_aplicacion.de_generica,   
         	produc.m_aplicacion.de_ruta  
    	INTO 	:gstr_info_usuario.nombre_aplicacion,   
      		:gstr_info_usuario.ruta_aplicacion  
	   FROM produc.m_aplicacion  
   	WHERE produc.m_aplicacion.co_aplicacion = :gstr_info_usuario.codigo_aplicacion   ;

	IF sqlca.sqlcode = -1 THEN
		 RETURN(-1)
	ELSE
	  IF sqlca.sqlcode = 100 THEN
		 RETURN(1)
	  ELSE
		 RETURN (0)
	  END IF
	END IF
ELSE
	messagebox("Error","Archivo ini corrupto")
END IF


end function

public function integer wf_llenar_opciones_nopermitidas ();////////////////////////////////////////////////////////////////////////
// FUNCION: wf_llenar_opciones_nopermitidas
// DESCRIPCION: Llenar la estructura s_base_opciones, con las opciones
//              no permitidas para un menu de una ventana para un perfil
//              especifico.
// PARAMETROS: Ninguno
// VALOR DE RETORNO: -1 Si hubo error de base de datos.
//                    1 Si la aplicacion no fue encontrada en la base
//                      datos.
//                    0 Si la aplicacion fue encontrada en la base de 
//                      datos.
////////////////////////////////////////////////////////////////////////
Long ll_registros
DataStore lds_opciones

////////////////////////////////////////////////////////////////////////
// Con la siguiente sentencia SQL, se esta seleccionando el nombre
// del perfil que tiene el usuario que esta intentando conectarse a 
// la aplicacion
////////////////////////////////////////////////////////////////////////


SELECT produc.m_perfil.de_perfil  
	INTO :gstr_info_usuario.nombre_perfil  
	FROM produc.m_perfil  
	WHERE produc.m_perfil.co_perfil = :gstr_info_usuario.codigo_perfil 
			AND produc.m_perfil.co_aplicacion = :gstr_info_usuario.codigo_aplicacion;
IF (SQLCA.SQLCODE = -1) OR (SQLCA.SQLCODE = 100) THEN
	RETURN(-1)
ELSE
	
	////////////////////////////////////////////////////////////////////////
	// Con la siguiente sentencia SQL, se esta declarando un Cursor, el cual
	// va a contener las opciones no permitidas, para el perfil de la 
	// aplicacion a la que se esta intentando conectar el usuario.
	////////////////////////////////////////////////////////////////////////
	lds_opciones = Create DataStore
	lds_opciones.DataObject = "d_opciones_no_permitidas"
	lds_opciones.SetTransObject(SQLCA)
	ll_registros = lds_opciones.Retrieve(gstr_info_usuario.codigo_aplicacion, gstr_info_usuario.codigo_perfil)
	If ll_registros = 0 Then
		lds_opciones.InsertRow(0)
		lds_opciones.SetItem(1,"dt_opcxapl_nom_obj_ventana","")
		ll_registros = 1
	End If

	gstr_opciones.nombre_ventana = lds_opciones.Object.dt_opcxapl_nom_obj_ventana.Current
	gstr_opciones.nivel = lds_opciones.Object.dt_opcxapl_cs_nivel.Current
	gstr_opciones.nivel_1 = lds_opciones.Object.dt_opcxapl_cs_prim_nivel.Current
	gstr_opciones.nivel_2 = lds_opciones.Object.dt_opcxapl_cs_seg_nivel.Current
	gstr_opciones.nivel_3 = lds_opciones.Object.dt_opcxapl_cs_ter_nivel.Current	
	gstr_opciones.nivel_4 = lds_opciones.Object.dt_opcxapl_cs_cuar_nivel.Current		
	gstr_info_usuario.numero_opciones = ll_registros
	Destroy lds_opciones
	RETURN (0)
END IF

end function

public function integer wf_conectar_bd (readonly string as_nombre_seccion, readonly string as_usuario, readonly string as_password);////////////////////////////////////////////////////////////////////////
// FUNCION: wf_conectar_bd
// DESCRIPCION: Leer el archivo .ini e intentar conectarse a la base
//              de datos y retorna el valor de la conexion.
//PARAMETROS: Nombre de la seccion del ini
// VALOR DE RETORNO: -1 Si hubo error de base de datos.
//                    0 Si fue exitosa la conexion.
////////////////////////////////////////////////////////////////////////


SQLCA.DBMS=ProfileString(gstr_info_usuario.ruta_ini,as_nombre_seccion,"DBMS","")
SQLCA.DATABASE=ProfileString(gstr_info_usuario.ruta_ini,as_nombre_seccion,"DATABASE","")
SQLCA.USERID=as_usuario
SQLCA.DBPASS=as_password
SQLCA.DBPARM="connectstring='DSN="+SQLCA.DATABASE+";UID="+as_usuario+";PWD="+as_password+"'" + ",DisableBind=1"
SQLCA.ServerName = ProfileString(gstr_info_usuario.ruta_ini,as_nombre_seccion,"SERVIDOR","")
SQLCA.Lock = "Committed read"


CONNECT USING SQLCA;
IF SQLCA.SQLCODE=-1 THEN
	istr_parametros_error.cadena[1] = sqlca.dbms
	istr_parametros_error.entero[1] = 9999
	istr_parametros_error.cadena[2] = this.classname()
	istr_parametros_error.cadena[3] = "wf_conectar_bd"
	istr_parametros_error.cadena[4] = "coneccion a la base de datos"
	istr_parametros_error.cadena[5] = sqlca.SQLErrText	
	OPENWITHPARM(w_reporte_errores,istr_parametros_error)
	RETURN(-1)
//	messagebox ("Error Conecci$$HEX1$$f300$$ENDHEX$$n","No se pudo conectar la Base de datos",Stopsign!,ok!)
ELSE
	RETURN(0)
//	messagebox ("Coneccion Exitosa","Se pudo conectar la a Base de datos")
END IF

end function

on w_base_conexion.create
this.dw_1=create dw_1
this.st_fabrica=create st_fabrica
this.pb_desconectar=create pb_desconectar
this.pb_conectar=create pb_conectar
this.sle_password=create sle_password
this.sle_co_usuario=create sle_co_usuario
this.st_password=create st_password
this.st_cousuario=create st_cousuario
this.gb_captura=create gb_captura
this.gb_picture=create gb_picture
this.Control[]={this.dw_1,&
this.st_fabrica,&
this.pb_desconectar,&
this.pb_conectar,&
this.sle_password,&
this.sle_co_usuario,&
this.st_password,&
this.st_cousuario,&
this.gb_captura,&
this.gb_picture}
end on

on w_base_conexion.destroy
destroy(this.dw_1)
destroy(this.st_fabrica)
destroy(this.pb_desconectar)
destroy(this.pb_conectar)
destroy(this.sle_password)
destroy(this.sle_co_usuario)
destroy(this.st_password)
destroy(this.st_cousuario)
destroy(this.gb_captura)
destroy(this.gb_picture)
end on

event open;////////////////////////////////////////////////////////////////////////
// En la siguiente linea se debe especificar la ruta del archivo .ini 
// de la aplicacion correspondiente
////////////////////////////////////////////////////////////////////////

//gstr_info_usuario.ruta_ini="c:\aplicacion\aplicacion.ini"
//This.Title = This.Title + " " + ProfileString(gstr_info_usuario.ruta_ini, "acerca de", "sistema", "")
dw_1.SetTransObject(sqlca)
dw_1.InsertRow(0)
dw_1.SetItem(1,'fabrica','MARINILLA')
OleObject lole_wsh
Integer  li_rc

//	Sino esta ejecutando en ambiente de desarrollo verifica si la aplicacion debe estar
//	Detenida por instruccionjes de la oficina de sistemas o no.
//If Not( Handle( GetApplication() ) = 0 ) Then
//	If Upper(ProfileString ( "\\Vesmant00\Aplicaciones\corte\administrar.ini", GetApplication().AppName, "Detener", "No")) = "SI" Then
//		lole_wsh = Create OleObject
//		li_rc = lole_wsh.ConnectToNewObject( "WScript.Network" )
//		If li_rc = 0 Then
//			Run("net send "+ lole_wsh.UserName + " En este momento no se puede abrir la aplicaci$$HEX1$$f300$$ENDHEX$$n.   Gracias")		
//		End If
//		If IsValid(lole_wsh) Then Destroy lole_wsh
//		Halt
//	End If
//End If

end event

type dw_1 from datawindow within w_base_conexion
integer x = 443
integer y = 708
integer width = 425
integer height = 84
integer taborder = 30
string title = "none"
string dataobject = "d_plantas"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type st_fabrica from statictext within w_base_conexion
integer x = 96
integer y = 732
integer width = 306
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "Fabrica:"
boolean focusrectangle = false
end type

type pb_desconectar from picturebutton within w_base_conexion
integer x = 521
integer y = 940
integer width = 393
integer height = 124
integer taborder = 50
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "C&ancelar"
boolean cancel = true
string picturename = "c:\graficos\cancelar.bmp"
alignment htextalign = right!
end type

event clicked;Close(Parent)
end event

type pb_conectar from picturebutton within w_base_conexion
integer x = 69
integer y = 940
integer width = 393
integer height = 124
integer taborder = 40
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "&Conectar"
boolean default = true
string picturename = "c:\graficos\ok.bmp"
alignment htextalign = right!
end type

event clicked;integer li_resultado_coneccion, i
String ls_fabrica
Long ll_count
s_base_parametros lstr_parametro

//////////////////////////////////////////////////////////////////////////////
// Las siguientes tres lineas, estan llenando la estructura s_base_parametros 
// para poder asi desplegar en la ventana se retroalimentacion el mensaje
// correspondiente a la accion que se esta ejecutando.
///////////////////////////////////////////////////////////////////////////////

lstr_parametro.cadena[1]="Conectandose..."
lstr_parametro.cadena[2]="El sistema esta intentando conectarse a las bases de datos, esta operacion puede demorar unos segundos, espere un momento por favor..."
lstr_parametro.cadena[3]="reloj"

OpenWithParm(w_retroalimentacion,lstr_parametro)

gstr_info_usuario.fabrica = dw_1.GetItemString(1,'fabrica')

IF gstr_info_usuario.fabrica = 'MARINILLA' THEN
	gstr_info_usuario.co_planta_pro = 2	
ELSEIF gstr_info_usuario.fabrica = 'PEREIRA' THEN
	gstr_info_usuario.co_planta_pro = 99
END IF


IF IsNull(gstr_info_usuario.fabrica) THEN
	Close(w_retroalimentacion)
	MessageBox('Advertencia','Es necesario ingresar la fabrica.',Stopsign!,ok!)
	Return
END IF

li_resultado_coneccion=wf_conectar_bd("bd seguridad",sle_co_usuario.text,sle_password.text)

Close(w_retroalimentacion)

///////////////////////////////////////////////////////////////////////
// Con el siguiente IF se esta validando el resultado de la conexion 
// a la base de datos de seguridad.
////////////////////////////////////////////////////////////////////////

IF (li_resultado_coneccion=-1) THEN
	messagebox ("Problema de Conexi$$HEX1$$f300$$ENDHEX$$n","No se pudo conectar la base de datos de seguridad",Stopsign!,ok!)
	HALT
ELSE
	OpenWithParm(w_retroalimentacion,lstr_parametro)
	li_resultado_coneccion=wf_validar_usuario(sle_co_usuario.text,sle_password.text)
	Close(w_retroalimentacion)
	
  	/////////////////////////////////////////////////////////////////////
   // Con el siguiente CHOOSE CASE 	se esta validando el resultado de 
   // la validacion del usuario.
   //////////////////////////////////////////////////////////////////////

	
   CHOOSE CASE li_resultado_coneccion
	CASE 0
		OpenWithParm(w_retroalimentacion,lstr_parametro)
		li_resultado_coneccion=wf_identificar_aplicacion ( )
		Close(w_retroalimentacion)
		IF li_resultado_coneccion = 0 THEN
			OpenWithParm(w_retroalimentacion,lstr_parametro)
			li_resultado_coneccion=wf_llenar_opciones_nopermitidas ( )
			
		   ///////////////////////////////////////////////////////////
         // Con el siguiente IF se esta verificando el resultado de 
			// llenar las opciones no permitidas.
			/////////////////////////////////////////////////////////////
			IF li_resultado_coneccion= 0 THEN
         	DISCONNECT;
				Close(w_retroalimentacion)
				OpenWithParm(w_retroalimentacion,lstr_parametro)
			 	li_resultado_coneccion = wf_conectar_bd("bd aplicacion", sle_co_usuario.text, sle_password.text)
				Close(w_retroalimentacion)
				
				///////////////////////////////////////////////////////////
            // Con el siguiente IF se esta verificando el resultado de
				// conectarse a la base de datos de la aplicacion.
				///////////////////////////////////////////////////////////

				IF (li_resultado_coneccion=-1) THEN
   	   		MessageBox ("Problema de Conexi$$HEX1$$f300$$ENDHEX$$n","No se pudo conectar la Base de datos de la aplicaci$$HEX1$$f300$$ENDHEX$$n",Stopsign!,Ok!)
	   		   HALT Close
	      	ELSE
					Open(w_principal) 
//					MessageBox ("Bienvenido al Sistema","Conectado a la Base de Datos de : < "+SQLCA.Database+" >",Information!,ok!)
			 	 	Close(Parent)
				END IF
         ELSE
	        	MessageBox ("Problema de configuracion","Hubo problemas en la base de datos al tratar de cargar las opciones permitidas al perfil del usuario",Information!,Ok!)
         END IF
		ELSE
		   MessageBox ("Problema de configuracion","Hubo problemas al tratar de identificar la aplicaci$$HEX1$$f300$$ENDHEX$$n",Information!,Ok!)
		END IF
	CASE -1
		DISCONNECT;
		MessageBox ("Problema de Base de Datos","Hubo problemas al tratar de verificar el usuario y password en la base de datos",Stopsign!,Ok!)
		Close(Parent)
	CASE -2
		DISCONNECT;
		MessageBox ("Advertencia","Debe digitar el usuario",Exclamation!,Ok!)
		sle_co_usuario.SetFocus()
   CASE -3
		DISCONNECT;
		MessageBox ("Advertencia","Debe digitar el password",Exclamation!,Ok!)
		sle_password.SetFocus()
	CASE -4
		DISCONNECT;
		MessageBox ("Advertencia","Debe digitar el usuario y el password",Exclamation!,Ok!)
		sle_co_usuario.SetFocus()
	CASE -5
		DISCONNECT;
		MessageBox ("Advertencia","El usuario digitado no esta matriculado en la base de datos",Exclamation!,Ok!)
 		sle_co_usuario.SetFocus()
	CASE -6
 		DISCONNECT;
   	MessageBox ("Advertencia","El password digitado es incorrecto",Exclamation!,Ok!)
		sle_password.SetFocus()
	END CHOOSE
END IF

end event

type sle_password from singlelineedit within w_base_conexion
integer x = 443
integer y = 580
integer width = 425
integer height = 84
integer taborder = 20
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
boolean autohscroll = false
boolean password = true
textcase textcase = lower!
integer limit = 8
borderstyle borderstyle = stylelowered!
end type

event getfocus;This.SelectText(1, Len(This.Text))
end event

type sle_co_usuario from singlelineedit within w_base_conexion
integer x = 443
integer y = 452
integer width = 425
integer height = 84
integer taborder = 10
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
boolean autohscroll = false
textcase textcase = lower!
integer limit = 8
borderstyle borderstyle = stylelowered!
end type

event getfocus;This.SelectText(1, Len(This.Text))
end event

type st_password from statictext within w_base_conexion
integer x = 96
integer y = 596
integer width = 306
integer height = 68
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
boolean enabled = false
string text = "Password: "
boolean focusrectangle = false
end type

type st_cousuario from statictext within w_base_conexion
integer x = 96
integer y = 460
integer width = 306
integer height = 68
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
boolean enabled = false
string text = "Usuario:"
boolean focusrectangle = false
end type

type gb_captura from groupbox within w_base_conexion
integer x = 27
integer y = 360
integer width = 942
integer height = 540
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
end type

type gb_picture from groupbox within w_base_conexion
integer x = 27
integer width = 942
integer height = 356
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
end type

