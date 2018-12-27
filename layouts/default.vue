<template>
  <el-container class="match-parent">
    <el-header>基于区块链的投票系统</el-header>
    <el-container height="100%" class="match-parent">
      <el-aside width="200px" class="match-parent">
        <el-row class="tac match-parent">
          <el-col class="match-parent">
            <el-menu
              :default-active="this.$route.path.split('?')[1] !== '/' ? this.$route.path.split('?')[0] : '/'"
              class="el-menu-vertical-demo match-parent"
              router
            >
              <el-menu-item index="/voting">
                <i class="el-icon-date"></i>
                <span>参与投票</span>
              </el-menu-item>
              <el-menu-item index="/newVote">
                <i class="el-icon-circle-plus"></i>
                <span>发起投票</span>
              </el-menu-item>
              <el-menu-item index="/winner">
                <i class="el-icon-document"></i>
                <span>查看当前胜利者</span>
              </el-menu-item>
              <el-menu-item index="/" @click="logout">
                <i class="el-icon-error"></i>
                <span v-text="this.$root.user ? '登出' : '登入'"></span>
              </el-menu-item>
            </el-menu>
          </el-col>
        </el-row>
      </el-aside>
      <el-main>
        <nuxt/>
      </el-main>
    </el-container>
  </el-container>
</template>

<script>
export default {
  methods: {
    logout() {
      this.$root.user = null;
      this.$router.replace("/");
    }
  }
};
</script>

<style>
html {
  font-family: "Helvetica Neue", Helvetica, "PingFang SC", "Hiragino Sans GB",
    "Microsoft YaHei", "微软雅黑", Arial, sans-serif;
  font-size: 16px;
  word-spacing: 1px;
  -ms-text-size-adjust: 100%;
  -webkit-text-size-adjust: 100%;
  -moz-osx-font-smoothing: grayscale;
  -webkit-font-smoothing: antialiased;
  box-sizing: border-box;
}
html,
body,
#__nuxt,
#__layout,
.match-parent {
  height: 100%;
}

*,
*:before,
*:after {
  box-sizing: border-box;
  margin: 0;
}

.button--green {
  display: inline-block;
  border-radius: 4px;
  border: 1px solid #3b8070;
  color: #3b8070;
  text-decoration: none;
  padding: 10px 30px;
}

.button--green:hover {
  color: #fff;
  background-color: #3b8070;
}

.button--grey {
  display: inline-block;
  border-radius: 4px;
  border: 1px solid #35495e;
  color: #35495e;
  text-decoration: none;
  padding: 10px 30px;
  margin-left: 15px;
}

.button--grey:hover {
  color: #fff;
  background-color: #35495e;
}

.el-header,
.el-footer {
  background-color: #b3c0d1;
  color: #333;
  text-align: center;
  line-height: 60px;
}

.el-header {
  font-size: xx-large;
}

.el-aside {
  background-color: #d3dce6;
  color: #333;
  text-align: center;
  line-height: 200px;
}

.el-main {
  background-color: #e9eef3;
  color: #333;
  text-align: center;
  padding: 5px;
}

body > .el-container {
  margin-bottom: 40px;
}
</style>
