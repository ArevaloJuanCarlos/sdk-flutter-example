import 'package:flutter/widgets.dart';
//import 'package:polygonid_flutter_sdk/proof/domain/entities/download_info_entity.dart';
//import 'package:wira_flutter_module/zk_gen.dart';
import 'method_channel.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  initializeWiraLogic();
  //runApp(const WiraApp());
}
/*
class WiraApp extends StatelessWidget {
  const WiraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wira Login',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final List<String> _outputs = [];
  final ZkGenerator _zkGenerator = ZkGenerator();
  final TextEditingController _authController = TextEditingController();
  final TextEditingController _credController = TextEditingController();

  @override
  void dispose() {
    _authController.dispose();
    _credController.dispose();
    super.dispose();
  }

  Future<void> _initializeSDK() async {
    await _zkGenerator.initialize(null);
    setState(() {
      _outputs.add('SDK Initialized');
    });
  }

  Future<void> _checkAndDownloadCircuits() async {
    Stream<DownloadInfo> stream = _zkGenerator.downloadCircuits(null);
    stream.listen((info) {
      setState(() {
        if (info is DownloadInfoOnProgress) {
          _outputs.add('Downloading: ${(info.downloaded / info.contentLength * 100).toStringAsFixed(2)} %');
        } else if (info is DownloadInfoOnDone) {
          _outputs.add('Download completed');
        } else if (info is DownloadInfoOnError) {
          _outputs.add('Download error: ${info.errorMessage}');
        }
      });
    });
  }

  Future<void> _createIdentity() async {
    String identity = await _zkGenerator.addIdentity();
    print(identity);
    setState(() {
      _outputs.add('Identity created');
    });
  }

  Future<void> _getCredentials() async {
    String input = _credController.text;
    await _zkGenerator.claimCredential(input, '', '');
    setState(() {
      _outputs.add('Credentials retrieved');
    });
  }

  Future<void> _authenticate() async {
    String input = _authController.text;
    await _zkGenerator.authenticate(input, '', '');
    setState(() {
      _outputs.add('Authenticated');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 360),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Welcome back',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _initializeSDK,
                child: const Text('1. Initialize SDK'),
              ),
              const SizedBox(height: 8),
              FilledButton(
                onPressed: _checkAndDownloadCircuits,
                child: const Text('2. Check and download circuits'),
              ),
              const SizedBox(height: 8),
              FilledButton(
                onPressed: _createIdentity,
                child: const Text('3. Create identity'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _credController,
                decoration: const InputDecoration(
                  labelText: 'Credentials Input',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              FilledButton(
                onPressed: _getCredentials,
                child: const Text('4. Get credentials'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _authController,
                decoration: const InputDecoration(
                  labelText: 'Authentication Input',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              FilledButton(
                onPressed: _authenticate,
                child: const Text('5. Authenticate'),
              ),
              const SizedBox(height: 24),
              const Text('Output:'),
              const SizedBox(height: 8),
              Container(
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(_outputs.isEmpty ? 'No output yet' : _outputs.join('\n')),
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
*/