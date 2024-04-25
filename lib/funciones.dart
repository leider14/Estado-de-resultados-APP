import 'dart:io';
import 'dart:typed_data';
import 'package:contaduria/estructuras.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdflib;
import 'package:flutter_mailer/flutter_mailer.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart';

double sizeText = 15;
double sizeTitulo = 12;
String filePathRaiz = "";
String filePath = "";
List<String> listaDocumentos = [];

Future<void> consultaHistorial() async{
  listaDocumentos.clear();
  final Directory appDocDirectory = await getApplicationDocumentsDirectory();
  filePathRaiz = appDocDirectory.path;
  final directory = Directory(appDocDirectory.path);
  final files = await directory.list().where((file) => file.path.endsWith('.pdf')).toList();

  for (final file in files) {
    final fileName = file.path.split('/').last;
    listaDocumentos.add(fileName);
  }
}

Future<void> compartirPdf() async {
  final MailOptions mailOptions = MailOptions(
    body: 'Adjunto archivo modificado',
    subject: 'Reporte modificado',
    recipients: ['abc@gmail.com'],
    isHTML: false,
    attachments: [
      (filePath),
    ],
  );
  // Enviar el correo electrónico
  await FlutterMailer.send(mailOptions);
}

List<Widget> lineas() {
  String obtenerSumatoriaM() {
    return (int.parse(listaCostos[0].precio) +
            int.parse(listaCostos[1].precio) +
            int.parse(listaCostos[2].precio) -
            int.parse(listaCostos[3].precio) -
            int.parse(listaCostos[4].precio))
        .toString();
  }

  String obtenerSumatoriaIO1() {
    return (int.parse(listaIngNoOperacionales[0].precio) +
            int.parse(listaIngNoOperacionales[1].precio))
        .toString();
  }

  String obtenerSumatoriaIO2() {
    return (int.parse(listaIngNoOperacionales[2].precio) +
            int.parse(listaIngNoOperacionales[3].precio))
        .toString();
  }

  String obtenerUtilidadO() {
    return ((int.parse(listaVentas[0].precio) -
                int.parse(listaVentas[1].precio) -
                int.parse(listaVentas[2].precio)) -
            (int.parse(obtenerSumatoriaM()) - int.parse(listaCostos[5].precio)))
        .toString();
  }

  String obtenerSumatoriaUNetaOp() {
    return (int.parse(obtenerUtilidadO()) -
            int.parse(listaOperacional[0].precio) +
            int.parse(listaOperacional[1].precio) +
            int.parse(listaOperacional[2].precio) +
            int.parse(listaOperacional[3].precio) +
            int.parse(listaOperacional[4].precio) +
            int.parse(listaOperacional[5].precio) +
            int.parse(listaOperacional[6].precio))
        .toString();
  }

  String obtenerSumatoriaSinISR() {
    return (int.parse(obtenerSumatoriaUNetaOp()) +
            int.parse(obtenerSumatoriaIO1()) -
            int.parse(obtenerSumatoriaIO2()))
        .toString();
  }

  String obtenerSumatoriaISR() {
    return (((int.parse(obtenerSumatoriaSinISR())) * 0.28).round()).toString();
  }

  String obtenerNeta() {
    return (int.parse(obtenerSumatoriaSinISR()) -
            int.parse(obtenerSumatoriaISR()))
        .toString();
  }

  String obtenerSumatoria(Ventanas e) {
    if (e.nombre == "Ventas Netas") {
      return (int.parse(listaVentas[0].precio) -
              int.parse(listaVentas[1].precio) -
              int.parse(listaVentas[2].precio))
          .toString();
    } else if (e.nombre == "Costos de ventas") {
      return (int.parse(obtenerSumatoriaM()) - int.parse(listaCostos[5].precio))
          .toString();
    } else if (e.nombre == "Ingresos no operacionales") {
      return (int.parse(obtenerSumatoriaIO2())).toString();
    } else if (e.nombre == "Utilidad Neta Operacional") {
      return (int.parse(obtenerSumatoriaUNetaOp())).toString();
    } else {
      return "";
    }
  }

  return interfaces.map((e) {
    return pdflib.Column(children: [
      pdflib.Column(
          children: e.datos.map((f) {
        if (f.tipo == "Descuentos en compras") {
          return Column(children: [
            pdflib.Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(f.tipo, style: pdflib.TextStyle(fontSize: sizeText)),
                  Text(f.precio, style: pdflib.TextStyle(fontSize: sizeText)),
                ]),
            pdflib.Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Mercancia disponible para la venta",
                      style: pdflib.TextStyle(
                          fontSize: sizeText, fontWeight: FontWeight.bold)),
                  Text(obtenerSumatoriaM(),
                      style: pdflib.TextStyle(fontSize: sizeText)),
                ])
          ]);
        }
        if (f.tipo == "Varios") {
          return Column(children: [
            pdflib.Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(f.tipo, style: pdflib.TextStyle(fontSize: sizeText)),
                  Text(f.precio, style: pdflib.TextStyle(fontSize: sizeText)),
                ]),
            pdflib.Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Ingresos no operacionales",
                      style: pdflib.TextStyle(
                          fontSize: sizeText, fontWeight: FontWeight.bold)),
                  Text(obtenerSumatoriaIO1(),
                      style: pdflib.TextStyle(fontSize: sizeText)),
                ]),
          ]);
        }
        return pdflib.Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(f.tipo, style: pdflib.TextStyle(fontSize: sizeText)),
              Text(f.precio, style: pdflib.TextStyle(fontSize: sizeText)),
            ]);
      }).toList()),
      //Evitar mostrar estos dos valores, que no contienen información
      if (e.nombre != "Datos" && e.nombre != "Finalizar")
        Container(
            color: e.nombre != "Ingresos no operacionales"
                ? PdfColors.grey300
                : PdfColors.white,
            child: pdflib.Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(e.nombre,
                      style: pdflib.TextStyle(
                          fontSize: sizeText, fontWeight: FontWeight.bold)),
                  Text(obtenerSumatoria(e),
                      style: pdflib.TextStyle(fontSize: sizeText))
                ])),
      SizedBox(height: 10),
      if (e.nombre == "Costos de ventas")
        Container(
          color: PdfColors.grey300,
          child: pdflib.Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Utilidad en operación",
                    style: pdflib.TextStyle(
                        fontSize: sizeText, fontWeight: FontWeight.bold)),
                Text(obtenerUtilidadO(),
                    style: pdflib.TextStyle(fontSize: sizeText))
              ]),
        ),
      if (e.nombre == "Ingresos no operacionales")
        pdflib.Column(children: [
          Container(
              color: PdfColors.grey300,
              child: pdflib.Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Utilidad en operación antes de ISR y PTU",
                        style: pdflib.TextStyle(
                            fontSize: sizeText, fontWeight: FontWeight.bold)),
                    Text(obtenerSumatoriaSinISR(),
                        style: pdflib.TextStyle(fontSize: sizeText)),
                  ])),
          pdflib.Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Impuesto sobre renta(ISR) 28%",
                    style: pdflib.TextStyle(
                        fontSize: sizeText, fontWeight: FontWeight.normal)),
                Text(obtenerSumatoriaISR(),
                    style: pdflib.TextStyle(fontSize: sizeText)),
              ]),
          Container(
            color: PdfColors.grey300,
            child: pdflib.Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Utilidad neta",
                      style: pdflib.TextStyle(
                          fontSize: sizeText, fontWeight: FontWeight.bold)),
                  Text(obtenerNeta(),
                      style: pdflib.TextStyle(fontSize: sizeText)),
                ]),
          )
        ])
    ]);
  }).toList();
}

