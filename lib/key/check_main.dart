// import 'dart:io';
//
//
//
// void main() {
//   // Specify the input and output file paths.
//   final inputFile = File('your_input_file.dart');
//   final outputFile = File('your_output_file.dart');
//
//   try {
//     // Read the content of the input file.
//     final lines = inputFile.readAsLinesSync();
//
//     // Create an output file for writing.
//     final outputSink = outputFile.openWrite();
//
//     // Define a regular expression pattern to match the existing format.
//     final pattern = RegExp(r'static const String (\w+) = \'[ ^ ']+\';');
//
//     for (final line in lines) {
//       final match = pattern.firstMatch(line);
//       if (match != null) {
//         // Extract the key from the matched line.
//         final key = match.group(1);
//
//         // Write the line with the new format to the output file.
//         outputSink.writeln('static const String $key = \'$key\';');
//       } else {
//         // Write the original line to the output file if it doesn't match the pattern.
//         outputSink.writeln(line);
//       }
//     }
//
//     // Close the output file.
//     outputSink.close();
//
//     print('Conversion completed successfully. Output written to ${outputFile.path}');
//   } catch (e) {
//     print('An error occurred: $e');
//   }
// }
