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
		// @todo: add animation here or smth else
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
		z: 1

		Image {
			id: mButtonImage
			source: "qrc:/images/settings-button.svg"
			anchors.fill: parent
		}

		MouseArea {
			id: mMouseArea
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

		width: parent.height
		height: parent.height
		anchors.margins: 0
		anchors.fill: parent
		model: myModel // imported from c++

		delegate: Rectangle {
			id : mDelegateRectangle
			width: Math.min(parent.width, parent.height) / 6
			height: width
			radius: width * 0.3
			border.color: "black"
			border.width: 5
			color: "blue"

			onXChanged: {
				// rotation center in (0, mwHeigth)
				var xC = myPath.startX
				var yC = myPath.startY
				// only in visible quarter
				var shift = width/2
				if (x + shift> 0 && y - shift < yC) {
					var deltaX = x + width/2 - xC
					var deltaY = y + width/2 - yC
					var angle = Math.atan2(deltaY, deltaX)
					rotation = angle * 57.2958 + 90
				}
			}

			property var modelDataArray: modelData.getList()

			Text {
				text: modelData.name
				anchors.centerIn: parent
				color: "#FFFFFF"
				font.pointSize: parent.width / 3
				transform: Translate { y: +20 ;}
				MouseArea {
					id: mListNameMouseArea
					// do it for both items... inner and outer
					anchors.fill: mDelegateRectangle

					onClicked: {
						console.log("clicked on inner Item")
					}
				}
			}

			Text {
				text: modelDataArray[0]
				anchors.centerIn: parent
				color: "#FFFFFF"
				font.pointSize: parent.width / 3
				transform: Translate { y: -20}
				MouseArea {
					id: mLastSelectedItemMouseArea
					// do it for both items... inner and outer
					anchors.fill: mDelegateRectangle

					onClicked: {
						console.log("clicked on outer Item")
					}
				}
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
				startAngle: -180
				sweepAngle: 270
			}
		}
	}
}
