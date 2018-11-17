import QtQuick 2.11
import QtQuick.Controls 2.4

ApplicationWindow {
	id : myMainWindow
	visible: true
	height: 900
	width: height / 25 * 16
	title: qsTr("WheelMenu")

	// control part:
	signal myButtonClicked
	onMyButtonClicked: {
		myButton.visible = ! myButton.visible
		myPathView.visible = !myPathView.visible
	}


	// button in the bottom left corner
	Rectangle {
		signal clicked
		onClicked: myMainWindow.myButtonClicked()

		id: myButton
		width: Math.min(myMainWindow.width, myMainWindow.height) / 10
		height: width
		radius: width / 2

		x: 0
		y: myMainWindow.height - height

		Image {
			id: mButtonImage
			source: "qrc:/images/settings-button.svg"
			anchors.fill: parent
		}

		MouseArea {
			id: mouseArea
			anchors.fill: myButton

			onClicked: {
				console.log("clicked")
				myButton.clicked()
			}
		}
	}

	// The wheel representation
	PathView {
		id: myPathView
		visible: false

		width: parent.height / 2
		height: parent.height / 2
		anchors.margins: 0
		anchors.fill: parent
		model: ListModel {
			ListElement { name: "element1" }
			ListElement { name: "element2" }
			ListElement { name: "element3" }
			ListElement { name: "element4" }
			ListElement { name: "element5" }
			ListElement { name: "element6" }
			ListElement { name: "element7" }
			ListElement { name: "element8" }
		}

		delegate: Rectangle {
			id : mDelegateRectangle
			width: Math.min(parent.width, parent.height) / 6
			height: width
			radius: width / 2
			color: "blue"
			Text {
				text: name
				anchors.centerIn: parent
				color: "#FFFFFF"
				font.pointSize: parent.width / 3
			}
		}

		path: Path {
			id: myPath
			startX: 0
			startY: myMainWindow.height
			PathAngleArc {
				centerX: 0
				centerY: myPath.startY
				radiusX: Math.min(myMainWindow.width, myMainWindow.height) / 3
				radiusY: radiusX
				startAngle: 0
				sweepAngle: 360
			}
		}
	}
}
