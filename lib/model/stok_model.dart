class TotalStokModel {
  final String total;

  TotalStokModel(this.total);
}

class TotalitemStokModel {
  final String totalItems;

  TotalitemStokModel(this.totalItems);
}

class StokModel {
  final String id;
  final String namaBrg;
  final String jumlah;
  final String harga;
  final String satuan;
  final String idBrg;
  final String tglmasuk;
  final String image;
  final String namaSup;

  StokModel(this.namaBrg, this.jumlah, this.harga, this.satuan, this.idBrg,
      this.tglmasuk, this.image, this.id, this.namaSup);
}
