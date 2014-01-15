//
//  JLMainViewController.m
//  Example
//
//  Created by Joshua on 15/1/14.
//  Copyright (c) 2014 Joshua. All rights reserved.
//

#import "JLMainViewController.h"

@interface JLMainViewController (){
    JLImageDL *jlImage;
    UITableView *tbView;
    NSArray *images;
    UIImageView *imageView;
    
}

@end

@implementation JLMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    tbView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tbView.delegate = self;
    tbView.dataSource = self;
    [self.view addSubview:tbView];
    
    
    images = @[@"http://cdn.arstechnica.net/wp-content/uploads/2012/10/06_Place_20773_1_Mis.jpg",
              @"http://viewallpaper.com/wp-content/uploads/2013/07/Images-Water-Wallpaper-1024x640.jpg",
              @"http://cdn.theatlantic.com/static/mt/assets/science/Screen%20Shot%202012-08-29%20at%201.45.48%20PM.png",
              @"http://d1jqu7g1y74ds1.cloudfront.net/wp-content/uploads/2012/11/N00198376.jpg",
              @"http://www.imagemagick.org/image/wizard.png",
              @"http://viewallpaper.com/wp-content/uploads/2013/07/Images-Tiger-Wallpaper.jpg"];


    imageView  = [[UIImageView alloc]initWithFrame:CGRectMake(100, 10, 100, 100)];
    [self.view addSubview:imageView];
    
    //init the imageDownloader
    if(jlImage==nil){
        jlImage =[JLImageDL new];
    }
    jlImage.delegate = self; // add the delegate
    
    //supposed you need to pass a parameter and need to retrieve it back after the image is downlaoded
    
    NSMutableDictionary *params = [@{@"key":@"testParam2"}mutableCopy];
    
    [jlImage downloadImageLink:@"http://viewallpaper.com/wp-content/uploads/2013/07/Images-Water-Wallpaper-1024x640.jpg" forView:self.view optionalParam:params]; // param is optional and can be nil
    
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark JLIMageDelegate
-(void)downloadFinished:(UIImage *)JLImage withParams:(NSMutableDictionary *)param{
    imageView.image = JLImage;
    
    NSLog(@"finish downloading param passed:%@",param); //will display back the parameter you have passed when image is finished downloading
    
    
    
}


#pragma mark tableview
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [images count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *defaultIdentifer = @"default";
    
    __block UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:defaultIdentifer];
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:defaultIdentifer];
        UIImageView *cv = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 100, 90)];
        cv.tag = 500+indexPath.row;
        [cell.contentView addSubview:cv];
        
    }
    
    UIImageView *cv = (UIImageView *)[cell.contentView viewWithTag:500+indexPath.row];
    if(cv!= nil){
        if(cv.image == nil){
            
            //This is download the image based on the required index
            //then cell will be refresh
            [JLImageDL downloadImageLinkBlock:[images objectAtIndex:indexPath.row] forView:cv completion:^(UIImage *image) {
                
                cv.image = image;
                [cell setNeedsLayout];
                
                
            }];
        }
    }
    
    return cell;
}



@end
