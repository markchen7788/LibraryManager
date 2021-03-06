# 图书管理系统

#### 介绍
《数据库原理》课程设计，一个Javaweb项目

#### 环境与架构
1.  环境：Eclipse+Mysql
2.  架构：Jsp+servelet+Javabean(页面显示用了一些Layui的模块)

#### 需求分析
##### 1）读者：
1.  图书的查询：图书的查询可以通过搜索图书id、书名、作者名、出版社来实现,显示结果中需要包括书籍信息以及是否被借阅的情况；
2.  图书的借阅：借阅图书时，需要判断该读者现已借阅的图书数量，若超过3本，则暂时不能借书；若尚有未缴纳罚金，暂时不能借书；否则点击“确认借阅 ”，即完成借阅。
3.  图书的归还：归还图书时，若尚有罚金未缴纳，提示学生去管理中心线下缴纳罚金再进行线下还书；否则界面显示所有待还书籍的信息，点击“确认还书”或输入图书id再点击“确认”即完成还书。
4.  查看、修改个人信息：个人信息包括用户id、姓名、密码、姓名以及电话；修改个人信息：包括修改姓名、密码、性别、电话等，其中用户id不可修改。
5.  查询借阅历史：通过输入书籍的id、书名、作者或出版社来查询借阅记录；记录内容包括读者id、书籍信息和借阅的开始日期以及结束日期；若书籍尚未归还，“结束日期”后会显示“尚未归还”。
6.  查看处罚记录：处罚记录的内容包括违规的借阅记录的信息；如若相关书籍仍未进行线下归还且读者也未缴纳罚金，则提示尚未缴纳罚金；否则显示该条借阅记录的超期天数。
7.  注册
##### 2）管理员：
1.  添加图书：输入图书的Id、书名、作者、出版社、其他信息，系统将信息导入数据库；
2.  删除图书：如果书籍未被借出，则可通过鼠标点击“删除图书”来完成删除任务；否则不能进行删除。
3.  修改图书信息：通过点击“修改信息”，打开修改图书信息页面，修改相应信息后(书名、作者、出版社、其他信息)，点击保存；
4.  借阅处罚管理：输入用户id，可以查看用户的借阅违规处罚情况，用户缴纳罚款后，可点击“缴纳罚款”，撤销对该生的处罚，恢复其正常借阅和归还权利；
5.  权限管理：输入最长借阅天数可修改读者最长借阅期限；点击“开启”、“关闭”按钮可以开启或者关闭“黑名单”功能。
6.  用户管理：可以输入读者id或者姓名来查找读者，点击“删除用户”可以删除该用户；若“黑名单”功能被启用，可以点击“加入黑名单”、“移除黑名单”来控制用户的登陆权限。
7.  管理员个人信息修改（主要是修改密码）；

#### 更多详情信息可参看[设计文档](./设计文档.docx)