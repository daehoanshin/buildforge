Set fso = CreateObject("Scripting.FileSystemObject")
xmlfile = "D:\vbDev\ga-workspace\test\attribute.xml"

Set xml = WScript.CreateObject("Msxml2.DOMDocument")
Set xsl = WScript.CreateObject("Msxml2.DOMDocument")

txt = Replace(fso.OpenTextFile(xmlfile).ReadAll, "><", ">" & vbCrLf & "<")
stylesheet = "<xsl:stylesheet version=""1.0"" xmlns:xsl=""http://www.w3.org/1999/XSL/Transform"">" & _
  "<xsl:output method=""xml"" indent=""yes""/>" & _
  "<xsl:template match=""/"">" & _
  "<xsl:copy-of select="".""/>" & _
  "</xsl:template>" & _
  "</xsl:stylesheet>"

xsl.loadXML stylesheet
xml.loadXML txt

If xml.parseError Then
  WScript.Echo xml.parseError.reason
  WScript.Quit 1
End If

xml.transformNode xsl

xml.Save xmlFile
