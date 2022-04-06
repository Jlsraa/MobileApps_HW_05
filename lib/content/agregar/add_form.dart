import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foto_share/content/agregar/bloc/create_bloc.dart';

class AddForm extends StatefulWidget {
  AddForm({Key? key}) : super(key: key);

  @override
  State<AddForm> createState() => _AddFormState();
}

class _AddFormState extends State<AddForm> {
  var _titleC = TextEditingController();
  bool _defaultSwitchValue = false;
  File? image;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreateBloc, CreateState>(
      listener: (context, state) {
        if (state is CreatePictureErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Error al seleccionar imagen..."),
          ));
        } else if (state is CreateFshareErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Error al guardar Fshare..."),
            ),
          );
        } else if (state is CreateSuccessState) {
          _titleC.clear();
          _defaultSwitchValue = false;
          image = null;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Imagen Publicada..."),
            ),
          );
        } else if (state is CreatePictureChangedState) {
          image = state.picture;
        }
      },
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: ListView(
            children: [
              image != null
                  ? Image.file(
                      image!,
                      height: 120,
                    )
                  : Container(),
              MaterialButton(
                child: Text("Nueva Foto"),
                onPressed: () {
                  // BLoC Tomar foto
                  BlocProvider.of<CreateBloc>(context)
                      .add(OnCreateTakePictureEvent());
                },
              ),
              SizedBox(
                height: 24,
              ),
              TextField(
                controller: _titleC,
                decoration: InputDecoration(
                  label: Text("Titulo"),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(
                height: 24,
              ),
              SwitchListTile(
                title: Text("Publico"),
                value: _defaultSwitchValue,
                onChanged: (newValue) {
                  _defaultSwitchValue = newValue;
                  setState(() {});
                },
              ),
              SizedBox(
                height: 24,
              ),
              MaterialButton(
                child: Text("Publicar"),
                onPressed: () {
                  // BLoC guarda los datos en FireBase
                  Map<String, dynamic> fshareData = {};
                  fshareData = {
                    "title": _titleC.text,
                    "public": _defaultSwitchValue,
                  };
                  BlocProvider.of<CreateBloc>(context)
                      .add(OnCreateSaveDataEvent(dataToSave: fshareData));
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
