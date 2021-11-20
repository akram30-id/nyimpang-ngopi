class BalanceSheetModel {
  final String id_branch;
  final String kecamatan;
  final String image;
  final String pemasukan;
  final String pengeluaran;
  final String modal;
  final String tgl;
  final String id;

  BalanceSheetModel(this.id_branch, this.kecamatan, this.image, this.pemasukan,
      this.pengeluaran, this.modal, this.tgl, this.id);
}

class TotalSalesModel {
  final String totalSales;

  TotalSalesModel(this.totalSales);
}
