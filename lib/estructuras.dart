import 'package:flutter/material.dart';

//AGREGAR DESDE - HASTA EN CALENDARIO
//VER EL ULTIMO ITEM DEL INPUESTO
//INVENTARIO FINAL DE MERCANCIAS
bool animacionBoton = false;
int animacionBotonInterfas = 0;
int animacionBotonCard = 0;
bool mostrarBotonHistory = true;
double ancho = 0;
double alto  = 0;
double altoCardList = 55;
bool fin = false;
bool animacionProgress = false;
int paginaSeleccionada = 1;
int dropSeleccionado = 0;
TextEditingController controllerValor = TextEditingController();
TextEditingController controllerFechaDesde = TextEditingController();
TextEditingController controllerFechaHasta = TextEditingController();
TextEditingController controllerEmpresa = TextEditingController();
TextEditingController controllerNit = TextEditingController();
TextEditingController controllerElaboro = TextEditingController();
TextEditingController controllerAutorizo = TextEditingController();
FocusNode focoEmpresa = FocusNode();
FocusNode focoNit = FocusNode();
FocusNode focoElaboro = FocusNode();
FocusNode focoAutorizo = FocusNode();

List<Color> colores = const [
  Color(0xFFF5885D),
  Color(0xFF3ABCBC),
  Color(0xFFF0C140),
  Color(0xFFAD6BDE),
  Color(0xFFF5719A),
  Color(0xFF2CD0A8),
  Color.fromARGB(255, 121, 116, 116),
  Color.fromARGB(255, 126, 13, 47),
];

class Valores{
  late String precio;
  late String tipo;
  late Color color;
  Valores(this.precio,this.tipo,this.color);
}

class Ventanas{
  late String nombre;
  late List<DropdownMenuItem<int>> dropOpciones;
  late List<Valores> datos;
  Ventanas(this.nombre,this.datos,this.dropOpciones);
}

Widget dropItem(String titulo, int color){
  return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        if(color!=0)CircleAvatar(backgroundColor: colores[color],radius: 10,),
        if(color!=0)const SizedBox(width: 2,),
        Text(titulo)
      ],
  );
}

List<String> tiposVenta = ["Tipo","Venta", "Devolución","Rebaja"];
List<String> tiposUtilidad = ["Tipo","Inventario inicial","Compras","Fletes sobre compras","Devoluciones en compras","Descuentos en compras","Inventario final"];
List<String> tiposNeta = ["Tipo","Sueldo Vendedor","Comisión Vendedor","Servicios Ventas","Arriendos Ventas","Sueldo Oficina","Servicios Oficina","Arriendos Oficina",];
List<String> tiposOperacionales = ["Tipo","Comisión","Varios","Financieros","Diversos"];

List<Ventanas> interfaces =[
  Ventanas(
    "Datos", 
    [],
    [],
  ),

  Ventanas(
    "Ventas Netas",
    listaVentas, 
    dropVentas,

  ),
  Ventanas(
    "Costos de ventas",
    listaCostos, 
    dropCostos,

  ),
  Ventanas(
    "Utilidad Neta Operacional",
    listaOperacional, 
    dropOperacional,

  ),
  Ventanas(
    "Ingresos no operacionales",
    listaIngNoOperacionales, 
    dropIngNoOperacionales,

  ),
  Ventanas(  
    "Finalizar", 
    [],
    [],
 
  ),
];

//----------------------------
List<Valores> listaVentas = [
  Valores("0", tiposVenta[1], colores[1]),
  Valores("0", tiposVenta[2], colores[2]),
  Valores("0", tiposVenta[3], colores[3]),
];

List<DropdownMenuItem<int>> dropVentas = [
  DropdownMenuItem(
      value: 0,
      child: dropItem(tiposVenta[0], 0)
    ),
  DropdownMenuItem(
      value: 1,
      child: dropItem(tiposVenta[1], 1)
    ),
  DropdownMenuItem(
      value: 2,
      child: dropItem(tiposVenta[2], 2)
    ),
  DropdownMenuItem(
      value: 3,
      child: dropItem(tiposVenta[3], 3)
    ),
];

