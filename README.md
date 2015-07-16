![](logo.png)       

####It was just one file and writen with `swift`, you can add to you project easily.

##What is it look like?

![](demo.gif)


##How to Use?       

####Add this file to you project, and write the code below, it's so simple!

```swift
let dragBadgeView = DragBadge(frame: CGRectMake(200, 200, 20, 20))
self.view.addSubview(dragBadgeView)
dragBadgeView.setUp()
```
####You can change the title at any place:  

```swift
dragBadgeView.title = "38"
```

####If you want to change the color and the max length to drag, then:

```swift
dragBadgeView.dragColor = UIColor.redColor()
dragBadgeView.maxLength = 200
```

####But make sure it will be writen before `setUp()` method!!!