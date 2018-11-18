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
		if (!myPathView.visible) {
			myPathView.visible = !myPathView.visible
			myPathViewShowAnimation.start()
		} else {
			myPathView.visible = !myPathView.visible
		}
	}

	// model as array too for decreasing memory allocations
	signal myShowTableContent(var modelObj, var model)
	onMyShowTableContent: {
		myMainListViewTable.myCurrentModel = modelObj
		myMainListViewTable.model = model
		myMainListViewTable.currentIndex = modelObj.selectedItem
		myMainListViewTable.visible = true
		myMainViewItem.visible = false
		myMainViewStart.visible = false
	}

	signal myShowSelectedItemInTable(var modelObj)
	onMyShowSelectedItemInTable: {
		myMainViewItem.myCurrentModel = modelObj
		myMainViewItem.visible = true
		myMainListViewTable.visible = false
		myMainViewStart.visible = false
	}

	// mainWidgets:
	// List view for table
	ListView
	{
		id: myMainListViewTable
		visible: false
		anchors.fill: parent
		anchors.margins: 20
		property variant myCurrentModel

		Component {
			id: myDataDelegate
			Item {
				width: myMainListViewTable.width
				height: myMainListViewTable.height * 0.25
				Text {
					anchors.centerIn: parent
					elide: Text.ElideLeft
					text: '<b>Value:</b> ' + modelData
					font.pixelSize: Math.min(parent.height, parent.width) * 0.3
				}

				MouseArea {
					anchors.fill: parent
					onClicked: {
						myMainListViewTable.currentIndex = index
						myMainListViewTable.myCurrentModel.selectedItem = index
					}
				}
			}
		}

		delegate: myDataDelegate
		highlight: Rectangle {
			color: "lightsteelblue"
			radius: parent.height * 0.5
		}

		highlightMoveDuration: 250

		// background
		Rectangle {
			z: -10
			anchors.fill: parent
			color: myMainListViewTable.myCurrentModel.color
			opacity: 0.6
			radius: parent.height * 0.01
		}
	}

	Item {
		id: myMainViewItem

		visible: false
		anchors.fill: parent
		anchors.margins: 20
		property variant myCurrentModel

		Text {
			anchors.centerIn: parent
			text: '<b>Value:</b> ' + (myMainViewItem.myCurrentModel.selectedItem + 1)
			font.pixelSize: Math.min(parent.height, parent.width) * 0.1
		}

		//background
		Rectangle {
			z: -10
			anchors.fill: parent
			// set color accroding to base table
			color: myMainViewItem.myCurrentModel.color
			opacity: 0.6
			radius: parent.height * 0.05
		}
	}

	Item {
		id: myMainViewStart
		anchors.fill: parent
		anchors.margins: 20

		Text {
			anchors.centerIn: parent
			text: 'Wheel Menu'
			font.pixelSize: Math.min(parent.height, parent.width) * 0.1
		}

		//background
		Rectangle {
			z: -10
			anchors.fill: parent
			color: "lightsteelblue"
			radius: parent.height * 0.05
		}
	}


	// button in the bottom left corner
	Rectangle {
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
			// rendering without sourceSise is awful
			sourceSize.width: parent.width
			sourceSize.height: parent.width
			anchors.fill: parent
		}

		MouseArea {
			id: mMouseArea
			anchors.fill: myButton

			onClicked: {
				myMainWindow.myButtonClicked()
			}
		}
	}

	// The wheel representation
	PathView {
		id: myPathView
		visible: false

		// block full screen when active
		width: parent.height
		height: parent.height
		anchors.margins: 0
		anchors.fill: parent
		model: myModel // imported from c++

		delegate: Rectangle {
			id : mDelegateRectangle
			width: Math.min(parent.width, parent.height) / 4
			height: width
			color: "transparent"

			function rotate(item, nonrotatingChild) {
				var xC = myPath.startX
				var yC = myPath.startY
				var deltaX = item.x + width/2 - xC
				var deltaY = item.y + width/2 - yC
				var angle = Math.atan2(deltaY, deltaX)
				item.rotation = angle * 57.2958 + 90
				nonrotatingChild.rotation = -item.rotation;
			}

			onXChanged: rotate(mDelegateRectangle, myOuterText)
			onVisibleChanged: rotate(mDelegateRectangle, myOuterText)

			readonly property var modelDataArray: modelData.getList()

			Text {
				id: myOuterText
				height: mDelegateRectangle.height / 9 * 3
				width: mDelegateRectangle.width
				text: "item: " + (modelData.selectedItem + 1)

				anchors.top: parent.top
				anchors.margins: mDelegateRectangle.height / 9
				horizontalAlignment: Text.AlignHCenter
				color: "white"
				font.pointSize: parent.width / 4
				MouseArea {
					id: mLastSelectedItemMouseArea
					anchors.fill: parent
					onClicked: {
						myMainWindow.myButtonClicked()
						myMainWindow.myShowSelectedItemInTable(modelData)
					}
				}
			}

			Rectangle {
				id: myInnerObject
				height: mDelegateRectangle.height / 9 * 3
				width: mDelegateRectangle.width * 0.5
				radius: width * 0.2
				anchors.top: parent.verticalCenter
				anchors.horizontalCenter: parent.horizontalCenter
				anchors.margins: mDelegateRectangle.height / 9
				color: modelData.color
				MouseArea {
					id: mListNameMouseArea
					anchors.fill: parent
					onClicked: {
						myMainWindow.myButtonClicked()
						myMainListViewTable.currentIndex = index
						myMainWindow.myShowTableContent(modelData, mDelegateRectangle.modelDataArray)
					}
				}
			}
		}

		path: Path {
			id: myPath
			startX: 0
			startY: myMainWindow.height
			PathAngleArc {
				id: myPathAngleArc
				centerX: 0
				centerY: myPath.startY
				radiusX: Math.min(myMainWindow.width, myMainWindow.height) / 2.2
				radiusY: radiusX
				startAngle: -180
				sweepAngle: 270
			}
		}

		Image {
			id: mPathViewImage
			sourceSize.width: Math.min(myMainWindow.width, myMainWindow.height) / 0.7
			sourceSize.height: sourceSize.height
			source: "qrc:/images/circle.svg"
			z: -1
			x: -width / 2
			y: myMainWindow.height - width / 2;
		}

		ParallelAnimation {
			id: myPathViewShowAnimation
			NumberAnimation {
				target: myPathAngleArc
				property: "radiusX"
				from: 0
				to: myPathAngleArc.radiusX
				duration: 300
			}

			NumberAnimation {
				target: myPathView
				property: "opacity"
				from: 0.0
				to: 1.0
				duration: 300
			}
		}
	}
}
