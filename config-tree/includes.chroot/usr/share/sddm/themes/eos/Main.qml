import QtQuick 2.0
import SddmComponents 2.0

Rectangle {
    id: root
    width: 1920; height: 1080
    color: "#1f3d22"
    property string userName: userModel.lastUser !== "" ? userModel.lastUser : "eos"

    TextConstants { id: textConstants }

    Connections {
        target: sddm
        onLoginFailed: { pw.text = ""; err.opacity = 1; pw.forceActiveFocus() }
    }

    Image {
        anchors.fill: parent
        source: "background.jpg"
        fillMode: Image.PreserveAspectCrop
    }
    Rectangle { anchors.fill: parent; color: "#66000000" }

    Text {
        id: clock
        anchors { top: parent.top; topMargin: 40; horizontalCenter: parent.horizontalCenter }
        color: "white"; font.pixelSize: 56; font.weight: Font.Light
        text: Qt.formatDateTime(new Date(), "HH:mm")
        Timer { interval: 1000; running: true; repeat: true; onTriggered: clock.text = Qt.formatDateTime(new Date(), "HH:mm") }
    }

    Column {
        anchors.centerIn: parent
        spacing: 16

        Rectangle {
            width: 128; height: 128; radius: 64
            anchors.horizontalCenter: parent.horizontalCenter
            color: "#1f4d23"; border.color: "#55af57"; border.width: 3
            Image { anchors.centerIn: parent; width: 80; height: 80; source: "logo.png"; smooth: true }
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: root.userName
            color: "white"; font.pixelSize: 26
        }

        Rectangle {
            width: 320; height: 46; radius: 23
            anchors.horizontalCenter: parent.horizontalCenter
            color: "#33ffffff"; border.color: "#aaffffff"; border.width: 1
            TextInput {
                id: pw
                anchors { fill: parent; leftMargin: 20; rightMargin: 20 }
                verticalAlignment: TextInput.AlignVCenter
                echoMode: TextInput.Password
                color: "white"; font.pixelSize: 18
                focus: true
                clip: true
                Keys.onReturnPressed: sddm.login(root.userName, pw.text, sessionModel.lastIndex)
                Keys.onEnterPressed: sddm.login(root.userName, pw.text, sessionModel.lastIndex)
            }
            Text {
                anchors { left: parent.left; leftMargin: 20; verticalCenter: parent.verticalCenter }
                visible: pw.text.length === 0
                text: textConstants.password
                color: "#bbffffff"; font.pixelSize: 18
            }
        }

        Text {
            id: err
            anchors.horizontalCenter: parent.horizontalCenter
            text: textConstants.loginFailed
            color: "#ffb4b4"; font.pixelSize: 15; opacity: 0
        }
    }

    Text {
        anchors { bottom: parent.bottom; bottomMargin: 36; left: parent.left; leftMargin: 40 }
        text: "E-OS · PME"; color: "#ccffffff"; font.pixelSize: 16
    }
    Row {
        anchors { bottom: parent.bottom; bottomMargin: 30; right: parent.right; rightMargin: 40 }
        spacing: 24
        Text { text: "⟳  " + textConstants.reboot; color: "white"; font.pixelSize: 16
               MouseArea { anchors.fill: parent; onClicked: sddm.reboot() } }
        Text { text: "⏻  " + textConstants.shutdown; color: "white"; font.pixelSize: 16
               MouseArea { anchors.fill: parent; onClicked: sddm.powerOff() } }
    }
}
