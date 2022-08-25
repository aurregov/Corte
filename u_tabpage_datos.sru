HA$PBExportHeader$u_tabpage_datos.sru
forward
global type u_tabpage_datos from u_tabpage_base
end type
type dw_datos from uo_dw_base within u_tabpage_datos
end type
end forward

global type u_tabpage_datos from u_tabpage_base
integer width = 1824
integer height = 372
dw_datos dw_datos
end type
global u_tabpage_datos u_tabpage_datos

forward prototypes
public function integer of_resize_dw ()
public function integer of_resize ()
end prototypes

public function integer of_resize_dw ();dw_datos.SetRedraw(false)
dw_datos.Width = This.Width - 30
dw_datos.Height = This.Height - 30
dw_datos.SetRedraw(true)

Return 1
end function

public function integer of_resize ();This.of_resize_dw( )

Return 1
end function

on u_tabpage_datos.create
int iCurrent
call super::create
this.dw_datos=create dw_datos
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_datos
end on

on u_tabpage_datos.destroy
call super::destroy
destroy(this.dw_datos)
end on

event constructor;call super::constructor;This.of_resize_dw()
end event

type dw_datos from uo_dw_base within u_tabpage_datos
integer x = 27
integer y = 20
integer width = 1687
integer height = 316
integer taborder = 10
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event itemfocuschanged;call super::itemfocuschanged;String	ls_nombrecolumna, ls_tag, ls_describe

w_principal.SetMicroHelp('')

ls_nombrecolumna	=	This.GetColumnName()
ls_describe			=	This.Describe(ls_nombrecolumna+".tag")

ls_tag	=	Trim(ls_describe)

w_principal.SetMicroHelp(ls_tag)
end event

event itemchanged;call super::itemchanged;Long ll_retorno
ll_retorno = Parent.Event ue_itemchanged_dw(row,dwo,data,"dw_datos")

Return ll_retorno
end event

event buttonclicked;call super::buttonclicked;Long ll_retorno

ll_retorno = Parent.Event ue_buttonclicked_dw(row,actionreturncode,dwo,"dw_datos")


Return ll_retorno
end event

event clicked;call super::clicked;long ll_retorno

ll_retorno = Parent.Dynamic Event ue_clicked_dw(xpos,ypos,row,dwo,"dw_datos")

Return ll_retorno
end event

event doubleclicked;call super::doubleclicked;long ll_retorno

ll_retorno = Parent.Dynamic Event ue_doubleclicked_dw(xpos,ypos,row,dwo,"dw_datos")

Return ll_retorno
end event

