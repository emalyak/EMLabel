# EMLabel #

EMLabel is a simple class that makes drawing text in a Core Graphics context easier and more readable. Instead of using Core Text, you can use a higher-level Objective-C class that has similar functionality to UILabel, with features like:
* Adjusting text's font size to fit its frame's width
* Vertical and horizonal alignment
* Text and background coloring

Check out the [EMLabel header file](EMLabel/EMLabel.h) to see its configurable properties.

## Usage ##
First, add the [EMLabel files](EMLabel) to your project and include the EMLabel header file wherever you wish to use the class:
```objc
#import "EMLabel.h"
```

Next, create and initialize an EMLabel object with its frame, set its attributes, and draw it on your context:
```objc
// Make sure you get the current Core Graphics context
CGContextRef context = UIGraphicsGetCurrentContext();

// Define the frame for the label
CGRect demoLabelFrame = CGRectMake(50, 50, 200, 100);

// Create an EMLabel object with its frame
EMLabel *demoLabel = [[EMLabel alloc] initWithFrame:demoLabelFrame];

// Set its attributes
demoLabel.text = @"Hello world.";
demoLabel.textAlignment = NSTextAlignmentCenter;
demoLabel.textColor = [UIColor whiteColor];
demoLabel.backgroundColor = [UIColor grayColor];

// Draw the label in the context
[demoLabel drawInContext:context];
```

## Demo ##
The idea for EMLabel originated from working on a project that generates PDF files with Core Graphics. To see EMLabel in action when generating PDF files, try out the demo by cloning this repository and opening the file *EMLabel Demo.xcodeproj* in Xcode.

## License ##
EMLabel is licensed under the terms of the permissive [MIT License](LICENSE).
