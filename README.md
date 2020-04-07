# swipee
Sample swipe cards apps
## About
A simple iOS app showing some contents in cards format. To go to next content you need to
swipe the card. Tracking of number of contents read is possible. It is possible to bring the previous card by tapping the 
Previous button. Reset all the cards to initial position is supported.

### Technology used
The app is implemented using Swift 5 and Xcode 11.2.1

**[UIPanGestureRecognizer]** - To detect the drag and how far the darg happened.<br />
**[CGAffineTransform]** - To animate the cards in various ways to give it tinder like user experience.<br />
**[NSUrl]** - To read the content from url as the content was not proper json thus needed to read as string and then clean it, after
that you may get proper json.<br />
**[Decodable]** - Convert the json data to model automatically.<br />
**[Components]** - Native iOS components.<br />

#### Installation
Clone or download the project. Open with latest xCode.

Always welcome for pull requests.

