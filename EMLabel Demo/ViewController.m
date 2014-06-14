//
//  ViewController.m
//  EMLabel Demo
//
//  Created by Erik Malyak on 6/12/14.
//  Copyright (c) 2014 Erik Malyak. All rights reserved.
//

#import "ViewController.h"
#import "EMLabel.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
    NSMutableData *pdfData = [[NSMutableData alloc] init];
    
    UIGraphicsBeginPDFContextToData(pdfData, CGRectZero, nil);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, 612, 792), nil);
    
    EMLabel *demoLabel = [[EMLabel alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    demoLabel.text = @"this is a test";
    demoLabel.adjustsFontSizeToFitWidth = YES;
    demoLabel.textColor = [UIColor whiteColor];
    demoLabel.textAlignment = NSTextAlignmentCenter;
    demoLabel.backgroundColor = [UIColor grayColor];
    
    [demoLabel drawInContext:context];
    
    UIGraphicsEndPDFContext();
    
    [self.webView loadData:pdfData MIMEType:@"application/pdf" textEncodingName:@"utf-8" baseURL:nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
