import QtQuick 2.0
import SddmComponents 2.0

Rectangle {
  id: root
  width: 640
  height: 480
  color: "#1a1b26"

  property string currentUser: userModel.lastUser
  property bool loginFailed: false
  property bool showPassword: false
  property int sessionIndex: {
    for (var i = 0; i < sessionModel.rowCount(); i++) {
      var name = (sessionModel.data(sessionModel.index(i, 0), Qt.DisplayRole) || "").toString()
      if (name.indexOf("uwsm") !== -1)
        return i
    }
    return sessionModel.lastIndex
  }

  Connections {
    target: sddm
    function onLoginFailed() {
      root.loginFailed = true
      root.showPassword = false
      password.text = ""
      password.focus = true
    }
    function onLoginSucceeded() {
      root.loginFailed = false
      root.showPassword = false
    }
  }

  Column {
    anchors.centerIn: parent
    spacing: 40

    Image {
      id: logo
      source: "logo.png"
      width: Math.min(sourceSize.width, root.width * 0.8)
      height: sourceSize.width > 0 ? Math.round(width * sourceSize.height / sourceSize.width) : 0
      fillMode: Image.PreserveAspectFit
      anchors.horizontalCenter: parent.horizontalCenter
    }

    Row {
      anchors.horizontalCenter: parent.horizontalCenter
      spacing: 15

      Image {
        source: root.loginFailed ? "lock-failed.png" : "lock.png"
        width: 34
        height: 38
        fillMode: Image.PreserveAspectFit
        anchors.verticalCenter: parent.verticalCenter
      }

      Item {
        width: entry.width
        height: entry.height

        Image {
          id: entry
          source: root.loginFailed ? "entry-failed.png" : "entry.png"
          anchors.centerIn: parent
        }

        // Cool white X Caps Lock indicator on the left edge of the entry field
        Item {
          id: capsIndicator
          width: 12
          height: 12
          anchors.left: parent.left
          anchors.leftMargin: 12
          anchors.verticalCenter: parent.verticalCenter
          visible: typeof keyboard !== "undefined" && keyboard !== null && keyboard.capsLock

          Rectangle {
            width: 12
            height: 2
            radius: 1
            anchors.centerIn: parent
            rotation: 45
            antialiasing: true
            color: "#ffffff"
          }

          Rectangle {
            width: 12
            height: 2
            radius: 1
            anchors.centerIn: parent
            rotation: -45
            antialiasing: true
            color: "#ffffff"
          }
        }

        Row {
          anchors.left: parent.left
          anchors.leftMargin: capsIndicator.visible ? 32 : 20
          anchors.verticalCenter: parent.verticalCenter
          spacing: 5
          visible: !root.showPassword

          Repeater {
            model: Math.min(password.text.length, 21)

            Image {
              source: "bullet.png"
              width: 7
              height: 7
            }
          }
        }

        TextInput {
          id: password
          anchors.fill: parent
          anchors.leftMargin: capsIndicator.visible ? 32 : 20
          anchors.rightMargin: eyeButton.visible ? 38 : 20
          verticalAlignment: TextInput.AlignVCenter
          clip: true
          echoMode: root.showPassword ? TextInput.Normal : TextInput.Password
          font.family: "JetBrainsMono Nerd Font"
          font.pixelSize: root.showPassword ? 16 : 24
          font.letterSpacing: root.showPassword ? 1 : 5
          passwordCharacter: "\u2022"
          color: root.showPassword ? "#ffffff" : "transparent"
          selectionColor: "transparent"
          selectedTextColor: root.showPassword ? "#ffffff" : "transparent"
          cursorDelegate: Item {}
          focus: true

          onTextChanged: {
            root.loginFailed = false
            if (text.length === 0) root.showPassword = false
          }

          Keys.onPressed: {
            if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
              root.showPassword = false
              sddm.login(root.currentUser, password.text, root.sessionIndex)
              event.accepted = true
            }
          }
        }

        // View Password eye toggle button on the right edge of the entry field
        Item {
          id: eyeButton
          width: 28
          height: parent.height
          anchors.right: parent.right
          anchors.rightMargin: 8
          anchors.verticalCenter: parent.verticalCenter
          visible: password.text.length > 0 || root.showPassword

          Text {
            anchors.centerIn: parent
            text: root.showPassword ? "󰈈" : "󰈉"
            color: root.showPassword || eyeMouse.containsMouse ? "#ffffff" : "#9aa5ce"
            font.family: "JetBrainsMono Nerd Font"
            font.pixelSize: 16
          }

          MouseArea {
            id: eyeMouse
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: {
              root.showPassword = !root.showPassword
              password.forceActiveFocus()
            }
          }
        }
      }
    }

  }

  Component.onCompleted: password.forceActiveFocus()
}
