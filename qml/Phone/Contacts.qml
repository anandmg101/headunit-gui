import QtQuick 2.0
import QtContacts 5.0
import QtGraphicalEffects 1.0
import QtContacts 5.0
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

Item {
    id: __root
    property int contactCardHeight: 50
    signal dial(Contact contact)

    StackView{
        id:contactView
        anchors.fill: parent
        initialItem: browsingArea
    }
    Component {
        id:browsingArea
        Item {
            ContactModel {
                id: contactsModel
                manager: "memory"
                Component.onCompleted: {
                    contactsModel.importContacts("file:/home/gino/.config/viktorgino/viktorgino's HeadUnit Desktop/contacts/contacts.vcf")
                }
                sortOrders: [
                    SortOrder {
                        detail: ContactDetail.Name
                        field: Name.FirstName
                        direction: Qt.AscendingOrder
                    }
                ]
            }

            Component {
                id: contactDelegate

                Item {
                    id: delRect
                    width: parent.width
                    height: __root.contactCardHeight

                    MouseArea {
                        id: mouseArea
                        anchors.fill: parent
                        onClicked: {
                            //__root.dial(contact)
                            contactView.push(contactInfo,{"contact":contact})
                        }
                    }

                    Text {
                        color: "#ffffff"
                        anchors {
                            verticalCenter: parent.verticalCenter
                            left: imageWrapper.right
                            leftMargin: 6
                        }
                        text: contact.name.firstName + " " + contact.name.lastName
                        elide: Text.ElideRight
                        font.pointSize: parent.height * 0.2
                        font.family: "Times New Roman"
                        font.bold: true
                    }
                    Rectangle{
                        id: imageWrapper
                        width: height
                        radius: height/2
                        clip: true
                        anchors.top: parent.top
                        anchors.topMargin: 6
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: 6
                        anchors.left: parent.left
                        anchors.leftMargin: 6
                        color:"#00BCD4"


                        Item {
                            anchors.fill: parent
                            layer.enabled: true
                            layer.effect: OpacityMask {
                                maskSource: imageWrapper
                            }

                            Text {
                                x: -height/5
                                color: "#66ffffff"
                                text: contact.name.firstName.charAt(0).toUpperCase()
                                font.pixelSize: parent.height * 1.4
                                anchors.bottomMargin: 0
                                anchors.top: image.top
                                anchors.bottom: parent.bottom
                                anchors.topMargin: 0
                                font.bold: true
                                clip: true
                                verticalAlignment: Text.AlignVCenter
                                horizontalAlignment: Text.AlignLeft
                            }

                            Text {
                                x: height/4
                                color: "#4cffffff"
                                text: contact.name.lastName.charAt(0).toUpperCase()
                                font.pixelSize: parent.height * 1.4
                                anchors.bottom: parent.bottom
                                anchors.top: parent.top
                                font.bold: true
                                clip: true
                                verticalAlignment: Text.AlignVCenter
                                horizontalAlignment: Text.AlignRight
                            }

                            Image {
                                id: image
                                anchors.fill: parent
                                source: contact.avatar.imageUrl
                                fillMode: Image.PreserveAspectCrop
                            }
                        }

                    }

                }
            }

            ListView {
                id: contactsView
                anchors.fill: parent
                model: contactsModel
                focus: true
                clip: true
                delegate: contactDelegate
            }
        }
    }

    Component {
        id: contactInfo
        Item {
            id: contactInfoItem
            property Contact contact: Contact {

            }
            Rectangle {
                color:"#ffffff"
                anchors.fill: parent
            }

            Rectangle {
                id: contactDetails
                color:"#00BCD4"
                clip: true
                height: parent.height*0.5
                anchors.top: parent.top
                anchors.topMargin: 0
                anchors.right: parent.right
                anchors.rightMargin: 0
                anchors.left: parent.left
                anchors.leftMargin: 0
                Text {
                    x: -height/4
                    color: "#66ffffff"
                    text: contact.name.firstName.charAt(0).toUpperCase()
                    font.pixelSize: parent.height * 2
                    anchors.bottomMargin: 0
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.topMargin: 0
                    font.bold: true
                    clip: true
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignLeft
                }

                Text {
                    x: height/2
                    color: "#4cffffff"
                    text: contact.name.lastName.charAt(0).toUpperCase()
                    font.pixelSize: parent.height * 2
                    anchors.bottom: parent.bottom
                    anchors.top: parent.top
                    font.bold: true
                    clip: true
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignRight
                }
                Image {
                    id: image1
                    anchors.fill: parent
                    fillMode: Image.PreserveAspectCrop
                    source: contact.avatar.imageUrl
                }

                Text {
                    id: text1
                    color: "#ffffff"
                    text: contact.name.firstName + " " + contact.name.lastName
                    elide: Text.ElideLeft
                    font.pixelSize: parent.height * 0.1
                    anchors.leftMargin: parent.width * 0.05
                    anchors.bottomMargin: parent.height * 0.1
                    anchors.left: parent.left
                    anchors.bottom: parent.bottom
                }
            }

            ListView {
                clip: true
                anchors.top: contactDetails.bottom
                anchors.topMargin: 0
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 0
                anchors.left: parent.left
                anchors.leftMargin: 0
                anchors.right: parent.right
                anchors.rightMargin: 0
                model: contact.phoneNumbers
                delegate: Item{
                    height: 100
                    width: parent.width
                    Image {
                        id: image
                        width: height
                        anchors.leftMargin: 8
                        anchors.bottomMargin: 8
                        anchors.topMargin: 8
                        anchors.bottom: parent.bottom
                        anchors.left: parent.left
                        anchors.top: parent.top
                        source: "qrc:/qml/icons/svg/android-call.svg"
                    }

                    ColorOverlay {
                        anchors.fill: image
                        source: image
                        color: "#000000"
                    }

                    Item {
                        anchors.right: parent.right
                        anchors.rightMargin: 8
                        anchors.left: image.right
                        anchors.leftMargin: 8
                        anchors.top: parent.top
                        anchors.topMargin: 8
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: 8

                        Text {
                            id: number
                            height: parent.height/2
                            text: modelData.number
                            anchors.right: parent.right
                            anchors.left: parent.left
                            anchors.top: parent.top
                            font.pixelSize: parent.height * 0.4
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignLeft
                        }

                        Text {
                            id: type
                            text: {
                                switch(modelData.subTypes[0]){
                                case PhoneNumber.Mobile :
                                    return qsTr("Mobile")
                                case PhoneNumber.Unknown :
                                    return qsTr("Other")
                                case PhoneNumber.Landline :
                                    return qsTr("Landline")
                                case PhoneNumber.Fax :
                                    return qsTr("Fax")
                                }
                            }
                            anchors.topMargin: 0
                            anchors.bottom: parent.bottom
                            anchors.bottomMargin: 0
                            font.pixelSize: parent.height * 0.3
                            horizontalAlignment: Text.AlignLeft
                            anchors.right: parent.right
                            verticalAlignment: Text.AlignVCenter
                            anchors.top: number.bottom
                            anchors.left: parent.left
                        }
                    }

                    MouseArea {
                        id: mouseArea
                        anchors.fill: parent
                        onClicked: {
                            __root.dial(contact)
                        }
                    }
                }
            }

            Button {
                id: button
                x: 8
                y: 8
                text: qsTr("Back")
                anchors.top: parent.top
                anchors.topMargin: 8
                anchors.left: parent.left
                anchors.leftMargin: 8
                onClicked: {
                    contactView.pop()
                }
            }

        }
    }
}