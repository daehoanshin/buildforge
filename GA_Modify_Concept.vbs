BIZ = WScript.Arguments(X)

If BIZ="ACT" Then
  'ROOT Path 변경.
  '/dinle/nxui_src/act/*.js
ElseIf BIZ="ATS" Then
  'ROOT Path 변경.
  '/dinle/nxui_src/ats/*.js
ElseIf BIZ="CUS" Then
  'ROOT Path 변경.
  '/dinle/nxui_src/cus/*.js
ElseIf BIZ="GNI" Then
  'ROOT Path 변경.
  '/dinle/nxui_src/gni/*.js
ElseIf BIZ="LTI" Then
  'ROOT Path 변경.
  '/dinle/nxui_src/lti/*.js
ElseIf BIZ="MTI" Then
  'ROOT Path 변경.
  '/dinle/nxui_src/mti/*.js
ElseIf BIZ="ONC" Then
  'ROOT Path 변경.
  '/dinle/nxui_src/onc/*.js
ElseIf BIZ="PDF" Then
  'ROOT Path 변경.
  '/dinle/nxui_src/pdf/*.js
ElseIf BIZ="SAL" Then
  'ROOT Path 변경.
  '/dinle/nxui_src/sal/*.js
ElseIf BIZ="STA" Then
  'ROOT Path 변경.
  '/dinle/nxui_src/sta/*.js
ElseIf BIZ="TCM" Then
  'ROOT Path 변경.
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
  'ROOT Path 변경.
  '/dinle/nxui_src/uwt/*.js
End if

Function Deploy (Param1 subDirctory, Param2 deploytarget_list)
{
  CMD = Configuration deploy command;
  Return CMD;
}
