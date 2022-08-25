HA$PBExportHeader$w_opciones_impresion_oc.srw
forward
global type w_opciones_impresion_oc from w_opciones_impresion
end type
end forward

global type w_opciones_impresion_oc from w_opciones_impresion
string title = "Imprimir OC..."
end type
global w_opciones_impresion_oc w_opciones_impresion_oc

type variables
Long il_page_sesgo, il_pagecount, il_ordencorte
Datawindow idw_raya_sesgo
end variables

on w_opciones_impresion_oc.create
call super::create
end on

on w_opciones_impresion_oc.destroy
call super::destroy
end on

event open;// Se omite el script del Ancestro
/*
	FACL - 2020/01/30 -  SA59815 - Se crea ventana para imprimir la OC
*/

string s
int i  
environment env
s_base_parametros lstr_parametro

if GetEnvironment(env) = 1 then
	this.x=(PixelsToUnits(env.ScreenWidth, XPixelsToUnits!) - this.Width)/2
	this.y=(PixelsToUnits(env.ScreenHeight, YPixelsToUnits!) - this.height)/2
end if

lstr_parametro = message.PowerObjectParm

If lstr_parametro.hay_parametros Then
	dwc_toprint = lstr_parametro.any[1]
	idw_raya_sesgo = lstr_parametro.any[2]
	il_ordencorte = lstr_parametro.entero[1]
End If
rb_currentpage.enabled = False //Upper(dwc_toprint.describe("DataWindow.Print.Preview")) = Upper("Yes")

//s=ProfileString("win.ini","Windows","device", "Impresora por defecto,,")
//st_impresora.text = Left(s,Pos(s,",")-1)+" en "+ right(s,Len(s)-Pos(s,",",Pos(s,",")+1))

st_impresora.text = dwc_toprint.describe('datawindow.printer')

if Long(dwc_toprint.describe("DataWindow.Print.Copies"))=0 then
	dwc_toprint.Modify("DataWindow.Print.Copies=1")
end if
cbx_archivo.Checked = dwc_toprint.describe("DataWindow.Print.FileName") <> ""
cbx_intercalar.Checked = (dwc_toprint.describe("DataWindow.Print.Collate") = "yes")
cbx_intercalar.TriggerEvent(Clicked!)
s = dwc_toprint.describe("DataWindow.Print.Page.Range") 
/*
if s = "" then
	rb_paginas.Checked=False
	rb_todo.Checked=True
else
	rb_todo.Checked=False
	rb_paginas.Checked=True
end if
*/
rb_todo.Checked=False
rb_paginas.Checked=False
ddlb_imp_solo.Enabled = False

sle_paginas.text=dwc_toprint.describe("DataWindow.Print.Page.Range")
i=Long(dwc_toprint.describe("DataWindow.Print.Page.RangeInclude"))
CHOOSE CASE i
	CASE 0
		ddlb_imp_solo.text = "El intervalo"
	CASE 1
		ddlb_imp_solo.text = "P$$HEX1$$e100$$ENDHEX$$ginas pares"
	CASE 2
		ddlb_imp_solo.text = "P$$HEX1$$e100$$ENDHEX$$ginas impares"
END CHOOSE
em_copias.text = dwc_toprint.describe("DataWindow.Print.Copies")

end event

type pb_cancelar from w_opciones_impresion`pb_cancelar within w_opciones_impresion_oc
end type

type pb_aceptar from w_opciones_impresion`pb_aceptar within w_opciones_impresion_oc
end type

event pb_aceptar::clicked;/*
	FACL - 2020/01/30 -  SA59815 - Se imprime la OC a doble cara y los sesgos en una sola cara
*/

int li_valor, li_ret
string ls_fullfilename, ls_filename
Long ll_pagecount, ll_pagecount_sesgo, ll_page_sesgo, ll_printJob

if cbx_archivo.checked then
	if dwc_toprint.describe("DataWindow.Print.Filename") = "" then
		li_Valor= GetFileSaveName("Imprimir a un archivo", ls_fullfilename, ls_filename ,"PRN", "Archivos de impresi$$HEX1$$f300$$ENDHEX$$n, *.PRN, Todos los archivos, *.*")
		IF li_Valor = 1 THEN
			dwc_toprint.Modify("DataWindow.Print.Filename='"+ls_filename+"'")
		END IF
	end if
	if dwc_toprint.describe("DataWindow.Print.Filename") <> "" then
		Hide(Parent)
		dwc_toprint.Print()
		dwc_toprint.Modify("DataWindow.Print.Page.Range=''")		
		Close(Parent)
	end if
