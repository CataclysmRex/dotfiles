import QtQuick
import QtQuick.Layouts
import Quickshell
import QtQuick.Controls
import Quickshell.Services.Pipewire
import Quickshell.Widgets
import Quickshell.Hyprland
import Quickshell.Wayland
import Quickshell.Widgets

import "../"
import "../Popups"

RowLayout {
    id: root
    property var sink: Pipewire.defaultAudioSink

    property bool ready: sink && sink.ready

    property real volume: ready ? sink.audio.volume : 0

    property real muted: ready ? sink.audio.muted : 0

    Text {
        color: {
            if (muted)
                return Colors.active;
            return Colors.foreground;
        }

        Layout.alignment: Qt.AlignVCenter
        font {
            family: "Material Symbols Rounded"
            pixelSize: 20
        }

        text: {
            if (!ready)
                return "";

            if (!muted && root.volume > 0) {
                if (root.volume > 1) {
                    return "sound_detection_loud_sound";
                } else if (root.volume > 0.66) {
                    return "volume_up";
                } else if (root.volume > 0.33) {
                    return "volume_down";
                } else {
                    return "volume_mute";
                }
            }
            if (muted)
                return "volume_off";

            return iconName;
        }
    }

    Text {
        color: Colors.foreground

        // Display volume percentage or muted indicator
        text: ready ? (volume * 100).toFixed(0) + "%" : "not ready"
    }

    PwObjectTracker {
        objects: [root.sink]
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: popup.visible = !popup.visible
    }

    Mixer {
        id: popup
    }
}
