
CURRENT_DIRECTORY = WScript.Arguments(0)
WORKSPACE = WScript.Arguments(1)
BIZ = WScript.Arguments(2)



'전역상수 선언
Const ForReading = 1, ForWriting = 2, ForAppending = 8
Const OverwriteIfExist = True

Const STR_XML_FILE_NAME = "deploy_list.xml" 'xml 파일명
      STR_BAT_FILE_NAME = "copy_nxui_" & BIZ & "_build_command.bat"
Const STR_FILE_END_TAG = "</File>"

Const STR_PRJ_START_TAG = "<Project>"
Const STR_PRJ_END_TAG = "</Project>"
Const STR_PATH_START_TAG = "<Path>"
Const STR_PATH_END_TAG = "</Path>"
Const STR_NAME_START_TAG = "<Name>"
Const STR_NAME_END_TAG = "</Name>"
Const STR_EXTENSION_START_TAG = "<Extension>"
Const STR_EXTENSION_END_TAG = "</Extension>"


'전연변수 선언
Dim glbStrUserXmlFile 'xml 파일명 (Full Path 포함)
Dim glbStrUserBatFile '결과 파일명 (Full path 포함)
Dim glbStrUserCurPath 'xml, Batch 파일이 존재하는 경로

'변수 선언
Dim FSO
Dim FCurDir

Set FSO = CreateObject("Scripting.FileSystemObject")
Set list = CreateObject("System.Collections.ArrayList")
'전역변수 정의
glbStrUserCurPath = Trim(CURRENT_DIRECTORY) '입력받은 xml, Batch 파일 경로
glbStrUserBatFile = glbStrUserCurPath

'현재 실행되는 위치 및 저장할 파일명등을 설정한다.
If Right(glbStrUserCurPath, 1) = "\" Then
  glbStrUserXmlFile = glbStrUserCurPath & STR_XML_FILE_NAME 'xml 파일위치
  glbStrUserBatFile = glbStrUserCurPath & STR_BAT_FILE_NAME '결과물(BatchFile) 파일위치
Else
  glbStrUserXmlFile = glbStrUserCurPath & "\" & STR_XML_FILE_NAME
  glbStrUserBatFile = glbStrUserCurPath & "\" & STR_BAT_FILE_NAME
End If

'원하는 결과 파일을 만든다.
Call subMakeDirFile
'Call nxuiFilter ("strPrjName", "strFilePath", "strFileName", "strFileExtension")
'프로그램 종료 처리
Set FCurDir = Nothing
Set FSO = Nothing

WScript.Quit

Sub subMakeDirFile

  '*******************************************************
  'xml 파일을 읽어 파일의 Full Path를 특정 파일에 저장한다.
  '*******************************************************
  Dim FxmlFile 'xml 파일
  Dim FBatFile '경로를 저장하는 Batch 파일
  Dim strXmlBuf 'xml 파일 전체를 저장하는 버퍼
  Dim strArrayXml 'xml 파일을 라인별로 저장하는 배열
  Dim strCmpTag 'Compile 성공 여부 판별
  Dim strPrjName 'WEB 프로젝트인지 판별
  Dim strFilePath 'Batch 파일에 입력되는 경로
  Dim strFileName 'Batch 파일에 입력되는 파일명
  Dim iStartPoint '태그시작 문자열의 위치
  Dim iEndPoint '태그끝 문자열의 위치

  Dim Fileset_Path 'FileSet Path
  Dim Include_Name 'Include Name

  Set FxmlFile = FSO.OpenTextFile(glbStrUserXmlFile, ForReading)

  '====<< xml 파일 전체를 읽어 배열로 변환 시킨다.
  strXmlBuf = FxmlFile.ReadAll
  FxmlFile.Close
  Set FxmlFile = Nothing

  Set FBatFile = FSO.CreateTextFile(glbStrUserBatFile, OverwriteIfExist)
  strArrayXml = Split(strXmlBuf, STR_FILE_END_TAG) '읽어온 파일을 배열로 저장한다.
  strXmlBuf = "" '읽어온 화일을 저장한 임시 메모리를 Clear 시킨다.


  For i = 0 To UBound(strArrayXml) - 1

    'Project를 구한다.
    iStartPoint = InStr(strArrayXml(i), STR_PRJ_START_TAG)
    iEndPoint = InStr(strArrayXml(i), STR_PRJ_END_TAG)
    strPrjName = Trim(Mid(strArrayXml(i), iStartPoint + Len(STR_PRJ_START_TAG), iEndPoint-iStartPoint-Len(STR_PRJ_START_TAG)))

    'Path를 구한다.
    iStartPoint = InStr(strArrayXml(i), STR_PATH_START_TAG)
    iEndPoint = InStr(strArrayXml(i), STR_PATH_END_TAG)
    strFilePath = Trim(Mid(strArrayXml(i), iStartPoint + Len(STR_PATH_START_TAG), iEndPoint-iStartPoint-Len(STR_PATH_START_TAG)))

    '파일명을 구한다.
    iStartPoint = InStr(strArrayXml(i), STR_NAME_START_TAG)
    iEndPoint = InStr(strArrayXml(i), STR_NAME_END_TAG)
    strFileName = Trim(Mid(strArrayXml(i), iStartPoint + Len(STR_NAME_START_TAG), iEndPoint-iStartPoint-Len(STR_NAME_START_TAG)))

    '확장자를 구한다.
    iStartPoint = InStr(strArrayXml(i), STR_EXTENSION_START_TAG)
    iEndPoint = InStr(strArrayXml(i), STR_EXTENSION_END_TAG)
    strFileExtension = Trim(Mid(strArrayXml(i), iStartPoint + Len(STR_EXTENSION_START_TAG), iEndPoint-iStartPoint-Len(STR_EXTENSION_START_TAG)))

    strFilePath = Replace(strFilePath, "DINLE_UI_LIB/dinle/nxui_src", "DINLE_UI_LIB/dinle/nxui")

    If (strPrjName="DINLE_UI_LIB") And InStr(strFilePath, "DINLE_UI_LIB/dinle/nxui") = 1 Then
      Include_Name = Replace(strFilePath, strPrjName & "/", "")
      path = Replace(strFilePath, "DINLE_UI_LIB/dinle/nxui", "")
      if(i = UBound(strArrayXml)-1) Then
        val = path & "/" & strFileName & "." & strFileExtension
      Else
        val = path & "/" & strFileName & "." & strFileExtension & ", "
      End If
      'WScript.Echo "val=" & val
      list.add val
      'list.add ","
    End If
  Next
  'list.removeat list.count-1
  FBatFile.WriteLine " generator -o -a -f (""" & Join(list.toarray) & """)"
  Set FBatFile = Nothing
End Sub
