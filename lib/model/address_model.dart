class AddressModel {
  final String name;
  final String phone;
  final String street;
  final String city;

  AddressModel({
    required this.name,
    required this.phone,
    required this.street,
    required this.city,
  });
}

var listAddress = [
  AddressModel(
    name: "Kristian Nodi Aditria",
    phone: "0822-4293-6628",
    street: "Jalan Karya Barat 1 No 19 16, Rt 8/Rw 3, Wijaya Kusuma (Kost Koe)",
    city: "GROGOL PETAMBURAN, KOTA JAKARTA BARAT, DKI JAKARTA, ID 11460",
  ),
  AddressModel(
    name: "Christina Arum",
    phone: "0822-2312-1234",
    street: "Jalan Kareben Pondok Condong Catur RT 05 RW 07",
    city: "GROGOL PETAMBURAN, KOTA JAKARTA BARAT, DKI JAKARTA, ID 11460",
  ),
];
