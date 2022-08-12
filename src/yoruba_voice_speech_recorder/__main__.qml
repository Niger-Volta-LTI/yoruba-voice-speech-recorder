import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs
import QtMultimedia

Window {
    id: root
    visible: true
    width: 1440; height: 1080
    color: "#f5f5f6"
    title: qsTr("Yorùbá Voice Recorder")

    property bool recording: false
    property string promptsName: ''
    property string scriptText: ''
    property string scriptFilename: ''
    property string saveDir: '.'

    Component.onCompleted: initTimer.start()
    Timer {
        id: initTimer
        interval: 0
        onTriggered: recorder.init(scriptModel)
    }

    onRecordingChanged: recorder.toggleRecording(recording)
    onScriptFilenameChanged: scriptModel.get(scriptListView.currentIndex).filename = scriptFilename

    // called by python code on init for each listview item: self.window.appendScript({'script': script, 'filename': ''})
    function appendScript(data) {
        scriptModel.append(data)
    }

    function gotoNextScript() {
        scriptListView.incrementCurrentIndex();
        scriptListView.positionViewAtIndex(scriptListView.currentIndex, ListView.Center);
    }

    ListModel {
        id: scriptModel
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10

        Frame {
            Layout.fillHeight: true
            Layout.fillWidth: true
            focus: true

            ListView {
                id: scriptListView
                model: scriptModel
                anchors.fill: parent
                focus: true
                clip: true
                ScrollBar.vertical: ScrollBar { active: true; policy: ScrollBar.AlwaysOn }
                highlight: Rectangle { color: "lightsteelblue"; radius: 5 }
                spacing: 3

                onCurrentItemChanged: {
                    scriptText = model.get(currentIndex).script;
                    scriptFilename = model.get(currentIndex).filename;
                    console.log('selected: "' + scriptText + '", ' + scriptFilename);
                }

                delegate: Item {
                    width: 940  // fixed width elements, no longer a function of parent.width
                    height: 60
                    Column {
                        Text {
                            text: script                    // Item .script
                            font.pointSize: 22
                            color: filename == '' ? "black" : "green"
                            // anchors.verticalCenter: parent.verticalCenter // TODO IO this is broken
                        }
                        Text {
                            text: 'Filename: ' + filename   // Item .filename
                            font.pointSize: 18
                            color: filename == '' ? "red" : "black"
                            // font.bold: filename == '' ? false : true
                            // color: "#ffffff"
                        }
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: scriptListView.currentIndex = index
                    }
                }
            }



        }

            // ComboBox {
            //     editable: false
            //     model: ListModel {
            //         id: model
            //         ListElement { text: "Script set 1" }
            //         ListElement { text: "Script set 2" }
            //         ListElement { text: "Script set 3" }
            //     }
            // }

        RowLayout {

            // Fills the width of this row, pushing elements to the right
            Item {
                Layout.fillWidth: true
            }
            
            Button {
                Layout.preferredHeight: 45
                font.pointSize: 22
                text: "Load Prompts file"
                highlighted: promptsName != '' ? true : false
                onClicked: { fileDialog.visible = true }
            }

            TextArea {
                width: 100
                font.pointSize: 18
                readOnly: true
                text: promptsName
                verticalAlignment: TextField.AlignVCenter

            }

            // Separator between Prompt file && Speakername
            Item {
                width: 15
            }
            Text {
                text: 'Speaker Name:'
                font.pointSize: 18
                verticalAlignment: TextField.AlignVCenter
            }
            TextField {
                Layout.preferredHeight: 30
                font.pointSize: 18
                placeholderText: "Olúwadáminí"
                verticalAlignment: TextField.AlignVCenter
                background: Rectangle {
                        border.color: control.enabled ? "#21be2b" : "transparent"
                }
                onAccepted: {
                    console.log("Speaker Name is: " + text)
                    recorder.acceptSpeakerNameText(text)
                }
            }
        }

        TextArea {
            Layout.fillWidth: true
            font.pointSize: 26
            wrapMode: TextEdit.Wrap
            readOnly: true
            text: scriptText
            background: Rectangle {
                border.width: 5
                border.color: recording ? "#2b2" : "#b22"
            }
        }

        Button {
            Layout.fillWidth: true
            Layout.preferredHeight: 60
            font.pointSize: 22
            highlighted: recording
            text: recording ? "Stop" : "Start"
            onClicked: {
                recording = !recording;
                if (recording) {
                    recorder.startRecording();
                } else {
                    recorder.finishRecording();
                    gotoNextScript();   // local QML function
                }
            }
        }

        RowLayout {
            Button {
                Layout.fillWidth: true
                Layout.preferredHeight: 40
                font.pointSize: 22
                text: "Play"
                enabled: scriptFilename
                highlighted: playFile.playbackState == playFile.PlayingState
                onClicked: {
                    playFile.source = scriptFilename
                    playFile.play()
                }
                MediaPlayer {
                    id: playFile
                    source: ''
                    audioOutput: AudioOutput {}
                }
            }

            Button {
                Layout.fillWidth: true
                Layout.preferredHeight: 40
                font.pointSize: 22
                text: "Delete"
                enabled: scriptFilename
                onClicked: recorder.deleteFile(scriptFilename) // @Slot def deleteFile(self, filename)
            }

            Button {
                Layout.fillWidth: true
                Layout.preferredHeight: 40
                font.pointSize: 22
                text: recording ? "Cancel" : "Next"
                onClicked: {
                    if (recording) {
                        recording = !recording;
                    } else {
                        gotoNextScript()    // local QML function
                    }
                }
            }
        }
    }

    FileDialog {
        id: fileDialog
        title: "Please choose a file"
        selectedNameFilter.index: 0
        nameFilters: ["Prompt files (*.txt)", "Text files (*.txt)"]
     
        onAccepted: {
            recorder.read_file(fileDialog.currentFile)
        }
        onRejected: {
            console.log("Canceled")
        }
     }
}
