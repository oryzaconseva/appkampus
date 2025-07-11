// lib/screens/add_edit_kampus_screen.dart

import 'package:app_kampus/models/kampus.dart';
import 'package:app_kampus/providers/kampus_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddEditKampusScreen extends StatefulWidget {
  final Kampus? kampus;
  const AddEditKampusScreen({super.key, this.kampus});

  @override
  State<AddEditKampusScreen> createState() => _AddEditKampusScreenState();
}

class _AddEditKampusScreenState extends State<AddEditKampusScreen> {
  final _formKey = GlobalKey<FormState>();
  late bool _isEditMode;

  final _namaController = TextEditingController();
  final _alamatController = TextEditingController();
  final _telpController = TextEditingController();
  final _jurusanController = TextEditingController();
  final _latController = TextEditingController();
  final _longController = TextEditingController();
  String? _kategoriValue;

  @override
  void initState() {
    super.initState();
    _isEditMode = widget.kampus != null;
    if (_isEditMode) {
      _namaController.text = widget.kampus!.nama;
      _alamatController.text = widget.kampus!.alamat;
      _telpController.text = widget.kampus!.noTelp;
      _jurusanController.text = widget.kampus!.jurusan;
      _latController.text = widget.kampus!.latitude.toString();
      _longController.text = widget.kampus!.longitude.toString();
      _kategoriValue = widget.kampus!.kategori;
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _alamatController.dispose();
    _telpController.dispose();
    _jurusanController.dispose();
    _latController.dispose();
    _longController.dispose();
    super.dispose();
  }

  void _saveForm() async {
    if (_formKey.currentState!.validate()) {
      final kampusProvider = Provider.of<KampusProvider>(context, listen: false);
      final data = {
        "nama_kampus": _namaController.text, "alamat": _alamatController.text, "no_telpon": _telpController.text,
        "kategori": _kategoriValue!, "latitude": _latController.text, "longitude": _longController.text,
        "jurusan": _jurusanController.text,
      };

      bool success = _isEditMode
          ? await kampusProvider.updateKampus(widget.kampus!.id, data)
          : await kampusProvider.addKampus(data);

      if (mounted) {
        if (success) {
          Navigator.of(context).pop();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(kampusProvider.errorMessage ?? 'Gagal menyimpan data'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
      ),
      validator: validator,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditMode ? 'Edit Kampus' : 'Tambah Kampus'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTextField(controller: _namaController, label: 'Nama Kampus', icon: Icons.school_outlined, validator: (v) => v!.isEmpty ? 'Wajib diisi' : null),
              const SizedBox(height: 16),
              _buildTextField(controller: _alamatController, label: 'Alamat', icon: Icons.location_on_outlined, validator: (v) => v!.isEmpty ? 'Wajib diisi' : null),
              const SizedBox(height: 16),
              _buildTextField(controller: _telpController, label: 'No. Telepon', icon: Icons.phone_outlined, keyboardType: TextInputType.phone, validator: (v) => v!.isEmpty ? 'Wajib diisi' : null),
              const SizedBox(height: 16),
              _buildTextField(controller: _jurusanController, label: 'Jurusan Unggulan', icon: Icons.star_outline, validator: (v) => v!.isEmpty ? 'Wajib diisi' : null),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(child: _buildTextField(controller: _latController, label: 'Latitude', icon: Icons.map_outlined, keyboardType: TextInputType.number, validator: (v) => v!.isEmpty ? 'Wajib diisi' : null)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildTextField(controller: _longController, label: 'Longitude', icon: Icons.map_outlined, keyboardType: TextInputType.number, validator: (v) => v!.isEmpty ? 'Wajib diisi' : null)),
                ],
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: _kategoriValue,
                decoration: const InputDecoration(
                  labelText: 'Kategori',
                  prefixIcon: Icon(Icons.category_outlined),
                ),
                items: ['Swasta', 'Negeri'].map((kategori) => DropdownMenuItem(value: kategori, child: Text(kategori))).toList(),
                onChanged: (value) => setState(() => _kategoriValue = value),
                validator: (v) => v == null ? 'Wajib dipilih' : null,
              ),
              const SizedBox(height: 32),

              Consumer<KampusProvider>(
                builder: (context, provider, child) {
                  return SizedBox(
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: provider.isLoading ? null : _saveForm,
                      icon: provider.isLoading ? Container() : const Icon(Icons.save),
                      label: provider.isLoading
                          ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
                          : const Text('Simpan Data', style: TextStyle(fontSize: 16)),
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
