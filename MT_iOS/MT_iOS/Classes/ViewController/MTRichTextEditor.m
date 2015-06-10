//
//  MTRichTextEditor.m
//  MT_iOS
//
//  Created by CHEEBOW on 2015/06/10.
//  Copyright (c) 2015年 Six Apart, Ltd. All rights reserved.
//

#import "MTRichTextEditor.h"

@interface MTRichTextEditor ()

@end

@implementation MTRichTextEditor

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.enabledToolbarItems = @[
                                 ZSSRichTextEditorToolbarBold,
                                 ZSSRichTextEditorToolbarItalic,
                                 ZSSRichTextEditorToolbarSubscript,
                                 ZSSRichTextEditorToolbarSuperscript,
                                 ZSSRichTextEditorToolbarStrikeThrough,
                                 ZSSRichTextEditorToolbarUnderline,
                                 ZSSRichTextEditorToolbarRemoveFormat,
                                 ZSSRichTextEditorToolbarJustifyLeft,
                                 ZSSRichTextEditorToolbarJustifyCenter,
                                 ZSSRichTextEditorToolbarJustifyRight,
                                 ZSSRichTextEditorToolbarJustifyFull,
                                 ZSSRichTextEditorToolbarH1,
                                 ZSSRichTextEditorToolbarH2,
                                 ZSSRichTextEditorToolbarH3,
                                 ZSSRichTextEditorToolbarH4,
                                 ZSSRichTextEditorToolbarH5,
                                 ZSSRichTextEditorToolbarH6,
                                 ZSSRichTextEditorToolbarTextColor,
                                 ZSSRichTextEditorToolbarBackgroundColor,
                                 ZSSRichTextEditorToolbarUnorderedList,
                                 ZSSRichTextEditorToolbarOrderedList,
                                 ZSSRichTextEditorToolbarHorizontalRule,
                                 ZSSRichTextEditorToolbarIndent,
                                 ZSSRichTextEditorToolbarOutdent,
//                                 ZSSRichTextEditorToolbarInsertImage,
                                 ZSSRichTextEditorToolbarInsertLink,
                                 ZSSRichTextEditorToolbarRemoveLink,
                                 ZSSRichTextEditorToolbarQuickLink,
                                 ZSSRichTextEditorToolbarUndo,
                                 ZSSRichTextEditorToolbarRedo,
                                 ZSSRichTextEditorToolbarViewSource,
                                 ZSSRichTextEditorToolbarParagraph,
                                 ];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
