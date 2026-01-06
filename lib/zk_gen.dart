import 'dart:async';
import 'dart:convert';

import 'package:polygonid_flutter_sdk/circuits/data/circuit_model.dart';
import 'package:polygonid_flutter_sdk/circuits/data/circuits_to_download_param.dart';
import 'package:polygonid_flutter_sdk/common/domain/entities/chain_config_entity.dart';
import 'package:polygonid_flutter_sdk/common/domain/entities/env_entity.dart';
import 'package:polygonid_flutter_sdk/credential/domain/entities/claim_entity.dart';
import 'package:polygonid_flutter_sdk/iden3comm/domain/entities/credential/request/offer_iden3_message_entity.dart';
import 'package:polygonid_flutter_sdk/proof/domain/entities/download_info_entity.dart';
import 'package:polygonid_flutter_sdk/sdk/polygon_id_sdk.dart';

class ZkGenerator {
  static final EnvEntity defaultEnv = EnvEntity(
    pushUrl: 'https://push-staging.polygonid.com/api/v1',
    ipfsUrl: 'https://ipfs.io',
    ipfsGatewayUrl: 'https://ipfs.io/ipfs/',
    chainConfigs: {
      "80002": ChainConfigEntity(
        blockchain: 'polygon',
        network: 'amoy',
        rpcUrl: 'https://rpc-amoy.polygon.technology/',
        stateContractAddr: '0x1a4cC30f2aA0377b0c3bc9848766D90cb4404124',
      )
    },
    didMethods: []
  );
  static final defaultCircuits = CircuitsToDownloadParam(
    zipFileName: "circuits",
    bucketUrl: "https://0bb12tnp-3001.brs.devtunnels.ms/api/v1/circuits/keys.zip",
    circuitsWithChecksum: [
      CircuitModel(
        fileName: 'authV2.dat',
        circuitId: 'authV2',
        checksum: null,
      ),
      CircuitModel(
        fileName: 'credentialAtomicQuerySigV2.dat',
        circuitId: 'credentialAtomicQuerySigV2',
        checksum: null,
      ),
    ],
  );

  ZkGenerator();

  Future<void> initialize(EnvEntity? env) async {
    await PolygonIdSdk.init(env: env ?? defaultEnv);
  }

  Stream<DownloadInfo> downloadCircuits(
    CircuitsToDownloadParam? circuitsToDownload
  ) {
    return PolygonIdSdk.I.circuits.initCircuitsDownloadAndGetInfoStream(
      circuitsToDownload: circuitsToDownload ?? defaultCircuits,
    );
  }

  void handleDownloadInfo(Stream<DownloadInfo> stream, void Function(String, String) onInfo) {
    late StreamSubscription<DownloadInfo> subscription;

    subscription = stream.listen((info) {
        if (info is DownloadInfoOnProgress) {
          onInfo('downloading', '${(info.downloaded / info.contentLength * 100).toStringAsFixed(2)} %');
        } else if (info is DownloadInfoOnDone) {
          onInfo('done', 'Download completed');
          subscription.cancel();
        } else if (info is DownloadInfoOnError) {
          onInfo('error', 'Download error: ${info.errorMessage}');
        }
      },
      cancelOnError: true,
      onError: (error) => onInfo('error', 'Stream error occurred: $error'),
    );
  }

  Future<String> addIdentity() async {
    var identityEntity = await PolygonIdSdk.I.identity.addIdentity();
    return jsonEncode(identityEntity.toJson());
  }

  Future<void> authenticate(String msg, String did, String pk) async {
    var message = await PolygonIdSdk.I.iden3comm.getIden3Message(message: msg);
    await PolygonIdSdk.I.iden3comm.authenticate(
      privateKey: pk,
      genesisDid: did,
      message: message,
    );
  }

  Future<List<CredentialEntity>> claimCredential(String message, String did, String pk) async {
    var iden3message = await PolygonIdSdk.I.iden3comm.getIden3Message(message: message);
    return await PolygonIdSdk.I.iden3comm.fetchAndSaveClaims(
      message: iden3message as CredentialsOfferMessage,
      genesisDid: did,
      privateKey: pk,
      profileNonce: BigInt.from(0),
      keys: []
    );
  }

  Future<String> backupIdentity(String did, String pk) async {
    return await PolygonIdSdk.I.identity.backupIdentity(
      genesisDid: did,
      privateKey: pk,
    );
  }
}