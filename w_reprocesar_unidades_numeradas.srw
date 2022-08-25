HA$PBExportHeader$w_reprocesar_unidades_numeradas.srw
forward
global type w_reprocesar_unidades_numeradas from w_base_buscar_interactivo
end type
end forward

global type w_reprocesar_unidades_numeradas from w_base_buscar_interactivo
end type
global w_reprocesar_unidades_numeradas w_reprocesar_unidades_numeradas

on w_reprocesar_unidades_numeradas.create
call super::create
end on

on w_reprocesar_unidades_numeradas.destroy
call super::destroy
end on

type pb_cancelar from w_base_buscar_interactivo`pb_cancelar within w_reprocesar_unidades_numeradas
end type

type pb_buscar from w_base_buscar_interactivo`pb_buscar within w_reprocesar_unidades_numeradas
end type

event pb_buscar::clicked;call super::clicked;long	ll_cs_orden_corte,ll_pedido,ll_co_referencia,ll_co_color_pt,ll_ca_actual,ll_ca_numerada
Long li_co_fabrica_exp, li_cs_liberacion,li_co_fabrica_pt,li_co_linea,li_cs_estilocolortono,li_co_talla
Long li_co_calidad,li_co_tono
string ls_po,ls_tono
TRANSACTION			itr_tela

itr_tela 				= 	Create Transaction
itr_tela.DBMS			=	ProfileString(gstr_info_usuario.ruta_ini,"bd aplicacion","DBMS","")
itr_tela.DATABASE		=	ProfileString(gstr_info_usuario.ruta_ini,"bd aplicacion","DATABASE","")
itr_tela.USERID		=	itr_tela.USERID
itr_tela.DBPASS		=	itr_tela.DBPASS
itr_tela.DBPARM		=	"connectstring='DSN="+itr_tela.DATABASE+";UID="+itr_tela.USERID+";PWD="+itr_tela.DBPASS+"'"
itr_tela.ServerName 	= 	ProfileString(gstr_info_usuario.ruta_ini,"bd aplicacion","SERVIDOR","")
itr_tela.Lock 			= 	ProfileString(gstr_info_usuario.ruta_ini,"bd aplicacion","LOCK","Dirty read")

CONNECT USING itr_tela;
IF itr_tela.SQLCODE = -1 THEN
   MessageBox("ERROR....","La conexi$$HEX1$$f300$$ENDHEX$$n para abrir esta ventana (dr)" +itr_tela.sqlerrtext,Stopsign!,OK!)
   Return
END IF

//buscar las oc liquidadas a partir de fecha
declare cur_liq cursor for
  SELECT DISTINCT dt_liquidaxespacio.cs_orden_corte  
    FROM dt_liquidaxespacio  
   WHERE ( dt_liquidaxespacio.cs_orden_corte > 0 ) AND  
         ( date(dt_liquidaxespacio.fe_liquidacion) >= "04-01-2003" )              
			USING itr_tela;
if itr_tela.sqlcode=-1 then
	messagebox("error bd","declare cur_liq")
	return
else
end if

open cur_liq;
if itr_tela.sqlcode=-1 then
	messagebox("error bd","open cur_liq")
	return
else
end if

fetch cur_liq into :ll_cs_orden_corte;
if itr_tela.sqlcode=-1 then
	messagebox("error bd","fetch cur_liq")
	return
else
end if

do while itr_tela.sqlcode=0
	
	//buscar en canastas de las liquidaciones los datos para loteo
	declare cur_canastas cursor for
	SELECT dt_agrupa_pdn.co_fabrica_exp,            dt_agrupa_pdn.pedido,            dt_agrupa_pdn.cs_liberacion,   
         dt_agrupa_pdn.po,            dt_agrupa_pdn.co_fabrica_pt,            dt_agrupa_pdn.co_linea,   
         dt_agrupa_pdn.co_referencia,            dt_agrupa_pdn.co_color_pt,            dt_agrupa_pdn.tono,   
         dt_agrupa_pdn.cs_estilocolortono,            dt_canasta_corte.co_talla,      dt_canasta_corte.co_calidad,   
         sum(dt_canasta_corte.ca_actual )  
    FROM h_canasta_corte,            dt_canasta_corte,            dt_agrupa_pdn  
   WHERE ( h_canasta_corte.cs_canasta = dt_canasta_corte.cs_canasta ) and  
         ( dt_canasta_corte.cs_agrupacion = dt_agrupa_pdn.cs_agrupacion ) and  
         ( dt_canasta_corte.cs_pdn = dt_agrupa_pdn.cs_pdn ) and  
         ( ( h_canasta_corte.cs_canasta > '0' ) AND  
         ( dt_canasta_corte.cs_orden_corte = :ll_cs_orden_corte ) AND  
         ( dt_canasta_corte.cs_secuencia = 1 ) AND  
         ( h_canasta_corte.co_estado >= 30 ) )   
GROUP BY dt_agrupa_pdn.co_fabrica_exp,            dt_agrupa_pdn.pedido,            dt_agrupa_pdn.cs_liberacion,   
         dt_agrupa_pdn.po,            dt_agrupa_pdn.co_fabrica_pt,            dt_agrupa_pdn.co_linea,   
         dt_agrupa_pdn.co_referencia,            dt_agrupa_pdn.co_color_pt,            dt_agrupa_pdn.tono,   
         dt_agrupa_pdn.cs_estilocolortono,            dt_canasta_corte.co_talla,   dt_canasta_corte.co_calidad  
