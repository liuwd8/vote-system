<template>
  <div>
    <el-form
      :model="votingForm"
      status-icon
      label-width="100px"
      ref="votingForm"
      :rules="rules"
      class="vertical-center"
    >
      <el-form-item label="议题" prop="title">
        <el-select v-model="votingForm.title" filterable placeholder="请选择" @change="refresh">
          <el-option
            v-for="item in options"
            :key="item"
            :label="item"
            :value="item">
          </el-option>
        </el-select>
      </el-form-item>
      <el-form-item label="候选人" prop="proposal" class="align-left">
        <el-radio-group v-model="votingForm.proposal">
          <el-radio-button
            v-for="(value, index) in proposals"
            :key="index"
            :label="index"
          >{{ value }}</el-radio-button>
        </el-radio-group>
      </el-form-item>
      <el-form-item label="选项">
        <el-button @click="showDialog2" type="primary">委托给他人投票</el-button>
        <el-button @click="showDialog" type="danger">添加新的候选人</el-button>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" @click="submit" :loading="loading">提交</el-button>
        <el-button @click="reset">重置</el-button>
      </el-form-item>
    </el-form>
    <el-dialog :visible.sync="dialogFormVisible">
      <el-form
        :model="newProposal"
        status-icon
        ref="newProposal"
        label-width="100px"
        :rules="rules2"
      >
        <el-form-item label="候选人" prop="name">
          <el-input v-model="newProposal.name" placeholder="候选人"></el-input>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="resetDialog">取 消</el-button>
        <el-button type="primary" @click="addProposal" :loading="loading2">确 定</el-button>
      </div>
    </el-dialog>
    <el-dialog :visible.sync="dialogFormVisible2">
      <el-form
        :model="person"
        status-icon
        ref="person"
        label-width="100px"
        :rules="rules3"
      >
        <el-form-item label="委托人地址" prop="address">
          <el-input v-model="person.address" placeholder="候选人"></el-input>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="resetDialog2">取 消</el-button>
        <el-button type="primary" @click="delegate" :loading="loading3">确 定</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<style scoped>
.vertical-center {
  width: 460px;
  position: fixed;
  top: 20%;
  left: 50%;
  margin-left: -230px;
}
.el-autocomplete {
  width: 100%;
}
.el-dialog {
  width: 600px;
}
.align-left {
  text-align: left;
}
.name {
  text-overflow: ellipsis;
  overflow: hidden;
}
.el-select {
  width: 100%;
}
</style>

