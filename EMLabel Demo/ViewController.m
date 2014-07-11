//
//  ViewController.m
//  EMLabel Demo
//
//  Created by Erik Malyak on 6/12/14.
//  Copyright (c) 2014 Erik Malyak. All rights reserved.
//

#import "ViewController.h"
#import "EMLabel.h"


// PDF dimensions
static const int pageWidth = 612;
static const int pageHeight = 792;

// PDF Margins
static const int topMargin = 40;
static const int rightMargin = 40;
static const int bottomMargin = 40;
static const int leftMargin = 40;


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Create a NSMutableData object for the PDF data
    NSMutableData *pdfData = [[NSMutableData alloc] init];
    
    // Start drawing PDF file
    UIGraphicsBeginPDFContextToData(pdfData, CGRectZero, nil);
    
    // Get current Core Graphics context
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Start drawing PDF page
    UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, pageWidth, pageHeight), nil);
    
    
    CGRect titleLabelFrame = CGRectMake(leftMargin, topMargin, 200, 40);
    EMLabel *titleLabel = [[EMLabel alloc] initWithFrame:titleLabelFrame];
    titleLabel.text = @"EMLabel";
    titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:30];
    [titleLabel drawInContext:context];
    
    
    CGRect tagLineLabelFrame = CGRectMake(leftMargin, 80, pageWidth - leftMargin - rightMargin, 20);
    EMLabel *tagLineLabel = [[EMLabel alloc] initWithFrame:tagLineLabelFrame];
    tagLineLabel.text = @"Simple, high-level text drawing for Core Graphics.";
    tagLineLabel.textColor = [UIColor grayColor];
    [tagLineLabel drawInContext:context];
    
    
    CGRect descriptionLabelFrame = CGRectMake(leftMargin, 140, pageWidth - leftMargin - rightMargin, 130);
    EMLabel *descriptionLabel = [[EMLabel alloc] initWithFrame:descriptionLabelFrame];
    descriptionLabel.text = @"EMLabel is a simple class that makes drawing text in a Core Graphics context easier and more readable. Instead of using the Core Text framework, you can use an Objective-C class that has similar functionality to UILabel.\n\n EMLabel has some nifty features...";
    [descriptionLabel drawInContext:context];
    
    
    CGRect demoLabelFrame = CGRectMake(leftMargin, 350, pageWidth - leftMargin - rightMargin, 100);
    EMLabel *demoLabel = [[EMLabel alloc] initWithFrame:demoLabelFrame];
    demoLabel.text = @"Color your label's text and background, and align it horizonally or vertically.";
    demoLabel.textColor = [UIColor whiteColor];
    demoLabel.textAlignment = NSTextAlignmentLeft;
    demoLabel.verticalAlignment = EMLabelVerticalAlignmentTop;
    demoLabel.backgroundColor = [UIColor grayColor];
    [demoLabel drawInContext:context];
    
    
    CGRect fitLabelFrame = CGRectMake(leftMargin, 550, pageWidth - leftMargin - rightMargin, 40);
    EMLabel *fitLabel = [[EMLabel alloc] initWithFrame:fitLabelFrame];
    fitLabel.text = @"If your text exceeds the boundaries of the label, the font size can automatically adjust to fit it.";
    fitLabel.textColor = [UIColor whiteColor];
    fitLabel.textAlignment = NSTextAlignmentCenter;
    fitLabel.backgroundColor = [UIColor grayColor];
    fitLabel.adjustsFontSizeToFitWidth = YES;
    [fitLabel drawInContext:context];
    
    
    CGRect footerLabelFrame = CGRectMake(leftMargin, pageHeight - bottomMargin - 15, pageWidth - leftMargin - rightMargin, 15);
    EMLabel *footerLabel = [[EMLabel alloc] initWithFrame:footerLabelFrame];
    footerLabel.text = @"EMLabel Demo";
    footerLabel.font = [UIFont systemFontOfSize:10.0];
    footerLabel.textColor = [UIColor grayColor];
    footerLabel.textAlignment = NSTextAlignmentCenter;
    [footerLabel drawInContext:context];
    
    // Stop drawing PDF
    UIGraphicsEndPDFContext();
    
    // Show the generated PDF on a UIWebView
    [self.webView loadData:pdfData MIMEType:@"application/pdf" textEncodingName:@"utf-8" baseURL:nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
