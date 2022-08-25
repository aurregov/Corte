HA$PBExportHeader$n_cts_ocfabrica.sru
forward
global type n_cts_ocfabrica from nonvisualobject
end type
end forward

global type n_cts_ocfabrica from nonvisualobject autoinstantiate
end type

forward prototypes
public function long of_validarocfabrica (long al_ordencorte)
end prototypes

public function long of_validarocfabrica (long al_ordencorte);//metodo con el cual se establece si una orden de corte pertenece a la fabrica con la cual
//se ingreso al sistema, esto se hace debido a que el sistema sera utilizado por Marinilla y
//Nicole con el fin de minimizar la posibilidad que un usuario de una planta manipule una 
//orden de corte de otra.
//jcrm
//junio 5 2007
LONG ll_orden, ll_count, li_total, li_color_crudo_apt
n_cts_constantes luo_constantes

SELECT max(cs_ordenpd_pt)
  INTO :ll_orden
  FROM dt_pdnxmodulo
 WHERE cs_asignacion = :al_ordencorte;
 
IF sqlca.sqlcode = -1 THEN
	MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de validar la orden de corte, ERROR: ' +sqlca.SqlErrText ,StopSign!)	
	Return -1
END IF

IF sqlca.sqlcode = 100 THEN
	MessageBox('Advertencia','La orden de corte no existe',Exclamation!)	
	Return -1
END IF
//
//li_color_crudo_apt = luo_constantes.of_consultar_numerico("COLOR_CRUDO_APT")
//IF li_color_crudo_apt = -1 THEN
//	Return -1
//END IF
//
//SELECT COUNT(*)
//  INTO :li_total
//  FROM dt_pdnxmodulo
// WHERE cs_asignacion = :al_ordencorte
//   AND co_color_pt   = :li_color_crudo_apt; 
//IF li_total > 0 THEN
//	MessageBox('Error','No puede hacer reposicion al color crudo APT')
//	Return -1
//END IF


//se coloca en comentario ya que todas las ordenes se estan generando en Marinilla
//IF gstr_info_usuario.co_planta_pro = 2 THEN
//	SELECT count(*)
//	  INTO :ll_count
//	  FROM m_rollo
//	 WHERE cs_orden_pr_act = :ll_orden AND
//	 		 co_centro = 15;
//			  
//	IF ll_count <= 0 THEN		  
//		MessageBox('Error','La orden de corte no pertenece a la planta: '+gstr_info_usuario.fabrica)
//   	Return -1
//	END IF
//ELSEIF gstr_info_usuario.co_planta_pro = 91 THEN
//	SELECT count(*)
//	  INTO :ll_count
//	  FROM m_rollo
//	 WHERE cs_orden_pr_act = :ll_orden AND
//	 		 co_centro = 21;
//			  
//	IF ll_count <= 0 THEN		  
//		MessageBox('Error','La orden de corte no pertenece a la planta: '+gstr_info_usuario.fabrica)
//   	Return -1
//	END IF
//END IF
Return 0

end function

on n_cts_ocfabrica.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cts_ocfabrica.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

