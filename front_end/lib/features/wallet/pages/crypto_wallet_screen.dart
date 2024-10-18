import 'dart:convert';
import 'dart:math';
import 'package:budgetwise_one/features/wallet/walletprovider/balance.dart';
import 'package:budgetwise_one/features/wallet/walletprovider/payment.dart';
import 'package:flutter/material.dart';
import 'package:reown_appkit/reown_appkit.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class CryptoWalletScreen extends StatefulWidget {
  const CryptoWalletScreen({super.key});


  @override
  State<CryptoWalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<CryptoWalletScreen> {
  ReownAppKitModal? appKitModal;
  String walletAddress = '';
  String _balance = '0';
  bool isLoading = false;
  List<TransactionDetails> transactions = [];

  final customNetwork = ReownAppKitModalNetworkInfo(
    name: 'Sepolia',
    chainId: '11155111',
    currency: 'ETH',
    rpcUrl: 'https://rpc.sepolia.org/',
    explorerUrl: 'https://sepolia.etherscan.io/',
    isTestNetwork: true,
  );

  final String etherscanApiKey = '13SYGMMFG27Z343YCQAVAH5B7R8NS3HR45';

  @override

  void initState() {
    super.initState();
    initializeAppKitModal();
  }

  void initializeAppKitModal() async {
    ReownAppKitModalNetworks.addNetworks('eip155', [customNetwork]);
    appKitModal = ReownAppKitModal(
      context: context,
      projectId: 'e9191ac2aa60ece02115a39c7d51b48c',
      metadata: const PairingMetadata(
        name: 'Buko App',
        description: 'Payment method',
        url: 'https://www.reown.com/',
        icons: ['https://reown.com/reown-logo.png'],
        redirect: Redirect(
          native: 'cryptoflutter://',
          universal: 'https://reown.com/buko_app',
          linkMode: true,
        ),
      ),
    );

    await appKitModal!.init();
    appKitModal!.addListener(updateWalletAddress);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedWalletAddress = prefs.getString('walletAddress');
    if (savedWalletAddress != null) {
      setState(() {
        walletAddress = savedWalletAddress;
      });
    }
  }

  void updateWalletAddress() async {
    if (appKitModal?.session != null) {
      setState(() {
        walletAddress = appKitModal!.session!.address ?? 'No Address';
        _balance = appKitModal!.balanceNotifier.value;
        fetchTransactions(
            walletAddress); 
      });

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('walletAddress', walletAddress);
    } else {
      setState(() {
        walletAddress = 'No Address';
        _balance = 'No Balance';
        transactions.clear(); 
      });

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('walletAddress');
    }
  }

  Future<void> loginWithMetaMask(
      String email, String password, String metamaskAddress) async {
    final response = await http.post(
      Uri.parse('https://vercel-testing-y4tp.vercel.app/api/users/login'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'email': email,
        'password': password,
        'walletAddress': metamaskAddress 
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      // Handle successful login, e.g., save the token
      print('Login successful: ${data['message']}');
    } else {
      print('Login failed: ${response.body}');
    }
  }

  Future<void> logout() async {
    final response = await http.post(
      Uri.parse('https://vercel-testing-y4tp.vercel.app/api/users/logout'),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      print('Logout successful: ${json.decode(response.body)['message']}');
    } else {
      print('Logout failed: ${response.body}');
    }
  }

  Future<void> fetchTransactions(String address) async {
    setState(() {
      isLoading = true;
    });
    try {
      final url =
          'https://api-sepolia.etherscan.io/api?module=account&action=txlist&address=$address&startblock=0&endblock=99999999&sort=desc&apikey=$etherscanApiKey';
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == '1') {
          final txList = data['result'] as List;
          setState(() {
            transactions = txList.map((tx) {
              // Check if the transaction is sent by the current address
              final String addressLowerCase = address
                  .toLowerCase(); // Convert address to lower case for comparison
              final String sender = tx['from'];
              final String recipient = tx['to'];
              bool isSent = sender.toLowerCase() == addressLowerCase;
              return TransactionDetails(
                sender: sender,
                recipient: recipient,
                amount: (BigInt.parse(tx['value']) / BigInt.from(10).pow(18))
                    .toString(),
                hash: tx['hash'],
                isSent: isSent,
                date: DateTime.fromMillisecondsSinceEpoch(
                    int.parse(tx['timeStamp']) * 1000),
              );
            }).toList();
          });
        } else {
          throw Exception('Failed to load transactions');
        }
      } else {
        throw Exception('Failed to fetch transactions');
      }
    } catch (e) {
      print('Error fetching transactions: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                automaticallyImplyLeading: false,
                pinned: true,
                expandedHeight: 200.0,
                flexibleSpace: FlexibleSpaceBar(
                  title: const SizedBox.shrink(),
                  background: Container(
                    color: const Color.fromARGB(255, 3, 169, 244),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              BalanceCard(
                                balance: _balance,
                                address: walletAddress,
                                backgroundColor: Colors
                                    .deepPurpleAccent, // Dark theme balance card
                                textColor: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                actions: const [
                   Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 30.0),
                        child: Text(
                          'Payment',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const SizedBox(height: 16),
                          AppKitModalConnectButton(
                            appKit: appKitModal!,
                            custom: ElevatedButton(
                              onPressed: () {
                                if (appKitModal!.isConnected) {
                                  appKitModal!.disconnect();
                                } else {
                                  appKitModal!.openModalView();
                                }
                              },
                              child: Text(appKitModal!.isConnected
                                  ? 'Disconnect'
                                  : 'Connect Wallet'),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Visibility(
                            visible: !appKitModal!.isConnected,
                            child: AppKitModalNetworkSelectButton(
                                appKit: appKitModal!),
                          ),
                          const SizedBox(height: 16),
                          Visibility(
                            visible: appKitModal!.isConnected,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    _showSendDialog(context);
                                  },
                                  child: const Text('Send'),
                                ),
                                const SizedBox(width: 17),
                                ElevatedButton(
                                  onPressed: () {
                                    // Define what happens when the Receive button is pressed
                                  },
                                  child: const Text('Receive'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Visibility(
                        visible: appKitModal!.isConnected,
                        child: isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : SizedBox(
                                height: 350,
                                child: ListView.builder(
                                  itemCount: transactions.length,
                                  itemBuilder: (context, index) {
                                    final transaction = transactions[index];
                                    return PaymentJobCardPage(
                                      amount: transaction.amount,
                                      sender: transaction.sender,
                                      recipient: transaction.recipient,
                                      hash: transaction.hash,
                                      date: transaction.date,
                                      isSent: transaction.isSent,
                                    );
                                  },
                                ),
                              ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showSendDialog(BuildContext context) {
    final TextEditingController addressController = TextEditingController();
    final TextEditingController amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Send Crypto'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: addressController,
                decoration: const InputDecoration(
                  hintText: 'Recipient Address (0x..)',
                ),
              ),
              TextField(
                controller: amountController,
                decoration: const InputDecoration(
                  hintText: 'Amount to Send',
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                String recipient = addressController.text;
                double amount = double.parse(amountController.text);
                BigInt bigIntValue = BigInt.from(amount * pow(10, 18));
                EtherAmount ethAmount =
                    EtherAmount.fromBigInt(EtherUnit.wei, bigIntValue);
                Navigator.of(context).pop();
                setState(() {
                  isLoading = true;
                  final Uri metamaskUri = Uri.parse("metamask://");
                  launchUrl(metamaskUri, mode: LaunchMode.externalApplication);
                });
                try {
                  await sendTransaction(recipient, ethAmount);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: ${e.toString()}')),
                  );
                }
              },
              child: const Text('Send'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  Future<void> sendTransaction(String receiver, EtherAmount txValue) async {
    setState(() {
      isLoading = true;
    });

    final tetherContract = DeployedContract(
      ContractAbi.fromJson(
        jsonEncode([
          {
            "constant": false,
            "inputs": [
              {"internalType": "address", "name": "_to", "type": "address"},
              {"internalType": "uint256", "name": "_value", "type": "uint256"}
            ],
            "name": "transfer",
            "outputs": [],
            "payable": false,
            "stateMutability": "nonpayable",
            "type": "function"
          }
        ]),
        'ETH',
      ),
      EthereumAddress.fromHex(receiver),
    );

    try {
      final senderAddress = appKitModal!.session!.address!;
      final currentBalance = appKitModal!.balanceNotifier.value;

      if (currentBalance.isEmpty) {
        throw Exception('Unable to fetch wallet balance.');
      }

      BigInt balanceInWeiValue;
      try {
        double balanceInEther = double.parse(currentBalance.split(' ')[0]);
        balanceInWeiValue = BigInt.from((balanceInEther * pow(10, 18)).toInt());
      } catch (e) {
        throw Exception('Error parsing wallet balance: $e');
      }

      final balanceInWei =
          EtherAmount.fromUnitAndValue(EtherUnit.wei, balanceInWeiValue);

      final totalCost = txValue.getInWei + BigInt.from(100000 * 21000);
      if (balanceInWei.getInWei < totalCost) {
        throw Exception('Insufficient funds for transaction!');
      }

      final result = await appKitModal!.requestWriteContract(
        topic: appKitModal!.session!.topic,
        chainId: appKitModal!.selectedChain!.chainId,
        deployedContract: tetherContract,
        functionName: 'transfer',
        transaction: Transaction(
          from: EthereumAddress.fromHex(senderAddress),
          to: EthereumAddress.fromHex(receiver),
          value: txValue,
          maxGas: 100000,
        ),
        parameters: [
          EthereumAddress.fromHex(receiver),
          txValue.getInWei,
        ],
      );

      if (result != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Transaction successful!')),
        );
        await appKitModal!.loadAccountData();
      } else {
        throw Exception('Transaction failed. Please try again.');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}

class TransactionDetails {
  final String sender;
  final String recipient;
  final String amount;
  final String hash;
  final DateTime date;
  final bool isSent;

  TransactionDetails({
    required this.sender,
    required this.recipient,
    required this.amount,
    required this.hash,
    required this.date,
    required this.isSent,
  });
}