import QtQuick
import QtQuick.Layouts
import Quickshell

import "../"
import "../Items"

PanelWindow {
    id: barWindow
    required property var modelData
    screen: modelData

    margins {
        left: 20
        right: 20
        top: 8
    }

    // Position at the top of each monitor
    anchors {
        top: true
        left: true
        right: true
    }
    implicitHeight: 34

    color: Colors.background

    RowLayout {
        anchors.left: parent.left
        implicitHeight: parent.height
        Section {
            leftMargin: 8
            PowerButton {}
        }
        Section {
            Workspaces {}
        }
    }

    Section {
        anchors.centerIn: parent
        WindowTitle {}
    }

    RowLayout {
        anchors.right: parent.right

        implicitHeight: parent.height

        Section {
            Tray {}
        }

        Section {
            Audio {}
            Clock {}
        }
    }
}
