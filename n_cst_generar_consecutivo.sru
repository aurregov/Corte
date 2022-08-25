HA$PBExportHeader$n_cst_generar_consecutivo.sru
forward
global type n_cst_generar_consecutivo from nonvisualobject
end type
end forward

global type n_cst_generar_consecutivo from nonvisualobject
end type
global n_cst_generar_consecutivo n_cst_generar_consecutivo

forward prototypes
public function long of_calcula_consecutivo (long an_co_fabrica, long an_id_documento)
public function string of_get_base_path (long ai_co_fabrica, long ai_id_documento)
public function long of_consulta_consecutivo_orden (long ai_fabrica, long ai_tipo)
end prototypes

public function long of_calcula_consecutivo (long an_co_fabrica, long an_id_documento);Long ll_cs_documento

ll_cs_documento=0

SELECT cs_documento  
INTO :ll_cs_documento  
FROM cf_consecutivos
WHERE ( cf_consecutivos.co_fabrica   = :an_co_fabrica ) AND  
		( cf_consecutivos.id_documento = :an_id_documento );

if Sqlca.sqlcode=-1 then
	MessageBox("Error Base Datos","No pudo traer consecutivo")
	ll_cs_documento = 0
else
end if

if IsNull(ll_cs_documento)  then
	ll_cs_documento = 0
else
	ll_cs_documento = ll_cs_documento + 1
end if

update cf_consecutivos 
set cs_documento=:ll_cs_documento
WHERE ( cf_consecutivos.co_fabrica   = :an_co_fabrica ) AND  
		( cf_consecutivos.id_documento = :an_id_documento );

if Sqlca.sqlcode=-1 then
	Rollback;
	MessageBox("Error Base Datos","No pudo Actualizar consecutivo")
	ll_cs_documento = 0
else
end if
	
Return ll_cs_documento
end function

public function string of_get_base_path (long ai_co_fabrica, long ai_id_documento);String ls_Base_Path

ls_Base_Path=""

  SELECT cf_consec_prepdn.de_documento  
    INTO :ls_Base_Path  
    FROM cf_consec_prepdn  
   WHERE ( cf_consec_prepdn.co_fabrica = :ai_co_fabrica ) AND  
         ( cf_consec_prepdn.id_documento = :ai_id_documento )   
	;

	if Sqlca.sqlcode=-1 then
		MessageBox("Error Base Datos","No pudo buscar la Ruta Base")
	else
		ls_Base_Path=Trim(ls_Base_Path)
	end if
	
Return ls_Base_Path
end function

public function long of_consulta_consecutivo_orden (long ai_fabrica, long ai_tipo);Long li_incremento
Long ll_mercada

SELECT incremento, nu_enque_esta
INTO :li_incremento, :ll_mercada
FROM cf_consc_ordenes
WHERE co_fabrica = :ai_fabrica AND
      tipo_orden = :ai_tipo;
		
IF SQLCA.SQLCode = -1 THEN
	MessageBox("Error Base Datos","Error al consultar la mercada en la base de datos " + SQLCA.SQLErrText)
	Return -1
ELSE
	IF SQLCA.SQLCode = 100 THEN
		MessageBox("Advertencia...","No se encontr$$HEX2$$f3002000$$ENDHEX$$el consecutivo de mercada")
		Return -1
	END IF
END IF

UPDATE cf_consc_ordenes
SET nu_enque_esta = nu_enque_esta + :li_incremento
WHERE co_fabrica = :ai_fabrica AND
      tipo_orden = :ai_tipo;
		
IF SQLCA.SQLCode = -1 THEN
	MessageBox("Error Base Datos","Error al actualizar el consecutivo en la base de datos " + SQLCA.SQLErrText)
	Return -1
END IF

Return ll_mercada
end function

on n_cst_generar_consecutivo.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cst_generar_consecutivo.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

