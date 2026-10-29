import 'package:flutter/material.dart';
import 'package:otlob/core/constants/app_colors.dart';
import 'package:otlob/core/network/auth_session.dart';
import 'package:otlob/core/routes/app_routes.dart';
import 'package:otlob/features/account/data/models/address_dto.dart';
import 'package:otlob/features/account/data/services/account_service.dart';
import 'package:otlob/features/auth/data/models/user_dto.dart';
import 'package:otlob/features/cart/data/services/cart_service.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final _service = AccountService();
  final _formKey = GlobalKey<FormState>();
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _street = TextEditingController();
  final _city = TextEditingController();
  final _country = TextEditingController();
  UserDto? _account;
  bool _isLoading = true;
  bool _isSaving = false;
  String? _error;
  String? _saveMessage;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _street.dispose();
    _city.dispose();
    _country.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _isLoading = true;
      _error = null;
      _saveMessage = null;
    });

    final errors = <String>[];
    final accountFuture = _service.getAccount();
    final addressFuture = _service.getAddress();
    try {
      try {
        _account = await accountFuture;
      } on AccountException catch (error) {
        errors.add(error.message);
      }

      try {
        final address = await addressFuture;
        _setAddress(address);
      } on AccountException catch (error) {
        errors.add(error.message);
      }
    } finally {
      if (mounted) {
        setState(() {
          _error = errors.isEmpty ? null : errors.join('\n');
          _isLoading = false;
        });
      }
    }
  }

  void _setAddress(AddressDto address) {
    _firstName.text = address.firstName;
    _lastName.text = address.lastName;
    _street.text = address.street;
    _city.text = address.city;
    _country.text = address.country;
  }

  Future<void> _saveAddress() async {
    if (_isSaving || !_formKey.currentState!.validate()) return;

    setState(() {
      _isSaving = true;
      _saveMessage = null;
    });
    try {
      final address = await _service.updateAddress(
        AddressDto(
          firstName: _firstName.text.trim(),
          lastName: _lastName.text.trim(),
          street: _street.text.trim(),
          city: _city.text.trim(),
          country: _country.text.trim(),
        ),
      );
      if (!mounted) return;
      _setAddress(address);
      setState(() => _saveMessage = 'Address saved.');
    } on AccountException catch (error) {
      if (!mounted) return;
      setState(() => _saveMessage = error.message);
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'My Account',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            if (_account != null) ...[
              Text(
                _account!.displayName ?? '',
                style: const TextStyle(fontSize: 17),
              ),
              Text(
                _account!.email ?? '',
                style: const TextStyle(color: Colors.grey),
              ),
            ] else ...[
              const Text(
                'Sign in to manage your account and delivery address.',
              ),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, AppRoutes.login),
                child: const Text('Log in'),
              ),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, AppRoutes.signUp),
                child: const Text('Create an account'),
              ),
            ],
            if (_error != null) ...[
              const SizedBox(height: 12),
              Text(_error!, style: const TextStyle(color: Colors.redAccent)),
              TextButton(onPressed: _load, child: const Text('Retry')),
            ],
            const SizedBox(height: 24),
            const Text(
              'Delivery address',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  _field(_firstName, 'First name'),
                  _field(_lastName, 'Last name'),
                  _field(_street, 'Street'),
                  _field(_city, 'City'),
                  _field(_country, 'Country'),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isSaving ? null : _saveAddress,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: _isSaving
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text('Save address'),
                    ),
                  ),
                  if (_saveMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        _saveMessage!,
                        style: TextStyle(
                          color: _saveMessage == 'Address saved.'
                              ? Colors.green
                              : Colors.redAccent,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          await AuthSession.instance.clear();
                          CartService.basketUpdates.value = null;
                          if (!context.mounted) return;
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            AppRoutes.login,
                            (_) => false,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text('Logout'),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(TextEditingController controller, String label) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: TextFormField(
      controller: controller,
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      ),
      validator: (value) =>
          value == null || value.trim().isEmpty ? 'Required' : null,
    ),
  );
}
