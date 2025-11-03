import 'package:flutter/material.dart';

class SetorSampahScreen extends StatefulWidget {
  const SetorSampahScreen({super.key});

  @override
  State<SetorSampahScreen> createState() => _SetorSampahScreenState();
}

class _SetorSampahScreenState extends State<SetorSampahScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _weightController = TextEditingController();

  // State variables
  String? _selectedTrashType;
  bool _isLoading = false;
  double _totalBalance = 250000.0; // Saldo total user (simulasi)
  int _totalDeposits = 15; // Total setor sampah (simulasi)

  // Data jenis sampah dengan harga per kg
  final Map<String, Map<String, dynamic>> _trashTypes = {
    'Plastik': {'price': 2500, 'icon': Icons.recycling, 'color': Colors.blue},
    'Kertas': {'price': 1500, 'icon': Icons.description, 'color': Colors.brown},
    'Organik': {'price': 500, 'icon': Icons.eco, 'color': Colors.green},
    'Logam': {'price': 5000, 'icon': Icons.build, 'color': Colors.grey},
    'Kaca': {'price': 1000, 'icon': Icons.wine_bar, 'color': Colors.lightBlue},
    'Lainnya': {'price': 1000, 'icon': Icons.category, 'color': Colors.orange},
  };

  @override
  void initState() {
    super.initState();
    // Add listener untuk real-time update
    _weightController.addListener(() {
      if (mounted) {
        setState(() {
          // Trigger rebuild untuk calculation preview
        });
      }
    });
  }

  @override
  void dispose() {
    _weightController.removeListener(() {});
    _weightController.dispose();
    super.dispose();
  }

  // Function untuk handle setor sampah
  void _handleSetorSampah() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedTrashType == null) {
      _showErrorSnackBar('Pilih jenis sampah terlebih dahulu');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulasi delay untuk proses setor
    await Future.delayed(Duration(seconds: 2));

    // Null safety checks
    double? weight = double.tryParse(_weightController.text);
    if (weight == null) {
      setState(() => _isLoading = false);
      _showErrorSnackBar('Berat sampah tidak valid');
      return;
    }

    final trashData = _trashTypes[_selectedTrashType];
    if (trashData == null) {
      setState(() => _isLoading = false);
      _showErrorSnackBar('Jenis sampah tidak valid');
      return;
    }

    int pricePerKg = trashData['price'] ?? 0;
    double totalEarning = weight * pricePerKg;

    if (mounted) {
      setState(() {
        _isLoading = false;
        _totalBalance += totalEarning;
        _totalDeposits += 1;
      });

      // Show success dialog
      _showSuccessDialog(weight, totalEarning);

      // Reset form
      _weightController.clear();
      _selectedTrashType = null;
    }
  }

  // Function untuk format currency
  String _formatCurrency(double amount) {
    return amount
        .toStringAsFixed(0)
        .replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        );
  }

  // Function untuk show success dialog
  void _showSuccessDialog(double weight, double earning) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 30),
              SizedBox(width: 10),
              Text('Setor Berhasil!'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow(
                'Jenis Sampah',
                _selectedTrashType ?? 'Tidak diketahui',
              ),
              _buildDetailRow('Berat', '${weight.toString()} kg'),
              _buildDetailRow(
                'Harga/kg',
                'Rp ${_formatCurrency((_trashTypes[_selectedTrashType]?['price'] ?? 0).toDouble())}',
              ),
              Divider(),
              _buildDetailRow(
                'Total Pendapatan',
                'Rp ${_formatCurrency(earning)}',
                isTotal: true,
              ),
              SizedBox(height: 8),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.account_balance_wallet,
                      color: Colors.green,
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Saldo Anda: Rp ${_formatCurrency(_totalBalance)}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Setor Lagi'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Kembali ke dashboard
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: Text('Kembali', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 16 : 14,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: isTotal ? 16 : 14,
              color: isTotal ? Colors.green : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  // Function untuk show error snackbar
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // Widget untuk stat item di header
  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 24),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(label, style: TextStyle(color: Colors.white70, fontSize: 12)),
      ],
    );
  }

  // Widget untuk preview perhitungan
  Widget _buildCalculationPreview() {
    double? weight = double.tryParse(_weightController.text);
    if (weight == null || _selectedTrashType == null) return SizedBox();

    // Null safety check untuk _trashTypes
    final trashData = _trashTypes[_selectedTrashType];
    if (trashData == null) return SizedBox();

    int pricePerKg = trashData['price'] ?? 0;
    double totalEarning = weight * pricePerKg;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.calculate, color: Colors.green, size: 20),
            SizedBox(width: 8),
            Text(
              'Perhitungan Pendapatan',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green.shade700,
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        _buildDetailRow('Jenis Sampah', _selectedTrashType!),
        _buildDetailRow('Berat', '${weight.toString()} kg'),
        _buildDetailRow(
          'Harga/kg',
          'Rp ${_formatCurrency(pricePerKg.toDouble())}',
        ),
        Divider(color: Colors.green.shade300),
        _buildDetailRow(
          'Total Pendapatan',
          'Rp ${_formatCurrency(totalEarning)}',
          isTotal: true,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Setor Sampah')),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.all(16.0),
            children: [
              // Info Card Saldo & Stats
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.green.shade400, Colors.green.shade600],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem(
                      'Saldo',
                      'Rp ${_formatCurrency(_totalBalance)}',
                      Icons.account_balance_wallet,
                    ),
                    Container(height: 40, width: 1, color: Colors.white30),
                    _buildStatItem(
                      'Total Setor',
                      '$_totalDeposits kali',
                      Icons.recycling,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),
              Text(
                'Pilih Jenis Sampah',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 8),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedTrashType,
                    hint: Text('Pilih jenis sampah'),
                    isExpanded: true,
                    onChanged: (newValue) {
                      setState(() {
                        _selectedTrashType = newValue;
                      });
                    },
                    items: _trashTypes.entries.map<DropdownMenuItem<String>>((
                      entry,
                    ) {
                      return DropdownMenuItem<String>(
                        value: entry.key,
                        child: Row(
                          children: [
                            Icon(
                              (entry.value['icon'] as IconData?) ??
                                  Icons.category,
                              color:
                                  (entry.value['color'] as Color?) ??
                                  Colors.grey,
                              size: 20,
                            ),
                            SizedBox(width: 12),
                            Expanded(child: Text(entry.key)),
                            Text(
                              'Rp ${_formatCurrency((entry.value['price'] ?? 0).toDouble())}/kg',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Berat Sampah',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: _weightController,
                decoration: InputDecoration(
                  hintText: 'Masukkan berat sampah (min. 0.1 kg)',
                  suffixText: 'Kg',
                  prefixIcon: Icon(Icons.scale, color: Colors.green),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.green, width: 2),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Berat sampah wajib diisi';
                  }

                  double? weight = double.tryParse(value);
                  if (weight == null) {
                    return 'Masukkan angka yang valid';
                  }

                  if (weight < 0.1) {
                    return 'Berat minimal 0.1 kg';
                  }

                  if (weight > 1000) {
                    return 'Berat maksimal 1000 kg';
                  }

                  return null;
                },
              ),

              // Preview perhitungan
              if (_selectedTrashType != null &&
                  _weightController.text.isNotEmpty &&
                  double.tryParse(_weightController.text) != null)
                Container(
                  margin: EdgeInsets.only(top: 16),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green.shade200),
                  ),
                  child: _buildCalculationPreview(),
                ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleSetorSampah,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isLoading ? Colors.grey : Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 2,
                  ),
                  child: _isLoading
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.recycling, color: Colors.white),
                            SizedBox(width: 8),
                            Text(
                              'Setor Sampah',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
