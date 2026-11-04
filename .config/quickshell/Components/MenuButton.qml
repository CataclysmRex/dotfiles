import QtQuick
import QtQuick.Layouts
import "../"

Rectangle {
    id: root

    // Public API
    property string icon: ""
    property string label: ""
    property color textColor: Colors.foreground
    property color hoverColor: Colors.accent // Or Colors.hoverBackground

    readonly property color effectiveTextColor: {
        if (mouseArea.containsMouse && root.hoverColor === Colors.accent) {
            return Colors.popupBackground; // Or dark foreground color
        }
        return root.textColor;
    }

    signal clicked

    // Sizing
    Layout.fillWidth: true
    implicitHeight: 24
    radius: implicitHeight / 4

    // Dynamic hover background
    color: mouseArea.containsMouse ? root.hoverColor : "transparent"

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onClicked: root.clicked()
    }

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 8
        anchors.rightMargin: 8
        spacing: 12

        // Material Symbol icon
        Text {
            visible: root.icon !== ""
            text: root.icon
            color: root.effectiveTextColor
            font.family: "Material Symbols Rounded"
            font.pixelSize: 16
        }

        // Label
        Text {
            text: root.label
            color: root.effectiveTextColor
            Layout.fillWidth: true
            // Enable truncation when text exceeds available width
            elide: Text.ElideRight
            clip: true
            horizontalAlignment: Text.AlignLeft
        }
    }
}
