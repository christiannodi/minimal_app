import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:minimal_app/theme.dart';

class CustomDropdownExample extends StatefulWidget {
  @override
  _CustomDropdownExampleState createState() => _CustomDropdownExampleState();
}

class _CustomDropdownExampleState extends State<CustomDropdownExample> {
  String? selectedCategory;
  List<String> categories = ["All", "T-shirt", "Polo Shirt", "Outwear"];

  @override
  void initState() {
    super.initState();
    selectedCategory = categories[0]; // Otomatis pilih index 1 ("Polo Shirt")
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Custom Dropdown Example")),
      body: Center(
        child: DropdownButton2<String>(
          isExpanded: true,
          value: selectedCategory,
          items: categories.map((String category) {
            return DropdownMenuItem<String>(
              value: category,
              child: Text(category,
                  style: TextStyle(fontSize: 14, color: Colors.pink)),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              selectedCategory = newValue;
            });
          },
          selectedItemBuilder: (BuildContext context) {
            return categories.map((String item) {
              return Center(
                child: Text(
                  item,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // Warna teks tombol tetap putih
                  ),
                ),
              );
            }).toList();
          },
          buttonStyleData: ButtonStyleData(
            height: 30,
            width: 120,
            padding: EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey),
              color: AppPallete.pink,
            ),
          ),
          dropdownStyleData: DropdownStyleData(
            maxHeight: 210, // Maksimal tinggi dropdown
            width: 100, // Lebar dropdown mengikuti tombol
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), // Border menu dropdown
              color: Colors.white, // Warna latar belakang menu dropdown
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 5,
                  offset: Offset(0, 2),
                ),
              ],
            ),
          ),
          iconStyleData: IconStyleData(
            icon: Icon(Icons.arrow_drop_down,
                color: Colors.white), // Warna ikon putih
            iconSize: 18,
          ),
          menuItemStyleData: MenuItemStyleData(
            padding: EdgeInsets.all(10),
          ),
        ),
      ),
    );
  }
}
