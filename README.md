# VPProgressView
This is a customisable progress view with 2 classes. Circular and Bar progress view.

## Installation
Drag and drop `VPProgressView` folder into your project

## Requirements

1. iOS 7.0 or later.
2. ARC memory management.

## Usage
After adding `VPProgressView` folder, you can add the view in 2 ways.

1. By adding an empty view to your xib/storyboard and 
changing the class of the view to `BarProgressView` or `CircularProgressView`.

2. Programmatically create the view (`BarProgressView` or `CircularProgressView`).

For the oulet/property of the view set the necessary properties. 
If more customization is needed, you can set the optional parameters.

You can make use of properties like `progressContainerColor` or `progressColor` to set the color. You can change the  `animationDuration` etc.

`progressExtremeValues` takes a tuple - (minimum, maximum). This specifies the minimum and maximum values to be displayed by the `progressLabel`

You can also customize the size and stroke width of the progressView based on your requirement.

There are 2 delegate methods for progress view.

`optional func willBeginProgress()` - Called before the start of the animation

`optional func didEndProgress()` - Called after the completion of the animation

# ![Screenshot](/VPProgressView-Screenshot.png)

## Contributing
1. Fork it!
2. Create your feature branch: `git checkout -b my-new-feature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin my-new-feature`
5. Submit a pull request :D

## History
###Version 0.0.1

Basic progress view integrated with support for circular and bar progress view with optional progress label

## License
The MIT License (MIT)

MIT License

Copyright (c) 2016 Varun P M

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
