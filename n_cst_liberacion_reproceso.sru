HA$PBExportHeader$n_cst_liberacion_reproceso.sru
forward
global type n_cst_liberacion_reproceso from nonvisualobject
end type
end forward

global type n_cst_liberacion_reproceso from nonvisualobject autoinstantiate
end type

type variables
Long ii_fabexp, ii_lanzamiento, ii_prioridad
Long il_liberacion
String is_po, is_cut
end variables

forward prototypes
public function long of_cargarhliberarescalas ()
public function long of_establecerpo ()
public function long of_genera_liberacion ()
public function long of_validarreflanzamiento (long ai_fabrica, long ai_linea, long al_ref)
public function long of_consecutivoliberacion ()
public function long of_updateyield ()
protected function long of_cargardttelaxmodelolib (long ai_fab, long ai_lin, long al_ref, long al_color, long al_cant_prog, long ai_tal, long ai_cal)
public function long of_cargardtliberaestilos (long ai_fab, long ai_lin, long al_ref, long al_color, long al_unidades, long ai_cal)
public function long of_cargardtescalasxtela (long ai_fabpt, long ai_lin, long al_ref, long al_colorpt, string as_tono, long al_mod, long ai_fabte, long al_reftel, long ai_caract, long ai_dia, long al_colorte, long ai_talla, long al_unidades, long ai_cal)
public function long of_cargardttallapdnmodulo (long ai_fabpt, long ai_lin, long al_ref, long al_colorpt, long ai_talla, long al_unidades)
public function long of_cargardtpdnxmodulo (long ai_fabpt, long ai_lin, long al_ref, long al_color, long al_unidades)
end prototypes

public function long of_cargarhliberarescalas ();DateTime ldt_fecha
Long il_est_lib, il_tip_lib

//-----------------------------------------primero determinamos la fabrica_exp
SELECT numerico
  INTO :ii_fabexp
  FROM m_constantes
 WHERE var_nombre = 'FABRICA LIBERACIONES' ;

IF sqlca.sqlcode = -1 THEN
	MessageBox('Error Base Datos','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de consultar la fabrica de la liberaci$$HEX1$$f300$$ENDHEX$$n '+ SQLCA.SQLErrText)
   Return -1
END IF

//---------------------------------------se determina el estado de la liberacion
SELECT numerico
  INTO :il_est_lib
  FROM m_constantes
 WHERE var_nombre = 'ESTADO ASIGNA' ;

IF sqlca.sqlcode = -1 THEN
	MessageBox('Error Base Datos','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de consultar el estado de la liberaci$$HEX1$$f300$$ENDHEX$$n '+ SQLCA.SQLErrText)
   Return -1
END IF

//se determina el tipo de la liberacion
//SELECT numerico
//  INTO :il_tip_lib
//  FROM m_constantes
// WHERE var_nombre = 'TIPO ASIGNA' ;

//se modifico la constante para poder identificar que se trata de un reproceso
SELECT numerico
  INTO :il_tip_lib
  FROM m_constantes
 WHERE var_nombre = 'ASIGNACION REPROCESO' ;


IF sqlca.sqlcode = -1 THEN
	MessageBox('Error Base Datos','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de consultar el tipo de la liberaci$$HEX1$$f300$$ENDHEX$$n '+ SQLCA.SQLErrText)
   Return -1
END IF


//------------------------------------con la fabrica_exp ya puedo conocer el consecutivo de liberacion
IF of_consecutivoLiberacion() <> 0 THEN
	RETURN -1
END IF

//---------------------------------------------determinamos la fecha del servidor
ldt_fecha = f_fecha_servidor()

//-------------------------------------insertamos el registro en h_liberar_escalas
INSERT INTO h_liberar_escalas  
         ( co_fabrica_exp,   
           cs_liberacion,   
           co_est_liberacion,   
           co_tip_liberacion,   
           fe_creacion,   
           fe_actualizacion,   
           usuario,   
           instancia )  
  VALUES ( :ii_fabexp,   
           :il_liberacion,   
           :il_est_lib,   
           :il_tip_lib,   
           :ldt_fecha,   
           :ldt_fecha,   
           :gstr_info_usuario.codigo_usuario,   
           :gstr_info_usuario.instancia )  ;
			  
IF sqlca.sqlcode <> 0 Then
	MessageBox('Error Base Datos','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de insertar los datos' + SQLCA.SQLErrText)
	Return -1
END IF

Return 0
end function

public function long of_establecerpo ();//se determina cual sera el P.O. a utilizar durante la liberaci$$HEX1$$f300$$ENDHEX$$n,
//para el caso de nacionales sera la descripci$$HEX1$$f300$$ENDHEX$$n del lanzamiento.

//SELECT de_lanzamiento
//  INTO :is_po
//  FROM m_lanzamientos
// WHERE co_lanzamiento = :ii_lanzamiento;
// 
////se valida que efectivamente se recupere un dato pa la P.O. 
// IF sqlca.sqlcode = -1 THEN
//	MessageBox('Error Base de Datos','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de establecer la descripci$$HEX1$$f300$$ENDHEX$$n del lanzamiento.' + SQLCA.SQLErrText)
//	Return -1
//ELSEIF sqlca.sqlcode = 100 THEN
//	MessageBox('Error','No se encontro ningun lanzamiento con el n$$HEX1$$fa00$$ENDHEX$$mero: '+ String(ii_lanzamiento))
//	Return 100
//END IF

is_po = 'SIN LANZAMIENTO'

Return 0
end function

public function long of_genera_liberacion ();//como se pueden ingresar varios registros y estos debe formar una solo liberaci$$HEX1$$f300$$ENDHEX$$n se
//crea un data store donde esten los datos ingresados por el usuario.
Long ll_fila, ll_ref, ll_cant_prog, ll_col
Long li_fab, li_lin, li_tal, li_cal
DataStore lds_datos

lds_datos = Create DataStore
lds_datos.DataObject = 'dtb_liberacion_reproceso'
lds_datos.SetTransObject(sqlca)

