import 'package:flutter/material.dart';
import '../../models/asset.dart';
import '../../core/theme.dart';

// Sample portfolio — no remote API needed for now
final _portfolio = [
  Asset(id: 'a_001', name: 'S&P 500 ETF', value: 4250.00),
  Asset(id: 'a_002', name: 'Bitcoin', value: 1800.00),
  Asset(id: 'a_003', name: 'Apple Inc.', value: 920.00),
  Asset(id: 'a_004', name: 'Gold ETF', value: 640.00),
  Asset(id: 'a_005', name: 'Emerging Markets', value: 390.00),
];

const _assetColors = [
  Color(0xFF1565C0),
  Color(0xFFF57F17),
  Color(0xFF1B5E20),
  Color(0xFFAD1457),
  Color(0xFF4527A0),
];

class InvestmentScreen extends StatelessWidget {
  const InvestmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final total = _portfolio.fold(0.0, (s, a) => s + a.value);

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
        title: const Text('Investments', style: TextStyle(fontWeight: FontWeight.w700)),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _PortfolioHeader(total: total),
          const SizedBox(height: 20),
          _AllocationBar(assets: _portfolio, total: total),
          const SizedBox(height: 20),
          Text('Holdings',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          ..._portfolio.asMap().entries.map((e) => _AssetCard(
                asset: e.value,
                color: _assetColors[e.key % _assetColors.length],
                percent: e.value.value / total * 100,
              )),
        ],
      ),
    );
  }
}

class _PortfolioHeader extends StatelessWidget {
  final double total;
  const _PortfolioHeader({required this.total});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [AppTheme.primary, const Color(0xFF1B5E20)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Portfolio Value',
                style: TextStyle(color: Colors.white70, fontSize: 13)),
            const SizedBox(height: 6),
            Text(
              '\$${total.toStringAsFixed(2)}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 36,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.trending_up, color: Colors.greenAccent, size: 18),
                const SizedBox(width: 4),
                const Text('+8.4% this month',
                    style: TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.w600)),
                const Spacer(),
                Text('${_portfolio.length} assets',
                    style: const TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AllocationBar extends StatelessWidget {
  final List<Asset> assets;
  final double total;
  const _AllocationBar({required this.assets, required this.total});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Allocation',
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Row(
                children: assets.asMap().entries.map((e) {
                  return Expanded(
                    flex: (e.value.value / total * 100).round(),
                    child: Container(
                      height: 14,
                      color: _assetColors[e.key % _assetColors.length],
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 6,
              children: assets.asMap().entries.map((e) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: _assetColors[e.key % _assetColors.length],
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(e.value.name.split(' ').first,
                        style: const TextStyle(fontSize: 11)),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _AssetCard extends StatelessWidget {
  final Asset asset;
  final Color color;
  final double percent;
  const _AssetCard(
      {required this.asset, required this.color, required this.percent});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.12),
          child: Text(
            asset.name.substring(0, 1),
            style: TextStyle(color: color, fontWeight: FontWeight.w800),
          ),
        ),
        title: Text(asset.name,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        subtitle: Text('${percent.toStringAsFixed(1)}% of portfolio',
            style: const TextStyle(fontSize: 12)),
        trailing: Text(
          '\$${asset.value.toStringAsFixed(2)}',
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w700,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}
