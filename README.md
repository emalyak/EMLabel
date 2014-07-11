# EMLabel #

EMLabel is a simple class that makes drawing text in a Core Graphics context easier and more readable. Instead of using the Core Text framework, you can use an Objective-C class that has similar functionality to UILabel. For example, a great application for EMLabel is drawing text when generating PDFs with Core Graphics.

## Usage ##
First, include the EMLabel header wherever you wish to use the class:
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

## License ##
EMLabel is licensed under the terms of the permissive [MIT License](LICENSE).