lds_datos.Retrieve(gstr_info_usuario.codigo_usuario)

FOR ll_fila = 1 TO lds_datos.Rowcount()
	//--------------------------------------capturamos las variables
	li_fab 			= lds_datos.GetItemNumber(ll_fila,'co_fabrica')
	li_lin 			= lds_datos.GetItemNumber(ll_fila,'co_linea')
	ll_ref 			= lds_datos.GetItemNumber(ll_fila,'co_referencia')
	li_tal 			= lds_datos.GetItemNumber(ll_fila,'co_talla')
	li_cal 			= lds_datos.GetItemNumber(ll_fila,'co_calidad')
	ll_col 			= lds_datos.GetItemNumber(ll_fila,'co_color')
	ii_lanzamiento = lds_datos.GetItemNumber(ll_fila,'co_lanzamiento')
	ll_cant_prog	= lds_datos.GetItemNumber(ll_fila,'ca_unidades')
	
	//is_cut = String(ii_lanzamiento)
	is_cut = '0'
	
	//----------------------------capturo el valor a trabajar para la P.O.
	IF of_EstablecerPo() <> 0 THEN
		Rollback;
		Return -1
	END IF
	
//	//valido que la referencia exista en el lanzamiento
//	IF of_ValidarRefLanzamiento(li_fab,li_lin,ll_ref) = 0 Then
//	ELSE
//		Rollback;
//		Return -1
//	END IF
	
	//-----------------------------se inserta registro en h_liberar_escalas
	IF ll_fila = 1 THEN
		IF of_CargarHLiberarEscalas() <> 0 THEN
			Rollback;
			Return -1
		END IF
	END IF
	
	//-----------------------------------se inserta en dt_libera_estilos
	IF of_CargarDtLiberaEstilos(li_fab,li_lin,ll_ref,ll_col,ll_cant_prog,li_cal) = -1 Then
		Rollback;
		Return -1
	END IF

	//--------------------------------se inserta en dt_talla_pdnmodulo
	IF of_CargarDtTallaPdnmodulo(li_fab,li_lin,ll_ref,ll_col,li_tal,ll_cant_prog)= -1 Then
		Rollback;
		Return -1
	END IF
	
	//---------------------------------se inserta en dt_telaxmodelo_lib
	IF of_CargarDtTelaxmodeloLib(li_fab,li_lin,ll_ref,ll_col,ll_cant_prog,li_tal,li_cal) = -1 Then
		Rollback;
		Return -1
	END IF
	
NEXT

//---------------------------------------------se recalculan los yield

Execute immediate "SET OPTIMIZATION LOW" ; 

DECLARE generar_yield PROCEDURE &
	FOR pr_act_conspromedio(:ii_fabexp,:il_liberacion);
EXECUTE generar_yield;
Execute immediate "SET OPTIMIZATION HIGH" ;

IF SQLCA.SQLCode = -1 THEN
	ROLLBACK;
	MessageBox("Error Base Datos","Error al ejecutar el stored procedure")			
	Return -1
END IF

//todo los procesos terminaron exitosamente por lo tanto se debe realizar la confirmaci$$HEX1$$f300$$ENDHEX$$n de los cambios.
Commit;
Return 0
end function

public function long of_validarreflanzamiento (long ai_fabrica, long ai_linea, long al_ref);//---------------------se verifica que si exista la referencia para el lanzamiento
Long ll_count

SELECT count(*)
  INTO :ll_count
  FROM dt_lanzamientos
 WHERE co_fabrica     = :ai_fabrica AND
 		 co_linea       = :ai_linea AND
		 co_referencia  = :al_ref AND
		 co_lanzamiento = :ii_lanzamiento;
IF sqlca.sqlcode = -1 THEN
	MessageBox('Error Base Datos','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de validar la referencia. ' + SQLCA.SQLErrText)
	Return -1
ELSEIF sqlca.sqlcode = 100 THEN
		MessageBox('Error','No se encontraron registros para el lanzamiento con la referencia: '+String(al_ref))
		Return 100
END IF

IF ll_count > 0 THEN
	Return 0
ELSE
	Return 1
END IF
end function

public function long of_consecutivoliberacion ();SELECT nvl(Max(cs_liberacion),0) + 1
INTO :il_liberacion
FROM h_liberar_escalas
WHERE co_fabrica_exp = :ii_fabexp;

IF SQLCA.SQLCode = -1 THEN
	MessageBox('Error','Error al consultar el consecutivo. ' + SQLCA.SQLErrText)
	Return -1
END IF

Return 0
end function

public function long of_updateyield ();

Return 0
end function

protected function long of_cargardttelaxmodelolib (long ai_fab, long ai_lin, long al_ref, long al_color, long al_cant_prog, long ai_tal, long ai_cal);Long ll_fila, ll_ref, ll_mod, ll_count, ll_reftel, ll_unidades
Long ll_fab, ll_lin, ll_tal, ll_cal, ll_colpt, ll_car, ll_dia, ll_colte, ll_caract, ll_colorte,&
		  ll_raya
String ls_tono
DateTime ldt_fecha
Decimal{2} ldc_ancho

//creo datastore de la tabla dt_color_modelo, haciendo retrieve con la fabrica, linea, referencia,
//talla, calidad y color
DataStore lds_col_modelo

lds_col_modelo = Create DataStore
lds_col_modelo.DataObject = 'ds_color_modelo'
lds_col_modelo.SetTransObject(sqlca)

//------------------------------------capturo la constante para el tono
SELECT texto
  INTO :ls_tono
  FROM m_constantes
 WHERE var_nombre = 'TONO';
 
IF sqlca.sqlcode <> 0 THEN
	MessageBox('Error 2','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de consultar el tono. '+ Sqlca.SqlErrText)
	Return -1
END IF

//--------------------------------------traigo la fecha del servidor
ldt_fecha = f_fecha_servidor()

lds_col_modelo.Retrieve(ai_fab,ai_lin,al_ref,ai_tal,ai_cal,al_color)

