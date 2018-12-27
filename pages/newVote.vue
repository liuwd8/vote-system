<template>
  <el-form
    :model="ballot"
    class="vertical-center"
    ref="ballot"
    status-icon
    label-width="100px"
    :rules="rules"
  >
    <el-form-item label="议题" prop="title">
      <el-input type="text" v-model="ballot.title"></el-input>
    </el-form-item>
    <el-form-item label="候选人" prop="proposalNames">
      <el-input type="text" v-model="ballot.proposalNames"></el-input>
    </el-form-item>
    <el-form-item>
      <el-button type="primary" @click="submitForm" :loading="loading">提交</el-button>
      <el-button @click="resetForm">重置</el-button>
    </el-form-item>
  </el-form>
</template>

<script scoped>
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
      ballot: {
        title: "",
        proposalNames: ""
      },
      loading: false,
      rules: {
        title: [
          {
            validator: isValidate,
            trigger: "blur",
            message: "议题不能为空",
            regx: /.+/
          }
        ],
        proposalNames: [
          {
            validator: isValidate,
            trigger: "blur",
            message: "候选人不能为空",
            regx: /.+/
          }
        ]
      }
    };
  },
  methods: {
    submitForm() {
      this.loading = true;
      this.$refs.ballot.validate((valid, object) => {
        if (valid) {
          let a = this.$web3.utils.fromAscii(this.ballot.title)
          let b = this.$web3.utils.fromAscii(this.ballot.proposalNames)
          this.$web3.ballotmanagerContract.methods.InitiateVote(a, [b]).send({
            from: this.$root.user.username,
            gas: 4700000
          }).then((data) => {
            this.loading = false
            this.$message({
              type: 'success',
              message: '发布成功'
            })
          }).catch((e) => {
            this.loading = false
            this.$message({
              type: 'error',
              message: e.message
            })
          })
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
      this.$refs.ballot.resetFields();
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
