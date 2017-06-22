# PlayingGIFModel
一个简易的播放GIF图的Demo，教你如何播放GIF图

**引言：**我们在用SDWebImage的时候， 如果图片是`.gif`的时候，是自动无限循环播放的，而如果我们只需要播放有限次数`gif`图的时候，是没有办法的，接下来让我们看看不用第三方如何播放`gif`图吧。
[Demo下载](https://github.com/Pangshishan/PlayingGIFDemo.git)

-----------

**首先**，UIImageView是存在播放一组图片的功能的，而`.gif`的图片，也是一组图片组成的， 我们需要把`gif`图分解成一组图片；
**第二步**，拿到一组图片之后，我们还需要知道`gif`图片需要播放多久，就需要拿到时间信息；
**第三步**，当我们停止播放的时候，要显示哪一张图片，也需要给定的，不然停止播放的时候就会显示空白；
**补充说明：** *`gif`图暂停的时候，是固定显示一张图片的。**如果想做实时暂停，则本篇微博不会涉及。**不过操作思路还是可以讲一下，就是拿到图片组；然后再拿到每张图片播放的时间，开一个定时器；然后根据时间的流逝显示图片，当点击暂停的时候定时器暂停，点击继续的时候定时器继续走，而不是用UIImageView提供的系统方法。定时器的话可以用`CADisplayLink`，比较精确，是根据屏幕刷新率来的，不过不了解可以自行搜索，也是不难的。虽然不提供此功能，但是，下面一部分的代码对你也是有一定的帮助的，看看就知道了，代码量也不是很大。（如果我哪天有闲暇时间，可能会写一个，到时候会发上链接的）*

### 代码：
```Swift
// 1.获取NSData类型
guard let filePath = Bundle.main.path(forResource: "demo.gif", ofType: nil) else { return }
guard let fileData = NSData(contentsOfFile: filePath) else { return }

// 2.根据Data获取CGImageSource对象
guard let imageSource = CGImageSourceCreateWithData(fileData, nil) else { return }

// 3.获取gif图片中图片的个数
let frameCount = CGImageSourceGetCount(imageSource)
// 记录播放时间
var duration : TimeInterval = 0
var images = [UIImage]()
for i in 0..<frameCount {
// 3.1.获取图片
guard let cgImage = CGImageSourceCreateImageAtIndex(imageSource, i, nil) else { continue }
// 3.2.获取时长
guard let properties = CGImageSourceCopyPropertiesAtIndex(imageSource, i, nil) , let gifInfo = (properties as NSDictionary)[kCGImagePropertyGIFDictionary as String] as? NSDictionary,
let frameDuration = (gifInfo[kCGImagePropertyGIFDelayTime as String] as? NSNumber) else { continue }
duration += frameDuration.doubleValue
let image = UIImage(cgImage: cgImage)
images.append(image)
// 设置停止播放时现实的图片
if i == frameCount - 1 {
imageView.image = image
}
}
// 4.播放图片
imageView.animationImages = images
// 播放总时间
imageView.animationDuration = duration
// 播放次数, 0为无限循环
imageView.animationRepeatCount = 1
// 开始播放
imageView.startAnimating()
// 停止播放
// imageView.stopAnimating()
```

#### 结束语：
以上代码是`Swift`的，不过需要用OC，可以自己翻译成OC，代码量也不大。如果一个iOS开发者读不懂这点Swift的代码的话，你的知识储备该提高了，赶紧去学啊少年！
如果懒得翻译，也可以用OC混编Swift，封装一下，照样用。最后再次附上[下载地址（戳这里下载Demo啊）](https://github.com/Pangshishan/PlayingGIFDemo.git)

**如果对你有帮助，点个Star呗**
同时也欢迎评论中指出本文存在的bug，或者疑问，互相促进！
作者邮箱：pangshishan@aliyun.com， pangshishan1@163.com
github地址：[https://github.com/Pangshishan](https://github.com/Pangshishan)
qq/微信： 704158807

