# 🛡️ NIU Guardian

**NIU Guardian** es una aplicación móvil robusta y moderna diseñada para el censo y gestión de responsables y menores de edad. Desarrollada con **Flutter**, ofrece una experiencia de usuario fluida, almacenamiento local seguro y una arquitectura escalable lista para producción.

---

## 🚀 Características Principales

- **Gestión Integral:** Registro completo de Responsables (Padres/Tutores) y sus Hijos.
- **Generación de Códigos Únicos:** Algoritmo inteligente para generar identificadores únicos (CUI) basados en nombres y fechas.
- **Persistencia Local de Alto Rendimiento:** Uso de **Isar Database** para un almacenamiento offline rápido y seguro.
- **Búsqueda Instantánea:** Filtrado en tiempo real por nombre, apellido, DPI o código de menor.
- **Validación de Identidad:** Reglas de negocio estrictas para evitar duplicidad de DPIs.
- **Onboarding Interactivo:** Flujo de bienvenida para nuevos usuarios con persistencia de estado.
- **UI/UX Premium:** Diseño limpio, feedback visual con `CustomSnackBars`, y protección contra pérdida de datos accidentales.

---

## 🛠️ Arquitectura y Tecnologías

El proyecto sigue los principios de **Clean Architecture** para garantizar la separación de responsabilidades, testabilidad y escalabilidad.

### 🏗️ Estructura del Proyecto

```
lib/
├── config/             # Configuración global (Router, Temas)
├── core/               # Utilidades compartidas (Validaciones, Feedback)
├── features/           # Módulos funcionales (Feature-first)
│   ├── census/         # Módulo Principal de Censo
│   │   ├── domain/     # Entidades y Repositorios (Lógica de Negocio)
│   │   ├── infrastructure/ # Implementación de Repositorios y Fuentes de Datos (Isar)
│   │   └── presentation/ # Widgets, Pantallas y Providers
│   └── onboarding/     # Módulo de Bienvenida
└── main.dart           # Punto de entrada
```

### 🧩 Stack Tecnológico

- **Framework:** [Flutter](https://flutter.dev/) (Multiplataforma)
- **Lenguaje:** [Dart](https://dart.dev/)
- **Gestión de Estado:** [Riverpod](https://riverpod.dev/) (Provider-based)
- **Base de Datos:** [Isar](https://isar.dev/) (NoSQL, ACID, Súper rápida)
- **Enrutamiento:** [GoRouter](https://pub.dev/packages/go_router) (Navegación declarativa)
- **Formularios:** [Flutter Form Builder](https://pub.dev/packages/flutter_form_builder)

---

## 📱 Compatibilidad

> **Proyecto desarrollado bajo los estándares multiplataforma de Flutter.**
>
> Probado y compilado nativamente para **Android** (ver APK). El código base está estructurado de forma agnóstica a la plataforma y está **100% listo para ser compilado en iOS** a través de Xcode o un pipeline de CI/CD sin necesidad de cambios mayores en la lógica de negocio.

---

## 🏁 Guía de Instalación

Sigue estos pasos para ejecutar el proyecto en tu entorno local:

### Prerrequisitos
- Flutter SDK (Stable Channel)
- Dart SDK
- Android Studio / VS Code

### Pasos

1.  **Clonar el repositorio:**
    ```bash
    git clone https://github.com/tu-usuario/niu-guardian.git
    cd niu-guardian
    ```

2.  **Instalar dependencias:**
    ```bash
    flutter pub get
    ```

3.  **Generar código (para Isar y Riverpod):**
    ```bash
    dart run build_runner build --delete-conflicting-outputs
    ```

4.  **Ejecutar la App:**
    ```bash
    flutter run
    ```

---

## 🧪 Tests

El proyecto incluye pruebas unitarias y de simulación para validar la lógica crítica (como la generación de códigos).

```bash
flutter test
```

---

Hecho con ❤️ para **NIU Solutions**.