FOR ll_fila = 1 TO lds_col_modelo.RowCount()
	//----------------------------cargamos los datos del DS
	ll_mod = lds_col_modelo.GetItemNumber(ll_fila,'co_modelo')
	ll_reftel = lds_col_modelo.GetItemNumber(ll_fila,'co_reftel')
	ll_caract = lds_col_modelo.GetItemNumber(ll_fila,'co_caract')
	ll_dia = lds_col_modelo.GetItemNumber(ll_fila,'diametro')
	ll_colorte = lds_col_modelo.GetItemNumber(ll_fila,'co_color_te')
	
	
	
	//como pueden existir varias tallas para una mismo modelo, reftel, diametro y color
	//se pregunta primero por el registro a insertar si existe se ignora sino se inserta.
		
	//-------------------------------verificamos la existencia del registro
	SELECT count(*)
	  INTO :ll_count
     FROM dt_telaxmodelo_lib  
    WHERE dt_telaxmodelo_lib.co_fabrica_exp 	= :ii_fabexp  AND  
          dt_telaxmodelo_lib.cs_liberacion 	= :il_liberacion AND  
          dt_telaxmodelo_lib.nu_orden 			= :is_po  AND  
          dt_telaxmodelo_lib.nu_cut 			= :is_cut  AND  
          dt_telaxmodelo_lib.co_fabrica_pt 	= :ai_fab  AND  
          dt_telaxmodelo_lib.co_linea 			= :ai_lin  AND  
          dt_telaxmodelo_lib.co_referencia 	= :al_ref  AND  
          dt_telaxmodelo_lib.co_color_pt 		= :al_color AND  
          dt_telaxmodelo_lib.co_tono 			= :ls_tono  AND  
          dt_telaxmodelo_lib.co_modelo 		= :ll_mod  AND  
          dt_telaxmodelo_lib.co_fabrica_tela = :ai_fab  AND  
          dt_telaxmodelo_lib.co_reftel 		= :ll_reftel  AND  
          dt_telaxmodelo_lib.co_caract 		= :ll_caract  AND  
          dt_telaxmodelo_lib.diametro 			= :ll_dia  AND  
          dt_telaxmodelo_lib.co_color_tela 	= :ll_colorte ;
	
	IF sqlca.sqlcode = -1 THEN
		MessageBox('Error','Ocurrio un error al momento de verificar dt_telaxmodelo_lib. '+ Sqlca.SqlErrText)
		Return -1
	END IF
	
	IF ll_count > 0 THEN//---------------------realizamos update de cantidades
	   UPDATE dt_telaxmodelo_lib
		   SET ca_unidades = ca_unidades + :al_cant_prog
		 WHERE dt_telaxmodelo_lib.co_fabrica_exp 	= :ii_fabexp  AND  
         	 dt_telaxmodelo_lib.cs_liberacion 	= :il_liberacion AND  
          	 dt_telaxmodelo_lib.nu_orden 			= :is_po  AND  
          	 dt_telaxmodelo_lib.nu_cut 			= :is_cut  AND  
          	 dt_telaxmodelo_lib.co_fabrica_pt 	= :ai_fab  AND  
          	 dt_telaxmodelo_lib.co_linea 			= :ai_lin  AND  
          	 dt_telaxmodelo_lib.co_referencia 	= :al_ref  AND  
          	 dt_telaxmodelo_lib.co_color_pt 		= :al_color AND  
          	 dt_telaxmodelo_lib.co_tono 			= :ls_tono  AND  
          	 dt_telaxmodelo_lib.co_modelo 		= :ll_mod  AND  
          	 dt_telaxmodelo_lib.co_fabrica_tela = :ai_fab  AND  
          	 dt_telaxmodelo_lib.co_reftel 		= :ll_reftel  AND  
          	 dt_telaxmodelo_lib.co_caract 		= :ll_caract  AND  
          	 dt_telaxmodelo_lib.diametro 			= :ll_dia  AND  
          	 dt_telaxmodelo_lib.co_color_tela 	= :ll_colorte ;
				  
		IF sqlca.sqlcode <> 0 THEN
			MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de actualizar en dt_telaxmodelo_lib. '+ Sqlca.SqlErrText)
			Return -1
		END IF		  
				  
	ELSE
		//-------------------------------primero busco el ancho cortable
		SELECT ancho_abierto_term
		  INTO :ldc_ancho
		  FROM dt_teldiam
		 WHERE co_fabrica = :ai_fab AND
		 		 co_reftel  = :ll_reftel AND
				 co_caract  = :ll_caract AND
				 diametro   = :ll_dia;
		
		IF sqlca.sqlcode <> 0 THEN
			MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de consultar el ancho cortable. '+ Sqlca.SqlErrText)
			Return -1
		END IF
		
		//--------------------------------------traigo la raya
		SELECT raya
		  INTO :ll_raya
		  FROM dt_modelos
		 WHERE co_fabrica 	= :ai_fab AND
		 		 co_linea   	= :ai_lin AND
				 co_referencia = :al_ref AND
				 co_talla 		= :ai_tal AND
				 co_calidad 	= :ai_cal AND
				 co_color_pt 	= :al_color AND
				 co_modelo 		= :ll_mod;
		
		IF sqlca.sqlcode <> 0 THEN
			MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de consultar la raya. '+ Sqlca.SqlErrText)
			Return -1
		END IF
		
		//----------------------traigo las unidades para esta fabrica-linea-referencia-color
		SELECT sum(ca_unidades)
		  INTO :ll_unidades
		  FROM t_reposicion
		 WHERE co_fabrica 	= :ai_fab AND
				 co_linea   	= :ai_lin AND
				 co_referencia = :al_ref AND
				 co_color      = :al_color AND
				 co_calidad    = :ai_cal AND
				 usuario       = :gstr_info_usuario.codigo_usuario;
				 
		IF sqlca.sqlcode <> 0 THEN
			MessageBox('Error','Ocurrio un error al momento de consultar las unidades. '+ Sqlca.SqlErrText)
			Return -1 
		END IF
		
		
		//--------------------------------no existe lo insertamos
		 INSERT INTO dt_telaxmodelo_lib  
         ( co_fabrica_exp,   
           cs_liberacion,   
           nu_orden,   
           nu_cut,   
           co_fabrica_pt,   
           co_linea,   
           co_referencia,   
           co_color_pt,   
           co_tono,   
           co_modelo,   
           co_fabrica_tela,   
           co_reftel,   
           co_caract,   
           diametro,   
           co_color_tela,   
           ancho_cortable,   
           tono_tela,   
           raya,   
           ca_unidades,   
           yield,   
           ca_tela,   
           fe_creacion,   
           fe_actualizacion,   
           usuario,   
           instancia )  
       VALUES 
		     ( :ii_fabexp,   
           :il_liberacion,   
           :is_po,   
           :is_cut,   
           :ai_fab,   
           :ai_lin,   
           :al_ref,   
           :al_color,   
           :ls_tono,   
           :ll_mod,   
           :ai_fab,   
           :ll_reftel,   
           :ll_caract,   
           :ll_dia,   
           :ll_colorte,   
           :ldc_ancho,   
           :ls_tono,   
           :ll_raya,   
           :al_cant_prog,   
           0,   
           0,   
           :ldt_fecha,   
           :ldt_fecha,   
           :gstr_info_usuario.codigo_usuario,   
           :gstr_info_usuario.instancia )  ;

		IF sqlca.sqlcode <> 0 THEN
			MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de insertar en dt_telaxmodelo_lib. '+ Sqlca.SqlErrText)
			Return -1
		END IF
			
	END IF
	//------------------------------------insert en dt_escalastela
		IF of_CargarDtEscalasxTela(ai_fab,ai_lin,al_ref,al_color,ls_tono,ll_mod,ai_fab,ll_reftel,ll_caract,&
		                           ll_dia,ll_colorte, ai_tal,al_cant_prog,ai_cal) = -1 THEN
			Return -1
		END IF
		
	