//----------------------------
List<Valores> listaCostos = [
  Valores("0", tiposUtilidad[1], colores[1]),
  Valores("0", tiposUtilidad[2], colores[2]),
  Valores("0", tiposUtilidad[3], colores[3]),
  Valores("0", tiposUtilidad[4], colores[4]),
  Valores("0", tiposUtilidad[5], colores[5]),
  Valores("0", tiposUtilidad[6], colores[6]),
];

List<DropdownMenuItem<int>> dropCostos = [
  DropdownMenuItem(
      value: 0,
      child: dropItem(tiposUtilidad[0],0)
    ),
    DropdownMenuItem(
      value: 1,
      child: dropItem(tiposUtilidad[1],1)
    ),
    DropdownMenuItem(
      value: 2,
      child: dropItem(tiposUtilidad[2],2)
    ),
    DropdownMenuItem(
      value: 3,
      child: dropItem(tiposUtilidad[3],3)
    ),
    DropdownMenuItem(
      value: 4,
      child: dropItem(tiposUtilidad[4],4)
    ),
    DropdownMenuItem(
      value: 5,
      child: dropItem(tiposUtilidad[5],5)
    ),
    DropdownMenuItem(
      value: 6,
      child: dropItem(tiposUtilidad[6],6)
    ),
];
//----------------------------
List<Valores> listaOperacional = [
  Valores("0", tiposNeta[1], colores[1]),
  Valores("0", tiposNeta[2], colores[2]),
  Valores("0", tiposNeta[3], colores[3]),
  Valores("0", tiposNeta[4], colores[4]),
  Valores("0", tiposNeta[5], colores[5]),
  Valores("0", tiposNeta[6], colores[6]),
  Valores("0", tiposNeta[7], colores[7]),
];

List<DropdownMenuItem<int>> dropOperacional=  [
  DropdownMenuItem(
      value: 0,
      child: dropItem(tiposNeta[0],0)
    ),
    DropdownMenuItem(
      value: 1,
      child: dropItem(tiposNeta[1],1)
    ),
    DropdownMenuItem(
      value: 2,
      child: dropItem(tiposNeta[2],2)
    ),
    DropdownMenuItem(
      value: 3,
      child: dropItem(tiposNeta[3],3)
    ),
    DropdownMenuItem(
      value: 4,
      child: dropItem(tiposNeta[4],4)
    ),
    DropdownMenuItem(
      value: 5,
      child: dropItem(tiposNeta[5],5)
    ),
    DropdownMenuItem(
      value: 6,
      child: dropItem(tiposNeta[6],6)
    ),
    DropdownMenuItem(
      value: 7,
      child: dropItem(tiposNeta[7],7)
    ),
    
];

List<Valores> listaIngNoOperacionales = [
  Valores("0", tiposOperacionales[1], colores[1]),
  Valores("0", tiposOperacionales[2], colores[2]),
  Valores("0", tiposOperacionales[3], colores[3]),
  Valores("0", tiposOperacionales[4], colores[4]),
];

List<DropdownMenuItem<int>> dropIngNoOperacionales= [
  DropdownMenuItem(
      value: 0,
      child: dropItem(tiposOperacionales[0],0)
    ),
    DropdownMenuItem(
      value: 1,
      child: dropItem(tiposOperacionales[1],1)
    ),
    DropdownMenuItem(
      value: 2,
      child: dropItem(tiposOperacionales[2],2)
    ),
    DropdownMenuItem(
      value: 3,
      child: dropItem(tiposOperacionales[3],3)
    ),
    DropdownMenuItem(
      value: 4,
      child: dropItem(tiposOperacionales[4],4)
    ),
];