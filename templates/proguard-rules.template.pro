# ============================================
# ProGuard Rules - Flutter Project Template
# ============================================
#
# INSTRUCCIONES DE USO:
# 1. Copia este archivo a: android/app/proguard-rules.pro
# 2. Reemplaza {{APPLICATION_ID}} con tu applicationId (ej: com.miapp.nombre)
# 3. Agrega reglas específicas para tus modelos de datos en la sección CUSTOM RULES
# 4. Revisa la lista de plugins y descomenta los que uses
#
# ============================================

# ----------------------------------------
# FLUTTER CORE (OBLIGATORIO)
# ----------------------------------------
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# ----------------------------------------
# ANDROID COMPONENTS (OBLIGATORIO)
# ----------------------------------------
# TODO: Reemplaza {{APPLICATION_ID}} con tu applicationId real
-keep class {{APPLICATION_ID}}.MainActivity { *; }

# Si tienes otras Activities, Services, BroadcastReceivers:
# -keep class {{APPLICATION_ID}}.MiOtraActivity { *; }
# -keep class {{APPLICATION_ID}}.MiServicio { *; }

# ----------------------------------------
# DATA MODELS (para serialización JSON)
# ----------------------------------------
# TODO: Ajusta según la estructura de tu proyecto
# Ejemplo: Si tus modelos están en com.miapp.models
# -keep class {{APPLICATION_ID}}.models.** { *; }

# Si usas json_serializable o similar:
# -keepclassmembers class {{APPLICATION_ID}}.models.** {
#     public <init>(...);
#     public <fields>;
# }

# ----------------------------------------
# PLUGINS COMUNES DE FLUTTER
# ----------------------------------------
# Descomenta los que uses en tu proyecto:

# sqflite (base de datos local)
# -keep class com.tekartik.sqflite.** { *; }

# shared_preferences
# -keep class io.flutter.plugins.sharedpreferences.** { *; }

# path_provider
# -keep class io.flutter.plugins.pathprovider.** { *; }

# url_launcher
# -keep class io.flutter.plugins.urllauncher.** { *; }

# image_picker
# -keep class io.flutter.plugins.imagepicker.** { *; }

# camera
# -keep class io.flutter.plugins.camera.** { *; }

# firebase_core
# -keep class io.flutter.plugins.firebase.** { *; }

# firebase_messaging
# -keep class io.flutter.plugins.firebasemessaging.** { *; }

# google_sign_in
# -keep class io.flutter.plugins.googlesignin.** { *; }

# webview_flutter
# -keep class io.flutter.plugins.webviewflutter.** { *; }

# ----------------------------------------
# JNI (métodos nativos) - OBLIGATORIO
# ----------------------------------------
-keepclasseswithmembernames class * {
    native <methods>;
}

# ----------------------------------------
# REFLECTION (para serialización) - OBLIGATORIO
# ----------------------------------------
-keepattributes *Annotation*
-keepattributes Signature
-keepattributes SourceFile,LineNumberTable
-keepattributes InnerClasses,EnclosingMethod

# ----------------------------------------
# ENUMS - OBLIGATORIO
# ----------------------------------------
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}

# ----------------------------------------
# PARCELABLE - OBLIGATORIO
# ----------------------------------------
-keep interface android.os.Parcelable
-keepclassmembers class * implements android.os.Parcelable {
  public static final android.os.Parcelable$Creator CREATOR;
}

# ----------------------------------------
# SERIALIZABLE - OBLIGATORIO
# ----------------------------------------
-keepclassmembers class * implements java.io.Serializable {
    static final long serialVersionUID;
    private static final java.io.ObjectStreamField[] serialPersistentFields;
    private void writeObject(java.io.ObjectOutputStream);
    private void readObject(java.io.ObjectInputStream);
    java.lang.Object writeReplace();
    java.lang.Object readResolve();
}

# ----------------------------------------
# ANDROIDX COMPONENTS - OBLIGATORIO
# ----------------------------------------
-keep class ** extends androidx.lifecycle.ViewModel { *; }
-keep class ** extends androidx.lifecycle.AndroidViewModel { *; }

# WorkManager (si lo usas)
# -keep class androidx.work.** { *; }

# ----------------------------------------
# OPTIMIZATION - OBLIGATORIO
# ----------------------------------------
-optimizationpasses 5
-allowaccessmodification
-repackageclasses ''

# ----------------------------------------
# GOOGLE PLAY CORE - OBLIGATORIO
# ----------------------------------------
# Flutter referencia estas clases aunque no las uses directamente
-dontwarn com.google.android.play.core.**
-keep class com.google.android.play.core.** { *; }

# ----------------------------------------
# WARNINGS (suprimir conocidos) - OBLIGATORIO
# ----------------------------------------
-dontwarn javax.annotation.**
-dontwarn org.codehaus.mojo.animal_sniffer.IgnoreJRERequirement

# ----------------------------------------
# CUSTOM RULES
# ----------------------------------------
# TODO: Agrega aquí reglas específicas para tu proyecto

# Ejemplo: Si usas Retrofit
# -keepattributes Signature
# -keepattributes Exceptions
# -keep class retrofit2.** { *; }

# Ejemplo: Si usas Gson
# -keep class com.google.gson.** { *; }
# -keep class * implements com.google.gson.TypeAdapterFactory
# -keep class * implements com.google.gson.JsonSerializer
# -keep class * implements com.google.gson.JsonDeserializer

# Ejemplo: Si usas OkHttp
# -dontwarn okhttp3.**
# -keep class okhttp3.** { *; }

# ============================================
# FIN DE PLANTILLA
# ============================================