NEXT

Return 0
end function

public function long of_cargardtliberaestilos (long ai_fab, long ai_lin, long al_ref, long al_color, long al_unidades, long ai_cal);DateTime ldt_fecha
String ls_tono
Long ll_unidades, ll_count

//-----------------------------capturo la constante para el tono
SELECT texto
  INTO :ls_tono
  FROM m_constantes
 WHERE var_nombre = 'TONO';
 
 IF sqlca.sqlcode <> 0 THEN
	MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de consultar el tono. '+ Sqlca.SqlErrText)
	Return -1
END IF

//---------------------------traigo la fecha del servidor
ldt_fecha = f_fecha_servidor()

//se verifica que el registro no se encuentre, ya que para una misma talla pueden haber varios colores
SELECT count(*)
  INTO :ll_count
  FROM dt_libera_estilos
 WHERE co_fabrica_exp	= :ii_fabexp AND   
       cs_liberacion    = :il_liberacion AND
       nu_orden 			= :is_po AND  
       nu_cut  			= :is_cut AND
       co_fabrica   		= :ai_fab AND
       co_linea   		= :ai_lin AND	
       co_referencia    = :al_ref AND
       co_color_pt  		= :al_color AND
       co_tono 			= :ls_tono;

IF sqlca.sqlcode = -1 THEN
	MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de consultar dt_libera_estilos. '+ Sqlca.SqlErrText)
	Return -1
END IF

IF ll_count > 0 THEN //--------------se realiza update de las ca_unidades
	UPDATE dt_libera_estilos
   SET ca_unidades = ca_unidades + :al_unidades
   WHERE co_fabrica_exp = :ii_fabexp AND
         cs_liberacion 	= :il_liberacion AND
         nu_orden 		= :is_po AND
         nu_cut 			= :is_cut AND
         co_fabrica 		= :ai_fab AND
         co_linea 		= :ai_lin AND
         co_referencia 	= :al_ref AND
         co_color_pt 	= :al_color AND
         co_tono 			= :ls_tono;
			
   IF sqlca.sqlcode <> 0 THEN
		MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de actualizar en dt_libera_estilos. '+ Sqlca.SqlErrText)
		Return -1
	END IF
	
	
	
ELSE//------------------------------------inserto el registro
	INSERT INTO dt_libera_estilos  
				( co_fabrica_exp,   
				  cs_liberacion,   
				  nu_orden,   
				  nu_cut,   
				  co_fabrica,   
				  co_linea,   
				  co_referencia,   
				  co_color_pt,   
				  co_tono,   
				  cs_ordenpd_pt,   
				  yield,   
				  ca_unidades,   
				  fe_creacion,   
				  fe_actualizacion,   
				  usuario,   
				  instancia )  
	  VALUES ( :ii_fabexp,   
				  :il_liberacion,   
				  :is_po,   
				  :is_cut,   
				  :ai_fab,   
				  :ai_lin,   
				  :al_ref,   
				  :al_color,   
				  :ls_tono,   
				  0,   
				  0,   
				  :al_unidades,   
				  :ldt_fecha,   
				  :ldt_fecha,   
				  :gstr_info_usuario.codigo_usuario,   
				  :gstr_info_usuario.instancia )  ;
				  
	IF sqlca.sqlcode <> 0 THEN
		MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de insertar en dt_libera_estilos. '+ Sqlca.SqlErrText)
		Return -1
	END IF
	
	
	
END IF
	
//------------------------------se inserta en dt_pdnxmodulo
IF of_CargarDtPdnxmodulo(ai_fab,ai_lin,al_ref,al_color,al_unidades)= -1 Then
	Rollback;
	Return -1
END IF	
	
Return 0
end function

public function long of_cargardtescalasxtela (long ai_fabpt, long ai_lin, long al_ref, long al_colorpt, string as_tono, long al_mod, long ai_fabte, long al_reftel, long ai_caract, long ai_dia, long al_colorte, long ai_talla, long al_unidades, long ai_cal);Long ll_count, ll_unidades
DateTime ldt_fecha
Long li_partes, li_tiptel, li_rectilineo1, li_rectilineo2
Decimal{2} ldc_area, ldc_ancho, ldc_porccolor, ldc_porctalla
Decimal{5} ldc_yield
n_cts_constantes lpo_constantes

