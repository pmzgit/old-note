## git分布式
1. 每个电脑都有版本控制数据库，有很多工作模式。而svn是只有中央库有版本控制数据库
2. 每个历史版本存储完整的文件，svn存储文件差异
3. git有更强的撤销修改和修改版本历史的能力

## [git 官方网站](http://git-scm.com/)  

## [图解git](http://marklodato.github.io/visual-git-guide/index-zh-cn.html)
* [Git远程操作详解](http://www.ruanyifeng.com/blog/2014/06/git_remote.html)
* [Git 命令清单](http://www.ruanyifeng.com/blog/2015/12/git-cheat-sheet.html)
* [git合并原理](https://www.tripod.fun/2020/06/09/2020/git%E5%90%88%E5%B9%B6%E5%8E%9F%E7%90%861/)
* git-windows 2.8.3 没有乱码问题
## [起步-安装-Git](https://git-scm.com/book/zh/v1/%E8%B5%B7%E6%AD%A5-%E5%AE%89%E8%A3%85-Git#%E4%BB%8E%E6%BA%90%E4%BB%A3%E7%A0%81%E5%AE%89%E8%A3%85)

## .gitconfig 
```sh
[credential "helperselector"]
	selected = manager
[http]
	sslVerify = false
```
## [linux 安装,升级或卸载Git](https://git-scm.com/book/zh/v2/%E8%B5%B7%E6%AD%A5-%E5%AE%89%E8%A3%85-Git)
```
sudo add-apt-repository ppa:git-core/ppa
sudo apt-get update
sudo apt-get install git
// 卸载Git
sudo apt-get remove git


https://mirrors.edge.kernel.org/pub/software/scm/git/

sudo apt-get install dh-autoreconf libcurl4-gnutls-dev libexpat1-dev gettext libz-dev libssl-dev install-info
## 为了添加文档的多种格式（doc、html、info），需要以下附加的依赖
sudo apt-get install asciidoc xmlto docbook2x

make configure
./configure --prefix=/usr
make all doc info
sudo make install install-doc install-html install-info

```
```
	git --version
	//git help clone
	git config --help
	man git-config
	//alias
	git config --global alias.co checkout
	git config --global alias.st status
	git config --global alias.lol "log --oneline"
	//git config crud
	git config --global --add or --unset or name value or --get
	git config --global http.sslVerify false
```
## git ignore 忽略掉已经版本控制的文件
`git rm --cached --force .idea/compiler.xml`
# 搭建本地git 服务器（centos）,亲测有效
### 1 安装（更新）git
参考 ../linux/centos.md 中 centos 编译安装git
### 2 创建一个git用户，用来运行git服务
`adduser git`
### 3 初始化git仓库：这里我们选择/home/git/learngit.git来作为我们的git仓库
`git init --bare learngit.git`  
执行以上命令，会创建一个裸仓库，裸仓库没有工作区，因为服务器上的Git仓库纯粹是为了共享，所以不让用户直接登录到服务器上去改工作区，并且服务器上的Git仓库通常都以.git结尾。然后，把owner改为git：  
`chown -R git:git learngit.git`

### 4 禁用shell登录
* 出于安全考虑，第二步创建的git用户不允许登录shell，这可以通过编辑/etc/passwd文件完成。找到类似下面的一行：

`git:x:1001:1001:,,,:/home/git:/bin/bash`  
改为：  
`git:x:1001:1001:,,,:/home/git:/usr/local/bin/git-shell`  
* 这样，git用户可以正常通过ssh使用git，但无法登录shell，因为我们为git用户指定的git-shell每次一登录就自动退出。

* 注意，上面的说法参考网上的，本人觉得除了这个目的，这么做最主要是因为下面介绍的ssh 免密登陆（否则还要设置git用户密码，每次git push，pull 操作时，输入密码）

### 5 Git服务器打开RSA认证
* Git服务器上首先需要将/etc/ssh/sshd_config中将RSA认证打开，即：
```sh
1.RSAAuthentication yes     
2.PubkeyAuthentication yes     
3.AuthorizedKeysFile  .ssh/authorized_keys
```
* 可以看出公钥存放在.ssh/authorized_keys文件中。所以我们在/home/git下创建.ssh目录，然后创建authorized_keys文件，并将你自己的ssh公钥导入进去（公钥生成见第6步）。  
`cat id_rsa.pub >> .ssh/authorized_keys`

### 6 重要：要保证.ssh和authorized_keys都只有git用户自己有写权限。否则ssh免密登陆配置无效
* 设置所属主，所属组  
`chown -R git:git .ssh`
* 设置文件和目录权限：  
`chmod 700 -R .ssh`  
### 7 创建ssh rsa 公私密钥对（这里的公钥就是指第四步中的需要的公钥）

* 在客户端所在机器的用户主目录下，看看有没有.ssh目录，如果有，再看看这个目录下有没有id_rsa和id_rsa.pub这两个文件，如果已经有了，可直接跳到下一步。如果没有，打开Shell（Windows下打开Git Bash），创建SSH Key：  
`ssh-keygen -t rsa -C "youremail@example.com"`  
* 你需要把邮件地址换成你自己的邮件地址，然后一路回车，使用默认值即可，由于这个Key也不是用于军事目的，所以也无需设置密码。
* 如果一切顺利的话，可以在用户主目录里找到.ssh目录，里面有id_rsa和id_rsa.pub两个文件，这两个就是SSH Key的秘钥对，id_rsa是私钥，不能泄露出去，id_rsa.pub是公钥，可以放心地告诉任何人。

### 8 此时在客户端就可以clone 我们第3步创建的git远程仓库了

`git clone git@192.168.8.34:/home/git/learngit.git`  

### 注意： 但是有的时候可能我们现有客户端项目，后来才创建git远程仓库，那么如何关联本地git项目和远程仓库呢
* 1. 在项目根目录 执行 `git init` 把当前项目加入版本控制
* 2. `git add .` 和 `git commit -m "init"` 提交一个版本
* 3. 关联远程库，使用命令  
`git remote add origin git@server-name:path/repo-name.git`
* 关联后，使用命令git pull origin master --allow-unrelated-histories 和 git push -u origin master第一次推送master分支的所有内容；（第一次推送远程仓库没有该分支时，使用这个命令可以完成本地新分支与远程新分支的跟踪）
* 此后，每次本地提交后，只要有必要，就可以使用命令git push origin master推送最新修改；

* https://git-scm.com/book/zh/v2/%E6%9C%8D%E5%8A%A1%E5%99%A8%E4%B8%8A%E7%9A%84-Git-%E5%8D%8F%E8%AE%AE

## git diff 查看文件内容修改
* 要随时掌握工作区的状态，使用git status命令。 
* 如果git status告诉你有文件被修改过，用git diff可以查看修改内容,注意，从上到下看。

`git diff filename`:工作区与暂存区差异     
`git diff <branch> <filename>`也可查看和另一分支的区别。


`git diff --cached filename`: 暂存区与历史记录差异  
`git diff --cached HEAD~2 filename`: 暂存区与历史记录差异 


`git diff HEAD filename`: 工作区 与 历史记录 差异  


`git diff HEAD HEAD~2`:当前历史记录与上一个历史记录差异（横向，注意顺序）  
`git diff --color-words`: 同一行单词差异，不同颜色，推荐用此command  
`git diff --word-diff` :强烈推荐，增减，不同颜色  

* HEAD指向的版本就是当前版本，因此，Git允许我们在版本的历史之间穿梭，使用命令git reset --hard commit_id（例如git reset --hard HEAD～返回上一个版本）。此时，head和分支指向当前commit_id，工作区和暂存区在当前commit_id之后的修改都被丢掉。 (--mixed 只修改暂存区，--soft只移动master和head)
穿梭前，用git log可以查看提交历史，以便确定要回退到哪个版本。git log --decorate --graph --oneline --all(查看所有分支commit，tag信息)  
要重返未来，用git reflog查看命令历史，以便确定要回到未来的哪个版本。 

## git 工作流程

* 配置用户名   
`git config --global user.name "Your Name"`  
`git config --global user.email "email@example.com"`  
user.name pmzgit user.email pmz00  
因为是分布式所以必须每台机器进行认证,注意git config命令的--global参数，用了这个参数，表示你这台机器上所有的Git仓库都会使用这个配置，当然也可以对某个仓库指定不同的用户名和Email地址。
* git config -l --local 列出该仓库下的参数  
* 配置有三个级别，优先级由高到低 --local --global(当前用户) --system（当前系统所有用户）

概括来说整个引用关系就是：HEAD里面的内容是当前分支的ref，而当前ref的内容是commit hash，commit object内容是 tree hash，tree object的内容是blob hash，blob存储着文件的具体内容

* git 使用40个16进制字符的	SHA-1 Hash 来唯一标识对象。	git 有四种对象：tag -> commit -> tree > blob (tree包含tree和blob对象，树形结构)

* 初始化一个Git仓库（两种方式）
1. 使用git init命令。在当前文件夹下初始化 `git init`. 
2. git clone local_repo dist_dir_name

* 添加文件到Git仓库，分两步:    
第一步，使用命令git add <file>，注意，可反复多次使用，添加多个文件 `git add a.md b.txt`；  
第二步，使用命令git commit，完成。

 


版本库（Repository）：工作区有一个隐藏目录.git，这个不算工作区，而是Git的版本库。

Git的版本库里存了很多东西，其中最重要的就是称为stage（或者叫index）的暂存区，还有Git为我们自动创建的第一个分支master，以及指向master的一个指针叫HEAD。
前面讲了我们把文件往Git版本库里添加的时候，是分两步执行的：

第一步是用git add把文件添加进去，实际上就是把文件修改添加到暂存区；

第二步是用git commit提交更改，实际上就是把暂存区的所有内容提交到当前分支。

因为我们创建Git版本库时，Git自动为我们创建了唯一一个master分支，所以，现在，git commit就是往master分支上提交更改。

你可以简单理解为，需要提交的文件修改通通放到暂存区，然后，一次性提交暂存区的所有修改。

现在，你又理解了Git是如何跟踪修改的，每次修改，如果不add到暂存区，那就不会加入到commit中


* 命令git checkout -- readme.txt意思就是，把readme.txt文件在工作区的修改全部撤销，这里有两种情况：(note: `git checkout commitid/tag/分支明/HEAD~n -- file`: 用指定的历史提交的暂存区和工作区，覆盖当前的暂存区和工作区。同理`git reset commitid/tag/分支名 -- file`,则只是覆盖暂存区的内容)  
一种是readme.txt自修改后还没有被放到暂存区，现在，撤销修改就回到和版本库一模一样的状态,实际上是用暂存区对象复制到工作区，来达到撤销工作区修改的目的；  
一种是readme.txt已经添加到暂存区后，又作了修改，现在，撤销修改就回到添加到暂存区后的状态。  
总之，就是让这个文件回到最近一次git commit或git add时的状态。  
git reset命令既可以回退版本，也可以把暂存区的修改回退到工作区。当我们用HEAD时，表示最新的版本。  

又到了小结时间。

场景1：当你改乱了工作区某个文件的内容，想直接丢弃工作区的修改时，用命令git checkout -- file。

场景2：当你不但改乱了工作区某个文件的内容，还添加到了暂存区时，想丢弃修改，分两步，第一步用命令git reset HEAD file，就回到了场景1，此时，暂存区与当前历史提交没有差异，实际上也是向下复制，第二步按场景1操作。

场景3：已经提交了不合适的修改到版本库时，想要撤销本次提交，参考版本回退一节，不过前提是没有推送到远程库。

* Git中，删除也是一个修改操作，我们实战一下，先添加一个新文件test.txt到Git并且提交：一般情况下，你通常直接在文件管理器中把没用的文件删了，或者用rm命令删了：
这个时候，Git知道你删除了文件，因此，工作区和版本库就不一致了，git status命令会立刻告诉你哪些文件被删除了：
现在你有两个选择，一是确实要从版本库中删除该文件，那就用命令git rm删掉，并且git commit：
现在，文件就从版本库中被删除了。`git rm file` 删除了工作区和暂存区 `git rm --cached file` 只删除了暂存区  
另一种情况是删错了，因为版本库里还有呢，所以可以很轻松地把误删的文件恢复到最新版本：git checkout -- test.txt  
git checkout其实是用版本库里的版本替换工作区的版本，无论工作区是修改还是删除，都可以“一键还原”。
命令git rm用于删除一个文件。如果一个文件已经被提交到版本库，那么你永远不用担心误删，但是要小心，你只能恢复文件到最新版本，你会丢失最近一次提交后你修改的内容。

* `git mv file1.txt file2.txt` 重命名操作，工作区和暂存区文件名都更改了，但是根据文件内容生成的暂存区索引SHA-1 Hash码，并没有更改，因为只是重命名操作，内容并没有更改。



* 要克隆一个仓库，首先必须知道仓库的地址，然后使用`git clone`命令克隆。  
`git clone git@github.com:michaelliao/gitskills.git （destion dir）`克隆到的仓库会有一个origin/master（远程跟踪分支，用户只读），据其还会产生一个master分支（跟踪分支，用户可写），指向最新commit（HEAD）

* Git支持多种协议，包括https，但通过ssh支持的原生git协议速度最快。
## git 分支
* Git鼓励大量使用分支：分支只是指向某个commit对象的引用

查看当前分支：git branch
git branch --remote
创建分支：git branch name

切换分支：git checkout name

创建+切换分支：git checkout -b name

删除分支：git branch -d name

* 合并某分支到当前分支  
git merge name   
(当远程分支有新的commit，首先要git fetch origin下来，这时候本地的origin/master移向最新的commit，所以要用git merge origin/master（线性历史） 使本地master指向最新的提交)  
这两个操作=git pull  推荐分开，因为可以用git diff origin/master master 查看远程的版本与本地历史区别

> [remote "origin"]   
 
	url = git@github.com:pmzgit/note.git
	fetch = +refs/heads/*:refs/remotes/origin/*
		远程仓库master分支（refs/heads/master：commit SHA1 hash）
		本地远程跟踪origin/master分支（refs/remotes/origin/master：commit SHA1 hash）
		+ 代表强制non-fast-forward  不建议修改远程仓库店历史commit（例如版本倒退，并覆盖），也不建议强制push（git push origin +master）
		否则别人fetch时（此时强制+）


* 当Git无法自动合并分支时，就必须首先解决冲突。  
解决冲突后，再提交，合并完成。或者放弃本次合并操作： `git merge --abort`

* 用git log --graph命令可以看到分支合并图。   
`git log --graph --pretty=oneline --abbrev-commit`


* 分支管理策略  
在实际开发中，我们应该按照几个基本原则进行分支管理：
1. 首先，master分支应该是非常稳定的，也就是仅用来发布新版本，平时不能在上面干活；
那在哪干活呢？干活都在dev分支上，也就是说，dev分支是不稳定的，到某个时候，比如1.0版本发布时，再把dev分支合并到master上，在master分支发布1.0版本；  
你和你的小伙伴们每个人都在dev分支上干活，每个人都有自己的分支，时不时地往dev分支上合并就可以了。

Git分支十分强大，在团队开发中应该充分应用。

* 合并分支时，加上--no-ff参数就可以用普通模式合并，合并后的历史有分支，能看出来曾经做过合并，而fast forward合并就看不出来曾经做过合并。
* bug分支
修复bug时，我们会通过创建新的bug分支进行修复，然后合并，最后删除；

当手头工作没有完成时，先把工作现场git stash一下，然后去修复bug，修复后，再git stash pop，回到工作现场。
http://www.liaoxuefeng.com/wiki/0013739516305929606dd18361248578c67b8067c8c017b000/00137602359178794d966923e5c4134bc8bf98dfb03aea3000
`git stash save -a "stash_name"`  
`git stash list`  
`git stash pop --index stash_ref` = `git stash apply --index stash@{0}` and `git stash drop stash@{0}`  
`git stash clear` 删除所有stash

开发一个新feature，最好新建一个分支；

如果要丢弃一个没有被合并过的分支，可以通过git branch -D <name>强行删除。


因此，多人协作的工作模式通常是这样：

现在，你的小伙伴要在dev分支上开发，就必须创建远程origin的dev分支到本地，于是他用这个命令创建本地dev分支：

$ git checkout -b dev origin/dev（此时也完成了远程dev分支与本地新建dev分支的跟踪绑定）

首先，可以试图用git push origin branch-name推送自己的修改；

如果推送失败，则因为远程分支比你的本地更新，需要先用git pull试图合并；

如果合并有冲突，则解决冲突，并在本地提交；

没有冲突或者解决掉冲突后，再用git push origin branch-name推送就能成功！

如果git pull提示“no tracking information”，则说明本地分支和远程分支的链接关系没有创建，用命令git branch --set-upstream-to=origin/dev dev（旧版本git  该命令为git branch --track | --set-upstream dev origin/dev 此时本地 .git/config 文件zhong新增一项配置：
[branch "dev"]
	remote = origin
	merge = refs/heads/dev
merge指 本地dev 跟踪远程的ref/heads/下的dev分支
`git checkout remote_branch` :如果远程仓库存在本地不存在的分支时，可以用  `git fetch origin` 后，再用开头的命令直接用fetch后的远程跟踪分支信息创建并跟踪了一个与远程分支对应的本地分支。  
**使用修改配置方式，新建分支并跟踪远程分支**  
`git branch dev`  
`git config branch.dev.remote origin` : 设置跟踪远程仓库信息，制定origin对应的remote配置    
`git config branch.dev.merge refs/heads/dev` : 表示跟踪远程仓库的 dev分支

这就是多人协作的工作模式，一旦熟悉了，就非常简单。

小结

查看远程库信息，使用git remote -v；

本地新建的分支如果不推送到远程，对其他人就是不可见的；

从本地推送分支，使用git push origin branch-name，如果推送失败，先用git pull抓取远程的新提交；

在本地创建和远程分支对应的分支，使用git checkout -b branch-name origin/branch-name，本地和远程分支的名称最好一致（若此时远程已有分支v1 git fetch origin 后 可直接用 git checkout v1 创建并跟踪远程v1）；

建立本地分支和远程分支的关联，使用git branch --set-upstream-to=origin/dev dev

从远程抓取分支，使用git pull，如果有冲突，要先处理冲突。

* `git commit --amend` : use a new commit replace current commit.    
`git rebase master` 合并分支的另一种方法，线性合并，在master重演当前分支历史（注意从HEAD后开始演示当前分支所有的历史提交，但是从HEAD之后新生成的提交历史hash，所以经常要处理冲突），以使master分支历史呈线性的。可以指定要重演当前分支指定提交版本分界，注意不包含该分界点。`git rebase --onto master current_certain_commitid` ,[官方文档：分支衍合](https://git-scm.com/book/zh/v1/Git-分支-分支的衍合)




* Git的标签虽然是版本库的快照，但其实它就是指向某个commit的指针（跟分支很像对不对？但是分支可以移动，标签不能移动），所以，创建和删除标签都是瞬间完成的。  
命令git tag name用于新建一个标签，默认为HEAD，也可以指定一个commit id；  
git tag -a tagname -m "blablabla..."可以指定标签信息；  
git tag -s tagname -m "blablabla..."可以用PGP签名标签；

命令git tag可以查看所有标签。`git show tag_name` show detail tag info

git checkout tag_name

git checkout -b branch_name tag_name

命令git push origin <tagname>可以推送一个本地标签；

命令git push origin --tags可以推送全部未推送过的本地标签；

命令git tag -d <tagname>可以删除一个本地标签；

命令git push origin :refs/tags/<tagname>可以删除一个远程标签。


让Git显示颜色，会让命令输出看起来更醒目：git config --global color.ui true


* 忽略某些文件时，需要编写.gitignore；  
.gitignore文件本身要放到版本库里，并且可以对.gitignore做版本管理！

* 读取规则：

自上向下，如果前面包含了后面的规则，后面规则就没有写的意义了，如果冲突，前面的规则也没有了意义。

管理规则：
path        过滤文件，不对该文件或文件夹进行管理

!path       !表示消除对于该文件和文件夹的过滤

path规则：
/folder/        文件夹，以/结尾表示文件夹，过滤文件夹，即该文件夹下的所有文件都不放入管理

/filename               文件，过滤文件

/name                   以/开头表示仅代表当前目录，没有/表示任意目录，即相当于前面加了*号符

通配符：
*            表示0~多个（包括多级目录和多个字符）

？          表示1个字符

/*/          表示匹配一级目录

/**/         表示多级目录

已跟踪的文件取消跟踪：
git update-index  --assume-unchanged PATH               不对特定文件检查，每次都要操作，比较麻烦

git rm -r --cached PATH                     取消对特定文件的追踪，--cached表示不删除本地文件，这个时候在.gitignore配置对应的文件，就能生效了。不过他会删除服务器端的对应文件。-r表示递归，用于文件夹。

如果是由于不同环境开发，使用不同版本的数据库之类的问题，可以建立一个备份文件，比如在后面加上.example，取消源文件的追踪。

* 未跟踪的文件的删除  
`git clean -n`:提醒git会删除那些文件。  
`git clean -f`:git会强制删除由以上命令提醒要删除的文件  
`git clean -n -X`: 与.gitignore 文件相反，会提醒要删除的文件中配置的文件  
`git clean -X -f`: 同楼上  

* `git rever commitid` 对commitid引入的改变取反， 然后应用到新的提交，并移动分支和HEAD 到新的提交。
设置别名：http://www.liaoxuefeng.com/wiki/0013739516305929606dd18361248578c67b8067c8c017b000/001375234012342f90be1fc4d81446c967bbdc19e7c03d3000

git@github.com:pmzgit/note.git


git commit -m "waf 模块前后端联调" --no-verify


# git 凭证存储
git config --global credential.helper store

# fork 
[远程跟踪分支](https://git-scm.com/book/zh/v2/Git-%E5%88%86%E6%94%AF-%E8%BF%9C%E7%A8%8B%E5%88%86%E6%94%AF)
https://www.jianshu.com/p/d73dcee2d907
https://www.jianshu.com/p/4f4c04c6e98b
```sh
git checkout -b dev-20.11.01
git branch --set-upstream-to=origin/dev-20.07.01 dev-20.07.01




git push -u origin dev-20.07.01
git pull origin dev:dev

# 创建并拉取想要的远端分支代码 
git branch -avv
git checkout -t origin/daily/1.4.1

git remote -v
git remote add upstream https://github.com/ORIGINAL_OWNER/ORIGINAL_REPOSITORY.git

git checkout --track origin/confirm

git fetch upstream # 并会被存储在一个本地分支 upstream/master默认会将远程所有的分支fetch下来
git checkout dev-20.07.01
git merge upstream/dev-20.11.01 #把 upstream/dev-20.07.01 分支合并到本地 dev-20.07.01 上

git push origin dev-20.11.01:dev-20.11.01 #将本地仓库dev分支的代码推送到自己远程仓库B的dev分支上

更新远程地址  
git remote set-url origin https://github.com/pmzgit/life.git   
git remote rm <主机名>
建立追踪关系，在现有分支与指定的远程分支之间
git branch -u [remote-branch] 
git checkout -b serverfix origin/serverfix
git pull <远程主机名> <远程分支名>:<本地分支名>
git push <远程主机名> <本地分支名>:<远程分支名>

# 删除远程分支
git push origin --delete serverfix

# 本地分支重命名
git branch -m <new_name>
```



