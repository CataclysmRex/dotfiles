import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Pipewire
import "../"
import "../Components"

BasePopup {
    id: root

    // Reactive PipeWire state bindings
    property var sink: Pipewire.defaultAudioSink
    property var source: Pipewire.defaultAudioSource

    property bool sinkReady: sink && sink.ready
    property bool sourceReady: source && source.ready

    // Collapsible list toggles
    property bool showSinkDevices: false
    property bool showSourceDevices: false

    // Filter PipeWire nodes into Sinks and Sources
    readonly property var sinksList: {
        var nodes = Pipewire.nodes.values;
        var list = [];
        for (var i = 0; i < nodes.length; i++) {
            if (nodes[i].isSink && !nodes[i].isStream && nodes[i].audio) {
                list.push(nodes[i]);
            }
        }
        return list;
    }

    readonly property var sourcesList: {
        var nodes = Pipewire.nodes.values;
        var list = [];
        for (var i = 0; i < nodes.length; i++) {
            if (!nodes[i].isSink && !nodes[i].isStream && nodes[i].audio) {
                list.push(nodes[i]);
            }
        }
        return list;
    }

    ColumnLayout {
        spacing: 12
        Layout.preferredWidth: 300

        // ==========================================
        // 1. OUTPUT (SINK) SECTION
        // ==========================================
        ColumnLayout {
            spacing: 6
            Layout.fillWidth: true

            // Header & Toggle
            RowLayout {
                Layout.fillWidth: true

                Text {
                    text: "OUTPUT"
                    color: Colors.foreground
                    font.pixelSize: 11
                    font.bold: true
                    opacity: 0.6
                }

                Item {
                    Layout.fillWidth: true
                }

                // Expand/Collapse Device List Button
                Rectangle {
                    implicitWidth: 20
                    implicitHeight: 20
                    radius: 4
                    color: sinkMouse.containsMouse ? Colors.hoverBackground : "transparent"

                    MouseArea {
                        id: sinkMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.showSinkDevices = !root.showSinkDevices
                    }

                    Text {
                        anchors.centerIn: parent
                        text: root.showSinkDevices ? "expand_less" : "expand_more"
                        color: Colors.foreground
                        font.family: "Material Symbols Rounded"
                        font.pixelSize: 16
                    }
                }
            }

            // Volume Controls Row
            RowLayout {
                spacing: 8
                Layout.fillWidth: true

                // Mute Toggle Button
                Rectangle {
                    implicitWidth: 28
                    implicitHeight: 28
                    radius: 6
                    color: muteSinkMouse.containsMouse ? Colors.hoverBackground : "transparent"

                    MouseArea {
                        id: muteSinkMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            if (root.sinkReady) {
                                root.sink.audio.muted = !root.sink.audio.muted;
                            }
                        }
                    }

                    Text {
                        anchors.centerIn: parent
                        text: {
                            if (!root.sinkReady || root.sink.audio.muted)
                                return "volume_off";
                            if (root.sink.audio.volume > 0.66)
                                return "volume_up";
                            if (root.sink.audio.volume > 0.33)
                                return "volume_down";
                            return "volume_mute";
                        }
                        color: (root.sinkReady && root.sink.audio.muted) ? Colors.active : Colors.foreground
                        font.family: "Material Symbols Rounded"
                        font.pixelSize: 18
                    }
                }

                // Volume Slider (Interactive MouseArea)
                Rectangle {
                    id: sinkTrack
                    Layout.fillWidth: true
                    implicitHeight: 6
                    radius: 3
                    color: Colors.hoverBackground

                    Rectangle {
                        width: sinkTrack.width * (root.sinkReady ? root.sink.audio.volume : 0)
                        height: parent.height
                        radius: parent.radius
                        color: Colors.accent
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor

                        function updateVolume(mouse) {
                            if (!root.sinkReady)
                                return;
                            var newVol = Math.max(0, Math.min(1, mouse.x / sinkTrack.width));
                            root.sink.audio.volume = newVol;
                        }

                        onClicked: mouse => updateVolume(mouse)
                        onPositionChanged: mouse => {
                            if (pressed)
                                updateVolume(mouse);
                        }
                    }
                }

                // Percentage Indicator
                Text {
                    text: root.sinkReady ? Math.round(root.sink.audio.volume * 100) + "%" : "0%"
                    color: Colors.foreground
                    font.pixelSize: 12
                    Layout.preferredWidth: 32
                    horizontalAlignment: Text.AlignRight
                }
            }

            // Expanded Sinks Device List
            ColumnLayout {
                visible: root.showSinkDevices
                spacing: 2
                Layout.fillWidth: true

                Repeater {
                    model: root.sinksList

                    MenuButton {
                        required property var modelData

                        // Display checkmark if node matches default sink ID
                        icon: (root.sinkReady && modelData.id === root.sink.id) ? "check" : "speaker"
                        label: modelData.description || modelData.name || "Output Device"
                        textColor: (root.sinkReady && modelData.id === root.sink.id) ? Colors.accent : Colors.foreground

                        onClicked: {
                            Pipewire.preferredDefaultAudioSink = modelData;
                        }
                    }
                }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            implicitHeight: 1
            color: Colors.hoverBackground
            opacity: 0.5
        }

        // ==========================================
        // 2. INPUT (SOURCE) SECTION
        // ==========================================
        ColumnLayout {
            spacing: 6
            Layout.fillWidth: true

            // Header & Toggle
            RowLayout {
                Layout.fillWidth: true

                Text {
                    text: "INPUT"
                    color: Colors.foreground
                    font.pixelSize: 11
                    font.bold: true
                    opacity: 0.6
                }

                Item {
                    Layout.fillWidth: true
                }

                Rectangle {
                    implicitWidth: 20
                    implicitHeight: 20
                    radius: 4
                    color: sourceMouse.containsMouse ? Colors.hoverBackground : "transparent"

                    MouseArea {
                        id: sourceMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.showSourceDevices = !root.showSourceDevices
                    }

                    Text {
                        anchors.centerIn: parent
                        text: root.showSourceDevices ? "expand_less" : "expand_more"
                        color: Colors.foreground
                        font.family: "Material Symbols Rounded"
                        font.pixelSize: 16
                    }
                }
            }

            // Volume Controls Row
            RowLayout {
                spacing: 8
                Layout.fillWidth: true

                Rectangle {
                    implicitWidth: 28
                    implicitHeight: 28
                    radius: 6
                    color: muteSourceMouse.containsMouse ? Colors.hoverBackground : "transparent"

                    MouseArea {
                        id: muteSourceMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            if (root.sourceReady) {
                                root.source.audio.muted = !root.source.audio.muted;
                            }
                        }
                    }

                    Text {
                        anchors.centerIn: parent
                        text: (root.sourceReady && root.source.audio.muted) ? "mic_off" : "mic"
                        color: (root.sourceReady && root.source.audio.muted) ? Colors.active : Colors.foreground
                        font.family: "Material Symbols Rounded"
                        font.pixelSize: 18
                    }
                }

                // Volume Slider
                Rectangle {
                    id: sourceTrack
                    Layout.fillWidth: true
                    implicitHeight: 6
                    radius: 3
                    color: Colors.hoverBackground

                    Rectangle {
                        width: sourceTrack.width * (root.sourceReady ? root.source.audio.volume : 0)
                        height: parent.height
                        radius: parent.radius
                        color: Colors.accent
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor

                        function updateVolume(mouse) {
                            if (!root.sourceReady)
                                return;
                            var newVol = Math.max(0, Math.min(1, mouse.x / sourceTrack.width));
                            root.source.audio.volume = newVol;
                        }

                        onClicked: mouse => updateVolume(mouse)
                        onPositionChanged: mouse => {
                            if (pressed)
                                updateVolume(mouse);
                        }
                    }
                }

                // Percentage Indicator
                Text {
                    text: root.sourceReady ? Math.round(root.source.audio.volume * 100) + "%" : "0%"
                    color: Colors.foreground
                    font.pixelSize: 12
                    Layout.preferredWidth: 32
                    horizontalAlignment: Text.AlignRight
                }
            }

            // Expanded Sources Device List
            ColumnLayout {
                visible: root.showSourceDevices
                spacing: 2
                Layout.fillWidth: true

                Repeater {
                    model: root.sourcesList

                    MenuButton {
                        required property var modelData

                        icon: (root.sourceReady && modelData.id === root.source.id) ? "check" : "mic"
                        label: modelData.description || modelData.name || "Input Device"
                        textColor: (root.sourceReady && modelData.id === root.source.id) ? Colors.accent : Colors.foreground

                        onClicked: {
                            Pipewire.preferredDefaultAudioSource = modelData;
                        }
                    }
                }
            }
        }
    }

    // Live PipeWire object state tracking
    PwObjectTracker {
        objects: [root.sink, root.source]
    }
}