else
	dwc_toprint.Modify("DataWindow.Print.Filename=''")
	Hide(Parent)
	
	If  ddlb_1.Text =  'OC Completa' Then
		dwc_toprint.Print()
	// FACL - 2020/09/04 - SA61085 - Reporte Orden Corte - Impresion x Paginas 
	ElseIf  ddlb_1.Text =  'P$$HEX1$$e100$$ENDHEX$$ginas' Then		
		dwc_toprint.Print()
	Else 
		
		ll_pagecount = Long(dwc_toprint.Describe("Evaluate('pagecount()', 1)"))
		
		If idw_raya_sesgo.RowCount() = 0 Then
			ll_pagecount_sesgo = 0
			ll_page_sesgo = ll_pagecount + 1
		Else
			ll_pagecount_sesgo = Long(idw_raya_sesgo.Describe("Evaluate('pagecount()', 1)"))
			ll_page_sesgo = ll_pagecount + 1 - ll_pagecount_sesgo
		End If
		
		ll_printJob = PrintOpen('OC_' + String(il_ordencorte) )
		
		dwc_toprint.Modify("Datawindow.Print.OverridePrintJob=yes")
		dwc_toprint.Modify("DataWindow.Print.Duplex = '3'")
		dwc_toprint.Modify("Datawindow.Print.Page.Range='1-" + String(ll_page_sesgo - 1) + "'"   )
		
		li_ret = PrintDatawindow(ll_printJob, dwc_toprint ) 
		
		
		If ll_page_sesgo <= ll_pagecount Then
			dwc_toprint.Modify("DataWindow.Print.Duplex = '1'")
			dwc_toprint.Modify("Datawindow.Print.Page.Range='" + String(ll_page_sesgo) + "-"+String(ll_pagecount) + "'"   )
		
			li_ret = PrintDatawindow(ll_printJob, dwc_toprint ) 
		End If
		
		li_ret = PrintClose(ll_printJob)
	End If
	
	dwc_toprint.Modify("DataWindow.Print.Page.Range=''")
	Close(Parent)
end if



end event

type ddlb_1 from w_opciones_impresion`ddlb_1 within w_opciones_impresion_oc
boolean visible = true
integer y = 556
string text = "OC doble cara/Sesgo Una Cara"
boolean allowedit = true
string item[] = {"OC doble cara/Sesgo Una Cara","P$$HEX1$$e100$$ENDHEX$$ginas"}
end type

event ddlb_1::selectionchanged;call super::selectionchanged;
Choose Case index
	Case 1
		rb_paginas.Enabled = False
		sle_paginas.Enabled = False
		ddlb_imp_solo.Enabled = False
	Case 2
		rb_paginas.Enabled = True
		sle_paginas.Enabled = True
		ddlb_imp_solo.Enabled = True
		
End Choose
end event

type st_1 from w_opciones_impresion`st_1 within w_opciones_impresion_oc
boolean visible = true
integer y = 564
end type

type st_donde from w_opciones_impresion`st_donde within w_opciones_impresion_oc
end type

type st_comentarios from w_opciones_impresion`st_comentarios within w_opciones_impresion_oc
end type

type st_t_comentarios from w_opciones_impresion`st_t_comentarios within w_opciones_impresion_oc
end type

type st_t_donde from w_opciones_impresion`st_t_donde within w_opciones_impresion_oc
end type

type st_tipo from w_opciones_impresion`st_tipo within w_opciones_impresion_oc
end type

type st_t_tipo from w_opciones_impresion`st_t_tipo within w_opciones_impresion_oc
end type

type st_estado from w_opciones_impresion`st_estado within w_opciones_impresion_oc
end type

type st_t_estado from w_opciones_impresion`st_t_estado within w_opciones_impresion_oc
end type

type p_si_inter from w_opciones_impresion`p_si_inter within w_opciones_impresion_oc
end type

type st_impresora from w_opciones_impresion`st_impresora within w_opciones_impresion_oc
end type

type cbx_intercalar from w_opciones_impresion`cbx_intercalar within w_opciones_impresion_oc
end type

type ddlb_imp_solo from w_opciones_impresion`ddlb_imp_solo within w_opciones_impresion_oc
boolean enabled = false
end type

type st_imp_solo from w_opciones_impresion`st_imp_solo within w_opciones_impresion_oc
end type

type st_explicacion from w_opciones_impresion`st_explicacion within w_opciones_impresion_oc
integer y = 976
end type

type sle_paginas from w_opciones_impresion`sle_paginas within w_opciones_impresion_oc
integer y = 868
boolean enabled = false
end type

type rb_paginas from w_opciones_impresion`rb_paginas within w_opciones_impresion_oc
integer y = 876
boolean enabled = false
end type

type rb_currentpage from w_opciones_impresion`rb_currentpage within w_opciones_impresion_oc
integer y = 796
boolean enabled = false
end type

type st_copias from w_opciones_impresion`st_copias within w_opciones_impresion_oc
end type

type st_t_impresora from w_opciones_impresion`st_t_impresora within w_opciones_impresion_oc
end type

type rb_seleccion from w_opciones_impresion`rb_seleccion within w_opciones_impresion_oc
integer y = 792
end type

type rb_todo from w_opciones_impresion`rb_todo within w_opciones_impresion_oc
integer y = 716
boolean enabled = false
end type

type em_copias from w_opciones_impresion`em_copias within w_opciones_impresion_oc
end type

type cbx_archivo from w_opciones_impresion`cbx_archivo within w_opciones_impresion_oc
end type

type p_no_inter from w_opciones_impresion`p_no_inter within w_opciones_impresion_oc
end type

type cb_impresora from w_opciones_impresion`cb_impresora within w_opciones_impresion_oc
end type

type gb_impresora from w_opciones_impresion`gb_impresora within w_opciones_impresion_oc
end type

type gb_intervalo from w_opciones_impresion`gb_intervalo within w_opciones_impresion_oc
integer y = 644
end type

type gb_copias from w_opciones_impresion`gb_copias within w_opciones_impresion_oc
end type

