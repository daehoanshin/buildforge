
CURRENT_DIRECTORY = WScript.Arguments(0)
DEV_HOST_IP = WScript.Arguments(1)
BIZ = WScript.Arguments(2)



'전역상수 선언
Const ForReading = 1, ForWriting = 2, ForAppending = 8
Const OverwriteIfExist = True

Const STR_XML_FILE_NAME = "deploy_list.xml" 'xml 파일명
      STR_BAT_FILE_NAME = "copy_TST_nxui_" & BIZ & "_static.sh"
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

  WebRootPath = "/webroot/"

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

    If (strPrjName="DINLE_UI_LIB") And (InStr(strFilePath, "DINLE_UI_LIB/dinle/nxui") = 1) Then

      Include_Name = Replace(strFilePath, strPrjName & "/", "")
      path = Replace(strFilePath, "DINLE_UI_LIB/dinle/nxui", "")
      Wscript.Echo "path=" & path

      'js 변환 체크
      converResult = nxuiFilterRuleConvert(path, strFileExtension, "dinle/nxui")
      If(converResult = "false") Then
        Include_Name = Include_Name & "/" & strFileName
      Else
        If(Right(strFileName, 3) = ".js") Then
          Include_Name = Include_Name & "/" & strFileName
        Else
          Include_Name = Include_Name & "/" & strFileName & ".js"
        End If
      End If

      '배포 금지 체크
      defenderResult = nxuiFilterRuleDefender(path, strFileExtension, "dinle/nxui")
      'BIZ에 맞는 도메인의 내역 찾기
      domainResult = nxuiFilterRuleDomainCheck(path, strFileExtension)

      If(defenderResult <> "false" And domainResult = true) Then
        FBatFile.WriteLine "echo " & " mkdir -p " & WebRootPath & Include_Name
        FBatFile.WriteLine " mkdir -p "& WebRootPath & Include_Name
        FBatFile.WriteLine  "echo " & " scp " & DEV_HOST_IP & ":" & """" & "'" & _
        WebRootPath & Include_Name & "'" & """ " & """" & WebRootPath & Include_Name & """"
        FBatFile.WriteLine " scp " & DEV_HOST_IP & ":" & """" & "'" & _
        WebRootPath & Include_Name & "'" & """ " & """" & WebRootPath & Include_Name & """"
      End If
    End If
  Next

  If(BIZ="TCM") Then
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

      'strFilePath = Replace(strFilePath, "DINLE_UI_LIB/dinle/nxui_src", "DINLE_UI_LIB/dinle/nxui")

      If (strPrjName="DINLE_UI_LIB") And InStr(strFilePath, "DINLE_UI_LIB/install_nexacro") = 1 Then

        Include_Name = Replace(strFilePath, strPrjName & "/", "")
        path = Replace(strFilePath, "DINLE_UI_LIB/install_nexacro", "")
        Wscript.Echo "path=" & path

        'js 변환 체크
        converResult = nxuiFilterRuleConvert(path, strFileExtension, "install_nexacro")
        If(converResult = "false") Then
          Include_Name = Include_Name & "/" & strFileName
        Else
          If(Right(strFileName, 3) = ".js") Then
            Include_Name = Include_Name & "/" & strFileName
          Else
            Include_Name = Include_Name & "/" & strFileName & ".js"
          End If
        End If
        FBatFile.WriteLine "echo " & " mkdir -p " & WebRootPath & Include_Name
        FBatFile.WriteLine " mkdir -p "& WebRootPath & Include_Name
        FBatFile.WriteLine  "echo " & " scp " & DEV_HOST_IP & ":" & """" & "'" & _
        WebRootPath & Include_Name & "'" & """ " & """" & WebRootPath & Include_Name & """"
        FBatFile.WriteLine " scp " & DEV_HOST_IP & ":" & """" & "'" & _
        WebRootPath & Include_Name & "'" & """ " & """" & WebRootPath & Include_Name & """"
      End If
    Next
  End If
  Set FBatFile = Nothing
End Sub

