<template>
  <el-table :data="tableData" border stripe>
    <el-table-column prop="title" label="议题"></el-table-column>
    <el-table-column prop="winner" label="当前胜利者"></el-table-column>
  </el-table>
</template>

<style scoped>
.el-table {
    height: 100%;
}
.el-table td, .el-table th {
    text-align: center;
}
</style>


<script>
export default {
  data() {
    return {
      tableData: []
    };
  },
  created() {
    this.$web3.ballotmanagerContract.methods
      .getBallotTitiles()
      .call()
      .then(data => {
        this.tableData = [];
        data.forEach(element => {
          let a = {};
          a.title = this.$web3.utils.toAscii(
            element.replace(/(00){0,16}/g, "")
          );
          this.$web3.ballotmanagerContract.methods
            .winnerName(element)
            .call()
            .then(data => {
              a.winner = this.$web3.utils.toAscii(
                data.replace(/(00){0,16}/g, "")
              );
              this.tableData.push(a);
            });
        });
      });
  }
};
</script>