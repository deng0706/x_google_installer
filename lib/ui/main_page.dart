import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:package_info/package_info.dart';
import 'package:x_google_installer/generated/l10n.dart';
import 'package:x_google_installer/ui/widgets.dart';

import '../conf.dart';

class MainPage extends StatefulWidget {
  MainPage({Key key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  GoogleFrameworkStatus status = GoogleFrameworkStatus(null, null, null);

  @override
  void initState() {
    checkState();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: getAppBackGroundColor(context),
      appBar: makeAppBar(context,
          title: Text(
            "X Google Installer",
            style: TextStyle(color: getTextColor(context)),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.delete),
              tooltip: S.of(context).title_uninstall,
              onPressed: () {},
              color: getTextColor(context),
            ),
            IconButton(
              tooltip: S.of(context).title_about_us,
              icon: Icon(Icons.help),
              onPressed: () {},
              color: getTextColor(context),
            )
          ]),
      body: SingleChildScrollView(
        child: Column(
          children: [
            StateBanner(status.getStatusCode()),
            SizedBox(
              height: 4,
            ),
            DeviceInformationBanner(),
          ],
        ),
      ),
    );
  }

  void checkState() async {
    PackageInfo framework;
    try {
      framework =
          await PackageInfo.fromPlatformByPackageName("com.google.android.gsf");
    } catch (e) {
      print(e);
    }
    PackageInfo service;
    try {
      service =
          await PackageInfo.fromPlatformByPackageName("com.google.android.gms");
    } catch (e) {
      print(e);
    }
    PackageInfo store;
    try {
      store =
          await PackageInfo.fromPlatformByPackageName("com.android.vending");
    } catch (e) {
      print(e);
    }
    setState(() {
      status = GoogleFrameworkStatus(framework, service, store);
    });
  }
}

class DeviceInformationBanner extends StatefulWidget {
  @override
  _DeviceInformationBannerState createState() =>
      _DeviceInformationBannerState();
}

class _DeviceInformationBannerState extends State<DeviceInformationBanner> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Card(
        elevation: 0.5,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.white70, width: 1),
          borderRadius: BorderRadius.circular(1),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
                padding: EdgeInsets.only(left: 10, top: 4, bottom: 10),
                child: Row(
                  children: [
                    Icon(
                      Icons.code,
                      size: 28,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      S.of(context).title_deviceInfo,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    )
                  ],
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                makeDeviceInfoRow(
                    context,
                    Icon(
                      Icons.android,
                      size: 32,
                      color: const Color.fromARGB(255, 61, 218, 132),
                    ),
                    "Android${AppConf.androidDeviceInfo.version.release}",
                    "Sdk${AppConf.androidDeviceInfo.version.sdkInt}"),
                makeDeviceInfoRow(
                    context,
                    Icon(
                      Icons.developer_board,
                      size: 32,
                      color: Colors.black,
                    ),
                    S.of(context).title_architecture,
                    "${AppConf.androidDeviceInfo.supportedAbis.toString().replaceAll("[", "").replaceAll("]", "")}",
                    subtitleSize: 8),
                makeDeviceInfoRow(
                    context,
                    Icon(
                      Icons.phone_android,
                      size: 32,
                      color: Colors.black,
                    ),
                    "${AppConf.androidDeviceInfo.manufacturer}",
                    "${AppConf.androidDeviceInfo.model}")
              ],
            ),
            SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}

class GoogleFrameworkStatus {
  PackageInfo framework;
  PackageInfo service;
  PackageInfo store;

  GoogleFrameworkStatus(this.framework, this.service, this.store);

  int getStatusCode() {
    if (framework == null && service == null && store == null) {
      return -1;
    }
    if (framework == null || service == null || store == null) {
      return -2;
    }
    return 0;
  }
}

Widget makeDeviceInfoRow(
    BuildContext context, Widget icon, String title, String subtitle,
    {double subtitleSize = 13}) {
  return Padding(
    padding: EdgeInsets.only(left: 10, right: 10),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        icon,
        Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 12,
          child: Center(
            child: Text(
              subtitle,
              style: TextStyle(
                  fontSize: subtitleSize,
                  color: Colors.black.withAlpha(120),
                  fontWeight: FontWeight.bold),
            ),
          ),
        )
      ],
    ),
  );
}

class StateBanner extends StatefulWidget {
  /// ok:0 nothing:-1 incomplete:-2
  final int status;

  StateBanner(this.status);

  @override
  _StateBannerState createState() => _StateBannerState();
}

class _StateBannerState extends State<StateBanner> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: getBannerColorWithStatus(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Padding(
              padding: EdgeInsets.only(top: 20),
              child: getBannerIconWithStatus(),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: Text(
                getBannerTextWithStatus(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }

  String getBannerTextWithStatus() {
    switch (widget.status) {
      case 0:
        return S.of(context).c_framework_ok;
      case -1:
        return S.of(context).c_framework_error;
      case -2:
        return S.of(context).c_framework_warning;
      default:
        return "?";
    }
  }

  Color getBannerColorWithStatus() {
    switch (widget.status) {
      case 0:
        return Colors.green;
      case -1:
        return Colors.red;
      case -2:
        return Colors.amberAccent;
      default:
        return Colors.white;
    }
  }

  Widget getBannerIconWithStatus() {
    const size = 48.00;
    const color = Colors.white;
    switch (widget.status) {
      case 0:
        return FaIcon(
          FontAwesomeIcons.check,
          size: size,
          color: color,
        );
      case -1:
        return FaIcon(FontAwesomeIcons.times, size: size, color: color);
      case -2:
        return FaIcon(FontAwesomeIcons.exclamationTriangle,
            size: size, color: color);
      default:
        return Icon(
          Icons.help,
          size: size,
          color: color,
        );
    }
  }
}