' nxui_filter_rule.xml을 로딩하여
' 배포 금지여부 체크
Function nxuiFilterRuleDefender(deployPath, deployExtension, repoUrl)
  strType = "defender"

  Set objDomDeployList = CreateObject("Microsoft.XMLDOM")
  objDomDeployList.Load(CURRENT_DIRECTORY & "\nxui_filter_rule.xml")

  Set Nodes = objDomDeployList.SelectNodes("//repository[@name='DINLE_UI_LIB/" & repoUrl & "'][@type='" & strType & "']")
  For Each repoNode in Nodes
    For Each childNode in repoNode.childNodes
      'nxui_filter_rule.xml의 <convert path= 값
      rulePath = childNode.Attributes.getNamedItem("path").Text
      'nxui_filter_rule.xml의 <convert extension= 값
      ruleExtension = childNode.Attributes.getNamedItem("extension").Text

      If(deployPath <> "" And rulePath <> "" And InStr(deployPath, rulePath) = 1 And (deployExtension = ruleExtension)) Then
        nxuiFilterRuleDefender = childNode.Attributes.getNamedItem("useDeploy").Text
      ElseIf(deployPath = "" And rulePath = "" And (deployExtension = ruleExtension)) Then
        nxuiFilterRuleDefender = childNode.Attributes.getNamedItem("useDeploy").Text
      ElseIf(InStr(deployPath, rulePath) = 1 And ruleExtension = "!JS" And deployExtension <> "JS") Then
        nxuiFilterRuleDefender = childNode.Attributes.getNamedItem("useDeploy").Text
      ElseIf(InStr(deployPath, rulePath) = 1 And ruleExtension = "*") Then
        nxuiFilterRuleDefender = childNode.Attributes.getNamedItem("useDeploy").Text
      ElseIf(ruleExtension = "JSP" And (deployExtension = ruleExtension)) Then
        nxuiFilterRuleDefender = childNode.Attributes.getNamedItem("useDeploy").Text
      End If
    Next
  Next

  Set Nodes = Nothing

End Function

' nxui_filter_rule.xml을 로딩하여
' 파일확장자에 js추가 변환여부 체크
Function nxuiFilterRuleConvert(deployPath, deployExtension, repoUrl)
  strType = "convert"
  Set objDomDeployList = CreateObject("Microsoft.XMLDOM")
  objDomDeployList.Load(CURRENT_DIRECTORY & "\nxui_filter_rule.xml")
  Set Nodes = objDomDeployList.SelectNodes("//repository[@name='DINLE_UI_LIB/" & repoUrl & "'][@type='" & strType & "']")
  For Each repoNode in Nodes
    For Each childNode in repoNode.childNodes
      'nxui_filter_rule.xml의 <convert path= 값
      rulePath = childNode.Attributes.getNamedItem("path").Text
      'nxui_filter_rule.xml의 <convert extension= 값
      ruleExtension = childNode.Attributes.getNamedItem("extension").Text
      If(deployPath <> "" And rulePath <> "" And InStr(deployPath, rulePath) = 1 And ruleExtension = "*") Then
        nxuiFilterRuleConvert = childNode.Attributes.getNamedItem("useConvert").Text
      ElseIf(InStr(deployPath, rulePath) = 1 And (deployExtension = ruleExtension) And ruleExtension="HTML" ) Then
        nxuiFilterRuleConvert = childNode.Attributes.getNamedItem("useConvert").Text
      ElseIf(deployPath = "" And rulePath = "" And (deployExtension = ruleExtension) And ruleExtension="HTML" ) Then
        nxuiFilterRuleConvert = childNode.Attributes.getNamedItem("useConvert").Text
      ElseIf(rulePath = "" And ruleExtension = "*") Then
        nxuiFilterRuleConvert = childNode.Attributes.getNamedItem("useConvert").Text
      End If
    Next
  Next

  Set Nodes = Nothing

End Function

' nxui_filter_rule.xml을 로딩하여
' BIZ의 업무 도메인에 맞는 내역 체크
Function nxuiFilterRuleDomainCheck(deployPath, deployExtension)
  strType = "pattern"
  Set objDomDeployList = CreateObject("Microsoft.XMLDOM")
  objDomDeployList.Load(CURRENT_DIRECTORY & "\nxui_filter_rule.xml")
  Set Nodes = objDomDeployList.SelectNodes("//domain[@name='" & BIZ & "'][@type='" & strType & "']")
  For Each repoNode in Nodes
    For Each childNode in repoNode.childNodes
      'nxui_filter_rule.xml의 <convert path= 값
      rulePath = childNode.Attributes.getNamedItem("path").Text
      'nxui_filter_rule.xml의 <convert extension= 값
      ruleExtension = childNode.Attributes.getNamedItem("extension").Text
      If(deployPath="" And rulePath="" And (deployExtension = ruleExtension)) Then
        nxuiFilterRuleDomainCheck = true
        Exit For
      ElseIf(deployPath <> "" And rulePath <> "" And InStr(deployPath, rulePath)=1) Then
        nxuiFilterRuleDomainCheck = true
        Exit For
      Else
        nxuiFilterRuleDomainCheck = false
      End If
    Next
  Next

  Set Nodes = Nothing

End Function