//primero se verifica que el registro no exista, ya que desde donde se esta invocando se hace para todos los posibles
//registros de una talla, por lo tanto nosotros solo debemos insertar una vez por talla.

SELECT count(*)
  INTO :ll_count
  FROM dt_escalasxtela
 WHERE co_fabrica_exp 	= :ii_fabexp  AND  
       cs_liberacion 	= :il_liberacion  AND  
       nu_orden 			= :is_po  AND  
       nu_cut 				= :is_cut  AND  
       co_fabrica_pt 	= :ai_fabpt  AND  
       co_linea 			= :ai_lin  AND  
       co_referencia 	= :al_ref  AND  
       co_color_pt 		= :al_colorpt  AND  
       co_tono 			= :as_tono  AND  
       co_modelo 			= :al_mod  AND  
       co_fabrica_tela 	= :ai_fabte  AND  
       co_reftel 			= :al_reftel  AND  
       co_caract 			= :ai_caract  AND  
       diametro 			= :ai_dia  AND  
       co_color_tela 	= :al_colorte  AND  
       co_talla 			= :ai_talla ;   
		 
IF sqlca.sqlcode = -1 THEN
	MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de consultar en dt_escalasxtela. '+Sqlca.SqlErrText)
	Return -1
END IF
 
IF ll_count > 0 THEN//-----------------------update de las unidades
   UPDATE dt_escalasxtela
	   SET ca_unidades = ca_unidades + :al_unidades
	 WHERE co_fabrica_exp 	= :ii_fabexp  AND  
       	 cs_liberacion 	= :il_liberacion  AND  
       	 nu_orden 			= :is_po  AND  
       	 nu_cut 				= :is_cut  AND  
       	 co_fabrica_pt 	= :ai_fabpt  AND  
       	 co_linea 			= :ai_lin  AND  
       	 co_referencia 	= :al_ref  AND  
       	 co_color_pt 		= :al_colorpt  AND  
       	 co_tono 			= :as_tono  AND  
       	 co_modelo 			= :al_mod  AND  
       	 co_fabrica_tela 	= :ai_fabte  AND  
       	 co_reftel 			= :al_reftel  AND  
       	 co_caract 			= :ai_caract  AND  
       	 diametro 			= :ai_dia  AND  
       	 co_color_tela 	= :al_colorte  AND  
       	 co_talla 			= :ai_talla ;	
			  
	IF sqlca.sqlcode <> 0 THEN
		MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de actualizar la informaci$$HEX1$$f300$$ENDHEX$$n en dt_escalasxtela. '+Sqlca.SqlErrText)
		Return -1
	END IF		  
	
ELSE
	SELECT co_tiptel
	  INTO :li_tiptel
	  FROM h_telas
	 WHERE co_reftel = :al_reftel and
	       co_caract = :ai_caract;

	lpo_constantes = Create n_cts_constantes
	li_rectilineo1 = lpo_constantes.of_consultar_numerico('RECTILINEO 1')
	 
	IF li_rectilineo1 = -1 THEN
		Return -1
	END IF
	
	li_rectilineo2 = lpo_constantes.of_consultar_numerico('RECTILINEO 2')
	 
	IF li_rectilineo2 = -1 THEN
		Return -1
	END IF
	
	IF li_tiptel = li_rectilineo1 OR li_tiptel = li_rectilineo2 THEN
		ldc_yield =  0
	ELSE
		//-----------------------------se debe calcular el yield para dicha talla
		
		//-----------------------------capturo el ca_area y ca_partes
		SELECT nvl(sum(ca_partes * ca_area),0)
		  INTO :ldc_area
		  FROM dt_color_modelo
		 WHERE co_fabrica 	= :ai_fabpt AND
				 co_linea   	= :ai_lin AND
				 co_referencia = :al_ref AND
				 co_talla      = :ai_talla AND
				 co_calidad    = :ai_cal AND
				 co_color_pt   = :al_colorpt AND
				 co_modelo     = :al_mod AND
				 co_reftel     = :al_reftel AND
				 co_caract		= :ai_caract AND
				 diametro		= :ai_dia AND
				 co_color_te	= :al_colorte;	
				 
		IF sqlca.sqlcode <> 0 THEN
			MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de consultar el $$HEX1$$e100$$ENDHEX$$rea. '+ Sqlca.SqlErrText)
			Return -1
		END IF
			
		IF ldc_area = 0 THEN ldc_area = 1
		IF li_partes = 0  THEN li_partes = 1
			
		//--------------------------------traigo el ancho cortable
		SELECT nvl(ancho_abierto_term,0)
		  INTO :ldc_ancho
		  FROM dt_teldiam
		 WHERE co_fabrica = :ai_fabpt AND
				 co_reftel  = :al_reftel AND
				 co_caract  = :ai_caract AND
				 diametro   = :ai_dia;
			
		IF sqlca.sqlcode <> 0 THEN
			MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de consultar el ancho cortable. '+ Sqlca.SqlErrText)
			Return -1
		END IF
			
		IF ldc_ancho = 0 THEN ldc_ancho = 1	
			
		//-------------------capturo el porcentaje de utilizaci$$HEX1$$f300$$ENDHEX$$n para el color-modelo
		SELECT nvl(porc_utilizacion,0)
		  INTO :ldc_porccolor
		  FROM dt_modelos
		 WHERE co_fabrica 	= :ai_fabpt AND
				 co_linea   	= :ai_lin AND
				 co_referencia = :al_ref AND
				 co_talla 		= :ai_talla AND
				 co_calidad 	= :ai_cal AND
				 co_color_pt 	= :al_colorpt AND
				 co_modelo 		= :al_mod;
			
			IF sqlca.sqlcode <> 0 THEN
				MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de consultar el porcentaje de utilizaci$$HEX1$$f300$$ENDHEX$$n. '+ Sqlca.SqlErrText)
				Return -1
			END IF
			
		IF ldc_porccolor = 0 THEN ldc_porccolor = 1	
			
		//calculo el porcentaje para la talla-color con respecto a todos los colores para la talla
		//primero determino las unidades para todos los colores
		SELECT nvl(sum(ca_unidades),0)
			  INTO :ll_unidades
			  FROM t_reposicion
			 WHERE co_fabrica 	= :ai_fabpt AND
					 co_linea   	= :ai_lin AND
					 co_referencia = :al_ref AND
					 co_color      = :al_colorpt AND
					 co_calidad    = :ai_cal AND
					 usuario       = :gstr_info_usuario.codigo_usuario;
					 
			IF sqlca.sqlcode <> 0 THEN
				MessageBox('Error','Ocurrio un error al momento de consultar las unidades. '+ Sqlca.SqlErrText)
				Return -1 
			END IF
		
		IF ll_unidades = 0 THEN ll_unidades = 1
		
		ldc_porctalla = ((al_unidades * 100) / ll_unidades)/100
		
		
		//-------------------------ya podemos calcular el yield
		ldc_yield  = ((((ldc_area) / (ldc_porccolor/100) ) * ldc_porctalla) / ldc_ancho) / 100
	END IF	
	
	//------------------------------traigo la fecha del servidor
		ldt_fecha = f_fecha_servidor()
	
	//-------------------------el registro no existe se debe ingresar el registro en dt_escalasxtela
	INSERT INTO dt_escalasxtela  
         ( co_fabrica_exp,   
           cs_liberacion,   
           nu_orden,   
           nu_cut,   
           co_fabrica_pt,   
           co_linea,   
           co_referencia,   
           co_color_pt,   
           co_tono,   
           co_modelo,   
           co_fabrica_tela,   
           co_reftel,   
           co_caract,   
           diametro,   
           co_color_tela,   
           co_talla,   
           ca_unidades,   
           yield,   
           fe_creacion,   
           fe_actualizacion,   
           usuario,   
           instancia )  
  VALUES ( :ii_fabexp,   
           :il_liberacion,   
           :is_po,   
           :is_cut,   
           :ai_fabpt,   
           :ai_lin,   
           :al_ref,   
           :al_colorpt,   
           :as_tono,   
           :al_mod,   
           :ai_fabte,   
           :al_reftel,   
           :ai_caract,   
           :ai_dia,   
           :al_colorte,   
           :ai_talla,   
           :al_unidades,   
           :ldc_yield,   
           :ldt_fecha,   
           :ldt_fecha,   
           :gstr_info_usuario.codigo_usuario,   
           :gstr_info_usuario.instancia )  ;
			  
	IF sqlca.sqlcode <> 0 THEN
		MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de guardar la informaci$$HEX1$$f300$$ENDHEX$$n en dt_escalasxtela. '+ Sqlca.SqlErrText)
		Return -1
	END IF
