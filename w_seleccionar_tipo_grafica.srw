HA$PBExportHeader$w_seleccionar_tipo_grafica.srw
forward
global type w_seleccionar_tipo_grafica from Window
end type
type uo_1 from uo_seleccionar_tipo_grafica within w_seleccionar_tipo_grafica
end type
end forward

global type w_seleccionar_tipo_grafica from Window
int X=211
int Y=169
int Width=2231
int Height=1185
boolean TitleBar=true
string Title="Seleccione El Tipo de Gr$$HEX1$$e100$$ENDHEX$$fica"
long BackColor=79741120
boolean ControlMenu=true
ToolBarAlignment ToolBarAlignment=AlignAtLeft!
WindowType WindowType=response!
uo_1 uo_1
end type
global w_seleccionar_tipo_grafica w_seleccionar_tipo_grafica

type variables
graph igr_parm
datawindow idw_parm
object io_pasado
end variables

event open;// Recibe y recuerda en igr_parm o idw_parm, el
// objeto que ha sido pasado por la ventana que abrio esto

graphicobject lgro_vieja

lgro_vieja = message.powerobjectparm

If lgro_vieja.TypeOf() = Graph! Then
	io_pasado = Graph!
	igr_parm = message.powerobjectparm
Elseif lgro_vieja.TypeOf() = Datawindow! Then
	io_pasado = Datawindow!
	idw_parm = message.powerobjectparm
End If

end event

on w_seleccionar_tipo_grafica.create
this.uo_1=create uo_1
this.Control[]={ this.uo_1}
end on

on w_seleccionar_tipo_grafica.destroy
destroy(this.uo_1)
end on

type uo_1 from uo_seleccionar_tipo_grafica within w_seleccionar_tipo_grafica
int X=1
int Y=1
int TabOrder=2
boolean Border=false
BorderStyle BorderStyle=StyleBox!
long BackColor=79741120
end type

event tipografica_aceptar;call super::tipografica_aceptar;Long li_col,li_row, li_ret
string ls_graph_type

// Get the graph type from the graph gallery user object.
li_ret = uof_consultar_tipografica (li_row, li_col, ls_graph_type)
if li_ret = 0 then
	messagebox ("Sorry!","Clicked on invalid type")
	return
end if


If io_pasado = Graph! Then
	// The user clicked on a graph type. Set the type in the passed graph
	// object.
	Choose Case ls_graph_type
		case "area3d"
			igr_parm.graphtype = area3d!
		case "areagraph"
			igr_parm.graphtype = areagraph!
		case "bar3dobjgraph"
			igr_parm.graphtype = bar3dobjgraph!
		case "barstack3dobjgraph"
			igr_parm.graphtype = barstack3dobjgraph!
		case "bargraph"
			igr_parm.graphtype = bargraph!
		case "bar3dgraph"
			igr_parm.graphtype = bar3dgraph!
		case "barstackgraph"
			igr_parm.graphtype = barstackgraph!
		case "col3dgraph"
			igr_parm.graphtype = col3dgraph!
		case "col3dobjgraph"
			igr_parm.graphtype = col3dobjgraph!
		case "colgraph"
			igr_parm.graphtype = colgraph!
		case "colstack3dobjgraph"
			igr_parm.graphtype = colstack3dobjgraph!
		case "colstackgraph"
			igr_parm.graphtype = colstackgraph!
		case "line3d"
			igr_parm.graphtype = line3d!
		case "linegraph"
			igr_parm.graphtype = linegraph!
		case "pie3d"
			igr_parm.graphtype = pie3d!
		case "piegraph"
			igr_parm.graphtype = piegraph!
		case "scattergraph"
			igr_parm.graphtype = scattergraph!
		case else
			messagebox ("Error!", "Invalid Graph Type")
	end choose
Elseif io_pasado = Datawindow! Then
	// The user clicked on a graph type. Set the type in the passed 
	// datawindow object.
	Choose Case ls_graph_type
		case "area3d"
			idw_parm.Object.gr_1.graphtype = 15
		case "areagraph"
			idw_parm.Object.gr_1.graphtype = 1
		case "bar3dobjgraph"
			idw_parm.Object.gr_1.graphtype = 4
		case "barstack3dobjgraph"
			idw_parm.Object.gr_1.graphtype = 6
		case "bargraph"
			idw_parm.Object.gr_1.graphtype = 2
		case "bar3dgraph"
			idw_parm.Object.gr_1.graphtype = 3
		case "barstackgraph"
			idw_parm.Object.gr_1.graphtype = 5
			case "col3dgraph"
			idw_parm.Object.gr_1.graphtype = 8
		case "col3dobjgraph"
			idw_parm.Object.gr_1.graphtype = 9
		case "colgraph"
			idw_parm.Object.gr_1.graphtype = 7
		case "colstack3dobjgraph"
			idw_parm.Object.gr_1.graphtype = 11
		case "colstackgraph"
			idw_parm.Object.gr_1.graphtype = 10
		case "line3d"
			idw_parm.Object.gr_1.graphtype = 16
		case "linegraph"
			idw_parm.Object.gr_1.graphtype = 12
		case "pie3d"
			idw_parm.Object.gr_1.graphtype = 17
		case "piegraph"
			idw_parm.Object.gr_1.graphtype = 13
		case "scattergraph"
			idw_parm.Object.gr_1.graphtype = 14
		case else
			messagebox ("Error!", "Invalid Graph Type")
	end choose
End If
Close (parent)
end event

event tipografica_cancelar;call super::tipografica_cancelar;Close (parent)
end event

on uo_1.destroy
call uo_seleccionar_tipo_grafica::destroy
end on

