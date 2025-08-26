# lab2

Laboratorio creado por:
## Bastian Correa Diaz de tercer año.

## Objetivo de su creacioón
Bueno en este laboratorio buscamos crear una aplicación en Flutter, usando Dart para la lógica de las funcionalidades. La aplicación debe mostrar en la parte superior izquierda el número de matrícula del estudiante, en el centro un título solicitado y, en la parte inferior, cuatro botones:
-	Restar (de 1 en 1).
-	Sumar (de 1 en 1).
-	Reiniciar el conteo (volviendo a 0).
-	Una paleta de colores que permita modificar dinámicamente el color de la pantalla y de los botones.


## La lógica (paso a paso)
1.	Inicialización: la app carga con el contador en 0 y un color por defecto definido en _themeColor.
2.	Botón Restar: al presionarlo se ejecuta _decrementCounter(), que disminuye el valor del contador en 1.
3.	Botón Sumar: al presionarlo se ejecuta _incrementCounter(), que aumenta el valor del contador en 1.
4.	Botón Reiniciar: al presionarlo se ejecuta _resetCounter(), que devuelve el contador a 0.
5.	Botón Paleta: abre un ModalBottomSheet con varias opciones de color.
6.	Selección de color: al tocar un CircleAvatar, se asigna el color a _themeColor, lo que actualiza dinámicamente el color del AppBar y de los botones.
7.	La interfaz se actualiza automáticamente gracias al uso de setState().



## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
