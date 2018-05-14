Sub Main()
  Set objDomDeployList = CreateObject("Microsoft.XMLDOM")
  objDomDeployList.Load("booksort.xml")

  Set colNodes = objDomDeployList.SelectNodes("//book[@genre='novel']")
  For Each objNode in colNodes
    Wscript.Echo objNode.Text
    WScript.Echo objNode.Attributes.getNamedItem("publicationdate").Text
  Next

  WScript.Echo "---------------------------------------------"

  Set NodeList = objDomDeployList.SelectNodes("bookstore/book/author/last-name")
  For i = 0 To NodeList.length - 1
    WScript.Echo NodeList(i).Text
  Next
End Sub

Call Main
