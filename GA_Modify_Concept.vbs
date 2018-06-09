BIZ = WScript.Arguments(X)

If BIZ="ACT" Then
  '/dinle/nxui_src/act/*.js
ElseIf BIZ="ATS" Then
  '/dinle/nxui_src/ats/*.js
ElseIf BIZ="CUS" Then
  '/dinle/nxui_src/cus/*.js
ElseIf BIZ="GNI" Then
  '/dinle/nxui_src/gni/*.js
ElseIf BIZ="LTI" Then
  '/dinle/nxui_src/lti/*.js
ElseIf BIZ="MTI" Then
  '/dinle/nxui_src/mti/*.js
ElseIf BIZ="ONC" Then
  '/dinle/nxui_src/onc/*.js
ElseIf BIZ="PDF" Then
  '/dinle/nxui_src/pdf/*.js
ElseIf BIZ="SAL" Then
  '/dinle/nxui_src/sal/*.js
ElseIf BIZ="STA" Then
  '/dinle/nxui_src/sta/*.js
ElseIf BIZ="TCM" Then
  '/dinle/nxui_src/*.html
  '/dinle/nxui_src/*.js
  '/dinle/nxui_src/*.json
  '/dinle/nxui_src/_theme_/*.js
  '/dinle/nxui_src/_theme_/*.png
  '/dinle/nxui_src/bizComm/*.js
  '/dinle/nxui_src/comm/*.js
  '/dinle/nxui_src/css/*.js
  '/dinle/nxui_src/font/*.css
  '/dinle/nxui_src/font/*.ttf
  '/dinle/nxui_src/frame/*.js
  '/dinle/nxui_src/guide/*.js
  '/dinle/nxui_src/images/*.png
  '/dinle/nxui_src/images/*.gif
  '/dinle/nxui_src/images/*.jpg
  '/dinle/nxui_src/images/*.jpeg
  '/dinle/nxui_src/lib/*.js
  '/dinle/nxui_src/main/*.js
  '/dinle/nxui_src/nexacro14lib/*.js
  '/dinle/nxui_src/sample/*.js
  '/dinle/nxui_src/template/*.js
  '/dinle/nxui_src/template/*.gif
  '/dinle/nxui_src/web/*.js
  '/dinle/nxui_src/web/*.html
ElseIf BIZ="UWT" Then
  '/dinle/nxui_src/uwt/*.js
End if

Function Deploy (Param1 subDirctory, Param2 deploytarget_list)
{
  CMD = ""
  For Each ext In deploytarget_list
    CMD = CMD & "\n" Configuration deploy command;
  Next

  Return CMD;
}
