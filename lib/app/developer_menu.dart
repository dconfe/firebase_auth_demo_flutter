import 'package:firebase_auth_demo_flutter/app/auth_service_type_bloc.dart';
import 'package:firebase_auth_demo_flutter/services/auth_service.dart';
import 'package:firebase_auth_demo_flutter/services/auth_service_facade.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DeveloperMenu extends StatelessWidget {
  const DeveloperMenu._({@required this.authServiceTypeBloc});
  final AuthServiceTypeBloc authServiceTypeBloc;

  static Widget create(BuildContext context) {
    final AuthServiceFacade authServiceFacade = Provider.of<AuthService>(context) as AuthServiceFacade;
    final AuthServiceTypeBloc bloc = AuthServiceTypeBloc(authServiceFacade: authServiceFacade);
    return StatefulProvider<AuthServiceTypeBloc>(
      valueBuilder: (BuildContext context) => bloc,
      onDispose: (BuildContext context, AuthServiceTypeBloc bloc) => bloc.dispose(),
      child: DeveloperMenu._(authServiceTypeBloc: bloc),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: <Widget>[
        DrawerHeader(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: const <Widget>[
              Text('Developer menu'),
            ],
          ),
          decoration: BoxDecoration(
            color: Colors.indigo,
          ),
        ),
        _buildOptions(context),
      ]),
    );
  }

  Widget _buildOptions(BuildContext context) {
    return StreamBuilder<AuthServiceType>(
        stream: authServiceTypeBloc.authServiceTypeStream,
        initialData: AuthServiceType.firebase,
        builder: (BuildContext context, AsyncSnapshot<AuthServiceType> snapshot) {
          return Expanded(
            child: ListView(
              children: <Widget>[
                SegmentedControl<AuthServiceType>(
                  header: Text('Authentication type'),
                  value: snapshot.data,
                  onValueChanged: (AuthServiceType type) => authServiceTypeBloc.setAuthServiceType(type),
                  children: const <AuthServiceType, Widget>{
                    AuthServiceType.firebase: Text('Firebase'),
                    AuthServiceType.mock: Text('Mock'),
                  },
                ),
              ],
            ),
          );
        });
  }
}

class SegmentedControl<T> extends StatelessWidget {
  SegmentedControl({this.header, this.value, this.children, this.onValueChanged});
  final Widget header;
  final T value;
  final Map<T, Widget> children;
  final ValueChanged<T> onValueChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
          child: header,
        ),
        SizedBox(
          width: double.infinity,
          child: CupertinoSegmentedControl<T>(
            children: children,
            groupValue: value,
//            selectedColor: Palette.blueSky,
//            pressedColor: Palette.blueSkyLighter,
            onValueChanged: onValueChanged,
          ),
        ),
      ],
    );
  }
}