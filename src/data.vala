class Data {
  private string[,] data;
  public Data() {
  
    this.data = {
      {"data1.1", "data1.2", "data1.3"},
      {"data2.1", "data2.2", "data2.3"},
      {"data3.1", "data3.2", "data3.3"},
      {"data4.1", "data4.2", "data4.3"},
      {"data5.1", "data5.2", "data5.3"},
    };
  }

  public string[,] get_data() {
    return data;
  }
}
