import 'package:flutter/material.dart';
import 'package:otlob/core/constants/app_colors.dart';
import 'package:otlob/features/account/data/models/address_dto.dart';
import 'package:otlob/features/account/data/services/account_service.dart';
import 'package:otlob/features/orders/data/models/delivery_method.dart';
import 'package:otlob/features/orders/data/models/order_request.dart';
import 'package:otlob/features/orders/data/services/order_service.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _accountService = AccountService();
  final _orderService = OrderService();
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _street = TextEditingController();
  final _city = TextEditingController();
  final _country = TextEditingController();
  List<DeliveryMethodModel> _methods = [];
  int? _selectedMethodId;
  bool _isLoading = true;
  bool _isSubmitting = false;
  String? _error;

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
    });

    final errors = <String>[];
    final methodsFuture = _orderService.getDeliveryMethods();
    final addressFuture = _accountService.getAddress();
    try {
      try {
        _methods = await methodsFuture;
        _selectedMethodId ??= _methods.isEmpty ? null : _methods.first.id;
      } on OrderException catch (error) {
        errors.add(error.message);
      }

      try {
        final address = await addressFuture;
        _firstName.text = address.firstName;
        _lastName.text = address.lastName;
        _street.text = address.street;
        _city.text = address.city;
        _country.text = address.country;
      } on AccountException catch (error) {
        errors.add(
          'Saved address unavailable. Enter a shipping address below. ${error.message}',
        );
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

  Future<void> _submit() async {
    if (_isSubmitting ||
        _selectedMethodId == null ||
        !_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSubmitting = true;
      _error = null;
    });
    try {
      final order = await _orderService.createOrder(
        OrderRequest(
          deliverMethodId: _selectedMethodId!,
          shippingAddress: AddressDto(
            firstName: _firstName.text.trim(),
            lastName: _lastName.text.trim(),
            street: _street.text.trim(),
            city: _city.text.trim(),
            country: _country.text.trim(),
          ),
        ),
      );
      if (!mounted) return;
      Navigator.pop(context, order);
    } on OrderException catch (error) {
      if (!mounted) return;
      setState(() => _error = error.message);
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final selectedMethod = _methods.where(
      (method) => method.id == _selectedMethodId,
    );
    final fee = selectedMethod.isEmpty ? null : selectedMethod.first.cost;

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const Text(
                'Delivery method',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              if (_methods.isEmpty)
                const Text('No delivery methods are currently available.')
              else
                DropdownButtonFormField<int>(
                  initialValue: _selectedMethodId,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  items: _methods
                      .map(
                        (method) => DropdownMenuItem(
                          value: method.id,
                          child: Text(
                            '${method.shortName} · ${method.cost.toStringAsFixed(2)} EGP',
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: _isSubmitting
                      ? null
                      : (value) => setState(() => _selectedMethodId = value),
                ),
              if (selectedMethod.isNotEmpty &&
                  selectedMethod.first.description.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  '${selectedMethod.first.description} ${selectedMethod.first.deliveryTime}',
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
              const SizedBox(height: 24),
              const Text(
                'Shipping address',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              _field(_firstName, 'First name'),
              _field(_lastName, 'Last name'),
              _field(_street, 'Street'),
              _field(_city, 'City'),
              _field(_country, 'Country'),
              if (_error != null) ...[
                const SizedBox(height: 8),
                Text(_error!, style: const TextStyle(color: Colors.redAccent)),
                TextButton(
                  onPressed: _isSubmitting ? null : _load,
                  child: const Text('Retry'),
                ),
              ],
              const SizedBox(height: 12),
              SizedBox(
                height: 54,
                child: ElevatedButton(
                  onPressed: _isSubmitting || _methods.isEmpty ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          fee == null
                              ? 'Place order'
                              : 'Place order · ${fee.toStringAsFixed(2)} EGP delivery',
                        ),
                ),
              ),
            ],
          ),
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