END IF
 
Return 0
end function

public function long of_cargardttallapdnmodulo (long ai_fabpt, long ai_lin, long al_ref, long al_colorpt, long ai_talla, long al_unidades);Long li_simulacion, li_planta, li_fabplanta, li_modulo, li_ordentalla, li_estado_asigna
String ls_tono
DateTime ldt_fecha

//---------------------------cargo las constantes necesarias para cargar dt_tallapdnmodulo
SELECT numerico
  INTO :li_simulacion
  FROM m_constantes
 WHERE var_nombre = "SIMULACION";

SELECT numerico
  INTO :li_fabplanta
  FROM m_constantes
 WHERE var_nombre = "FABRICA PLANTA";

SELECT numerico
  INTO :li_planta
  FROM m_constantes
 WHERE var_nombre = "PLANTA LIBERACIONES";

SELECT numerico
  INTO :li_modulo
  FROM m_constantes
 WHERE var_nombre = "MODULO";
 
SELECT numerico
  INTO :li_estado_asigna
  FROM m_constantes
 WHERE var_nombre = "ESTADO ASIGNA";

ldt_fecha = f_fecha_servidor()

 SELECT nvl(Max(cs_orden_talla),0)
   INTO :li_ordentalla
   FROM dt_talla_pdnmodulo
   WHERE simulacion 			= :li_simulacion AND
         co_fabrica 			= :li_fabplanta AND
         co_planta 			= :li_planta AND
         co_modulo 			= :li_modulo AND
         co_fabrica_exp 	= :ii_fabexp AND
         cs_liberacion 		= :il_liberacion AND
         po 					= :is_po AND
         nu_cut 				= :is_cut AND
         co_fabrica_pt 		= :ai_fabpt AND
         co_linea 			= :ai_lin AND
         co_referencia 		= :al_ref AND
         co_color_pt 		= :al_colorpt AND
         tono 					= :ls_tono AND
         cs_particion 		= 1 AND
         co_talla 			= :ai_talla;
			
IF sqlca.sqlcode = -1 THEN
	MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de verificar en dt_talla_pdnmodulo. '+ Sqlca.SqlErrText)
	Return -1
END IF

IF li_ordentalla = 0 THEN
      INSERT INTO dt_talla_pdnmodulo(
			simulacion, 
			co_fabrica,
         co_planta, 
			co_modulo, 
			co_fabrica_exp, 
			cs_liberacion,
         po, 
			nu_cut, 
			co_fabrica_pt, 
			co_linea, 
			co_referencia,
         co_color_pt, 
			tono, 
			cs_particion, 
			co_talla,
         cs_orden_talla, 
			cs_prioridad, 
			ca_programada,
         ca_producida, 
			ca_pendiente, 
			co_est_prog_talla,
         fuente_dato, 
			fe_creacion, 
			fe_actualizacion, 
			usuario,
         instancia, 
			co_estado_merc, 
			ca_proyectada, 
			ca_actual,
         ca_numerada)
      VALUES(:li_simulacion, 
		:li_fabplanta, 
		:li_planta,
         :li_modulo, 
			:ii_fabexp, 
			:il_liberacion, 
			:is_po,
         :is_cut, 
			:ai_fabpt, 
			:ai_lin, 
			:al_ref,
         :al_colorpt, 
			:ls_tono, 
			1, 
			:ai_talla, 
			:li_ordentalla,
         :ii_prioridad, 
			:al_unidades, 
			0, 
			:al_unidades,
         :li_estado_asigna, 
			0, 
			:ldt_fecha, 
			:ldt_fecha, 
			:gstr_info_usuario.codigo_usuario,
         :gstr_info_usuario.instancia, 
			Null, 
			0, 
			0, 
			0);
			
	IF sqlca.sqlcode <> 0 THEN
		MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de insertar en dt_talla_pdnmodulo. '+ Sqlca.SqlErrText)
		Return -1
	END IF
		
			