ORDER BY dt_agrupa_pdn.co_fabrica_exp ASC,            dt_agrupa_pdn.pedido ASC,   dt_agrupa_pdn.cs_liberacion ASC,   
         dt_agrupa_pdn.po ASC,            dt_agrupa_pdn.co_fabrica_pt ASC,            dt_agrupa_pdn.co_linea ASC,   
         dt_agrupa_pdn.co_referencia ASC,            dt_agrupa_pdn.co_color_pt ASC,   dt_agrupa_pdn.tono ASC,   
         dt_agrupa_pdn.cs_estilocolortono ASC,       dt_canasta_corte.co_talla ASC,dt_canasta_corte.co_calidad ASC  
			USING itr_tela;
		if itr_tela.sqlcode=-1 then
			messagebox("error bd","declar cur_canasta")
			return
		else
		end if	
			
		open cur_canastas;
		if itr_tela.sqlcode=-1 then
			messagebox("error bd","open cur_canasta")
			return
		else
		end if	
		
		fetch cur_canastas into :li_co_fabrica_exp,:ll_pedido,            :li_cs_liberacion,   
         :ls_po,            :li_co_fabrica_pt,            :li_co_linea,            :ll_co_referencia,   
         :ll_co_color_pt,            :ls_tono,            :li_cs_estilocolortono,            :li_co_talla,   
         :li_co_calidad,            :ll_ca_actual ;
		if itr_tela.sqlcode=-1 then
			messagebox("error bd","fetch cur_canasta")
			return
		else
		end if	
			
		do while itr_tela.sqlcode=0
			
			//busca tono
			SELECT m_equi_tono.numero  
			 INTO :li_co_tono  
			 FROM m_equi_tono  
			WHERE ( m_equi_tono.numero > 0 ) AND  
					( m_equi_tono.co_tono = :ls_tono )   
					USING itr_tela;
			if itr_tela.sqlcode=-1 then
				messagebox("error bd","busca tono")
				return
			else
			end if
			
			//buscar en loteo
			SELECT sum(m_lotes_conf.ca_numerada )  
			 INTO :ll_ca_numerada  
			 FROM m_lotes_conf  
			WHERE ( m_lotes_conf.co_fabrica > 0 ) AND  
					( m_lotes_conf.co_fabrica_exp = :li_co_fabrica_exp ) AND  
					( m_lotes_conf.cs_pedido = :ll_pedido ) AND  
					( m_lotes_conf.cs_liberacion = :li_cs_liberacion ) AND  
					( m_lotes_conf.po = :ls_po ) AND  
					( m_lotes_conf.co_linea = :li_co_linea ) AND  
					( m_lotes_conf.co_referencia = :ll_co_referencia ) AND  
					( m_lotes_conf.co_color = :ll_co_color_pt ) AND  
					( m_lotes_conf.co_talla = :li_co_talla ) AND  
					( m_lotes_conf.co_calidad = :li_co_calidad ) AND  
					( m_lotes_conf.co_tono = :li_co_tono ) AND  
					( m_lotes_conf.cs_estilocolortono = :li_cs_estilocolortono ) and
					( m_lotes_conf.cs_ordencorte =:ll_cs_orden_corte ) 
					USING itr_tela;
			if itr_tela.sqlcode=-1 then
				messagebox("error bd","busca loteo")
				return
			else
			end if	
					
			//comparar
		
			if ll_ca_actual <> ll_ca_numerada then
				//problema
				INSERT INTO t_dif_lot  
					( cs_orden_corte, co_fabrica_exp,   pedido,   po,    cs_liberacion,   co_linea,   co_referencia,   
					  co_color_pt,     co_talla,   	  co_calidad,tono,  secuencia,     ca_canastas,   ca_loteo )  
		  VALUES ( :ll_cs_orden_corte,:li_co_fabrica_exp,:ll_pedido,:ls_po,:li_cs_liberacion,:li_co_linea,:ll_co_referencia,   
					  :ll_co_color_pt,:li_co_talla,:li_co_calidad,:ls_tono,:li_cs_estilocolortono,:ll_ca_actual,:ll_ca_numerada )  
					  USING itr_tela;
				if itr_tela.sqlcode=-1 then
					messagebox("error bd","insert t_dif_lot")
					return
				else
				end if	
			else
			end if

			
			fetch cur_canastas into :li_co_fabrica_exp,:ll_pedido,            :li_cs_liberacion,   
         :ls_po,            :li_co_fabrica_pt,            :li_co_linea,            :ll_co_referencia,   
         :ll_co_color_pt,            :ls_tono,            :li_cs_estilocolortono,            :li_co_talla,   
         :li_co_calidad,            :ll_ca_actual ;
			if itr_tela.sqlcode=-1 then
				messagebox("error bd","fetch cur_canasta")
				return
			else
			end if	
			
		loop
		
		close cur_canastas;
		if itr_tela.sqlcode=-1 then
			messagebox("error bd","cerrar cur_canasta")
			return
		else
		end if	
	
	fetch cur_liq into :ll_cs_orden_corte;
	if itr_tela.sqlcode=-1 then
		messagebox("error bd","fetch cur_liq")
		return
	else
	end if

loop

close cur_liq;
if itr_tela.sqlcode=-1 then
	messagebox("error bd","close cur_liq")
	return
else
end if	



end event

type st_1 from w_base_buscar_interactivo`st_1 within w_reprocesar_unidades_numeradas
end type

type sle_parametro1 from w_base_buscar_interactivo`sle_parametro1 within w_reprocesar_unidades_numeradas
end type

type gb_1 from w_base_buscar_interactivo`gb_1 within w_reprocesar_unidades_numeradas
end type

