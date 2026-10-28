import 'package:flutter/material.dart';
import 'package:otlob/core/constants/app_colors.dart';
import 'package:otlob/core/shared/bottom_nav.dart';
import 'package:otlob/features/account/data/models/address_dto.dart';
import 'package:otlob/features/account/data/services/account_service.dart';
import 'package:otlob/features/auth/data/models/user_dto.dart';

class HomeAppBar extends StatefulWidget {
  const HomeAppBar({super.key});

  @override
  State<HomeAppBar> createState() => _HomeAppBarState();
}

class _HomeAppBarState extends State<HomeAppBar> {
  final _service = AccountService();
  late Future<(UserDto?, AddressDto?)> _account = _loadAccount();

  @override
  void initState() {
    super.initState();
    AccountService.accountUpdates.addListener(_refreshAccount);
  }

  @override
  void dispose() {
    AccountService.accountUpdates.removeListener(_refreshAccount);
    super.dispose();
  }

  void _refreshAccount() {
    setState(() => _account = _loadAccount());
  }

  Future<(UserDto?, AddressDto?)> _loadAccount() async {
    UserDto? user;
    AddressDto? address;
    try {
      user = await _service.getAccount();
    } on AccountException {
      return (null, null);
    }
    try {
      address = await _service.getAddress();
    } on AccountException {
      // The account name remains usable when no address has been saved yet.
    }
    return (user, address);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<(UserDto?, AddressDto?)>(
      future: _account,
      builder: (context, snapshot) {
        final user = snapshot.data?.$1;
        final address = snapshot.data?.$2;
        final deliveryAddress =
            [address?.street, address?.city, address?.country]
                .whereType<String>()
                .where((part) => part.trim().isNotEmpty)
                .join(', ');

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Good evening ',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.textGrey,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      user?.displayName?.isNotEmpty == true
                          ? user!.displayName!
                          : 'Welcome',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 6),
                    GestureDetector(
                      onTap: () => tabIndex.value = 4,
                      child: Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            color: AppColors.primary,
                            size: 16,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            deliveryAddress.isEmpty
                                ? 'Set your delivery address'
                                : deliveryAddress,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textDark,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.keyboard_arrow_down,
                            color: AppColors.textDark,
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Stack(
              clipBehavior: Clip.none,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 25),
                  child: Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.notifications_outlined,
                      color: AppColors.textDark,
                      size: 22,
                    ),
                  ),
                ),
                Positioned(
                  right: 10,
                  top: 35,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
