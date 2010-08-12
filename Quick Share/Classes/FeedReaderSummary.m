//
//  RootViewController.m
//  Quick Share
//
//  Created by lilli on 8/9/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "FeedReaderSummary.h"


@implementation FeedReaderSummary


#pragma mark -
#pragma mark View lifecycle

/*
- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
*/


- (void)viewWillAppear:(BOOL)animated 
{
    [super viewWillAppear:animated];

    reader = [FeedReader initFeedReader];
    [reader addFeedForUrl:@"http://rss.slashdot.org/Slashdot/slashdot"];

    //        [stories release];
    //        stories = [[NSDictionary alloc] initWithDictionary:[reader allStories] copyItems:YES];
    
    [sortedStories release];
    sortedStories = [[NSArray alloc] initWithArray:[reader allStories]];// copyItems:YES];//[stories allKeys];//[[stories allKeys] filteredArrayUsingPredicate:[NSPredicate ]]        
}


- (void)viewDidAppear:(BOOL)animated 
{
    [super viewDidAppear:animated];
 
    [newsTable reloadData];
}


/*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
*/

/*
 // Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
 */


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView 
{
    return 1;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section 
{
    return [sortedStories count] + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == [sortedStories count])
        return 40;
    
    return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    static NSString *reuseIdentifier = @"cachedCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) 
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier] autorelease];

        if (indexPath.row < [sortedStories count])
        {
            Story *story = [[sortedStories objectAtIndex:indexPath.row] retain];
            
            UIImageView *favicon = [[[UIImageView alloc] initWithFrame:CGRectMake(6, 8, 16, 16)] autorelease];
            favicon.image = [UIImage imageNamed:@"favicon.png"];
            
            UILabel *documentTitle = [[[UILabel alloc] initWithFrame:CGRectMake(28, 6, 286, 20)] autorelease];
            documentTitle.font = [UIFont boldSystemFontOfSize:16.0];
            documentTitle.textColor = [UIColor blackColor];
            documentTitle.text = story.title;

            UILabel *documentDescription = [[[UILabel alloc] initWithFrame:CGRectMake(38, 26, 270, 42)] autorelease];
            documentDescription.font = [UIFont systemFontOfSize:11.0];
            documentDescription.textColor = [UIColor grayColor];
            documentDescription.lineBreakMode = UILineBreakModeWordWrap;
            documentDescription.numberOfLines = 3;
            documentDescription.text = story.description;
            
            UILabel *documentDate = [[[UILabel alloc] initWithFrame:CGRectMake(6, 74, 298, 10)] autorelease];
            documentDate.font = [UIFont italicSystemFontOfSize:10.0];
            documentDate.textColor = [UIColor grayColor];
            documentDate.textAlignment = UITextAlignmentLeft;
            
            /* First trim just the whitespace off of the end of the string */
            NSString *date = [story.pubDate stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            
            /* Then trim the "+0000" or whatever off of the end of the string (and the "\n")*/
            date = [date stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"+0123456789\n"]];
            
            /* Then trim the remaining whitespace off of the end.  If we trimmed whitespace and decimal characters at the same time,
               we'd remove more than just the "+0000" */
            documentDate.text = [NSString stringWithFormat:@"published on %@",
                                 [date stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
            
            [cell.contentView addSubview:favicon];
            [cell.contentView addSubview:documentTitle];
            [cell.contentView addSubview:documentDescription];
            [cell.contentView addSubview:documentDate];
            
            [story release];
        }
        else if (indexPath.row == [sortedStories count])
        {
            cell.textLabel.text = @"Reload Stories";
        }
    }
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    if (indexPath.row == [sortedStories count])
    {
//        [stories release];
//        stories = [[NSDictionary alloc] initWithDictionary:[reader allStories] copyItems:YES];
        
        [sortedStories release];
        sortedStories = [[NSArray alloc] initWithArray:[reader allStories]];// copyItems:YES];//[stories allKeys];//[[stories allKeys] filteredArrayUsingPredicate:[NSPredicate ]]        
    }
    else
    {
        reader.selectedStory = [sortedStories objectAtIndex:indexPath.row];
        FeedReaderDetail *detailViewController = [[FeedReaderDetail alloc] initWithNibName:@"FeedReaderDetail" bundle:[NSBundle mainBundle]];

//        detailViewController.story = [sortedStories objectAtIndex:indexPath.row];

        [self.navigationController pushViewController:detailViewController animated:YES];
        [detailViewController release];
    }
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc 
{
	[stories release];
    
    [super dealloc];
}


@end

 