Future<void> generarPdf() async {
  final pdf = pdflib.Document();

  // Agregar un título centrado en la parte superior
  pdf.addPage(pdflib.Page(
      margin: const EdgeInsets.fromLTRB(100, 10, 100, 10),
      orientation: PageOrientation.portrait,
      build: (context) {
        return pdflib.Column(
            mainAxisAlignment: pdflib.MainAxisAlignment.start,
            children: [
              //Nombre empresa
              pdflib.Center(
                child: pdflib.Text(
                  controllerEmpresa.text.toUpperCase(),
                  style: pdflib.TextStyle(
                    fontSize: sizeTitulo,
                    fontWeight: pdflib.FontWeight.bold,
                  ),
                ),
              ),
              pdflib.SizedBox(height: 5),
              //Nit
              pdflib.Center(
                child: pdflib.Text(
                  'NIT :${controllerNit.text}',
                  style: pdflib.TextStyle(
                    fontSize: sizeTitulo,
                    fontWeight: pdflib.FontWeight.bold,
                  ),
                ),
              ),
              pdflib.SizedBox(height: 5),
              //Fecha
              pdflib.Center(
                child: pdflib.Text(
                  textAlign: TextAlign.center,
                  'ESTADO DE RESULTADOS DE ${controllerFechaDesde.text} A ${controllerFechaHasta.text}',
                  style: pdflib.TextStyle(
                    fontSize: sizeTitulo,
                    fontWeight: pdflib.FontWeight.bold,
                  ),
                ),
              ),
              pdflib.SizedBox(height: 20),

              pdflib.Column(children: lineas()),

              pdflib.Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text("Elaboró: ${controllerElaboro.text}",
                        style: pdflib.TextStyle(fontSize: sizeText)),
                    Text("Autorizó: ${controllerAutorizo.text}",
                        style: pdflib.TextStyle(fontSize: sizeText)),
                  ]),
                  SizedBox(height: 10),
            ]);
      }));
  // Escribir el archivo de PDF en disco
  
  final pdfFile = File(filePath);
  //Guardarlo
  await pdfFile.writeAsBytes(await pdf.save());
}


Future<void> crearArchivo() async{
  // Escribir el archivo de PDF en disco
  final Directory appDocDirectory = await getApplicationDocumentsDirectory();

  final pdf = pdflib.Document();

  final String pdfFilePath = '${appDocDirectory.path}/${controllerFechaDesde.text.trim()} - ${controllerFechaHasta.text.trim()}.pdf';
  filePath = pdfFilePath;
  final pdfFile = File(pdfFilePath);
  final listaArchivos = await Directory(appDocDirectory.path).list().toList();
  for (var element in listaArchivos) {
      print(element);
  }
  await pdfFile.writeAsBytes(await pdf.save());
  print("SE GENERO UN ARCHIVO CON ESTE NOMBRE $pdfFilePath");
}