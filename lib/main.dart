import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AppColor {
  static const Color background = Color(0xFFF5F5F5);
  static const Color gradientEnd = Color(0xFF6C754B);
}

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HasilUjianPage(),
    ),
  );
}

// =====================================================
// MODEL MAHASISWA
// =====================================================

class Mahasiswa {
  final String nama;
  final String npm;
  final String jurusan;
  final double nilai;
  final Uint8List? foto;

  Mahasiswa({
    required this.nama,
    required this.npm,
    required this.jurusan,
    required this.nilai,
    this.foto,
  });

  bool get lulus => nilai >= 60;

  String get statusText => lulus ? 'Lulus' : 'Tidak Lulus';
}

// =====================================================
// HALAMAN HASIL UJIAN
// =====================================================

class HasilUjianPage extends StatefulWidget {
  const HasilUjianPage({super.key});

  @override
  State<HasilUjianPage> createState() => _HasilUjianPageState();
}

class _HasilUjianPageState extends State<HasilUjianPage> {
  // =====================================================
  // DATA MAHASISWA
  // =====================================================

  final List<Mahasiswa> _daftarMahasiswa = [
    Mahasiswa(
      nama: 'Ani',
      npm: '2301001',
      jurusan: 'Teknik Informatika',
      nilai: 50,
    ),
    Mahasiswa(
      nama: 'Budi',
      npm: '2301002',
      jurusan: 'Sistem Informasi',
      nilai: 70,
    ),
    Mahasiswa(
      nama: 'GHIFARY',
      npm: '2301003',
      jurusan: 'Teknik Informatika',
      nilai: 55,
    ),
    Mahasiswa(
      nama: 'MUHAMMAD GHIFARY ANDHI',
      npm: '2408007010004',
      jurusan: 'Teknik Informatika',
      nilai: 90,
    ),
  ];

  // =====================================================
  // FOTO PROFIL UTAMA
  // =====================================================

  Uint8List? _fotoProfil;

  final ImagePicker _imagePicker = ImagePicker();

  // =====================================================
  // CONTROLLER FORM
  // =====================================================

  final TextEditingController _namaController =
      TextEditingController();

  final TextEditingController _npmController =
      TextEditingController();

  final TextEditingController _jurusanController =
      TextEditingController();

  final TextEditingController _nilaiController =
      TextEditingController();

  final _formKey = GlobalKey<FormState>();

  // Foto untuk mahasiswa yang ditambahkan
  Uint8List? _foto;

  // =====================================================
  // FILTER DAN SORTING
  // =====================================================

  String _filter = 'Semua';

  int? _sortColumnIndex;

  bool _sortAscending = true;

  // =====================================================
  // DATA YANG DITAMPILKAN
  // =====================================================

  List<Mahasiswa> get _dataTampil {
    switch (_filter) {
      case 'Lulus':
        return _daftarMahasiswa
            .where((m) => m.lulus)
            .toList();

      case 'Tidak Lulus':
        return _daftarMahasiswa
            .where((m) => !m.lulus)
            .toList();

      default:
        return List.from(_daftarMahasiswa);
    }
  }

  // =====================================================
  // PILIH FOTO PROFIL
  // =====================================================

  Future<void> _pilihFotoProfil() async {
    final image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
    );

    if (image == null) return;

    final bytes = await image.readAsBytes();

    if (!mounted) return;

