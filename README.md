# Mobile Simple Car Diagnosis Application

Mobile Car Diagnosis

## Description
This project is the implementation of idea for diploma project for Bachelor
of Science at West Pomeranian Technology University with 'Using Flutter framework to
build mobile application for simple car diagnosis based on OBD2 interface'.

It allows providing simple car diagnostic with finding and displaying DTC (Diagnostic Trouble Codes)
found in a car's ECU memory

#### User Flow
Application user flow is:
- Enable Bluetooth
- Connect to ELM327 device
- Scan for issues
- Look at found errors
- Repair a car :)

## Technologies
- **Flutter & Dart** with partial null-safety
- Attempt for writing **clean and maintainable code** with encapsulation (getters\setters), polymorphism (extending and 
implementing parent classes), using all best practices for Dart code
- Reactive approach with **BLoC pattern**
- Own custom services using streams and asynchronously mechanics - **Streams, Future, async/await**
- Used **design patterns** - Repository, Singleton
- **Declarative approach** at creating own custom widgets
- flutter_bluetooth_serial library for **handling Bluetooth** connection
- **obdsimulator and ELM327** as diagnostic hardware device for OBD-II interface

## Developer

Oleksandr Tilnyi