# vote

> block chain app
## 使用说明
1. 使用`npm`安装依赖，其中`web3`需要`python2`的支持
   ```sh
   npm install
   ```
2. 使用`remix`编译`contract/vote.sol`,在geth或其他支持`web3`的客户端上发布合约.
3. 将得到的合约地址填入`plugins/web3.js`的下述代码中
   ```javascript
    web3.eth.getAccounts().then((data) => {
        web3.from = data[0]
        //将这里的第二个参数改为 你得到的地址
        web3.ballotmanagerContract = new web3.eth.Contract(abi, '0x9342ba7ea1b1833e4070130252549a02021c1087')
    })
   ```
4. 开始挖矿
5. 运行服务器，服务器只提供页面渲染服务，数据均由`web3`提供，即数据均保存在区块链上
   ```sh
    //开发者模式
    npm run dev
   ```
   ```sh
    //非开发者模式
    $ npm run build
    $ npm start
   ```
   ```sh
    //生成静态项目
    npm run generate
   ```
6. 在浏览器中输入`127.0.0.1:8080`可查看运行效果
7. 不提供注册，需自行在geth客户端中新建账户。