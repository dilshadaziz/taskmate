import 'dart:io';
import 'dart:js_util';

void main (){
 var nums = [2,1,3,3], k = 2;
  List<int> sortedIndices = List<int>.generate(nums.length, (index) => index)
      ..sort((a, b) => nums[a].compareTo(nums[b]));

  List<int> sortedValues = sortedIndices.map((index) => nums[index]).toList();
  List<int> lastKValues = sortedValues.sublist(sortedValues.length - k);
  print( lastKValues);
  int numss =1;
  var n = double.parse('$numss');
  print(n);
}