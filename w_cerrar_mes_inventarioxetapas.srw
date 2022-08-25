HA$PBExportHeader$w_cerrar_mes_inventarioxetapas.srw
forward
global type w_cerrar_mes_inventarioxetapas from w_base_buscar_interactivo
end type
type st_2 from statictext within w_cerrar_mes_inventarioxetapas
end type
type em_1 from editmask within w_cerrar_mes_inventarioxetapas
end type
type em_2 from editmask within w_cerrar_mes_inventarioxetapas
end type
end forward

global type w_cerrar_mes_inventarioxetapas from w_base_buscar_interactivo
integer width = 937
integer height = 760
st_2 st_2
em_1 em_1
em_2 em_2
end type
global w_cerrar_mes_inventarioxetapas w_cerrar_mes_inventarioxetapas

type variables
DATE id_ano_mes_actual,id_ano_mes_prox
end variables

on w_cerrar_mes_inventarioxetapas.create
int iCurrent
call super::create
this.st_2=create st_2
this.em_1=create em_1
this.em_2=create em_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_2
this.Control[iCurrent+2]=this.em_1
this.Control[iCurrent+3]=this.em_2
end on

on w_cerrar_mes_inventarioxetapas.destroy
call super::destroy
destroy(this.st_2)
destroy(this.em_1)
destroy(this.em_2)
end on

event open;STRING ls_usuario
N_DATETIME lnvo_datetime
s_base_parametros	lstr_parametros

id_ano_mes_actual=date(f_fecha_servidor())
ls_usuario= gstr_info_usuario.codigo_usuario
em_1.Text=string(id_ano_mes_actual,'yyyy-mm')
id_ano_mes_prox = lnvo_datetime.of_relativemonth( id_ano_mes_actual, 1)
em_2.text = string(id_ano_mes_prox)
IF ls_usuario = 'fjangulo' THEN
	pb_buscar.visible=true
ELSE
	pb_buscar.visible=false
END IF

end event

type pb_cancelar from w_base_buscar_interactivo`pb_cancelar within w_cerrar_mes_inventarioxetapas
integer x = 507
integer y = 496
end type

event pb_cancelar::clicked;call super::clicked;close(parent)
end event

type pb_buscar from w_base_buscar_interactivo`pb_buscar within w_cerrar_mes_inventarioxetapas
integer x = 41
integer y = 496
string text = "&Ejecutar"
end type

event pb_buscar::clicked;call super::clicked;/////////////////////////////////////////////////////////////////////
// Estas lineas se deben acondionar seg$$HEX1$$fa00$$ENDHEX$$n la busqueda

/////////////////////////////////////////////////////////////////////

string	ls_ano_mes_cierre,ls_ano_mes_prox
long	ll_cs_dato,ll_cs_orden_corte,ll_cs_agrupacion,ll_ca_saldo,ll_lleva
Long li_etapa,li_cs_pdn,li_cuantos

//s_parametros lstr_parametros
//lstr_parametros.hay_parametros = TRUE
//lstr_parametros.cadena[1]=sle_parametro1.text

ls_ano_mes_cierre=em_1.text
ls_ano_mes_prox	=em_2.text
ll_lleva=0
 DECLARE cur_cierre CURSOR FOR 
 
   SELECT r_estadosxetapa.etapa,          r_estadosxetapa.cs_dato,   r_estadosxetapa.cs_orden_corte, 
  			r_estadosxetapa.cs_agrupacion,  r_estadosxetapa.cs_pdn,   
         sum(r_estadosxetapa.ca_inicial ) + sum(r_estadosxetapa.ca_entradas ) - sum(r_estadosxetapa.ca_salidas )  
    FROM r_estadosxetapa  
   WHERE r_estadosxetapa.ano_mes = :ls_ano_mes_cierre 
//and r_estadosxetapa.etapa in (9,13,14,15,16,19,20)
GROUP BY r_estadosxetapa.etapa,r_estadosxetapa.cs_dato,r_estadosxetapa.cs_orden_corte,r_estadosxetapa.cs_agrupacion,   
         r_estadosxetapa.cs_pdn
having sum(r_estadosxetapa.ca_inicial + r_estadosxetapa.ca_entradas - r_estadosxetapa.ca_salidas  ) <> 0
  
order BY r_estadosxetapa.etapa,r_estadosxetapa.cs_dato,r_estadosxetapa.cs_orden_corte,r_estadosxetapa.cs_agrupacion,   
         r_estadosxetapa.cs_pdn;
 

			
if sqlca.sqlcode=-1 then
	messagebox("Error bd","No pudo declarar el cursor de a$$HEX1$$f100$$ENDHEX$$o-mes a cerrar")
	Return
else
end if

