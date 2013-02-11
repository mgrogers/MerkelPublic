#import "HFTTableLayoutStateView.h"

@implementation HFTTableLayoutStateView


- (void)viewWillLoad:(IDView *)view
{
    self.title = @"Table Layout";
    
    self.startRow = 2;
    self.endRow = 6;
    
    //non table components, these are removed form the table by setting their position
    
    IDImage *iconRHMIApp = [IDImage image];
    [iconRHMIApp setImageData:[self.application.imageBundle imageWithName:@"iconDevice" type:@"png"]];
    iconRHMIApp.position = CGPointMake(0, 0);
        
    IDLabel *label = [IDLabel label];
    label.text = @"This is a state with a table layout";
    label.selectable = NO;
    label.position = CGPointMake(80, 8);
    
    //Table components
    
    IDButton *tableButton1 = [IDButton button];
    tableButton1.text = @"A button";
    
    IDButton *tableButton2 = [IDButton button];
    tableButton2.text = @"Another button";
    
    IDLabel *tableLabel1 = [IDLabel label];
    tableLabel1.text = @"A label";
    tableLabel1.selectable = NO;
    
    IDLabel *tableLabel2 = [IDLabel label];
    tableLabel2.text = @"Another label";
    tableLabel2.enabled = NO;
    
    IDButton *tableButton3 = [IDButton button];
    tableButton3.text = @"Yet another button";
    
    IDButton *tableButton4 = [IDButton button];
    tableButton4.text = @"Button 4";
    
    IDButton *tableButton5 = [IDButton button];
    tableButton5.text = @"Last button";
    
    self.widgets = [NSArray arrayWithObjects:
                    iconRHMIApp,
                    label,
                    tableButton1,
                    tableButton2,
                    tableLabel1,
                    tableLabel2,
                    tableButton3,
                    tableButton4,
                    tableButton5,
                    nil];
}

@end

