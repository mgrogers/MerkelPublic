#import "HFTPagingStateView.h"

@implementation HFTPagingStateView

- (void)viewWillLoad:(IDView *)view
{
    self.isPagingEnabled = YES;
    
    self.title = @"Paging State";
    
    IDTable *pagingTable = [IDTable table];
    pagingTable.isRichTextEnabled = YES;
    [pagingTable setRowCount:1 columnCount:1];
    [pagingTable setCell:[IDTableCell tableCellWithString:@"This is a very long string.\nWe need it to demonstrate how you\ncan use toolbar states\nto display some scroll buttons.\nBut be aware that the scroll buttons\nmight get disabled to avoid\ndriver distraction.\nSCROLL\nFURTHER\nDOWN\n...\nThe End"] atRow:0 column:0];
    
    IDLabel *label = [IDLabel label];
    label.text = @"LABEL";
    IDLabel *l2 = [IDLabel label];
    l2.text = @"TEXT";
    
    NSMutableArray *buttons = [NSMutableArray array];
    
    for (int i = 0; i < 8; i++) {
        IDButton *but = [IDButton button];
        but.selectable = i == 0 || i == 7;
        [buttons addObject:but];
    }
    
    self.toolbarWidgets = buttons;
    
    self.widgets = [NSArray arrayWithObjects:
                    label,
                    l2,
                    pagingTable,
                    nil];
}

@end