<script>
export default {
  data() {
    var validateProposal = (rule, value, callback) => {
      if (!value) {
        callback(new Error("新候选人不能为空"));
      } else if (this.proposals.indexOf(value) !== -1) {
        callback(new Error("该候选人已在列表中"));
      } else {
        callback();
      }
    };
    var validateAddress = (rule, value, callback) => {
      if (!rule.regx.test(value)) {
        callback(new Error(rule.message));
      } else {
        callback();
      }
    };
    return {
      proposals: [],
      options: [],
      loading: false,
      dialogFormVisible: false,
      dialogFormVisible2: false,
      loading2: false,
      loading3: false,
      newProposal: {
        name: ""
      },
      person: {
        address: ''
      },
      state: "",
      votingForm: {
        title: "",
        proposal: 0
      },
      rules: {
        title: [
          {
            required: true,
            message: "议题不能为空"
          }
        ]
      },
      rules2: {
        name: [
          {
            required: true,
            message: "新候选人不能为空"
          },
          {
            validator: validateProposal,
            trigger: "blur"
          }
        ]
      },
      rules3: {
        address: [
          {
            validator: true,
            message: '委托人地址不合法',
            validator: validateAddress,
            regx: /^0x[a-fA-F0-9]{40}$/
          }
        ]
      }
    };
  },
  created() {
    this.$web3.ballotmanagerContract.methods.getBallotTitiles().call()
      .then((data) => {
        this.options = []
        let a = "";
        data.forEach(element => {
          a = this.$web3.utils.toAscii(element.replace(/(00){0,16}/g, ""));
          this.options.push(a);
        });
      })
  },
  methods: {
    querySearch(queryString, cb) {
      var proposals = this.proposals;
      var results = queryString
        ? proposals.filter(this.createFilter(queryString))
        : proposals;
      cb(results);
    },
    createFilter(queryString) {
      return proposal => {
        return proposal.toLowerCase().indexOf(queryString.toLowerCase()) === 0;
      };
    },
    submit() {
      this.loading = true;
      this.$refs.votingForm.validate((valid, object) => {
        if (valid) {
          this.$web3.eth.personal.unlockAccount(
            this.$root.user.username,
            this.$root.user.password,
            (e, data) => {
              let a = this.$web3.utils.fromAscii(this.votingForm.title);
              let b = this.$web3.utils.toBN(this.votingForm.proposal)
              this.$web3.ballotmanagerContract.methods.vote(a, b).send({
                from: this.$root.user.username,
                gas: 4700000
              }).then((data) => {
                this.loading = false
                this.$message({
                  type: 'success',
                  message: '投票成功'
                })
              }).catch((e) => {
                this.loading = false
                this.$message({
                  type: 'error',
                  message: e.message
                })
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
    reset() {
      this.$refs.votingForm.resetFields();
      this.loading = false;
    },
    resetDialog() {
      this.$refs.newProposal.resetFields()
      this.dialogFormVisible = false;
      this.loading2 = false;
    },
    resetDialog2() {
      this.$refs.person.resetFields()
      this.dialogFormVisible2 = false;
      this.loading3 = false;
    },
    addProposal() {
      this.loading2 = true;
      this.$refs.newProposal.validate((valid, object) => {
        if (valid) {
          this.$web3.eth.personal.unlockAccount(
            this.$root.user.username,
            this.$root.user.password,
            (e, data) => {
              let a = this.$web3.utils.fromAscii(this.votingForm.title);
              let b = this.$web3.utils.fromAscii(this.newProposal.name);
              this.$web3.ballotmanagerContract.methods.addProposal(a, b).send({
                from: this.$root.user.username
              }).then((data) => {
                this.loading2 = false
                this.dialogFormVisible = false
                this.refresh()
              }).catch((e) => {
                this.loading2 = false
                console.log(e)
                this.$message({
                  type: "error",
                  message: e.message
                });
              })
            })
        } else {
          this.loading2 = false;
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
    delegate() {
      this.loading3 = true;
      this.$refs.person.validate((valid, object) => {
        if (valid) {
          this.$web3.eth.personal.unlockAccount(
            this.$root.user.username,
            this.$root.user.password,
            (e, data) => {
              let a = this.$web3.utils.fromAscii(this.votingForm.title)
              this.$web3.ballotmanagerContract.methods.delegate(a, this.person.address).send({
                from: this.$root.user.username
              }).then((data) => {
                this.loading3 = false
                this.dialogFormVisible2 = false
              }).catch((e) => {
                this.loading3 = false
                console.log(e)
                this.$message({
                  type: "error",
                  message: e.message
                });
              })
            })
        } else {
          this.loading3 = false;
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
    showDialog() {
      this.$refs.votingForm.validate((valid, object) => {
        if (valid) {
          this.dialogFormVisible = true;
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
    showDialog2() {
      this.$refs.votingForm.validate((valid, object) => {
        if (valid) {
          this.dialogFormVisible2 = true;
        } else {
          this.loading3 = false;
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
    refresh(callback) {
      if (typeof callback !== 'function') {
        callback = function() {}
      }
      let a = this.$web3.utils.fromAscii(this.votingForm.title);
      this.$web3.ballotmanagerContract.methods
        .getProposals(a)
        .call()
        .then(data => {
          if (data.length) {
            this.proposals = [];
            let a = "";
            data.forEach(element => {
              a = this.$web3.utils.toAscii(element.replace(/(00){0,16}/g, ""));
              this.proposals.push(a);
            });
            callback();
          } else {
            callback(new Error("议题不存在"));
          }
        })
        .catch(() => {
          callback(new Error("议题不存在"));
        })
    }
  }
};
</script>
