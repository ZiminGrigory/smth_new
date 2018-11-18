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
			width: Math.min(parent.width, parent.height) / 4
			height: width

			function rotate(item) {
				// rotation center in (0, mwHeigth)
				var xC = myPath.startX
				var yC = myPath.startY
				// only in visible quarter
				var shift = width/2
				if (item.x + shift> 0 && item.y - shift < yC) {
					var deltaX = item.x + width/2 - xC
					var deltaY = item.y + width/2 - yC
					var angle = Math.atan2(deltaY, deltaX)
					item.rotation = angle * 57.2958 + 90
				}
			}

			onXChanged: {
				rotate(mDelegateRectangle)
			}

			onVisibleChanged: {
				rotate(mDelegateRectangle)
			}

			property var modelDataArray: modelData.getList()
			property int currentSelectedItem: 0

			Image {
				id: mInnerImage
				source: "qrc:/images/ribbon.svg"
				anchors.fill: parent
			}

			Text {
				height: mDelegateRectangle.height / 9 * 3
				width: mDelegateRectangle.width
				text: modelDataArray[currentSelectedItem]

				anchors.top: parent.top
				anchors.margins: mDelegateRectangle.height / 9
				horizontalAlignment: Text.AlignHCenter
				color: "#000000"
				font.pointSize: parent.width / 4
				MouseArea {
					id: mLastSelectedItemMouseArea
					anchors.fill: parent
					onClicked: {
						console.log("clicked on outer Item")
						currentSelectedItem = (currentSelectedItem + 1) % modelDataArray.length
					}
				}
			}

			Text {
				height: mDelegateRectangle.height / 9 * 3
				width: mDelegateRectangle.width
				text: "<b>" + modelData.name + "</b>"
				anchors.top: parent.verticalCenter
				horizontalAlignment: Text.AlignHCenter
				anchors.margins: mDelegateRectangle.height / 9
				color: "#000000"
				font.pointSize: parent.width / 4
				MouseArea {
					id: mListNameMouseArea
					anchors.fill: parent
					onClicked: {
						console.log("clicked on inner Item")
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
				radiusX: Math.min(myMainWindow.width, myMainWindow.height) / 2.2
				radiusY: radiusX
				startAngle: -180
				sweepAngle: 270
			}
		}
	}
}
