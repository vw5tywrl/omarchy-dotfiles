import QtQuick
import Quickshell
import Quickshell.Io
import qs.Commons
import qs.Ui

BarWidget {
  id: root
  moduleName: "loathe.capslock"

  property bool capsLockOn: false
  property string sysfsPath: ""

  visible: root.capsLockOn
  implicitWidth: button.implicitWidth
  implicitHeight: button.implicitHeight

  Process {
    id: discoverProc
    command: ["sh", "-c", "for f in /sys/class/leds/*::capslock/brightness; do [ -e \"$f\" ] && printf '%s' \"$f\" && break; done"]
    stdout: StdioCollector {
      waitForEnd: true
      onStreamFinished: {
        var found = String(text || "").trim()
        if (found !== "") {
          root.sysfsPath = found
          capsFile.reload()
        }
      }
    }
  }

  FileView {
    id: capsFile
    path: root.sysfsPath
    watchChanges: false
    printErrors: false
    onLoaded: {
      root.capsLockOn = String(text() || "").trim() === "1"
    }
  }

  Timer {
    interval: 500
    running: root.sysfsPath !== ""
    repeat: true
    onTriggered: capsFile.reload()
  }

  Component.onCompleted: discoverProc.running = true

  Component {
    id: xIcon
    Item {
      Rectangle {
        width: Style.space(10)
        height: Style.space(2)
        radius: height / 2
        anchors.centerIn: parent
        rotation: 45
        antialiasing: true
        color: "#ffffff"
      }
      Rectangle {
        width: Style.space(10)
        height: Style.space(2)
        radius: height / 2
        anchors.centerIn: parent
        rotation: -45
        antialiasing: true
        color: "#ffffff"
      }
    }
  }

  BarIconButton {
    id: button
    anchors.fill: parent
    bar: root.bar
    iconComponent: xIcon
    active: root.capsLockOn
    useActiveColor: false
    slotSize: Style.bar.statusSlot
    fontSize: Style.font.caption
    pressable: false
    tooltipText: "Caps Lock is ON"
  }
}
