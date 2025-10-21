// import { postManager } from '../manager/PostManager';
// import { Post } from '../api/PostApi';
//
// // 导航参数接口
// interface PostDetailParam {
//   postId: number;
// }
//
// interface CreatePostParam {
//   // 创建文章页面暂时不需要参数
// }
//
// @Component
// export struct PostListPage {
//   @StorageLink('postList') postList: Post[] = [];
//   @StorageLink('isLoading') isLoading: boolean = false;
//   @StorageLink('errorMessage') errorMessage: string = '';
//   private navPathStack: NavPathStack = new NavPathStack();
//
//   async aboutToAppear() {
//     await this.loadData();
//   }
//
//   async loadData() {
//     postManager.setLoading(true);
//     postManager.clearError();
//
//     const success = await postManager.loadAllPosts();
//     if (!success) {
//       postManager.setError('加载文章列表失败，请重试');
//     }
//
//     postManager.setLoading(false);
//   }
//
//   async refreshData() {
//     await this.loadData();
//   }
//
//   build() {
//     Navigation(this.navPathStack) {
//       Column() {
//         // 标题栏
//         Row() {
//           Text('文章列表')
//             .fontSize(20)
//             .fontWeight(FontWeight.Bold)
//             .layoutWeight(1)
//
//           Button('刷新')
//             .height(35)
//             .onClick(() => {
//               this.refreshData();
//             })
//
//           Button('创建')
//             .height(35)
//             .margin({ left: 10 })
//             .onClick(() => {
//               const param: CreatePostParam = {};
//               this.navPathStack.pushPath({
//                 name: 'CreatePostPage',
//                 param: param
//               });
//             })
//         }
//         .width('100%')
//         .padding({ left: 20, right: 20, top: 10, bottom: 10 })
//         .justifyContent(FlexAlign.SpaceBetween)
//
//         // 错误信息
//         if (this.errorMessage) {
//           Text(this.errorMessage)
//             .fontSize(14)
//             .fontColor(Color.Red)
//             .padding(20)
//             .width('100%')
//             .textAlign(TextAlign.Center)
//         }
//
//         // 加载状态
//         if (this.isLoading) {
//           Column() {
//             Text('加载中...')
//               .fontSize(16)
//               .fontColor('#666666')
//           }
//           .width('100%')
//           .height(200)
//           .justifyContent(FlexAlign.Center)
//         } else {
//           // 文章列表
//           if (this.postList && this.postList.length > 0) {
//             List() {
//               ForEach(this.postList, (post: Post) => {
//                 ListItem() {
//                   this.PostItem(post)
//                 }
//                 .onClick(() => {
//                   const param: PostDetailParam = { postId: post.id };
//                   this.navPathStack.pushPath({
//                     name: 'PostDetailPage',
//                     param: param
//                   });
//                 })
//               })
//             }
//             .width('100%')
//             .layoutWeight(1)
//           } else {
//             Column() {
//               Text('暂无文章')
//                 .fontSize(16)
//                 .fontColor('#999999')
//             }
//             .width('100%')
//             .height(200)
//             .justifyContent(FlexAlign.Center)
//           }
//         }
//       }
//       .width('100%')
//       .height('100%')
//       .backgroundColor('#F5F5F5')
//     }
//     .navDestination(this.navDestinationBuilder)
//   }
//
//   @Builder
//   PostItem(post: Post) {
//     Column() {
//       Text(post.title)
//         .fontSize(16)
//         .fontWeight(FontWeight.Bold)
//         .maxLines(2)
//         .textOverflow({ overflow: TextOverflow.Ellipsis })
//         .width('100%')
//         .margin({ bottom: 8 })
//
//       Text(post.body)
//         .fontSize(14)
//         .fontColor('#666666')
//         .maxLines(3)
//         .textOverflow({ overflow: TextOverflow.Ellipsis })
//         .width('100%')
//         .margin({ bottom: 8 })
//
//       Row() {
//         Text(`ID: ${post.id}`)
//           .fontSize(12)
//           .fontColor('#999999')
//
//         Text(`用户ID: ${post.userId}`)
//           .fontSize(12)
//           .fontColor('#999999')
//       }
//       .width('100%')
//       .justifyContent(FlexAlign.SpaceBetween)
//     }
//     .width('100%')
//     .padding(15)
//     .backgroundColor('#FFFFFF')
//     .borderRadius(8)
//     .margin({ left: 15, right: 15, bottom: 10 })
//     .alignItems(HorizontalAlign.Start)
//   }
//
//   @Builder
//   navDestinationBuilder(name: string, param: Object) {
//     if (name === 'PostDetailPage') {
//       // const detailParam = param as PostDetailParam;
//       // PostDetailPage({ postId: detailParam.postId })
//     } else if (name === 'CreatePostPage') {
//       CreatePostPage()
//     }
//   }
// }
//
// @Component
// struct PostDetailPage {
//   @Prop postId: number = 0;
//   @StorageLink('currentPost') currentPost: Post | null = null;
//   @State loading: boolean = false;
//
//   async aboutToAppear() {
//     this.loading = true;
//     await postManager.loadPostDetail(this.postId);
//     this.loading = false;
//   }
//
//   build() {
//     NavDestination() {
//       Column() {
//         if (this.loading) {
//           Text('加载中...')
//             .fontSize(16)
//             .fontColor('#666666')
//         } else if (this.currentPost) {
//           Column() {
//             Text(this.currentPost.title)
//               .fontSize(20)
//               .fontWeight(FontWeight.Bold)
//               .margin({ bottom: 20 })
//               .width('100%')
//
//             Text(this.currentPost.body)
//               .fontSize(16)
//               .lineHeight(24)
//               .width('100%')
//               .margin({ bottom: 20 })
//
//             Row() {
//               Text(`文章ID: ${this.currentPost.id}`)
//                 .fontSize(14)
//                 .fontColor('#666666')
//
//               Text(`作者ID: ${this.currentPost.userId}`)
//                 .fontSize(14)
//                 .fontColor('#666666')
//             }
//             .width('100%')
//             .justifyContent(FlexAlign.SpaceBetween)
//           }
//           .alignItems(HorizontalAlign.Start)
//         } else {
//           Text('文章不存在')
//             .fontSize(16)
//             .fontColor('#999999')
//         }
//       }
//       .width('100%')
//       .height('100%')
//       .padding(20)
//       .backgroundColor('#F5F5F5')
//     }
//     .title('文章详情')
//   }
// }
//
// @Component
// struct CreatePostPage {
//   @State title: string = '';
//   @State body: string = '';
//   @State userId: number = 1;
//   @State creating: boolean = false;
//   @State message: string = '';
//
//   async handleCreate() {
//     if (!this.title.trim() || !this.body.trim()) {
//       this.message = '请填写标题和内容';
//       return;
//     }
//
//     this.creating = true;
//     this.message = '';
//
//     const success = await postManager.createNewPost(this.title, this.body, this.userId);
//
//     if (success) {
//       this.message = '文章创建成功！';
//       // 清空表单
//       this.title = '';
//       this.body = '';
//     } else {
//       this.message = '创建失败，请重试';
//     }
//
//     this.creating = false;
//   }
//
//   build() {
//     NavDestination() {
//       Column() {
//         Text('创建文章')
//           .fontSize(20)
//           .fontWeight(FontWeight.Bold)
//           .margin({ bottom: 30 })
//
//         Column() {
//           Text('标题')
//             .fontSize(16)
//             .alignSelf(ItemAlign.Start)
//             .margin({ bottom: 8 })
//
//           TextInput({ placeholder: '请输入文章标题' })
//             .width('100%')
//             .height(50)
//             .margin({ bottom: 20 })
//             .onChange((value: string) => {
//               this.title = value;
//             })
//
//           Text('内容')
//             .fontSize(16)
//             .alignSelf(ItemAlign.Start)
//             .margin({ bottom: 8 })
//
//           TextArea({ placeholder: '请输入文章内容' })
//             .width('100%')
//             .height(150)
//             .margin({ bottom: 20 })
//             .onChange((value: string) => {
//               this.body = value;
//             })
//
//           Text('用户ID')
//             .fontSize(16)
//             .alignSelf(ItemAlign.Start)
//             .margin({ bottom: 8 })
//
//           TextInput({ text: this.userId.toString() })
//             .width('100%')
//             .height(50)
//             .type(InputType.Number)
//             .margin({ bottom: 30 })
//             .onChange((value: string) => {
//               this.userId = parseInt(value) || 1;
//             })
//
//           Button(this.creating ? '创建中...' : '创建文章')
//             .width('100%')
//             .height(50)
//             .enabled(!this.creating)
//             .onClick(() => {
//               this.handleCreate();
//             })
//
//           if (this.message) {
//             Text(this.message)
//               .fontSize(14)
//               .fontColor(this.message.includes('成功') ? Color.Green : Color.Red)
//               .margin({ top: 15 })
//           }
//         }
//         .width('100%')
//       }
//       .width('100%')
//       .height('100%')
//       .padding(20)
//       .backgroundColor('#F5F5F5')
//     }
//     .title('创建文章')
//   }
// }