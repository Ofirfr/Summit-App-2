import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'package:file_saver/file_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' hide Column;

Future<void> generateExcel(String fileName, DataTable table) async {
  //Create a Excel document.

  //Creating a workbook.
  final Workbook workbook = Workbook();
  //Accessing via index
  final Worksheet sheet = workbook.worksheets[0];
  sheet.showGridlines = true;

  // Get Data from DataTable
  List<DataColumn> columns = table.columns;
  List<DataRow> rows = table.rows;
  final Style cellStyle = workbook.styles.add('CellStyle');
  cellStyle.hAlign = HAlignType.center;
  cellStyle.wrapText = true;
  for (int i = 0; i < columns.length; i++) {
    String column = String.fromCharCode(i + 65);
    for (int j = 0; j < rows.length + 1; j++) {
      String row = (j + 1).toString();
      String? displayData = j == 0
          ? (columns[i].label as Text).data
          : (rows[j - 1].cells[i].child as Text).data;
      sheet.getRangeByName(column + row).setText(displayData);
      if (j != 0) {
        sheet.getRangeByName(column + row).cellStyle = cellStyle;
      }
    }
  }
  // Set style
  final Style headingStyle = workbook.styles.add('HeadingStyle');
  headingStyle.bold = true;
  headingStyle.hAlign = HAlignType.center;
  headingStyle.wrapText = true;
  sheet
      .getRangeByName('A1:${String.fromCharCode(columns.length + 65)}1')
      .cellStyle = headingStyle;

  //Save and launch the excel.
  final List<int> bytes = workbook.saveAsStream();
  //Dispose the document.
  workbook.dispose();

  //Save and launch the file.
  MimeType type = MimeType.MICROSOFTEXCEL;
  Uint8List data = Uint8List.fromList(bytes);

  if (Platform.isIOS || Platform.isAndroid || Platform.isMacOS) {
    bool status = await Permission.storage.isGranted;

    if (!status) await Permission.storage.request();
  }
  if (Platform.isAndroid || Platform.isIOS) {
    await FileSaver.instance.saveAs(fileName, data, 'xlsx', type);
  } else {
    String path = await FileSaver.instance
        .saveFile(fileName, data, 'xlsx', mimeType: type);
    log(path);
  }
}
