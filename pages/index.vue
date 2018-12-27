<template>
  <el-form
    :model="loginForm"
    status-icon
    :rules="rules"
    ref="loginForm"
    label-width="100px"
    class="vertical-center"
    @keyup.enter.native="submitForm"
  >
    <el-form-item label="用户名" prop="username">
      <el-input
        type="text"
        v-model="loginForm.username"
        placeholder="以太坊账户名"
        autocomplete="on"
      ></el-input>
    </el-form-item>
    <el-form-item label="密码" prop="password">
      <el-input type="password" v-model="loginForm.password" placeholder="以太坊密码" autocomplete="off"></el-input>
    </el-form-item>
    <el-form-item>
      <el-button type="primary" @click="submitForm" :loading="loading">提交</el-button>
      <el-button @click="resetForm">重置</el-button>
    </el-form-item>
  </el-form>
</template>

<script>
export default {
  data() {
    var isValidate = (rule, value, callback) => {
      if (!rule.regx.test(value)) {
        callback(new Error(rule.message));
      } else {
        callback();
      }
    };
    return {
      loading: false,
      loginForm: {
        username: null,
        password: null
      },
      rules: {
        username: [
          {
            validator: isValidate,
            trigger: "blur",
            message: "用户名长度为42，且必须以0x开头",
            regx: /^0x[a-fA-F0-9]{40}$/
          }
        ],
        password: [
          {
            validator: isValidate,
            trigger: "blur",
            message: "请输入密码",
            regx: /^/
          }
        ]
      }
    };
  },
  methods: {
    submitForm() {
      this.loading = true;
      this.$refs.loginForm.validate((valid, object) => {
        if (valid) {
          try {
            this.$web3.eth.personal.unlockAccount(
              this.loginForm.username,
              this.loginForm.password,
              (e, data) => {
                this.loading = false;
                if (data) {
                  this.$root.user = this.loginForm;
                  this.$router.replace({ path: "voting" });
                  this.$message({
                    type: "success",
                    message: "登陆成功"
                  });
                } else {
                  this.$message({
                    type: "error",
                    message: "用户名或密码错误"
                  });
                }
              }
            );
          } catch (e) {
            this.$message({
              type: "error",
              message: e.message
            });
          }
        } else {
          this.loading = false;
          let a = "";
          Object.keys(object).forEach(function(key) {
            object[key].forEach(m => {
              a = a + m.message;
            });
          });
          this.$message({
            type: "error",
            message: a
          });
        }
      });
    },
    resetForm() {
      this.$refs.loginForm.resetFields();
    }
  }
};
</script>

<style scoped>
.vertical-center {
  width: 460px;
  position: fixed;
  top: 20%;
  left: 50%;
  margin-left: -230px;
}
</style>
