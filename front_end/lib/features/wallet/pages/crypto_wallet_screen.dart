import 'dart:convert';
import 'dart:typed_data';
import 'package:budgetwise_one/features/analytics/services/coingecko_service.dart';
import 'package:flutter/material.dart';
import 'package:reown_appkit/modal/appkit_modal_impl.dart';
import 'package:reown_appkit/modal/pages/public/appkit_modal_select_network_page.dart';
import 'package:reown_appkit/modal/widgets/public/appkit_modal_account_button.dart';
import 'package:reown_appkit/modal/widgets/public/appkit_modal_connect_button.dart';
import 'package:reown_appkit/modal/widgets/public/appkit_modal_network_select_button.dart';
import 'package:reown_appkit/reown_appkit.dart';
import 'package:uni_links/uni_links.dart';

class CryptoCurrencyTab extends StatefulWidget {
  @override
  _CryptoCurrencyTabState createState() => _CryptoCurrencyTabState();
}

class _CryptoCurrencyTabState extends State<CryptoCurrencyTab> {
  double cryptoBalance = 0.0;
  List<dynamic> topCoins = []; // To hold the top coins
  late ReownAppKitModal appKitModal;

  final Set<String> featuredWalletIds = {
    'c57ca95b47569778a828d19178114f4db188b89b763c899ba0be274e97267d96',
    '4622a2b2d6af1c9844944291e5e7351a6aa24cd7b23099efac1b2fd875da31a0',
    'fd20dc426fb37566d803205b19bbc1d4096b248ac04548e3cfb6b3a38bd033aa',
  };

  final Set<String> includedWalletIds = {
    'c57ca95b47569778a828d19178114f4db188b89b763c899ba0be274e97267d96',
    '4622a2b2d6af1c9844944291e5e7351a6aa24cd7b23099efac1b2fd875da31a0',
    'fd20dc426fb37566d803205b19bbc1d4096b248ac04548e3cfb6b3a38bd033aa',
  };

  final Set<String> excludedWalletIds = {};

  @override
  void initState() {
    super.initState();
    _initializeAppKitModal();
    _fetchCryptoData();
    _fetchTopCoins(); // Fetch top coins
    _initLinkListener();
    _setupEventListeners();
  }

  Future<void> _initializeAppKitModal() async {
    appKitModal = ReownAppKitModal(
      context: context,
      projectId: '{YOUR_PROJECT_ID}',
      metadata: const PairingMetadata(
        name: 'Example App',
        description: 'Example app description',
        url: 'https://example.com/',
        icons: ['https://example.com/logo.png'],
        redirect: Redirect(
          native: 'exampleapp://',
          universal: 'https://reown.com/exampleapp',
        ),
      ),
      featuredWalletIds: featuredWalletIds,
      includedWalletIds: includedWalletIds,
      excludedWalletIds: excludedWalletIds,
    );

    await appKitModal.init();
  }

  Future<void> _initLinkListener() async {
    final initialLink = await getInitialLink();
    if (initialLink != null) {
      _onLinkCaptured(initialLink);
    }

    linkStream.listen((String? link) {
      if (link != null) {
        _onLinkCaptured(link);
      }
    });
  }

  void _onLinkCaptured(String link) async {
    await appKitModal.connectSelectedWallet();
  }

  Future<void> _fetchCryptoData() async {
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        cryptoBalance = 1000.0; // Simulated balance
      });
    });
  }

  Future<void> _fetchTopCoins() async {
    final coinGeckoService = CoinGeckoService(); // Instance of your service
    try {
      final coins = await coinGeckoService.fetchTopCoins();
      setState(() {
        topCoins = coins;
      });
    } catch (e) {
      print('Error fetching top coins: $e');
    }
  }

  void _setupEventListeners() {
    appKitModal.onModalConnect.subscribe((ModalConnect? event) {
      if (event != null) {
        print('Connected to modal: ${event.toString()}');
      }
    });

    appKitModal.onModalDisconnect.subscribe((ModalDisconnect? event) {
      if (event != null) {
        print('Disconnected from modal');
      }
    });

    appKitModal.onModalError.subscribe((ModalError? event) {
      if (event != null) {
        print('Error: ${event.message}');
      }
    });

    appKitModal.appKit!.core.relayClient.onRelayClientConnect.subscribe((EventArgs? event) {
      print('Relay client connected');
    });

    appKitModal.appKit!.core.relayClient.onRelayClientError.subscribe((EventArgs? event) {
      print('Relay client error: ${event?.toString()}');
    });

    appKitModal.appKit!.core.relayClient.onRelayClientDisconnect.subscribe((EventArgs? event) {
      print('Relay client disconnected');
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildCryptoBalanceCard(),
          const SizedBox(height: 20),
          AppKitModalNetworkSelectButton(appKit: appKitModal),
          AppKitModalConnectButton(appKit: appKitModal),
          Visibility(
            visible: appKitModal.isConnected,
            child: AppKitModalAccountButton(appKit: appKitModal),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              appKitModal.openModalView(const ReownAppKitModalSelectNetworkPage());
            },
            child: const Text('CONNECT WALLET'),
          ),
          const SizedBox(height: 20),
          _buildTopCoinsSection(), // Add the section for top coins
        ],
      ),
    );
  }

  Widget _buildCryptoBalanceCard() {
    return Card(
      color: const Color(0xFF1E1E1E),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Crypto Balance',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '₱$cryptoBalance',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF8BBE6D),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopCoinsSection() {
    return Card(
      color: const Color(0xFF1E1E1E),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Top Cryptocurrencies',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            topCoins.isEmpty
                ? const Center(
                    child: Text(
                      'No coins found',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: topCoins.length > 5 ? 5 : topCoins.length,
                    itemBuilder: (context, index) {
                      final coin = topCoins[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: const Color(0xFF1E1E1E),
                          child: Image.network(
                            coin['image'],
                            width: 30,
                            height: 30,
                          ),
                        ),
                        title: Text(
                          coin['name'],
                          style: const TextStyle(color: Colors.white),
                        ),
                        subtitle: Text(
                          '₱${coin['current_price'].toString()}',
                          style: const TextStyle(color: Colors.white),
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}