ELSEIF li_ordentalla > 0 THEN
	 UPDATE dt_talla_pdnmodulo
      SET ca_programada = ca_programada + :al_unidades,
          ca_pendiente = ca_pendiente + :al_unidades
      WHERE simulacion 			= :li_simulacion AND
            co_fabrica 			= :li_fabplanta AND
            co_planta 			= :li_planta AND
            co_modulo 			= :li_modulo AND
            co_fabrica_exp 	= :ii_fabexp AND
            cs_liberacion 		= :il_liberacion AND
            po 					= :is_po AND
            nu_cut 				= :is_cut AND
            co_fabrica_pt 		= :ai_fabpt AND
            co_linea 			= :ai_lin AND
            co_referencia 		= :al_ref AND
            co_color_pt 		= :al_colorpt AND
            tono 					= :ls_tono AND
            cs_particion 		= 1 AND
            co_talla 			= :ai_talla;
				
		IF sqlca.sqlcode <> 0 THEN
			MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de actualizar en dt_talla_pdnmodulo. '+ Sqlca.SqlErrText)
			Return -1
		END IF
		
END IF


Return 0
end function

public function long of_cargardtpdnxmodulo (long ai_fabpt, long ai_lin, long al_ref, long al_color, long al_unidades);Long li_fabplanta, li_planta, li_modulo, li_estado_asigna, li_tipo_asigna, li_tipo_empate, li_simulacion,&
        li_tipoprog, li_asignacion
Long ll_prioridad, ll_count	
String ls_tono
DateTime ldt_entrega, ldt_fecha

//----------------------------------carga constantes iniciales
SELECT numerico
  INTO :li_simulacion
  FROM m_constantes
 WHERE var_nombre = "SIMULACION";

IF sqlca.sqlcode <> 0 THEN 
	MessageBox('Error','No fue posible localizar el valor para la simulaci$$HEX1$$f300$$ENDHEX$$n. '+ Sqlca.SqlErrText)
	Return -1
END IF

SELECT numerico
  INTO :li_fabplanta
  FROM m_constantes
 WHERE var_nombre = "FABRICA PLANTA";

IF sqlca.sqlcode <> 0 THEN 
	MessageBox('Error','No fue posible localizar el valor para la fabrica-planta. '+ Sqlca.SqlErrText)
	Return -1
END IF

SELECT numerico
  INTO :li_planta
  FROM m_constantes
 WHERE var_nombre = "PLANTA LIBERACIONES";

IF sqlca.sqlcode <> 0 THEN 
	MessageBox('Error','No fue posible localizar el valor para la planta de la liberaci$$HEX1$$f300$$ENDHEX$$n. '+ Sqlca.SqlErrText)
	Return -1
END IF

SELECT numerico
  INTO :li_modulo
  FROM m_constantes
 WHERE var_nombre = "MODULO";
	
IF sqlca.sqlcode <> 0 THEN 
	MessageBox('Error','No fue posible localizar el valor para el m$$HEX1$$f300$$ENDHEX$$dulo. '+ Sqlca.SqlErrText)
	Return -1
END IF	
	
SELECT texto
  INTO :ls_tono
  FROM m_constantes
 WHERE var_nombre = 'TONO';

IF sqlca.sqlcode <> 0 THEN 
	MessageBox('Error','No fue posible localizar el valor para el tono. '+ Sqlca.SqlErrText)
	Return -1
END IF

SELECT count(*)
  INTO :ll_count
  FROM dt_pdnxmodulo
 WHERE simulacion 		=:li_simulacion	AND
		 co_fabrica 		=:li_fabplanta	AND
		 co_planta			=:li_planta	AND
       co_modulo 			=:li_modulo	AND
		 co_fabrica_exp	=:ii_fabexp 	AND
		 cs_liberacion 	=:il_liberacion	AND
		 po					=:is_po	AND
		 nu_cut				=:is_cut	AND
       co_fabrica_pt 	=:ai_fabpt	AND
		 co_linea			=:ai_lin	AND
		 co_referencia		=:al_ref	AND
		 co_color_pt 		=:al_color	AND
		 tono 				=:ls_tono	;
	
	IF sqlca.sqlcode <> 0 THEN 
		MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de consultar en dt_pdnxmodulo. '+ Sqlca.SqlErrText)
		Return -1
	END IF


IF ll_count > 0 THEN //--------------------------actualizo las cantidades
   UPDATE dt_pdnxmodulo
	   SET ca_programada = ca_programada + :al_unidades,
		    ca_pendiente  = ca_pendiente + :al_unidades
	 WHERE simulacion 		=:li_simulacion	AND
		 	 co_fabrica 		=:li_fabplanta	AND
		 	 co_planta			=:li_planta	AND
       	 co_modulo 			=:li_modulo	AND
		 	 co_fabrica_exp	=:ii_fabexp 	AND
		 	 cs_liberacion 	=:il_liberacion	AND
		 	 po					=:is_po	AND
		 	 nu_cut				=:is_cut	AND
       	 co_fabrica_pt 	=:ai_fabpt	AND
		 	 co_linea			=:ai_lin	AND
		 	 co_referencia		=:al_ref	AND
		 	 co_color_pt 		=:al_color	AND
		 	 tono 				=:ls_tono	;
	
	IF sqlca.sqlcode <> 0 THEN 
		Rollback;
		MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de actualizar en dt_pdnxmodulo. '+ Sqlca.SqlErrText)
		Return -1
	END IF

