import QtQuick
import QtQuick.Effects
import Quickshell.Io
import qs.Commons
import qs.Ui

Item {
  id: root

  property string backgroundPath: ""
  property int backgroundVersion: 0
  property bool fingerprintConfigured: false
  property bool authenticatingPassword: false
  property string failureMessage: ""
  property int failedAttempts: 0
  property bool inputEnabled: true
  property bool loadBackground: true
  property string passwordText: ""
  property bool syncingPasswordText: false
  property bool showPassword: false
  property bool capsLockOn: false
  property string capsSysfsPath: ""

  readonly property string placeholderText: "Enter Password"
  readonly property int fieldWidth: 381
  readonly property int fieldHeight: 67
  readonly property int outlineThickness: 3
  readonly property int fieldFontSize: Math.round(Style.font.heading * 1.125)
  readonly property int passwordDotFontSize: Math.round(Style.font.heading * 1.33)
  readonly property int passwordDotLetterSpacing: Math.round(Style.font.heading * 0.19)
  readonly property bool showEyeButton: passwordInput.text.length > 0 || showPassword
  // Space to keep clear on each side of the field for the side indicators/buttons
  // so the centered dots/text never run under them.
  readonly property real rightSideWidth: (fingerprintConfigured ? Math.round(fingerprintIcon.implicitWidth + 12) : 0)
    + (showEyeButton ? Math.round(eyeButton.width + 12) : 0)
  readonly property real leftSideWidth: capsLockOn ? Math.round(capsDot.width + 16) : 0
  readonly property real sideReserve: Math.max(rightSideWidth, leftSideWidth)
  // Shrink the dots/text to fit once the password outgrows the field, so every
  // keystroke stays visible — otherwise long passwords clip with no feedback.
  readonly property real passwordDotScale: dotMetrics.advanceWidth > 0
    ? Math.min(1, (passwordInput.width - 4) / dotMetrics.advanceWidth)
    : 1
  readonly property bool showPasswordCursor: inputEnabled && !authenticatingPassword && failureMessage.length === 0
  readonly property bool errorState: failureMessage.length > 0
  readonly property var inputBorderSpec: errorState
    ? Border.surfaceSpec("lock", "border-error", Color.lock.borderError, root.outlineThickness, "border-alpha")
    : Border.surfaceSpec("lock", "border-active", Color.lock.borderActive, root.outlineThickness, "border-alpha")

  signal submitPassword(string password)
  signal passwordTextEdited(string password)
  signal clearFailureRequested()
  signal wakeRequested()

  // Cache-busts the lock background by appending `?v=`. Adding a query
  // string keeps Image's loader happy while forcing it to reload when the
  // user picks a new background mid-session.
  function fileUrl(path) {
    if (!path) return ""
    var encoded = String(path).split("/").map(encodeURIComponent).join("/")
    return "file://" + encoded + "?v=" + backgroundVersion
  }

  function forcePasswordFocus() {
    passwordInput.forceActiveFocus()
  }

  function clearPassword() {
    showPassword = false
    passwordTextEdited("")
  }

  function syncPasswordText() {
    if (passwordText.length === 0) showPassword = false
    if (passwordInput.text === passwordText) return
    syncingPasswordText = true
    passwordInput.text = passwordText
    syncingPasswordText = false
  }

  onPasswordTextChanged: syncPasswordText()
  onInputEnabledChanged: {
    showPassword = false
    if (inputEnabled) {
      if (capsSysfsPath !== "") capsFile.reload()
      Qt.callLater(forcePasswordFocus)
    }
  }
  Component.onCompleted: {
    discoverCapsProc.running = true
    syncPasswordText()
    if (inputEnabled) Qt.callLater(forcePasswordFocus)
  }

  Process {
    id: discoverCapsProc
    command: ["sh", "-c", "for f in /sys/class/leds/*::capslock/brightness; do [ -e \"$f\" ] && printf '%s' \"$f\" && break; done"]
    stdout: StdioCollector {
      waitForEnd: true
      onStreamFinished: {
        var found = String(text || "").trim()
        if (found !== "") {
          root.capsSysfsPath = found
          capsFile.reload()
        }
      }
    }
  }

  FileView {
    id: capsFile
    path: root.capsSysfsPath
    watchChanges: false
    printErrors: false
    onLoaded: {
      root.capsLockOn = String(text() || "").trim() === "1"
    }
  }

  Timer {
    interval: 150
    running: root.capsSysfsPath !== "" && (root.loadBackground || root.inputEnabled)
    repeat: true
    onTriggered: capsFile.reload()
  }

  // Measures the password at full size; passwordDotScale compares this
  // against the field width to decide how far the dots/text must shrink to fit.
  TextMetrics {
    id: dotMetrics
    font.family: Style.font.family
    font.pixelSize: root.showPassword ? root.fieldFontSize : root.passwordDotFontSize
    font.letterSpacing: root.showPassword ? 0 : root.passwordDotLetterSpacing
    text: root.showPassword ? passwordInput.text : "●".repeat(passwordInput.text.length)
  }

  Rectangle {
    anchors.fill: parent
    color: Color.background

    Image {
      id: wallpaper
      anchors.fill: parent
      source: root.loadBackground ? root.fileUrl(root.backgroundPath) : ""
      fillMode: Image.PreserveAspectCrop
      asynchronous: true
      cache: false
      sourceSize.width: width
      sourceSize.height: height
    }

    MultiEffect {
      anchors.fill: wallpaper
      source: wallpaper
      autoPaddingEnabled: false
      blurEnabled: root.loadBackground && wallpaper.status === Image.Ready
      blur: 1.0
      blurMax: 128
      blurMultiplier: 1.25
      contrast: -0.08
    }

    MouseArea {
      anchors.fill: parent
      hoverEnabled: true
      onClicked: { root.wakeRequested(); root.forcePasswordFocus() }
      onPositionChanged: root.wakeRequested()
    }

    BorderSurface {
      id: inputField
      width: root.fieldWidth
      height: root.fieldHeight
      anchors.centerIn: parent
      color: Color.lock.background
      borderSpec: root.inputBorderSpec
      radius: Style.cornerRadius
      clip: true

      // Cool white X Caps Lock indicator on the left edge of the password box
      Item {
        id: capsDot
        objectName: "capsLockIndicator"
        width: 14
        height: 14
        anchors.left: parent.left
        anchors.leftMargin: inputField.borderLeft + 18
        anchors.verticalCenter: parent.verticalCenter
        visible: root.capsLockOn

        Rectangle {
          width: 14
          height: 2.5
          radius: 1.25
          anchors.centerIn: parent
          rotation: 45
          antialiasing: true
          color: "#ffffff"
        }

        Rectangle {
          width: 14
          height: 2.5
          radius: 1.25
          anchors.centerIn: parent
          rotation: -45
          antialiasing: true
          color: "#ffffff"
        }
      }

      TextInput {
        id: passwordInput
        anchors.fill: parent
        anchors.topMargin: inputField.borderTop
        // Reserve equal width on both sides so the centered dots/text stay
        // symmetric and never slide under the side indicators as they grow.
        anchors.rightMargin: inputField.borderRight + 18 + root.sideReserve
        anchors.bottomMargin: inputField.borderBottom
        anchors.leftMargin: inputField.borderLeft + 18 + root.sideReserve
        verticalAlignment: TextInput.AlignVCenter
        horizontalAlignment: TextInput.AlignHCenter
        activeFocusOnPress: true
        clip: true
        enabled: root.inputEnabled && !root.authenticatingPassword
        readOnly: root.authenticatingPassword
        echoMode: root.showPassword ? TextInput.Normal : TextInput.Password
        passwordCharacter: "\u25CF"
        passwordMaskDelay: 0
        color: Color.lock.text
        selectionColor: Color.lock.selection
        selectedTextColor: Color.lock.text
        font.family: Style.font.family
        font.pixelSize: text.length > 0
          ? Math.max(1, Math.floor((root.showPassword ? root.fieldFontSize : root.passwordDotFontSize) * root.passwordDotScale))
          : root.fieldFontSize
        font.letterSpacing: text.length > 0 && !root.showPassword
          ? root.passwordDotLetterSpacing * root.passwordDotScale
          : 0
        cursorVisible: activeFocus && root.showPasswordCursor && text.length > 0
        cursorDelegate: Rectangle {
          width: 2
          color: Color.lock.text
          visible: passwordInput.cursorVisible
        }

        onTextChanged: {
          if (text.length === 0) root.showPassword = false
          if (!root.syncingPasswordText) root.passwordTextEdited(text)
          if (text.length > 0) {
            root.wakeRequested()
          }
          if (text.length > 0 && root.failureMessage.length > 0) root.clearFailureRequested()
        }

        onAccepted: {
          var submitted = root.passwordText
          root.showPassword = false
          root.passwordTextEdited("")
          if (submitted.length > 0) root.submitPassword(submitted)
        }

        Keys.onPressed: function(event) {
          root.wakeRequested()
          if (event.key === Qt.Key_CapsLock && root.capsSysfsPath !== "") {
            capsFile.reload()
          }
          if (event.key === Qt.Key_Escape || (event.modifiers & Qt.ControlModifier && event.key === Qt.Key_U)) {
            root.showPassword = false
            root.passwordTextEdited("")
            event.accepted = true
          }
        }

        Keys.onReleased: function(event) {
          if (event.key === Qt.Key_CapsLock && root.capsSysfsPath !== "") {
            capsFile.reload()
          }
        }
      }

      Text {
        textFormat: Text.PlainText
        anchors.fill: passwordInput
        text: root.authenticatingPassword ? "Checking…" : (root.failureMessage.length > 0 ? root.failureMessage : root.placeholderText)
        visible: passwordInput.text.length === 0
        color: root.authenticatingPassword ? Color.lock.text : (root.failureMessage.length > 0 ? Color.lock.textError : Color.lock.placeholder)
        font.family: Style.font.family
        font.pixelSize: root.fieldFontSize
        font.italic: !root.authenticatingPassword && root.failureMessage.length > 0
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
      }

      // View Password eye toggle button pinned inside the field's right edge
      Item {
        id: eyeButton
        objectName: "viewPasswordButton"
        width: Math.max(eyeIcon.implicitWidth + 8, 28)
        height: parent.height - inputField.borderTop - inputField.borderBottom
        anchors.right: fingerprintIcon.visible ? fingerprintIcon.left : parent.right
        anchors.rightMargin: fingerprintIcon.visible ? 10 : (inputField.borderRight + 14)
        anchors.verticalCenter: parent.verticalCenter
        visible: root.showEyeButton

        Text {
          id: eyeIcon
          anchors.centerIn: parent
          text: root.showPassword ? "󰈈" : "󰈉"
          color: root.showPassword || eyeMouse.containsMouse ? Color.lock.text : Color.lock.placeholder
          font.family: Style.font.family
          font.pixelSize: Math.round(root.fieldFontSize * 1.05)
          horizontalAlignment: Text.AlignHCenter
          verticalAlignment: Text.AlignVCenter
        }

        MouseArea {
          id: eyeMouse
          anchors.fill: parent
          hoverEnabled: true
          cursorShape: Qt.PointingHandCursor
          onClicked: {
            root.wakeRequested()
            root.showPassword = !root.showPassword
            root.forcePasswordFocus()
          }
        }
      }

      // Fingerprint hint pinned inside the field's right edge when a sensor is
      // enrolled, so the user knows they can touch to unlock instead of typing.
      // Matches hyprlock, which draws its fingerprint icon in the same spot.
      Text {
        id: fingerprintIcon
        objectName: "fingerprintIndicator"
        anchors.right: parent.right
        anchors.rightMargin: inputField.borderRight + 18
        anchors.verticalCenter: parent.verticalCenter
        visible: root.fingerprintConfigured
        text: "󰈷"
        color: Color.lock.placeholder
        font.family: Style.font.family
        font.pixelSize: Math.round(root.fieldFontSize * 1.1)
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
      }
    }
  }
}
