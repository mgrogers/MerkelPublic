#import "HFTInputSpellerOverviewView.h"
#import "HFTHmiProvider.h"

@interface HFTInputSpellerOverviewView() <IDSpellerDelegate>

@property (nonatomic, retain) NSMutableArray *suggestionListArray;

@end

@implementation HFTInputSpellerOverviewView

@synthesize suggestionListArray = _suggestionListArray;

- (void)dealloc
{
    [_suggestionListArray release];
    
    [super dealloc];
}

- (void)viewWillLoad:(IDView *)view
{
    _suggestionListArray = [[NSMutableArray alloc] init];

    HFTHmiProvider *provider = self.application.hmiProvider;
    
    IDSpeller *inputSpeller = [IDSpeller speller];    
    [inputSpeller setDelegate:self];
    [inputSpeller clear];
    
    [inputSpeller setTargetView:provider.resultsStateView];
    
    self.title = @"Speller";
    
    self.widgets = [NSArray arrayWithObjects:
                    inputSpeller,
                    nil];
}

# pragma mark - IDSpellerDelegate Protocol methods
- (void)speller:(IDSpeller *)speller didChangeText:(NSString *)string
{
    //Build array with results and show then in the Suggested list
    [self.suggestionListArray addObject:speller.text];
    [speller setResults:self.suggestionListArray];
}

- (void)speller:(IDSpeller *)speller didSelectResultAtIndex:(NSInteger)index
{
    // Result selected from the Suggested list
    NSString* str = [self.suggestionListArray objectAtIndex:index];
    NSLog(@"%s -- didSelectResult: %@", __PRETTY_FUNCTION__, str);
}

- (void)spellerDidSelectOK:(IDSpeller *)speller
{
    // OK button of the Speller is selected.
    NSLog(@"\n%s--spellerDidSelectOK. Input string:%@", __PRETTY_FUNCTION__, speller.text);
}

@end
