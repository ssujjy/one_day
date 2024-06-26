import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ovary_app/vm/mypage_update_vm.dart';
import 'package:ovary_app/vm/signup_vm.dart';
import 'package:ovary_app/widget/image_widget/image_widget.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class MypageUpdateWidget extends StatefulWidget {
  MypageUpdateWidget({Key? key}) : super(key: key);

  @override
  _MypageUpdateWidgetState createState() => _MypageUpdateWidgetState();
}

class _MypageUpdateWidgetState extends State<MypageUpdateWidget> {
  final TextEditingController nicknameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController1 = TextEditingController();
  final TextEditingController passwordController2 = TextEditingController();

  final MypageUpdateVM mypageUpdateVM = Get.put(MypageUpdateVM());
  final MypageUpdateVM mypageUpdateVMInstance = Get.put(MypageUpdateVM());
  final mypageUpdateVMFunction = MypageUpdateVM();
  final imageWidget = ImageWidget();
  final SignUpGetX c = Get.put(SignUpGetX());
  ImagePicker picker = ImagePicker();
  XFile? imageFile;
  File? imgFile;
  String email = '';
  String nickValue = '';
  final box = GetStorage();

  @override
  void initState() {
    super.initState();
    email = box.read('email');
    nickValue = box.read('nick');
    emailController.text = email;
    nicknameController.text = nickValue;
    loadingUserInfoAction();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: GetBuilder<MypageUpdateVM>(
          builder: (controller) {
            return Column(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width / 2,
                  child: Center(
                    child: imageFile == null
                        ? CircleAvatar(
                            backgroundImage: NetworkImage(controller.imagepath),
                            radius: 100,
                          )
                        : Image.file(
                            File(mypageUpdateVMInstance.selectedImagePath)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ElevatedButton(
                    onPressed: () {
                      getImageFromDevice(ImageSource.gallery);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(139, 127, 245, 1),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      fixedSize: Size(MediaQuery.of(context).size.width / 2,
                          MediaQuery.of(context).size.height / 17),
                    ),
                    child: const Text(
                      'Gallery에서 사진 불러오기',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 50, 20, 10),
                  child: TextField(
                    controller: emailController,
                    readOnly: true,
                    decoration: const InputDecoration(
                        labelText: '이메일(수정불가)', border: OutlineInputBorder()),
                    keyboardType: TextInputType.text,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: TextField(
                    controller: nicknameController,
                    decoration: const InputDecoration(
                        labelText: '닉네임을 입력하세요', border: OutlineInputBorder()),
                    keyboardType: TextInputType.text,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: TextField(
                    onChanged: (value) {
                      passwordCheck();
                    },
                    controller: passwordController1,
                    decoration: const InputDecoration(
                        labelText: '비밀번호를 입력 하세요', border: OutlineInputBorder()),
                    keyboardType: TextInputType.text,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: TextField(
                    onChanged: (value) {
                      passwordCheck();
                    },
                    controller: passwordController2,
                    decoration: const InputDecoration(
                        labelText: '비밀번호를 다시 입력 하세요',
                        border: OutlineInputBorder()),
                    keyboardType: TextInputType.text,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 10, 0, 10),
                  child: Obx(() => Row(
                    children: [
                      Text(
                        signUpGetX.pwCheckResult.value,
                        style: TextStyle(
                          color: signUpGetX.pwCheckResult.value == '일치'
                              ? Colors.blue
                              : signUpGetX.pwCheckResult.value == '불일치'
                              ? Colors.red
                              : Colors.green,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  )),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ElevatedButton(
                    onPressed: () {
                      checkpassword();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(139, 127, 245, 1),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      fixedSize: Size(MediaQuery.of(context).size.width / 2,
                          MediaQuery.of(context).size.height / 17),
                    ),
                    child: const Text(
                      '정보수정',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }



  serchInfo() {
    nicknameController.text = mypageUpdateVM.nickname;
    emailController.text = mypageUpdateVM.email;
  }

  checkpassword() {
    if (passwordController1.text == passwordController2.text) {
      //비밀번호 값 vm에 저장
      mypageUpdateVM.password1 = passwordController1.text;
      mypageUpdateVM.password2 = passwordController2.text;
    }
    if (nicknameController.text == null || nicknameController.text.isEmpty) {
      nicknameSnack();
    } else if (passwordController1.text == null ||
        passwordController1.text.isEmpty) {
      passwordSnack();
    } else if (passwordController2.text == null ||
        passwordController2.text.isEmpty) {
      passwordSnack();
    } else if (imageFile == null) {
      imageSnack();
    } else {
      updatesuccessSnack();
      updateAction();
      // 프로필 이미지 업데이트 함수 호출
      // updateProfileImage(File(imageFile!.path));
      Get.back();
      print("업데이트 성공");
    }
  }

  loadingUserInfoAction() async {
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('user')
        .where('email', isEqualTo: box.read('email'))
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      //firebase에서 받아온 데이터를 list로 변환
      final List<Map<String, dynamic>> dataList1 = querySnapshot.docs
          .map((doc) => {
                'email': doc['email'],
                'nickname': doc['nickname'],
                'profile': doc['profile'],
                // 'nickname': doc['profile'],
              })
          .toList();
      //받아온 list데이터를 풀어서 뷰 모델에 저장함
      String email = dataList1[0]['email'];
      String nickname = dataList1[0]['nickname'];
      String profile = dataList1[0]['profile'];
      //vm의 변수에 할당
      mypageUpdateVM.email = email;
      mypageUpdateVM.nickname = nickname;
      mypageUpdateVM.imagepath = await profile;

      mypageUpdateVM.show();
      //변수 바꾸고 나서 텍스트 필드에 변수 할당
      //nicknameController.text = await mypageUpdateVM.nickname;
      emailController.text = await mypageUpdateVM.email;
    } else {
      // 데이터가 없는 경우
      print('데이터 없음');
    }
  }

  updateAction() async {
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('user')
        .where('email', isEqualTo: box.read('email'))
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      final DocumentSnapshot document = querySnapshot.docs[0]; // 첫 번째 문서 사용
      final Map<String, dynamic> data = document.data() as Map<String, dynamic>;

      mypageUpdateVM.email = data['email'];
      mypageUpdateVM.nickname = data['nickname'];
      mypageUpdateVM.imagepath = data['profile'];
      mypageUpdateVM.nickname = nicknameController.text;
      // 업데이트 작업 수행
      await FirebaseFirestore.instance
          .collection('user')
          .doc(document.id) // 문서 ID 사용
          .update({
        'email': mypageUpdateVM.email,
        'password': mypageUpdateVM.password1,
        'nickname': mypageUpdateVM.nickname,

        // 프로필 필드가 있으면 업데이트
        if (mypageUpdateVM.imagepath != null)
          'profile': mypageUpdateVM.imagepath,
        // 다른 필드 업데이트
      }).then((_) {
        updateProfileImage(File(mypageUpdateVMInstance.selectedImagePath));
        Get.back();
        Get.back();
        Get.back();
      }).catchError((error) {
        print("업데이트 실패: $error");
      });
    } else {
      // 데이터가 없는 경우
      print('데이터 없음');
      // passwordController1.text.length==0;
    }
  }

  passwordCheck() {
    // 빈칸일때
    if (passwordController1.text.isEmpty || passwordController2.text.isEmpty) {
      signUpGetX.passwordCheck(
          passwordController1.text, passwordController2.text);
    }
    // 입력했을때
    if (passwordController1.text.isNotEmpty &&
        passwordController2.text.isNotEmpty) {
      signUpGetX.passwordCheck(
        passwordController1.text,
        passwordController2.text,
      );
    }
  }

  getImageFromDevice(imageSource) async {
    final XFile? pickedFile = await picker.pickImage(source: imageSource);
    if (pickedFile == null) {
      imageFile = null;
      mypageUpdateVM.update();
    } else {
      imageFile = XFile(pickedFile.path);
      mypageUpdateVMInstance.selectedImagePath = imageFile!.path;
      print(mypageUpdateVMInstance.selectedImagePath);
      mypageUpdateVM.update();
    }
  }

  Future<void> updateProfileImage(File imageFile) async {
    final email = box.read('email');
    final storage = firebase_storage.FirebaseStorage.instance;

    // Firebase Storage에 이미지 업로드 -> 이메일 기준으로 사진이름이 정해지기 때문에 자동으로 덮어쓰기가 된다!
    final imageRef = storage.ref().child('images/${email}.jpg');
    await imageRef.putFile(imageFile);

    // Firebase Storage에서 업로드된 이미지의 다운로드 URL 가져오기
    final downloadURL = await imageRef.getDownloadURL();

    // Firestore 문서에 다운로드 URL 업데이트
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('user')
        .where('email', isEqualTo: email)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      final DocumentSnapshot document = querySnapshot.docs[0];
      final existingImageURL = document.get('profile');
      // 기존 이미지 삭제 (있는 경우에만)
      // if (existingImageURL != null) {
      //   final existingImageRef = storage.refFromURL(existingImageURL);
      //   await existingIma geRef.delete();
      // }
      await FirebaseFirestore.instance
          .collection('user')
          .doc(document.id) // 문서 ID 사용
          .update({
        'profile': downloadURL,
      });
    } else {
      // 데이터가 없는 경우
      print('데이터 없음');
    }
  }

  //이미지 없을시에 나오는 snackbar
  imageSnack() {
    Get.snackbar(
      '알림',
      '이미지를 변경해주세요.',
      duration: const Duration(seconds: 1),
      backgroundColor: const Color.fromRGBO(245, 241, 255, 1),
      colorText: const Color.fromARGB(255, 117, 103, 241),
      snackPosition: SnackPosition.TOP,
    );
  }

  nicknameSnack() {
    Get.snackbar(
      '알림',
      '변경할 닉네임을 입력해주세요.',
      duration: const Duration(seconds: 1),
      backgroundColor: const Color.fromRGBO(245, 241, 255, 1),
      colorText: const Color.fromARGB(255, 117, 103, 241),
      snackPosition: SnackPosition.TOP,
    );
  }

  passwordSnack() {
    Get.snackbar(
      '알림',
      '변경할 비밀번호를 입력해주세요.',
      duration: const Duration(seconds: 1),
      backgroundColor: const Color.fromRGBO(245, 241, 255, 1),
      colorText: const Color.fromARGB(255, 117, 103, 241),
      snackPosition: SnackPosition.TOP,
    );
  }

  updatesuccessSnack() {
    Get.snackbar(
      '알림',
      '회원정보 변경에 성공했습니다!.',
      duration: const Duration(seconds: 1),
      backgroundColor: const Color.fromRGBO(245, 241, 255, 1),
      colorText: const Color.fromARGB(255, 117, 103, 241),
      snackPosition: SnackPosition.TOP,
    );
  }
}
