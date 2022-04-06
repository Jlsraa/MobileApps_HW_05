import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

part 'create_event.dart';
part 'create_state.dart';

class CreateBloc extends Bloc<CreateEvent, CreateState> {
  File? _selectedPicture;

  CreateBloc() : super(CreateInitial()) {
    on<OnCreateTakePictureEvent>(_takePicture);
    on<OnCreateSaveDataEvent>(_saveData);
  }

  FutureOr<void> _takePicture(event, emit) async {
    emit(CreateLoadingState());
    await _getImage();
    if (_selectedPicture != null) {
      emit(CreatePictureChangedState(picture: _selectedPicture!));
    } else {
      emit(CreatePictureErrorState());
    }
  }

  FutureOr<void> _saveData(OnCreateSaveDataEvent event, emit) async {
    emit(CreateLoadingState());
    bool saved = await _saveFshare(event.dataToSave);
    emit(saved ? CreateSuccessState() : CreateFshareErrorState());
  }

  FutureOr<void> _getImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxHeight: 720,
      maxWidth: 720,
      imageQuality: 85,
    );
    if (pickedFile != null) {
      _selectedPicture = File(pickedFile.path);
    } else {
      print("No se seleccionó una imagen");
      _selectedPicture = null;
    }
  }

  FutureOr<bool> _saveFshare(Map<String, dynamic> dataToSave) async {
    try {
      String _imageUrl = await _uploadPictureToStorage();
      if (_imageUrl != "") {
        // En caso de haber subido la imagem, hay que actualizar el Map
        dataToSave["picture"] = _imageUrl;
        dataToSave["publishedAt"] = Timestamp.fromDate(DateTime.now());
        dataToSave["stars"] = 0;
        dataToSave["username"] = FirebaseAuth.instance.currentUser!.displayName;
      } else {
        return false;
      }

      // Guardar Fshare en Cloud Firestore
      var docRef =
          await FirebaseFirestore.instance.collection("fshare").add(dataToSave);

      // Actualiza lista de fotoShares en collection "users"
      return await _updateUserDocumentReference(docRef.id);
    } catch (e) {
      print("Error al crear Fshare:  $e");
      return false;
    }
  }

  FutureOr<bool> _updateUserDocumentReference(String fshareId) async {
    try {
      var queryUSer = await FirebaseFirestore.instance
          .collection("users")
          .doc("${FirebaseAuth.instance.currentUser!.uid}");

      // Query para sacar la data
      var docsRef = await queryUSer.get();
      List<dynamic> listIds = docsRef.data()?["fotosListId"];

      //Agregar nuevo id
      listIds.add(fshareId);

      //Guardar
      await queryUSer.update({"fotosListId": listIds});
      return true;
    } catch (e) {
      print("Error al actulizar la colección de Users:  $e");
      return false;
    }
  }

  FutureOr<String> _uploadPictureToStorage() async {
    try {
      var stamp = DateTime.now();
      if (_selectedPicture == null) {
        return "";
      }

      // Definición de upload task
      UploadTask task = FirebaseStorage.instance
          .ref("fshares/imagen_${stamp}.png")
          .putFile(_selectedPicture!);

      // Ejejcutar task
      await task;

      // Al esperar la ejecución, si todo sale bien se guarda y necesitamos recuperar la URL del archivo
      return await task.storage
          .ref("fshares/imagen_${stamp}.png")
          .getDownloadURL();
    } catch (e) {
      return "";
    }
  }
}