open cur_cierre;
if sqlca.sqlcode=-1 then
	messagebox("Error bd","No pudo abrir el cursor de a$$HEX1$$f100$$ENDHEX$$o-mes a cerrar")
	Return
else
end if

fetch cur_cierre into :li_etapa,:ll_cs_dato,:ll_cs_orden_corte,:ll_cs_agrupacion,:li_cs_pdn,:ll_ca_saldo;

if sqlca.sqlcode=-1 then
	messagebox("Error bd","No pudo traer datos para el cursor de a$$HEX1$$f100$$ENDHEX$$o-mes a cerrar")
	Return
else
end if

do while sqlca.sqlcode=0
	ll_lleva=ll_lleva + 1
	li_cuantos=0
	//buscar en nuevo a$$HEX1$$f100$$ENDHEX$$o-mes
	SELECT count(*)  
    INTO :li_cuantos  
    FROM r_estadosxetapa  
   WHERE ( r_estadosxetapa.ano_mes = :ls_ano_mes_prox ) AND  
         ( r_estadosxetapa.etapa = :li_etapa ) AND  
         ( r_estadosxetapa.cs_dato = :ll_cs_dato )   ;
	if sqlca.sqlcode=-1 then
		messagebox("Error bd","No pudo traer datos para el cursor de a$$HEX1$$f100$$ENDHEX$$o-mes a cerrar")
		Return
	else
	end if
	
	if isnull(li_cuantos) then
		li_cuantos=0
	else
	end if
	
	if li_cuantos > 0 then
		//update
		UPDATE r_estadosxetapa  
		  SET ca_inicial = ca_inicial + :ll_ca_saldo  
		WHERE ( r_estadosxetapa.ano_mes = :ls_ano_mes_prox ) AND  
				( r_estadosxetapa.etapa = :li_etapa ) AND  
				( r_estadosxetapa.cs_dato = :ll_cs_dato )   				  ;
		if sqlca.sqlcode=-1 then
			messagebox("Error bd","No pudo actualizar saldo")
			Return
		else
		end if
	else
		//insert
		INSERT INTO r_estadosxetapa  
         ( ano_mes,etapa,cs_dato,cs_orden_corte,cs_agrupacion,cs_pdn,   
           ca_inicial,ca_entradas,ca_salidas,ca_saldo,   
           fe_creacion,fe_actualizacion,usuario,instancia )  
  VALUES ( :ls_ano_mes_prox,:li_etapa,:ll_cs_dato,:ll_cs_orden_corte,:ll_cs_agrupacion,:li_cs_pdn,:ll_ca_saldo,   
           0,0,0,current,current,user,sitename )  ;
		if sqlca.sqlcode=-1 then
			messagebox("Error bd","No pudo insertar")
			Return
		else
		end if
	end if

	fetch cur_cierre into :li_etapa,:ll_cs_dato,:ll_cs_orden_corte,:ll_cs_agrupacion,:li_cs_pdn,:ll_ca_saldo;
	
	if sqlca.sqlcode=-1 then
		messagebox("Error bd","No pudo traer datos para el cursor de a$$HEX1$$f100$$ENDHEX$$o-mes a cerrar")
		Return
	else
	end if
	
loop

Messagebox("PROCESO EXITOSO","El proceso termin$$HEX2$$f3002000$$ENDHEX$$bien. ",Exclamation!,Ok!)		

Close(parent)
end event

type st_1 from w_base_buscar_interactivo`st_1 within w_cerrar_mes_inventarioxetapas
integer x = 55
integer y = 148
integer width = 407
string text = "A$$HEX1$$f100$$ENDHEX$$o-mes a Cerrar: "
end type

type sle_parametro1 from w_base_buscar_interactivo`sle_parametro1 within w_cerrar_mes_inventarioxetapas
boolean visible = false
integer x = 539
integer y = 512
integer width = 338
boolean enabled = false
end type

type gb_1 from w_base_buscar_interactivo`gb_1 within w_cerrar_mes_inventarioxetapas
integer width = 869
integer height = 444
end type

type st_2 from statictext within w_cerrar_mes_inventarioxetapas
integer x = 46
integer y = 300
integer width = 425
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long backcolor = 15780518
string text = "A$$HEX1$$f100$$ENDHEX$$o-mes Siguiente:"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_1 from editmask within w_cerrar_mes_inventarioxetapas
integer x = 494
integer y = 128
integer width = 306
integer height = 80
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long backcolor = 16777215
string text = "none"
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datetimemask!
string mask = "yyyy-mm"
boolean spin = true
end type

type em_2 from editmask within w_cerrar_mes_inventarioxetapas
integer x = 494
integer y = 300
integer width = 306
integer height = 80
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long backcolor = 16777215
string text = "none"
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datetimemask!
string mask = "yyyy-mm"
end type

