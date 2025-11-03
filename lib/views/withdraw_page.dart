import 'package:flutter/material.dart';

class WithdrawPage extends StatefulWidget {
  const WithdrawPage({super.key});

  @override
  State<WithdrawPage> createState() => _WithdrawPageState();
}

class _WithdrawPageState extends State<WithdrawPage> {
  // Form key untuk validasi
  final _formKey = GlobalKey<FormState>();
  
  // Text controller untuk amount
  final _amountController = TextEditingController();
  
  // State variables
  bool _isLoading = false;
  double _currentBalance = 500000.0; // Saldo saat ini (simulasi)
  
  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }
  
  // Function untuk handle withdraw
  void _handleWithdraw() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    setState(() {
      _isLoading = true;
    });
    
    // Simulasi delay untuk proses withdraw
    await Future.delayed(Duration(seconds: 2));
    
    double withdrawAmount = double.parse(_amountController.text.replaceAll(RegExp(r'[^\d.]'), ''));
    
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
      
      if (withdrawAmount > _currentBalance) {
        // Saldo tidak cukup
        _showErrorDialog('Saldo Tidak Cukup', 'Jumlah penarikan melebihi saldo yang tersedia.\nSaldo Anda: Rp ${_formatCurrency(_currentBalance)}');
      } else if (withdrawAmount < 10000) {
        // Minimum withdraw
        _showErrorDialog('Jumlah Terlalu Kecil', 'Minimal penarikan adalah Rp 10.000');
      } else {
        // Withdraw berhasil
        setState(() {
          _currentBalance -= withdrawAmount;
        });
        
        _showSuccessDialog(withdrawAmount);
        _amountController.clear();
      }
    }
  }
  
  // Function untuk format currency
  String _formatCurrency(double amount) {
    return amount.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), 
      (Match m) => '${m[1]}.'
    );
  }
  
  // Function untuk show success dialog
  void _showSuccessDialog(double amount) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          icon: Icon(Icons.check_circle, color: Colors.green, size: 60),
          title: Text('Penarikan Berhasil'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Jumlah yang ditarik:'),
              SizedBox(height: 8),
              Text(
                'Rp ${_formatCurrency(amount)}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              SizedBox(height: 12),
              Text('Saldo tersisa: Rp ${_formatCurrency(_currentBalance)}'),
              SizedBox(height: 8),
              Text(
                'Uang akan ditransfer ke rekening Anda dalam 1-2 hari kerja.',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Kembali ke halaman sebelumnya
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
  
  // Function untuk show error dialog
  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          icon: Icon(Icons.error, color: Colors.red, size: 60),
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
  
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    return Scaffold(
      appBar: AppBar(title: Text('Penarikan Uang')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: screenHeight - kToolbarHeight - MediaQuery.of(context).padding.top - 32,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                Icon(
                  Icons.monetization_on, 
                  size: screenWidth * 0.2, // Responsive icon size (20% dari lebar screen)
                  color: Colors.green,
                ),
                SizedBox(height: screenHeight * 0.02),
                // Card info saldo
                Container(
                  width: screenWidth * 0.8,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.green.shade200),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Saldo Tersedia',
                        style: TextStyle(
                          fontSize: screenWidth * 0.035,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Rp ${_formatCurrency(_currentBalance)}',
                        style: TextStyle(
                          fontSize: screenWidth * 0.05,
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: screenHeight * 0.03), // Responsive spacing
                Text(
                  'Jumlah Penarikan',
                  style: TextStyle(
                    fontSize: screenWidth * 0.05, // Responsive font size
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                Container(
                  width: screenWidth * 0.8, // 80% dari lebar screen
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextFormField(
                    controller: _amountController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Jumlah penarikan tidak boleh kosong';
                      }
                      
                      String cleanValue = value.replaceAll(RegExp(r'[^\d.]'), '');
                      double? amount = double.tryParse(cleanValue);
                      
                      if (amount == null) {
                        return 'Masukkan jumlah yang valid';
                      }
                      
                      if (amount < 10000) {
                        return 'Minimal penarikan Rp 10.000';
                      }
                      
                      if (amount > _currentBalance) {
                        return 'Jumlah melebihi saldo tersedia';
                      }
                      
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: 'Masukkan Jumlah (min. Rp 10.000)',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(color: Colors.green, width: 2),
                      ),
                      prefixText: 'Rp ',
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 12.0,
                      ),
                    ),
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),
                SizedBox(
                  width: screenWidth * 0.8, // 80% dari lebar screen
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isLoading ? Colors.grey : Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      elevation: 2,
                    ),
                    onPressed: _isLoading ? null : _handleWithdraw,
                    child: _isLoading
                        ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Text(
                            'Tarik',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: screenWidth * 0.04, // Responsive font size
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                // Info tambahan
                Text(
                  '• Minimal penarikan Rp 10.000\n• Proses 1-2 hari kerja\n• Gratis biaya admin',
                  style: TextStyle(
                    fontSize: screenWidth * 0.03,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
