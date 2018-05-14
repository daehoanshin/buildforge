Set xmlDoc = _
  CreateObject("Microsoft.XMLDOM")

xmlDoc.Async = "False"
xmlDoc.Load("hardware.xml")

Set colNodes=xmlDoc.selectNodes("//HARDWARE/COMPUTER[@os='Windows XP']")

For Each objNode in colNodes
  Wscript.Echo objNode.Text
  Wscript.Echo objNode.Attributes. _
      getNamedItem("department").Text
Next
