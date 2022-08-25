HA$PBExportHeader$n_cst_importfile.sru
$PBExportComments$/***********************************************************  SA52689 - Ceiba/jjmonsal - 09-11-2015  Comentario:Import_file  ***********************************************************/
forward
global type n_cst_importfile from uo_dsbase
end type
end forward

global type n_cst_importfile from uo_dsbase
end type
global n_cst_importfile n_cst_importfile

forward prototypes
public function boolean of_importfile (ref uo_dsbase ads_param)
end prototypes

public function boolean of_importfile (ref uo_dsbase ads_param);String 	ls_docpath, ls_docname[],ls_error
Long	li_rtn

GetFileOpenName("Seleccione Archivo",ls_docpath, ls_docname, "TXT",  + "Archivos de Texto (*.TXT),*.TXT,"    + "Archivos dBase (*.DBF),*.DBF,"    + "Archivos CVS (*.CVS),*.CVS,"  + "Archivos XML (*.XML),*.XML,"     + "Todos (*.*), *.*",    "C:\micarpeta", 18)
li_rtn = ads_param.ImportFile(ls_docpath)
If  li_rtn > 0 then
    messagebox("Importado el archivo","Se importaron " + string(li_rtn) + " registros correctamente")
	 RETURN TRUE
Else
    CHOOSE CASE li_rtn
        case -1  
            ls_error = "No rows or startrow value supplied is greater than the number of rows in the file"
        case -2  
            ls_error = "Empty file"
        case -3  
            ls_error = "Invalid argument"
        case -4  
            ls_error = "Invalid input"
        case -5  
            ls_error = "Could not open the file"
        case -6  
            ls_error = "Could not close the file"
        case -7  
            ls_error = "Error reading the text"
        case -8  
            ls_error = "Unsupported file name suffix (must be *.txt, *.csv, *.dbf or *.xml)"
        case -10  
            ls_error = "Unsupported dBase file format (not version 2 or 3)"
        case -11  
            ls_error = "XML Parsing Error; XML parser libraries not found or XML not well formed"
        case -12  
            ls_error = "XML Template does not exist or does not match the DataWindow"
        case -13   
            ls_error = "Unsupported DataWindow style for import"
        case -14   
            ls_error = "Error resolving DataWindow nesting"
    End Choose
 
	Messagebox("Error Importado el archivo","No se pudo importar el archivo debido al siguiente error " + ls_error,stopsign!)
	RETURN FALSE
End If
end function

on n_cst_importfile.create
call super::create
end on

on n_cst_importfile.destroy
call super::destroy
end on

