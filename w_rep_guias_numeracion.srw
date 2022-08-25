HA$PBExportHeader$w_rep_guias_numeracion.srw
forward
global type w_rep_guias_numeracion from w_preview_de_impresion
end type
end forward

global type w_rep_guias_numeracion from w_preview_de_impresion
integer width = 3456
string title = "Programaci$$HEX1$$f300$$ENDHEX$$n General Corte"
event guardar_como pbm_custom08
end type
global w_rep_guias_numeracion w_rep_guias_numeracion

event guardar_como;long	ll_filas

ll_filas = dw_reporte.RowCount()

IF ll_filas <=0 THEN
	MessageBox("Generar archivo","Error al generar el archivo",Exclamation!)
	Return
ELSE
	dw_reporte.SaveAs("",PSReport! ,false)
END IF

end event

on w_rep_guias_numeracion.create
call super::create
end on

on w_rep_guias_numeracion.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;DataStore lds_lista
n_cts_param lou_param
Long   ll_result,ll_trazo,ll_talla,ll_tllax,ll_pack,ll_const,ll_capa,&
       ll_inicio,ll_fin,ll_tzaux,ll_ctdtz,ll_finfd
Int    li_i,li_j
String ls_sqlerr


lds_lista = Create DataStore
lds_lista.DataObject = 'd_lista_para_crear_t_cruadro_trazo'
lds_lista.SetTransObject(Sqlca)


ii_ancho = dw_reporte.width 
ii_alto  = dw_reporte.height
ii_posx  = dw_reporte.x   
ii_posy  = dw_reporte.y 

dw_reporte.SetTransObject(Sqlca)

Open(w_parametro_corte)
 
lou_param = Message.PowerObjectParm

If IsValid(lou_param) Then
	
	ll_result = lds_lista.Retrieve(lou_param.il_vector[1])
	
	If ll_result > 0 Then	
		
		delete 
		  from t_cuadrotrazo
		 where orden = :lou_param.il_vector[1] ;
		 
		If Sqlca.SqlCode = -1 Then
			ls_sqlerr = Sqlca.SqlErrText
			rollback ;
			MessageBox("Advertencia!","No se pudo borrar la temporal para el reporte.~n~n~n" + ls_sqlerr)
			Return
		Else
			commit ;
		End If
			
		ll_ctdtz  = 0	
		ll_const  = 0
		ll_tllax  = -1
		ll_tzaux  = -1
		ll_inicio = 1
		
		For li_i = 1 To ll_result
			ll_trazo = lds_lista.GetItemNumber(li_i,'cs_trazo')
			ll_talla = lds_lista.GetItemNumber(li_i,'co_talla')
			ll_capa  = lds_lista.GetItemNumber(li_i,'capas')
			ll_pack  = lds_lista.GetItemNumber(li_i,'paquetes')
			
			If ll_talla <> ll_tllax Then
				ll_const = 0
				
				select max(final)  
              into :ll_finfd  
              from t_cuadrotrazo  
             where orden = :lou_param.il_vector[1] and
                   co_talla = :ll_talla   ;

				If Sqlca.SqlCode = -1 Then
					ls_sqlerr = Sqlca.SqlErrText
					Rollback ;
					MessageBox("Advertencia!","No se pudo buscar la cantidad final de la talla.~n~n~n" + ls_sqlerr)
					Return
				ElseIf IsNull(ll_finfd) Or ll_finfd = 0 Then
					ll_inicio = 1
					ll_fin    = ll_capa
				Else
					ll_inicio = ll_finfd + 1
					ll_fin    = ll_finfd + ll_capa
				End If
						
			Else
				ll_inicio = ll_fin + 1
				ll_fin    += ll_capa
			End If
			
			If ll_trazo <> ll_tzaux Then
				ll_ctdtz = 0
			End If
			
			ll_tzaux = ll_trazo
			ll_tllax = ll_talla
			
			For li_j = 1 To ll_pack
												
				ll_const ++
				ll_ctdtz ++
				
				insert into t_cuadrotrazo  
               ( orden,co_trazo,co_talla,cs_talla,paquete,inicio,final )  
            values ( :lou_param.il_vector[1],:ll_trazo,   
               :ll_talla,:ll_const,:ll_ctdtz,:ll_inicio,:ll_fin )  ;

				If Sqlca.SqlCode = -1 Then
					ls_sqlerr = Sqlca.SqlErrText
					Rollback ;
					MessageBox("Advertencia!","No se pudo insertar en la temporal para el reporte.~n~n~n" + ls_sqlerr)
					Return
				End If
				
				If li_j < ll_pack Then
					ll_inicio = ll_fin + 1 
					ll_fin    += ll_capa
				End If
			Next			
		Next		

		
		commit ;
		
		dw_reporte.Retrieve(lou_param.il_vector[1])
		
	End If
End If

Destroy lds_lista
end event

type dw_reporte from w_preview_de_impresion`dw_reporte within w_rep_guias_numeracion
integer x = 0
integer y = 8
integer width = 3397
string dataobject = "d_guias_de_numeracion"
end type

event dw_reporte::clicked;call super::clicked;

If Row <= 0 Then Return

This.SelectRow(0,False)
This.SelectRow(Row,True)

end event

