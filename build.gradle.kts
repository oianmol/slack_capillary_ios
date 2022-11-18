val sdks = listOf("iphoneos", "iphonesimulator")

sdks.forEach { sdk ->
  tasks.create<Exec>("build${sdk.capitalize()}") {
    group = "build"
    description = "Builds $sdk"

    val libraryName = "capillaryios"
    commandLine(
      "xcodebuild",
      "-workspace", "$projectDir/$libraryName.xcworkspace",
      "-scheme", libraryName,
      "-derivedDataPath", "$projectDir/build",
      "-destination", "generic/platform=iOS${if (sdk == "iphonesimulator") " Simulator" else ""}",
      "-sdk", sdk,
      "-configuration", "Release", "SKIP_INSTALL=NO"
    )

    workingDir(projectDir)

    inputs.files(
      fileTree("$projectDir/$libraryName.xcodeproj") { exclude("**/xcuserdata") },
      fileTree("$projectDir/$libraryName.xcworkspace") { exclude("**/xcuserdata") },
      fileTree("$projectDir/$libraryName")
    )
  }
}

tasks.create<Delete>("clean") {
  group = "build"
  delete("$projectDir/build")
}

tasks.register("buildCapillaryLibrary") {
  group = "build"
  description = "Builds all iOS dependencies"

  val dependencies = sdks.map { name -> "build${name.capitalize()}" }
  dependsOn(dependencies)
}