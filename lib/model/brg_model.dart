class BarangModel {
  final String id;
  final String namaBrg;
  final String jumlah;
  final String harga;
  final String satuan;
  final String idPg;
  final String tglmasuk;
  final String image;
  final String namaSup;
  final String nama;

  BarangModel(this.namaBrg, this.jumlah, this.harga, this.satuan, this.idPg,
      this.tglmasuk, this.image, this.id, this.namaSup, this.nama);
}

class BarangKeluarModel {
  final String id;
  final String idBrg;
  final String namaBrg;
  final String jumlah;
  final String satuan;
  final String tglKeluar;

  BarangKeluarModel(this.id, this.idBrg, this.namaBrg, this.jumlah, this.satuan, this.tglKeluar);
}