ELSE//-----------------------------------------inserto en dt_pdnxmodulo

	//------------------------cargo las constantes necesarias para cargar dt_pdnxmodulo
	
	SELECT numerico
	  INTO :li_estado_asigna
	  FROM m_constantes
	 WHERE var_nombre = "ESTADO ASIGNA";
	
	IF sqlca.sqlcode <> 0 THEN 
		MessageBox('Error','No fue posible localizar el valor para el estado de asignaci$$HEX1$$f300$$ENDHEX$$n. '+ Sqlca.SqlErrText)
		Return -1
	END IF
	
	SELECT numerico
	  INTO :li_tipo_asigna
	  FROM m_constantes
	 WHERE var_nombre = "TIPO ASIGNA";
	
	IF sqlca.sqlcode <> 0 THEN 
		MessageBox('Error','No fue posible localizar el valor el tipo de asignaci$$HEX1$$f300$$ENDHEX$$n. '+ Sqlca.SqlErrText)
		Return -1
	END IF
	
	SELECT numerico
	  INTO :li_tipo_empate
	  FROM m_constantes
	 WHERE var_nombre = "TIPO EMPATE";
	 
	 IF sqlca.sqlcode <> 0 THEN 
		MessageBox('Error','No fue posible localizar el valor el tipo de empate. '+ Sqlca.SqlErrText)
		Return -1
	END IF
		 
	SELECT numerico
	  INTO :li_tipoprog
	  FROM m_constantes
	 WHERE var_nombre = "TIPO PROG";
	
	IF sqlca.sqlcode <> 0 THEN 
		MessageBox('Error','No fue posible localizar el valor el tipo de programaci$$HEX1$$f300$$ENDHEX$$n. '+ Sqlca.SqlErrText)
		Return -1
	END IF
	
//	SELECT numerico
//	  INTO :li_asignacion
//	  FROM m_constantes
//	 WHERE var_nombre = "ASIGNACION";
	
	SELECT numerico
	  INTO :li_asignacion
	  FROM m_constantes
	 WHERE var_nombre = "ASIGNACION REPROCESO";
	
	IF sqlca.sqlcode <> 0 THEN 
		MessageBox('Error','No fue posible localizar el valor para la asignaci$$HEX1$$f300$$ENDHEX$$n. '+ Sqlca.SqlErrText)
		Return -1
	END IF
	
	
	SELECT Nvl(Max(cs_prioridad), 0) + 1
	  INTO :ii_prioridad
	  FROM dt_pdnxmodulo
	 WHERE simulacion = :li_simulacion AND
			 co_fabrica = :li_fabplanta AND
			 co_planta 	= :li_planta AND
			 co_modulo 	= :li_modulo;
	
	ldt_fecha = f_fecha_servidor()  
	  
	INSERT INTO dt_pdnxmodulo(
			simulacion, 
			co_fabrica, 
			co_planta,
			co_modulo, 
			co_fabrica_exp, 
			cs_liberacion, 
			po, 
			nu_cut,
			co_fabrica_pt, 
			co_linea, 
			co_referencia, 
			co_color_pt, 
			tono,
			cs_prioridad, 
			ca_programada, 
			ca_producida, 
			ca_pendiente,
			co_estado_asigna, 
			co_curva, 
			fe_inicio_prog, 
			fe_fin_prog,
			fe_requerida_desp, 
			ca_minutos_std, 
			co_tipo_asignacion,
			ca_personasxmod, 
			cod_tur, 
			minutos_jornada,
			ind_cambio_estilo, 
			ca_unid_base_dia, 
			orige_uni_base_dia,
			tipo_empate, 
			unidades_empate, 
			metodo_programa,
			fuente_dato, 
			fe_creacion, 
			fe_actualizacion, 
			usuario,
			instancia, 
			fe_entra_pdn, 
			tipo_fe_prog, 
			fe_lim_prog,
			fe_desp_programada, 
			indicativo_base, 
			ca_base_dia_prod,
			ca_base_dia_prog, 
			ca_a_programar, 
			co_estado_merc,
			ca_proyectada, 
			ca_actual, 
			ca_numerada, 
			fe_fogueo,
			fe_trabajo, 
			cs_asignacion, 
			cs_particion, 
			cs_ordenpd_pt,
			co_fabrica_prop,
			co_linea_exp,
			co_ref_exp,
			co_color_exp)
		VALUES(:li_simulacion, 
			:li_fabplanta, 
			:li_planta, 
			:li_modulo,
			:ii_fabexp, 
			:il_liberacion, 
			:is_po, 
			:is_cut, 
			:ai_fabpt,
			:ai_lin, 
			:al_ref, 
			:al_color, 
			:ls_tono, 
			:ii_prioridad,
			:al_unidades, 
			0, 
			:al_unidades, 
			:li_estado_asigna, 
			Null, 
			Null,
			null, 
			:ldt_entrega, 
			0, 
			:li_tipo_asigna, 
			0, 
			0, 
			0, 
			0, 
			0, 
			0,
			:li_tipo_empate, 
			0, 
			0, 
			0, 
			:ldt_fecha, 
			:ldt_fecha, 
			:gstr_info_usuario.codigo_usuario, 
			:gstr_info_usuario.instancia,
			Null, 
			:li_tipoprog, 
			Null, 
			Null, 
			0, 
			0, 
			0, 
			0, 
			0, 
			0, 
			0, 
			0,
			Null,
			Null, 
			:li_asignacion, 
			1, 
			0,
			:gstr_info_usuario.co_planta_pro,
			0,
			'0',
			'0');
	
	IF sqlca.sqlcode <> 0 THEN
		Rollback;
		MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de guardar la informaci$$HEX1$$f300$$ENDHEX$$n en dt_pdnxmodulo. '+ Sqlca.SqlErrText)
		Return -1
	END IF
END IF

Return 0
end function

on n_cst_liberacion_reproceso.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cst_liberacion_reproceso.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

