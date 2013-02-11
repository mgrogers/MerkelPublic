#import "HFTCheckboxRadioOverviewView.h"

@interface HFTCheckboxRadioOverviewView() <IDCheckboxDelegate>

@end

@implementation HFTCheckboxRadioOverviewView

- (void)viewWillLoad:(IDView *)view
{
    IDCheckbox *radioButton1 = [IDCheckbox checkbox];
    radioButton1.style = IDCheckboxStyleRadioButton;
    radioButton1.text = @"Normal Radio Button";
    radioButton1.delegate = self;
    
    IDCheckbox *checkbox1 = [IDCheckbox checkbox];
    checkbox1.text = @"Normal Checkbox";
    checkbox1.delegate = self;
    
    IDCheckbox *checkbox2 = [IDCheckbox checkbox];
    checkbox2.text = @"Unselectable Checkbox";
    checkbox2.delegate = self;
    checkbox2.selectable = NO;
    
    IDCheckbox *checkbox3 = [IDCheckbox checkbox];
    checkbox3.text = @"Disabled Checkbox";
    checkbox3.delegate = self;
    checkbox3.enabled = NO;
    
    IDCheckbox *checkbox4 = [IDCheckbox checkbox];
    checkbox4.text = @"Checkbox (with no delegate defined)";
    
    self.widgets = [NSArray arrayWithObjects:
                    radioButton1,
                    checkbox1,
                    checkbox2,
                    checkbox3,
                    checkbox4,
                    nil];
}

# pragma mark - IDCheckboxDelegate protocol delegate (optional) implementation
- (BOOL)checkboxShouldToggle:(IDCheckbox*)checkbox
{
    // if the checkbox is Enabled and Selectable, we allow it to be toggled
    return checkbox.selectable && checkbox.enabled;
}

- (void)checkbox:(IDCheckbox *)checkbox didChangeCheckedValue:(BOOL)checkedValue
{
    NSLog(@"Checkbox:%p changed value to:%d",checkbox, checkedValue);
}

@end
