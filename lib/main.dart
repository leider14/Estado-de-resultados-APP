import 'dart:io';
import 'package:contaduria/estructuras.dart';
import 'package:contaduria/funciones.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
          backgroundColor: Color.fromARGB(255, 241, 241, 241), body: Home()),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  void esconderTeclado(){
    FocusScope.of(context).requestFocus(FocusNode());
  }

  @override
  void initState() {
    controllerFechaDesde.text = DateTime(2021).toString().substring(0, 11);
    controllerFechaHasta.text = DateTime.now().toString().substring(0, 11);
    super.initState();
  }

  Widget getPagina() {
    if (paginaSeleccionada <= 1) {
      setState(() {mostrarBotonHistory = true;});
      return datos();
    }
    if (paginaSeleccionada >= interfaces.length) {
      generarPdf();
      setState(() {mostrarBotonHistory = true;});
      return compartir();
    } else {
      setState(() {mostrarBotonHistory = false;});
      return moduloPrincipal(paginaSeleccionada - 1);
    }
  }

  void limpiarFields() {
    controllerValor.clear();
    dropSeleccionado = 0;
  }

  void cambiarDrop(int index) {
    setState(() {
      dropSeleccionado = index;
    });
  }

  void cambiarPagina(int valor) {
    switch (valor) {
      case 1:
        if (paginaSeleccionada == interfaces.length - 1) {
          fin = true;
          animacionProgress = true;
          limpiarFields();
          paginaSeleccionada += paginaSeleccionada >= interfaces.length ? 0 : 1;
        } else {
          fin = false;
          animacionProgress = true;
          limpiarFields();
          paginaSeleccionada += paginaSeleccionada >= interfaces.length ? 0 : 1;
        }
        break;
      case 0:
        fin = false;
        animacionProgress = true;
        paginaSeleccionada -= paginaSeleccionada - 1 <= 0 ? 0 : 1;
        break;
    }
    setState(() {});
  }

  void mostrarHistory()async{
    await consultaHistorial();
    setState(() {});
    // ignore: use_build_context_synchronously
    Navigator.push(
      context, 
      MaterialPageRoute(
        builder: ((context) {
          return Scaffold(
            appBar: AppBar(title: const Text("History"),),
            body: 
              ListView.builder(
                itemCount: listaDocumentos.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(listaDocumentos[index]),
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return SfPdfViewer.file(
                              File("$filePathRaiz/${listaDocumentos[index]}")
                            );
                          },
                        )
                      );
                    },
                  );
                },
              )
          );
        }
        )
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    ancho = MediaQuery.of(context).size.width;
    alto = MediaQuery.of(context).size.height;
    return 
    Stack(
      children: [
        Column(
          children: [
            progress(),
            Expanded(child: getPagina(),),
            botones()
          ],
        ),
        AnimatedPositioned(
          top: 40,
          right: mostrarBotonHistory ? -10: -100,
          duration: const Duration(milliseconds: 300),
          curve:Curves.easeInOutBack,
          child:
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize:const Size(80,50),
                elevation: 0,
                shape:const RoundedRectangleBorder(
                  borderRadius: BorderRadius.horizontal(left: Radius.circular(20))
                )
              ),
              onPressed: (){mostrarHistory();},
              child: const Icon(Icons.history_rounded)
            )
        )
        
      ],
    );
  }

  Widget compartir() {
    return Stack(
          children: [
            SizedBox.expand(
              child: 
              SfPdfViewer.file(
                  initialScrollOffset: const Offset(50,0),
                  initialZoomLevel: 1.3,
                  File(filePath)
              ),
            ),
            const Positioned(
                bottom: 10,
                right: 10,
                child: FloatingActionButton(
                  onPressed: compartirPdf,
                  child: Icon(Icons.share),
                )),
          ],
        );
  }

  Widget datos() {
    void calendarioDesde() async {
      DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime(2021),
          firstDate: DateTime(2000),
          lastDate: DateTime(2101));
      if (pickedDate != null) {
        setState(() {
          controllerFechaDesde.text = pickedDate.toString().substring(0, 11);
        });
      } else {
        print("fecha no elegida");
      }
    }
    void calendarioHasta() async {
      DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2101));
      if (pickedDate != null) {
        setState(() {
          controllerFechaHasta.text = pickedDate.toString().substring(0, 11);
        });
      } else {
        print("fecha no elegida");
      }
    }

    return Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(20)),
        child: ListView(
          padding: const EdgeInsets.all(0),
          children: [
            const Text(
              "Bienvenido",
              textScaleFactor: 2,
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "Proporcioneme el nombre de su empresa y algunos detalles financieros clave para que pueda preparar un estado de resultados detallado y preciso",
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: controllerEmpresa,
              focusNode: focoEmpresa,
              onEditingComplete: () {
                FocusScope.of(context).requestFocus(focoNit);
              },
              decoration: const InputDecoration(
                  label: Text("Nombre de la empresa"),
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.cabin)),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: controllerNit,
              focusNode: focoNit,
              keyboardType: TextInputType.number,
              onEditingComplete: () {
                FocusScope.of(context).requestFocus(focoElaboro);
              },
              decoration: const InputDecoration(
                  label: Text("Nit de la empresa"),
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.numbers)),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              readOnly: true,
              controller: controllerFechaDesde,
              enabled: true,
              keyboardType: TextInputType.datetime,
              onTap: () async {
                calendarioDesde();
              },
              decoration: const InputDecoration(
                  label: Text("Fecha del Informe Desde"),
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.calendar_month)),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              readOnly: true,
              controller: controllerFechaHasta,
              enabled: true,
              keyboardType: TextInputType.datetime,
              onTap: () async {
                calendarioHasta();
              },
              decoration: const InputDecoration(
                  label: Text("Fecha del Informe Hasta"),
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.calendar_month)),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: controllerElaboro,
              focusNode: focoElaboro,
              keyboardType: TextInputType.text,
              onEditingComplete: () {
                FocusScope.of(context).requestFocus(focoAutorizo);
              },
              decoration: const InputDecoration(
                  label: Text("Elaboró"),
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person_4_rounded)),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: controllerAutorizo,
              focusNode: focoAutorizo,
              keyboardType: TextInputType.text,
              onEditingComplete: () {},
              decoration: const InputDecoration(
                  label: Text("Autorizó"),
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person_2_rounded)),
            ),
          ],
        ));
  }

  Widget cardLista(int NumeroPagina, int NumeroCard) {
    return AnimatedContainer(
        onEnd: () {
          animacionBoton = false;
          setState(() {});
        },
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOutBack,
        margin: (animacionBoton && NumeroPagina==animacionBotonInterfas && NumeroCard==animacionBotonCard )? const EdgeInsets.fromLTRB(5,3, 5, 3): const EdgeInsets.fromLTRB(10,5,10,5),
        width: ancho,
        height: altoCardList,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20), color: Colors.white),
        child: Row(
          children: [
            Container(
              height: altoCardList,
              width: 15,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomLeft: Radius.circular(20)),
                color: interfaces[NumeroPagina].datos[NumeroCard].color,
              ),
            ),
            const SizedBox(width: 10,),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  interfaces[NumeroPagina].datos[NumeroCard].tipo,
                  textScaleFactor: 1.3,
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  "\$${interfaces[NumeroPagina].datos[NumeroCard].precio}",
                  textScaleFactor: 1,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: interfaces[NumeroPagina].datos[NumeroCard].color),
                ),
              ],
            ),
          ],
        ));
  }

  String obtenerTipo(int i) {
    switch (i) {
      case 1:
        return tiposVenta[dropSeleccionado];
      case 2:
        return tiposUtilidad[dropSeleccionado];
      case 3:
        return tiposNeta[dropSeleccionado];
      case 4:
        return tiposOperacionales[dropSeleccionado];
      default:
        return "";
    }
  }

  Widget agregarCard(int NumeroPagina) {
    void agregarBoton() {
      if (controllerValor.text.isNotEmpty && dropSeleccionado != 0) {
        animacionBoton = true;
        animacionBotonInterfas = NumeroPagina;
        animacionBotonCard = dropSeleccionado - 1;
        interfaces[NumeroPagina].datos[dropSeleccionado - 1].precio =
            controllerValor.text;
        limpiarFields();
        esconderTeclado();
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: SizedBox(
                height: 200,
                width: ancho-100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 100,
                      child:Image.asset("assets/triste.gif"),
                    ),
                    Text("Ups!",textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30,color: colores[1]),),
                    const Text("No ingreso todos los datos necesarios",textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15,color: Color.fromARGB(255, 66, 67, 71)),),
                  ],
                ),
              ),
            );
          },
        );
      }
      setState(() {});
    }

    return Container(
        width: ancho,
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(30)),
          color: Colors.white,
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            interfaces[NumeroPagina].nombre,
            textScaleFactor: 1.5,
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: TextField(
                  controller: controllerValor,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), label: Text("Valor")),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              DropdownButton(
                value: dropSeleccionado,
                elevation: 1,
                items: interfaces[NumeroPagina].dropOpciones,
                onChanged: (value) => cambiarDrop(value!),
              )
            ],
          ),
          ElevatedButton(
            onPressed: () => agregarBoton(),
            style: ElevatedButton.styleFrom(
                fixedSize: Size(ancho, 20),
                elevation: 0,
                foregroundColor: Colors.blue.shade50,
                backgroundColor: Colors.blue),
            child: const Text("Agregar", textScaleFactor: 1.5),
          ),
          const Divider(
            height: 2,
            color: Colors.grey,
          )
        ]));
  }

  Widget moduloPrincipal(int i) {
    return Stack(children: [
      ListView.builder(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 200),
        itemCount: interfaces[i].datos.length,
        itemBuilder: (context, index) {
          return cardLista(i, index);
        },
      ),
      Positioned(bottom: 0, child: agregarCard(i))
    ]);
  }

  Widget progress() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 45, 20, 10),
      width: ancho,
      height: paginaSeleccionada == interfaces.length ? 100 : 150,
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: paginaSeleccionada == interfaces.length ? 40 : 100,
            width: paginaSeleccionada == interfaces.length ? 40 : 100,
            child: Stack(
              children: [
                Center(
                  child: SizedBox(
                    height: 60,
                    width: 60,
                    child: CircularProgressIndicator(
                      value: paginaSeleccionada * 1 / interfaces.length,
                      strokeWidth: 5,
                      color: Colors.green,
                    ),
                  ),
                ),
                Center(
                  child: !fin
                      ? Text("$paginaSeleccionada de ${interfaces.length}",
                          style: const TextStyle(fontWeight: FontWeight.bold))
                      : const Icon(
                          Icons.check,
                          size: 30,
                          color: Colors.green,
                        ),
                )
              ],
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          Expanded(
              child: Stack(
            children: [
              AnimatedPositioned(
                  curve: Curves.easeInOutBack,
                  duration: const Duration(milliseconds: 200),
                  top: animacionProgress
                      ? -50
                      : fin
                          ? 10
                          : 10,
                  onEnd: () {
                    setState(() {
                      animacionProgress = false;
                    });
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: ancho * 0.6,
                        child: Text(
                          interfaces[paginaSeleccionada - 1].nombre,
                          textScaleFactor:
                              paginaSeleccionada == interfaces.length ? 1.5 : 2,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      if (!(paginaSeleccionada >= interfaces.length) &
                          !animacionProgress)
                        Text(
                            "Continua: ${interfaces[paginaSeleccionada].nombre}")
                    ],
                  ))
            ],
          ))
        ],
      ),
    );
  }

  Widget botones() {
    return Container(
      height: 80,
      width: ancho,
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ElevatedButton(
            onPressed: () {
              esconderTeclado();
              cambiarPagina(0);
            },
            style: ElevatedButton.styleFrom(
                fixedSize: const Size(150, 50),
                elevation: 0,
                foregroundColor:
                    paginaSeleccionada <= 1 ? Colors.blueGrey : Colors.blue,
                backgroundColor: paginaSeleccionada <= 1
                    ? Colors.blueGrey.shade50
                    : Colors.blue.shade50),
            child: const Text("Atras", textScaleFactor: 1.5),
          ),
          if (!fin)
            ElevatedButton(
              onPressed: () {
                if(paginaSeleccionada ==1){
                  crearArchivo();
                }
                esconderTeclado();
                cambiarPagina(1);
              },
              style: ElevatedButton.styleFrom(
                  fixedSize: const Size(150, 50),
                  elevation: 0,
                  foregroundColor: Colors.blue.shade50,
                  backgroundColor: Colors.blue),
              child: const Text("Siguiente", textScaleFactor: 1.5),
            )
        ],
      ),
    );
  }
}