    setState(() {
      _fotoProfil = bytes;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Foto profil berhasil diubah'),
      ),
    );
  }

  // =====================================================
  // PILIH FOTO UNTUK DATA MAHASISWA
  // =====================================================

  Future<void> _pilihFoto() async {
    final image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
    );

    if (image == null) return;

    final bytes = await image.readAsBytes();

    if (!mounted) return;

    setState(() {
      _foto = bytes;
    });
  }

  // =====================================================
  // TAMBAH DATA MAHASISWA
  // =====================================================

  void _tambahData() {
    if (!_formKey.currentState!.validate()) return;

    final nama = _namaController.text.trim();
    final npm = _npmController.text.trim();
    final jurusan = _jurusanController.text.trim();
    final nilai =
        double.parse(_nilaiController.text.trim());

    setState(() {
      _daftarMahasiswa.add(
        Mahasiswa(
          nama: nama,
          npm: npm,
          jurusan: jurusan,
          nilai: nilai,
          foto: _foto,
        ),
      );
    });

    _namaController.clear();
    _npmController.clear();
    _jurusanController.clear();
    _nilaiController.clear();

    _foto = null;

    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Data "$nama" berhasil ditambahkan',
        ),
      ),
    );
  }

  // =====================================================
  // HAPUS DATA
  // =====================================================

  void _hapusData(Mahasiswa mahasiswa) {
    setState(() {
      _daftarMahasiswa.remove(mahasiswa);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Data "${mahasiswa.nama}" dihapus',
        ),
      ),
    );
  }

  // =====================================================
  // DIALOG TAMBAH DATA
  // =====================================================

  void _dialogTambahData() {
    _namaController.clear();
    _npmController.clear();
    _jurusanController.clear();
    _nilaiController.clear();

    _foto = null;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Tambah Data Mahasiswa',
          ),
          content: SizedBox(
            width: 450,
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // ==========================
                    // FOTO
                    // ==========================

                    Center(
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 45,
                            backgroundImage: _foto == null
                                ? null
                                : MemoryImage(_foto!),
                            child: _foto == null
                                ? const Icon(
                                    Icons.person_outline,
                                    size: 40,
                                  )
                                : null,
                          ),

                          const SizedBox(height: 8),

                          OutlinedButton.icon(
                            onPressed: _pilihFoto,
                            icon: const Icon(
                              Icons.photo_camera_outlined,
                            ),
                            label: Text(
                              _foto == null
                                  ? 'Pilih Foto'
                                  : 'Ganti Foto',
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),

                    // ==========================
                    // NAMA
                    // ==========================

                    TextFormField(
                      controller: _namaController,
                      decoration:
                          const InputDecoration(
                        labelText: 'Nama',
                        prefixIcon:
                            Icon(Icons.person_outline),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null ||
                            value.trim().isEmpty) {
                          return 'Nama tidak boleh kosong';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 12),

                    // ==========================
                    // NPM
                    // ==========================

                    TextFormField(
                      controller: _npmController,
                      keyboardType:
                          TextInputType.number,
                      decoration:
                          const InputDecoration(
                        labelText: 'NPM',
                        prefixIcon:
                            Icon(Icons.badge_outlined),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null ||
                            value.trim().isEmpty) {
                          return 'NPM tidak boleh kosong';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 12),

                    // ==========================
                    // JURUSAN
                    // ==========================

                    TextFormField(
                      controller:
                          _jurusanController,
                      decoration:
                          const InputDecoration(
                        labelText: 'Jurusan',
                        prefixIcon:
                            Icon(Icons.school_outlined),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null ||
                            value.trim().isEmpty) {
                          return 'Jurusan tidak boleh kosong';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 12),

                    // ==========================
                    // NILAI
                    // ==========================

                    TextFormField(
                      controller:
                          _nilaiController,
                      keyboardType:
                          const TextInputType
                              .numberWithOptions(
                        decimal: true,
                      ),
                      decoration:
                          const InputDecoration(
                        labelText: 'Nilai Akhir',
                        prefixIcon:
                            Icon(Icons.grade_outlined),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null ||
                            value.trim().isEmpty) {
                          return 'Nilai tidak boleh kosong';
                        }

                        final nilai =
                            double.tryParse(value);

                        if (nilai == null) {
                          return 'Nilai harus berupa angka';
                        }

                        if (nilai < 0 || nilai > 100) {
                          return 'Nilai harus 0 - 100';
                        }

                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Batal'),
            ),

            ElevatedButton.icon(
              onPressed: _tambahData,
              icon: const Icon(Icons.save),
              label: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  // =====================================================
  // SORTING
  // =====================================================

  void _sort<T>(
    Comparable<T> Function(Mahasiswa mahasiswa)
        getField,
    int columnIndex,
    bool ascending,
  ) {
    _daftarMahasiswa.sort((a, b) {
      final aValue = getField(a);
      final bValue = getField(b);

      return ascending
          ? Comparable.compare(aValue, bValue)
          : Comparable.compare(bValue, aValue);
    });

    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
    });
  }

  // =====================================================
  // BUILD
  // =====================================================

  @override
  Widget build(BuildContext context) {
    final jumlahLulus =
        _daftarMahasiswa.where((m) => m.lulus).length;

    final jumlahTidakLulus =
        _daftarMahasiswa.length - jumlahLulus;

    return Scaffold(
      backgroundColor: AppColor.background,

      // =================================================
      // APP BAR
      // =================================================

      appBar: AppBar(
        title: const Text(
          'Hasil Akhir Ujian Mahasiswa',
        ),
        backgroundColor: AppColor.gradientEnd,
        foregroundColor: Colors.white,
      ),

      // =================================================
      // BODY
      // =================================================

      body: SafeArea(
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.stretch,
          children: [

            // =================================================
            // FOTO PROFIL DI BAGIAN ATAS
            // =================================================

            _buildProfile(),

            // =================================================
            // STATISTIK
            // =================================================

            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  _buildStatCard(
                    'Total',
                    _daftarMahasiswa.length
                        .toString(),
                    AppColor.gradientEnd,
                  ),

                  const SizedBox(width: 8),

                  _buildStatCard(
                    'Lulus',
                    jumlahLulus.toString(),
                    Colors.green,
                  ),

                  const SizedBox(width: 8),

                  _buildStatCard(
                    'Tidak Lulus',
                    jumlahTidakLulus
                        .toString(),
                    Colors.red,
                  ),
                ],
              ),
            ),

            // =================================================
            // FILTER
            // =================================================

            Padding(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 12,
              ),
              child: Row(
                children: [
                  const Text(
                    'Filter:',
                    style: TextStyle(
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(width: 8),

                  DropdownButton<String>(
                    value: _filter,
                    items: const [
                      DropdownMenuItem(
                        value: 'Semua',
                        child: Text('Semua'),
                      ),
                      DropdownMenuItem(
                        value: 'Lulus',
                        child: Text('Lulus'),
                      ),
                      DropdownMenuItem(
                        value: 'Tidak Lulus',
                        child:
                            Text('Tidak Lulus'),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _filter = value!;
                      });
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // =================================================
            // TABEL
            // =================================================

            Expanded(
              child: _dataTampil.isEmpty
                  ? const Center(
                      child:
                          Text('Tidak ada data'),
                    )
                  : SingleChildScrollView(
                      child:
                          SingleChildScrollView(
                        scrollDirection:
                            Axis.horizontal,
                        child: DataTable(
                          sortColumnIndex:
                              _sortColumnIndex,
                          sortAscending:
                              _sortAscending,

                          columns: [
                            const DataColumn(
                              label:
                                  Text('Foto'),
                            ),

                            DataColumn(
                              label:
                                  const Text(
                                'Nama',
                              ),
                              onSort: (
                                columnIndex,
                                ascending,
                              ) {
                                _sort(
                                  (m) => m.nama,
                                  columnIndex,
                                  ascending,
                                );
                              },
                            ),

                            const DataColumn(
                              label:
                                  Text('NPM'),
                            ),

                            const DataColumn(
                              label:
                                  Text(
                                'Jurusan',
                              ),
                            ),

                            DataColumn(
                              label:
                                  const Text(
                                'Nilai',
                              ),
                              numeric: true,
                              onSort: (
                                columnIndex,
                                ascending,
                              ) {
                                _sort(
                                  (m) => m.nilai,
                                  columnIndex,
                                  ascending,
                                );
                              },
                            ),

                            const DataColumn(
                              label:
                                  Text('Status'),
                            ),

                            const DataColumn(
                              label:
                                  Text('Aksi'),
                            ),
                          ],

                          rows: _dataTampil
                              .map((m) {
                            return DataRow(
                              cells: [

                                // FOTO
                                DataCell(
                                  CircleAvatar(
                                    radius: 22,
                                    backgroundImage:
                                        m.foto ==
                                                null
                                            ? null
                                            : MemoryImage(
                                                m.foto!,
                                              ),
                                    child: m.foto ==
                                            null
                                        ? const Icon(
                                            Icons
                                                .person_outline,
                                          )
                                        : null,
                                  ),
                                ),

                                // NAMA
                                DataCell(
                                  Text(m.nama),
                                ),

                                // NPM
                                DataCell(
                                  Text(m.npm),
                                ),

                                // JURUSAN
                                DataCell(
                                  Text(
                                    m.jurusan,
                                  ),
                                ),

                                // NILAI
                                DataCell(
                                  Text(
                                    m.nilai
                                        .toStringAsFixed(
                                      0,
                                    ),
                                  ),
                                ),

                                // STATUS
                                DataCell(
                                  Chip(
                                    label: Text(
                                      m.statusText,
                                      style:
                                          const TextStyle(
                                        color:
                                            Colors
                                                .white,
                                        fontSize: 12,
                                      ),
                                    ),
                                    backgroundColor:
                                        m.lulus
                                            ? Colors
                                                .green
                                            : Colors
                                                .red,
                                  ),
                                ),

                                // AKSI
                                DataCell(
                                  IconButton(
                                    icon:
                                        const Icon(
                                      Icons
                                          .delete_outline,
                                      color:
                                          Colors.red,
                                    ),
                                    onPressed: () {
                                      _hapusData(
                                        m,
                                      );
                                    },
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),

      // =================================================
      // TOMBOL TAMBAH
      // =================================================

      floatingActionButton:
          FloatingActionButton.extended(
        backgroundColor:
            AppColor.gradientEnd,
        foregroundColor: Colors.white,
        onPressed: _dialogTambahData,
        icon: const Icon(Icons.add),
        label: const Text(
          'Tambah Data',
        ),
      ),
    );
  }

  // =====================================================
  // WIDGET PROFIL
  // =====================================================

  Widget _buildProfile() {
    return Container(
      margin: const EdgeInsets.fromLTRB(
        12,
        12,
        12,
        4,
      ),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColor.gradientEnd,
        borderRadius:
            BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black
                .withValues(alpha: 0.10),
            blurRadius: 8,
            offset:
                const Offset(0, 3),
          ),
        ],
      ),

      child: Row(
        children: [

          // =================================================
          // FOTO PROFIL
          // =================================================

          CircleAvatar(
            radius: 48,
            backgroundColor: Colors.white,

            backgroundImage:
                _fotoProfil == null
                    ? null
                    : MemoryImage(
                        _fotoProfil!,
                      ),

            child: _fotoProfil == null
                ? const Icon(
                    Icons.person,
                    size: 50,
                    color:
                        AppColor.gradientEnd,
                  )
                : null,
          ),

          const SizedBox(width: 16),

          // =================================================
          // INFORMASI PROFIL
          // =================================================

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [

                const Text(
                  'Profil Mahasiswa',
                  style: TextStyle(
                    color:
                        Colors.white70,
                    fontSize: 13,
                  ),
                ),

                const SizedBox(height: 4),

                const Text(
                  'MUHAMMAD GHIFARY ANDHI',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 5),

                const Text(
                  'NPM: 2408007010004',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 3),

                const Text(
                  'Teknik Informatika',
                  style: TextStyle(
                    color:
                        Colors.white70,
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 8),

                // =================================================
                // TOMBOL PILIH FOTO
                // =================================================

                OutlinedButton.icon(
                  onPressed:
                      _pilihFotoProfil,
                  style:
                      OutlinedButton
                          .styleFrom(
                    foregroundColor:
                        Colors.white,
                    side:
                        const BorderSide(
                      color:
                          Colors.white,
                    ),
                  ),
                  icon: const Icon(
                    Icons
                        .photo_camera_outlined,
                    size: 18,
                  ),
                  label: Text(
                    _fotoProfil == null
                        ? 'Pilih Foto'
                        : 'Ganti Foto',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =====================================================
  // STATISTIK CARD
  // =====================================================

  Widget _buildStatCard(
    String label,
    String value,
    Color color,
  ) {
    return Expanded(
      child: Card(
        color: color.withValues(
          alpha: 0.1,
        ),

        child: Padding(
          padding:
              const EdgeInsets.all(12),

          child: Column(
            children: [

              Text(
                value,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight:
                      FontWeight.bold,
                  color: color,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                label,
                style: TextStyle(
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =====================================================
  // DISPOSE
  // =====================================================

  @override
  void dispose() {
    _namaController.dispose();
    _npmController.dispose();
    _jurusanController.dispose();
    _nilaiController.dispose();

    super.dispose();
  }
}