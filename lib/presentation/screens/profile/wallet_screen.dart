import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../data/providers/user_provider.dart';
import '../../../data/repositories/wallet_repository.dart';
import '../../../domain/models/transaction_model.dart';
import '../../../l10n/app_localizations.dart';
import '../../theme/app_colors.dart';
import '../../widgets/glass_container.dart';

class WalletScreen extends ConsumerWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final userAsync = ref.watch(currentUserProvider);
    final transactionsStream = ref.watch(walletRepositoryProvider).getTransactions();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(t.wallet_title),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.chevron_left, size: 30),
        ),
      ),
      body: Stack(
        children: [
          // Background decorations consistent with ProfileScreen
          Positioned(
            top: -50,
            left: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.secondary.withValues(alpha: 0.1),
              ),
            ),
          ),
          
          userAsync.when(
            data: (user) {
              if (user == null) return const Center(child: Text("Please Login"));
              
              return Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).padding.top + 80),
                  
                  // Balance Card
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: GlassContainer(
                      padding: const EdgeInsets.all(24),
                      borderRadius: 24,
                      child: Column(
                        children: [
                          Text(
                            t.wallet_balance,
                            style: const TextStyle(color: Colors.white70, fontSize: 14),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "${user.balance.toStringAsFixed(2)} ₴",
                            style: const TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Row(
                            children: [
                              Expanded(
                                child: _buildWalletAction(
                                  icon: Icons.add_circle_outline,
                                  label: t.wallet_top_up,
                                  onTap: () => _showTopUpDialog(context, ref),
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildWalletAction(
                                  icon: Icons.file_upload_outlined,
                                  label: t.wallet_withdraw,
                                  onTap: () => _showWithdrawDialog(context, ref),
                                  color: AppColors.secondary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Transaction History
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
                          child: Text(
                            t.wallet_history,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Expanded(
                          child: StreamBuilder<List<TransactionModel>>(
                            stream: transactionsStream,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const Center(child: CircularProgressIndicator());
                              }
                              final transactions = snapshot.data ?? [];
                              if (transactions.isEmpty) {
                                return Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.history, size: 64, color: Colors.white24),
                                      const SizedBox(height: 16),
                                      Text(t.no_transactions, style: TextStyle(color: Colors.white38)),
                                    ],
                                  ),
                                );
                              }
                              
                              return ListView.separated(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                itemCount: transactions.length,
                                separatorBuilder: (context, index) => const SizedBox(height: 12),
                                itemBuilder: (context, index) {
                                  return _buildTransactionItem(context, transactions[index], t);
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, s) => Center(child: Text("Error: $e")),
          ),
        ],
      ),
    );
  }

  Widget _buildWalletAction({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required Color color,
  }) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withValues(alpha: 0.2),
        foregroundColor: color,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: color.withValues(alpha: 0.3)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildTransactionItem(BuildContext context, TransactionModel tx, AppLocalizations t) {
    final isNegative = tx.amount < 0;
    final color = isNegative ? Colors.redAccent : Colors.greenAccent;
    
    IconData icon;
    String typeLabel;
    
    switch (tx.type) {
      case 'topup':
        icon = Icons.add_business_outlined;
        typeLabel = t.transaction_type_topup;
        break;
      case 'withdrawal':
        icon = Icons.account_balance_outlined;
        typeLabel = t.transaction_type_withdrawal;
        break;
      case 'ride_payment':
      default:
        icon = Icons.directions_car_outlined;
        typeLabel = t.transaction_type_ride;
    }

    return GlassContainer(
      padding: const EdgeInsets.all(16),
      borderRadius: 16,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  typeLabel,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  DateFormat('dd.MM.yyyy, HH:mm').format(tx.createdAt),
                  style: const TextStyle(color: Colors.white38, fontSize: 12),
                ),
              ],
            ),
          ),
          Text(
            "${isNegative ? '' : '+'}${tx.amount.toStringAsFixed(2)} ₴",
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  void _showTopUpDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey.shade900,
        title: Text("Поповнити баланс", style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: "Сума (₴)",
            hintStyle: TextStyle(color: Colors.white24),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Скасувати"),
          ),
          ElevatedButton(
            onPressed: () {
              final amount = double.tryParse(controller.text);
              if (amount != null && amount > 0) {
                ref.read(walletRepositoryProvider).topUp(amount);
                Navigator.pop(context);
              }
            },
            child: Text("Поповнити"),
          ),
        ],
      ),
    );
  }

  void _showWithdrawDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey.shade900,
        title: Text("Вивести кошти", style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: "Сума (₴)",
            hintStyle: TextStyle(color: Colors.white24),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Скасувати"),
          ),
          ElevatedButton(
            onPressed: () {
              final amount = double.tryParse(controller.text);
              if (amount != null && amount > 0) {
                ref.read(walletRepositoryProvider).withdraw(amount);
                Navigator.pop(context);
              }
            },
            child: Text("Вивести"),
          ),
        ],
      ),
    );
  }
}
