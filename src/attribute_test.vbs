Set objDom = WScript.CreateObject("Msxml2.DOMDocument.3.0")
Set objRoot = objDom.createElement("entry")
Set objAttrib = objDom.createAttribute("xmlns")
objAttrib.text = "http://www.w3.org/2005/Atom1"
objRoot.setAttributeNode objAttrib
objDom.appendChild(objRoot)

Set objTitle = objDom.createElement("title")
Set objAttrib = objDom.createAttribute("type")
objAttrib.text = "text"
objTitle.setAttributeNode objAttrib
objRoot.appendChild objTitle

Set objUpdated = objDom.createElement("updated")
objUpdated.text = Date()
objRoot.appendChild objUpdated
Set objChild = objDom.createElement("author")
objRoot.appendChild objChild

Set objId = objDom.createElement("id")
objId.text = "data:,none"
objRoot.appendChild objId

Set objSummary = objDom.createElement("summary")
Set objAttrib = objDom.createAttribute("type")
objAttrib.text = "text"
objSummary.setAttributeNode objAttrib
objSummary.text = "Contact"
objRoot.appendChild objSummary

Dim content
Set content = objDom.createElement("content")
Set objAttrib = objDom.createAttribute("type")
objAttrib.text = "application/vnd.ctct+xml"
content.setAttributeNode objAttrib
objRoot.appendChild content

Dim contact
Set contact = objDom.createElement("contact")
Set objAttrib = objDom.createAttribute("xmlns")
objAttrib.text = "http://ws.constantcontact.com/ns/1.0/"
contact.setAttributeNode objAttrib
content.appendChild contact


Dim contactinfo
Set contactinfo = objDom.createElement("EmailAddress")
contactinfo.text = "abc@yahoo.com"
contact.appendChild contactinfo

Set contactinfo = objDom.createElement("Name")
contactinfo.text = "John Smith"
contact.appendChild contactinfo

Set contactinfo = objDom.createElement("OptInSource")
contactinfo.text = "ACTION_BY_CUSTOMER"
contact.appendChild contactinfo

Dim ContactLists
Set ContactLists = objDom.createElement("ContactLists")
contact.appendChild ContactLists

Dim ContactList
Set ContactList = objDom.createElement("ContactList")
Set objAttrib = objDom.createAttribute("id")
objAttrib.text = "https://api.constantcontact.com/ws/customers/" & UN & "/lists/5"
ContactList.setAttributeNode objAttrib
ContactLists.appendChild ContactList

objDom.Save("attribute.xml")
