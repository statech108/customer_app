// Top-level build.gradle.kts (Project-level)

buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        // ✅ This is required for Firebase services
        classpath("com.google.gms:google-services:4.4.2")
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// ✅ Set up custom build directory for Flutter
val newBuildDir: Directory = rootProject.layout.buildDirectory
    .dir("../../build")
    .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
    project.evaluationDependsOn(":app")
}

// ✅ Define clean task
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
