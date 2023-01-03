import 'dart:math';

extension ExtendedList<T> on List<T> {
  List<int> getRandomIndex({int count = 1}) {
    List<int> numberList = [];
    Random random = Random();
    while (numberList.length < count) {
      int randomNumber = random.nextInt(length);
      if (!numberList.contains(randomNumber)) {
        numberList.add(randomNumber);
      }
    }

    return numberList;
  }
}
