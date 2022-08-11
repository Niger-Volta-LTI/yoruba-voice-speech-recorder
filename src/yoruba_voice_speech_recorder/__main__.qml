import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts
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
        anchors.margins: 6

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

                onCurrentItemChanged: {
                    scriptText = model.get(currentIndex).script;
                    scriptFilename = model.get(currentIndex).filename;
                    console.log('selected: "' + scriptText + '", ' + scriptFilename);
                }

                delegate: Item {
                    width: parent.width * 2/3
                    height: 60
                    Column {
                        Text {
                            text: script                    // Item .script
                            font.pointSize: 20
                            // color: "#ffffff"


                        }
                        Text {
                            text: 'Filename: ' + filename   // Item .filename
                            font.pointSize: 16
                            color: filename == '' ? "red" : "green"
                            font.bold: filename == '' ? false : true
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

            Text {
                 text: 'Enter Speaker Name: '
                       font.pointSize: 18
            }
            TextField {
                placeholderText: qsTr("Àrẹ̀mú")
                onAccepted: {
                    console.log("Speaker Name is: " + text)
                    recorder.acceptSpeakerNameText(text)
                }
            }
        }

        TextArea {
            Layout.fillWidth: true
            font.pointSize: 24
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
            font.pointSize: 18
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
                font.pointSize: 18
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
                font.pointSize: 18
                text: "Delete"
                enabled: scriptFilename
                onClicked: recorder.deleteFile(scriptFilename) // @Slot def deleteFile(self, filename)
            }

            Button {
                Layout.fillWidth: true
                font.pointSize: 18
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
}
