# Simplified and community-driven man pages
* [官网](http://tldr.sh/)
* [github](https://github.com/tldr-pages/tldr)
# 安装
## 只需安装client 即可
1. [web 端](https://tldr.ostera.io/)
2. [bash-client](https://github.com/pepa65/tldr-bash-client)
    - 安装命令
    ```sh
    location=/usr/local/bin/tldr  # elevated privileges needed for some locations
    sudo wget -qO $location https://4e4.win/tldr
    sudo chmod +x $location
    //If the location is not in $PATH, you need to specify the path to run it.
    
    ```
3. [nodejs clent] 
    `npm install -g tldr` 
    需要python
# 使用
* `tldr` 显示使用参数 