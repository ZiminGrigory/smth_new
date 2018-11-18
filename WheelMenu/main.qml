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

	signal myShowContent(var model, bool innerElement, int currentInnerIndex, string baseColor)
	onMyShowContent: {
		console.log("MODEL: ", model, "is Inner: ", innerElement, "index = ", currentInnerIndex, "color= ", baseColor)
		myMainListViewTable.model = model
		myMainListViewTable.innerElement = innerElement
		myMainListViewTable.color = baseColor
		myMainListViewTable.visible = true
	}

	signal myUpdateWheelItem(int selectedOuterIndex)
	onMyUpdateWheelItem: {
		myPathView.currentItem.currentSelectedItem = selectedOuterIndex
	}

	// mainWidgets:
	// List view for table... and for selected Item in table too
	ListView
	{
		id: myMainListViewTable
		visible: false
		anchors.fill: parent
		anchors.margins: 20
		property bool innerElement: false
		property string color: ""

		signal itemSelected(bool innerElement, int index)
		onItemSelected: {

		}

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
						myMainListViewTable.itemSelected(myMainListViewTable.innerElement, index)
						if (myMainListViewTable.innerElement) {
							myMainWindow.myUpdateWheelItem(index)
						}
					}
				}
			}
		}

		delegate: myDataDelegate
		highlight: Rectangle {
			color: "lightsteelblue"
			radius: parent.height * 0.5
		}

		// background
		Rectangle {
			z: -10
			anchors.fill: parent
			color: parent.color
			opacity: 0.3
			radius: parent.height * 0.05
		}

		highlightFollowsCurrentItem: innerElement
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

		// block full screen when active
		width: parent.height
		height: parent.height
		anchors.margins: 0
		anchors.fill: parent
		model: myModel // imported from c++

		signal closeMe
		// todo add animation
		onCloseMe: visible = !visible

		delegate: Rectangle {
			id : mDelegateRectangle
			width: Math.min(parent.width, parent.height) / 4
			height: width
			color: "transparent"

			function rotate(item) {
				var xC = myPath.startX
				var yC = myPath.startY
				var deltaX = item.x + width/2 - xC
				var deltaY = item.y + width/2 - yC
				var angle = Math.atan2(deltaY, deltaX)
				item.rotation = angle * 57.2958 + 90
			}

			onXChanged: rotate(mDelegateRectangle)
			onVisibleChanged: rotate(mDelegateRectangle)

			readonly property var modelDataArray: modelData.getList()
			property int currentSelectedItem: 0

			signal itemClicked
			onItemClicked: parent.closeMe()

			Text {
				id: myOuterText
				height: mDelegateRectangle.height / 9 * 3
				width: mDelegateRectangle.width
				text: modelDataArray[currentSelectedItem % 7]

				anchors.top: parent.top
				anchors.margins: mDelegateRectangle.height / 9
				horizontalAlignment: Text.AlignHCenter
				color: "#000000"
				font.pointSize: parent.width / 4
				MouseArea {
					id: mLastSelectedItemMouseArea
					anchors.fill: parent
					onClicked: {
						mDelegateRectangle.itemClicked()
						console.log("clicked on outer Item")
						currentSelectedItem = (currentSelectedItem + 1) % modelDataArray.length
					}
				}
			}

			Text {
				id: myInnerText
				height: mDelegateRectangle.height / 9 * 3
				width: mDelegateRectangle.width
				text: "<b>LIST</b>"
				anchors.top: parent.verticalCenter
				horizontalAlignment: Text.AlignHCenter
				anchors.margins: mDelegateRectangle.height / 9
				color: modelData.color
				font.pointSize: parent.width / 4
				MouseArea {
					id: mListNameMouseArea
					anchors.fill: parent
					onClicked: {
						myMainListViewTable.currentIndex = index
						myMainWindow.myShowContent(
								mDelegateRectangle.modelDataArray
								, true
								, mDelegateRectangle.currentSelectedItem
								, parent.color)
						mDelegateRectangle.itemClicked()
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
			width: Math.min(myMainWindow.width, myMainWindow.height) / 0.7
			height: width
			source: "qrc:/images/circle.svg"
			z: -1
			x: -width / 2
			y: myMainWindow.height - width / 2;
		}
	}
}
