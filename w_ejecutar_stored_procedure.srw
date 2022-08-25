HA$PBExportHeader$w_ejecutar_stored_procedure.srw
forward
global type w_ejecutar_stored_procedure from Window
end type
type pb_2 from picturebutton within w_ejecutar_stored_procedure
end type
type pb_1 from picturebutton within w_ejecutar_stored_procedure
end type
end forward

global type w_ejecutar_stored_procedure from Window
int X=672
int Y=264
int Width=992
int Height=788
boolean TitleBar=true
string Title="Untitled"
long BackColor=79741120
boolean ControlMenu=true
boolean MinBox=true
boolean MaxBox=true
boolean Resizable=true
pb_2 pb_2
pb_1 pb_1
end type
global w_ejecutar_stored_procedure w_ejecutar_stored_procedure

on w_ejecutar_stored_procedure.create
this.pb_2=create pb_2
this.pb_1=create pb_1
this.Control[]={this.pb_2,&
this.pb_1}
end on

on w_ejecutar_stored_procedure.destroy
destroy(this.pb_2)
destroy(this.pb_1)
end on

event open;This.Width = 993
This.Height = 789
end event

type pb_2 from picturebutton within w_ejecutar_stored_procedure
int X=27
int Y=368
int Width=891
int Height=236
int TabOrder=2
string Text="Salir"
string PictureName="c:\graficos\cancelar.bmp"
Alignment HTextAlign=Right!
boolean Cancel=true
int TextSize=-8
int Weight=400
string FaceName="MS Sans Serif"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;Close(Parent)
end event

type pb_1 from picturebutton within w_ejecutar_stored_procedure
int X=27
int Y=52
int Width=891
int Height=236
int TabOrder=1
string Text="Ejecutar Stored Procedure"
string PictureName="c:\graficos\ok.bmp"
Alignment HTextAlign=Right!
boolean Default=true
int TextSize=-8
int Weight=400
string FaceName="MS Sans Serif"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;//**********************************************************************
//	LO PRIMERO ES DECLARAR LOGICAMENTE EL PROCEDIMIENTO DENTRO DEL SCRIPT,
//	ESTO LO QUE HACE ES DECIR CUAL ES EL NOMBRE CON QUE SE VA A TRABAJAR EL
//	PROCEDIMIENTO DENTRO DEL SCRIPT DE POWERBUILDER CON EL SCOOP 
//	CORRESPONDIENTE, LUEGO SE LE DICE ESE NOMBRE A QUE PROCEDIMIENTO DE 
//	INFORMIX VA A CORRESPONDER Y QUE PARAMETROS HAY QUE MANDARLE SI LOS 
//	NECESITA, SI NO UTILIZA PARAMETROS SE ABRE Y SE CIERRA EL PARENTESIS :
// 
//DECLARE nombre_logico_dentro_del_script PROCEDURE FOR
//	nombre_del_procedimiento_en_informix
//	({:parametro1, :parametro2 , ...})
//	{USING transaction_object}; 
//**********************************************************************

//**********************************************************************
//	LUEGO DE HABER DECLARADO EL PROCEDIMIENTO SE TIENE QUE EJECUTAR EN EL
//	LUGAR DONDE SE NECESITE, HACIENDO REFERENCIA A EL NOMBRE LOGICO :
//
//EXECUTE nombre_logico_dentro_del_script ;
//**********************************************************************

//**********************************************************************
// SI NECESITA CONSULTAR ALGUN REGISTRO DEL RESULTADO DEL PROCEDIMIENTO
//	SE PROCEDE COMO EN LOS CURSORES :
//
//FETCH nombre_logico_dentro_del_script INTO :variable1, :variable2,....;
//**********************************************************************

//**********************************************************************
//	AL FINAL, CUANDO YA SE HA EJECUTADO EL PROCEDIMIENTO, HAY QUE LIBERAR
//	MEMORIA EN EL SERVIDOR :
//	
//CLOSE emp_proc;
//**********************************************************************
end event

